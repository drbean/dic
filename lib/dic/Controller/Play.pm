package dic::Controller::Play;

use strict;
use warnings;
use base 'Catalyst::Controller';
use FirstLast;

=head1 NAME

dic::Controller::Play - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 start

Show a created exercise from the exercises database.

=cut
 
sub start : Local {
	my ($self, $c, $exerciseId) = @_;
	my $resultset = $c->model('dicDB::Exercise')->find($exerciseId);
	$c->stash->{exercise_id} = $exerciseId;
	$c->stash->{cloze} = $resultset->cloze;
    $c->stash->{template} = 'play/start.tt2';
}


=head2 questionupdate

Check answers. Partly-correct answers are accepted up to the first letter that is wrong. Words correctly answered in the text that are also in a comprehension question appear in the question.

=cut
 
sub questionupdate : Local {
	my ($self, $c, $exerciseId) = @_;
	my $player = $c->session->{player_id};
	my $leagueId = $c->session->{league};
	my $genre = $c->model("dicDB::LeagueGenre")->find(
			{ league => $leagueId } )->genre;
	my $exercises = $c->model('dicDB::Exercise')->search(
			{ genre => $genre, }, { order_by => 'id' } );
	$exerciseId = $c->session->{exercise};
	my $exercise;
	if ( defined $exerciseId )
	{		
		do { $exercise = $exercises->next }
					until $exercise->id eq $exerciseId;
	}
	else {
		$exercise = $exercises->single;
		$c->session->{exercise} = $exercise->id;
	}
	$c->forward('update');
	my $question = $exercise->text->questions->single;
	my $questionWords = $exercise->questionwords;
	my $answer = $c->request->params->{answer};
	if ( $answer )
	{
		my $correctAnswer = $question->answer;
		my $correct = $answer eq $correctAnswer? 1: 0;
		my $quizplay = $c->model('dicDB::Quiz');
		$quizplay->create({
			league => $leagueId,
			exercise => $exerciseId,
			player => $player,
			question => $question->id,
			# text => $text->id,
			correct => $correct });
		my $nextExercise = $exercises->next;
		$c->stash->{status_msg} = 
				"Your answer: \"$answer\". The correct answer: \"$correctAnswer\".";
		if ( $nextExercise )
		{
			$c->session->{exercise} = $nextExercise->id;
		}
		else {
			$c->stash->{status_msg} .= " GAME OVER";
		}
	}
	my $wordSet = $exercise->words;
	my $playSet = $c->model('dicDB::Play')->search(
			{player => $player, exercise => $exerciseId},
			{ order_by => 'blank' } );
	my @question = ( { Newline => 1 } );
	while ( my $questionWord = $questionWords->next )
	{
		my $link = $questionWord->link;
		my $published = $questionWord->content;
		unless ( $link or $link eq "0" )
		{ push @question, $published; }
		else {
			if ( $published !~ m/^[A-Za-z0-9]*$/ )
			{ push @question, $published; }
			else {		
				my $word = $wordSet->find({ id => $link });
				my $cloze = $word->clozed;
				unless ($cloze) {push @question, $published}
				else {
					my $played = $playSet->find(
							{ blank => $link });
					if ( $played and $played->correct eq 
						length $cloze )
					{ push @question, $published; }
					else { push @question, '_' x
							length($published); }
				}
			}
		}
	}
	$c->stash->{question} = \@question;
	$c->stash->{answer} = $question->answer;
	$c->stash->{template} = "play/question.tt2";
}


=head2 update

Check answers, fetch all characters and pass to characters/list.tt2 for display. Partly-correct answers are accepted up to the first letter that is wrong.

=cut
 
sub update : Local {
	my ($self, $c, $exerciseId) = @_;
	my $player = $c->session->{player_id};
	my $league = $c->session->{league};
	$exerciseId ||= $c->session->{exercise};
	my $genre = $c->model("dicDB::LeagueGenre")->find
			( {league => $league} )->genre;
	my $exerciseType = $c->model('dicDB::Exercise')->find(
			{ genre => $genre, id =>$exerciseId },)->type;
	my $title = $c->model('dicDB::Exercise')->find(
		{ genre => $genre, id => $exerciseId } )->description;
	my $wordSet = $c->model('dicDB::Word')->search(
			{genre => $genre, exercise => $exerciseId},
			{ order_by => 'id' } );
	my $playSet = $c->model('dicDB::Play')->search(
			{player => $player, exercise => $exerciseId},
			{ order_by => 'blank' } );
	my $questions = $c->request->params;
	my $play =  $c->model('dicDB::Play');
	my $score = 0;
	my @cloze = ( $title, { Newline => 1 }, { Newline => 1 } );
	while (my $word = $wordSet->next)
	{
		my $id = $word->id;
		my $unclozed = $word->unclozed;
		my $entry = $word->entry;
		my $kwic = ($entry and $entry->count > 1)? 1: 0;
		my $class = $word->class;
		my $published = $word->published;
		if ( $class eq 'Word' )
		{
			chop $published if $exerciseType eq "FirstLast";
			my $previous = $playSet->find({ blank=>$id });
			my $correct = $previous? $previous->correct: 0;
			my $clozed = $word->clozed;
			my $allLetters = length $clozed;
			my $answer = substr $clozed, $correct;
			my $response = $questions->{$id};
			if ( $correct == $allLetters ) {
				$score += $allLetters;
				push @cloze, $published;
			}
			elsif ( $response )
			{
				my $letters = length $response;
				if ( $response eq $answer )
				{
					$correct += $letters;
					$score += $correct;
					push @cloze, $published;
				}
				else {
					my $onewrong;
					for my $letter ( 0.. $letters )
					{
						if (substr($response, $letter, 1) eq substr($answer, $letter, 1))
						{ $correct++; }
						else {
							$onewrong = $letter;
							last;
						}
					}
					$score += $correct;
					my $answered =
						substr $clozed, 0, $correct;
					my $attempted =
						substr $response, $onewrong;
					my $length = length($clozed)-length($answered);
					push @cloze, { id => $id,
						unclozed => $unclozed,
						answered =>$answered,
						remaining => $attempted,
						length => $length,
						kwic => $kwic };
				}
				$play->update_or_create({
				league => $league,
				exercise => $exerciseId,
				player => $player,
				blank => $id,
				correct => $correct });
			}
			else {
				$score += $correct;
				my $answered = substr $clozed, 0, $correct;
				my $length = length($clozed)-length($answered);
				push @cloze, { id => $id,
						unclozed => $unclozed,
						answered =>$answered,
						remaining => '',
						length => $length,
						kwic => $kwic };
			}
		}
		elsif ( $class eq 'Newline' ) {
			push @cloze, { Newline => 1 }
		}
		else {push @cloze, $published; }
	}
	my $name = $c->model("dicDB::Player")->find({id=>$player})->name;
	$c->stash->{exercise_id} = $exerciseId;
	$c->stash->{cloze} = \@cloze;
	$c->stash->{status_msg} = "$name has $score letters correct";
	$c->stash->{reversed} = $exerciseType eq "Last"? 1: 0;
	$c->stash->{template} = 'play/start.tt2';
}


=head2 list

Fetch all Play objects and pass to play/list.tt2 in stash to be displayed

=cut
 
sub list : Local {
    # Retrieve the usual perl OO '$self' for this object. $c is the Catalyst
    # 'Context' that's used to 'glue together' the various components
    # that make up the application
    my ($self, $c) = @_;
    # Retrieve all of the text records as text model objects and store in
    # stash where they can be accessed by the TT template
    $c->stash->{exercises} = [$c->model('dicDB::Exercise')->all];
    # Set the TT template to use.  You will almost always want to do this
    # in your action methods (actions methods respond to user input in
    # your controllers).
    $c->stash->{template} = 'exercises/list.tt2';
}


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;
    $c->response->body('Matched dic::Controller::Play in Play.');
}


=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
