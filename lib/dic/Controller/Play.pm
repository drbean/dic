package dic::Controller::Play;

use strict;
use warnings;
use parent 'Catalyst::Controller';
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
	my $resultset = $c->model('DB::Exercise')->find($exerciseId);
	$c->stash->{exercise_id} = $exerciseId;
	$c->stash->{cloze} = $resultset->cloze;
    $c->stash->{template} = 'play/start.tt2';
}


=head2 update

Check answers, fetch all characters and pass to characters/list.tt2 for display.

=cut
 
sub update : Local {
	my ($self, $c, $exerciseId) = @_;
	my $player = $c->session->{player_id};
	my $leagueId = $c->session->{league};
	$exerciseId ||= $c->session->{exercise};
	my $genre = $c->model("DB::Leaguegenre")->find(
			{ league => $leagueId } )->genre;
	my $exercise = $c->model('DB::Exercise')->find(
			{ genre => $genre, id => $exerciseId } );
	$c->stash->{exercise} = $exercise;
	my $questions = $exercise->text->questions;
	my $questionid = $c->session->{question};
	my $question;
	if ( defined $questionid ) {
		$question = $questions->find({ id => $questionid });
	}
	else {
		$question = $questions->search({},
			 {offset => int(rand($questions->count)), rows => 1}
								)->single;
		$c->session->{question} = $question->id;
	}
	$c->stash->{question} = $question;
	$c->forward('clozeupdate');
	$c->forward('questionupdate', $exerciseId);
	$c->stash->{template} = "play/question.tt2";
	}


=head2 clozeupdate

Partly-correct answers are accepted up to the first letter that is wrong.

=cut
 
sub clozeupdate : Local {
	my ($self, $c, $exerciseId) = @_;
	my $player = $c->session->{player_id};
	my $league = $c->session->{league};
	$exerciseId ||= $c->session->{exercise};
	my $genre = $c->model("DB::Leaguegenre")->find
			( {league => $league} )->genre;
	my $exerciseType = $c->model('DB::Exercise')->find(
			{ genre => $genre, id =>$exerciseId },)->type;
	my $title = $c->model('DB::Exercise')->find(
		{ genre => $genre, id => $exerciseId } )->description;
	my $wordSet = $c->model('DB::Word')->search(
			{genre => $genre, exercise => $exerciseId},
			{ order_by => 'id' } );
	my $playSet = $c->model('DB::Play')->search(
			{player => $player, exercise => $exerciseId},
			{ order_by => 'blank' } );
	my $responses = $c->request->params;
	my $play =  $c->model('DB::Play');
	my $score = 0;
	my @cloze = ( { Newline => 1 }, { Newline => 1 } );
	while (my $word = $wordSet->next)
	{
		my $id = $word->id;
		my $unclozed = $word->unclozed;
		my $entry = $word->dictionary;
		my $kwic = ($entry and $entry->count > 1)? 1: 0;
		my $class = $word->class;
		my $published = $word->published;
		if ( $class eq 'Word' )
		{
			if ( $exerciseType eq "FirstLast" )
			{
				chop $published unless length $published <= 2;
			}
			my $previous = $playSet->find({ blank=>$id });
			my $correct = $previous? $previous->correct: 0;
			my $clozed = $word->clozed;
			my $allLetters = length $clozed;
			my $answer = substr $clozed, $correct;
			my $response = $responses->{$id};
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
	my $name = $c->model("DB::Player")->find({id=>$player})->name;
	$c->stash->{exercise_id} = $exerciseId;
	$c->stash->{title} = $title;
	$c->stash->{cloze} = \@cloze;
	$c->stash->{status_msg} = "$name has $score letters correct";
	$c->stash->{reversed} = $exerciseType eq "Last"? 1: 0;
}


=head2 questionupdate

Words correctly answered in the text that are also in a comprehension question appear in the question.

=cut
 
sub questionupdate : Local {
	my ($self, $c, $exerciseId) = @_;
	my $player = $c->session->{player_id};
	my $leagueId = $c->session->{league};
	my $exercise = $c->stash->{exercise};
	my $question = $c->stash->{question};
	my $questionWords = $question->words;
	my $answer = $c->request->params->{answer};
	if ( $answer )
	{
		my $correctAnswer = $question->answer;
		my $correct = $answer =~ m/$correctAnswer/i? 1: 0;
		my $quizplay = $c->model('DB::Quiz');
		$quizplay->update_or_create({
			league => $leagueId,
			exercise => $exerciseId,
			player => $player,
			question => $question->id,
			# text => $text->id,
			correct => $correct });
		if ( $correct ) {
		$c->stash->{status_msg} .= 
				" Your answer, \"$answer\" is correct."
		}
		else {
			$c->stash->{status_msg} .= " Your answer: \"$answer\".
				The correct answer: \"$correctAnswer\".";
		}
	}
	my $wordSet = $exercise->words;
	my $playSet = $c->model('DB::Play')->search(
			{player => $player, exercise => $exerciseId},
			{ order_by => 'blank' } );
	my @question = ( { Newline => 1 } );
	my $wordFilledFlag;
	while ( my $questionWord = $questionWords->next )
	{
		my $link = $questionWord->link;
		my $published = $questionWord->content;
		if ( $link == 0 )
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
						length $cloze ) {
						push @question, $published;
						$wordFilledFlag = 1; }
					else { push @question, '_' x
							length($published); }
				}
			}
		}
	}
	$c->stash->{questionwords} = \@question if $wordFilledFlag;
	$c->stash->{answer} = $question->answer;
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
    $c->stash->{exercises} = [$c->model('DB::Exercise')->all];
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
