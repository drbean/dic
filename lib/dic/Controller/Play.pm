package dic::Controller::Play;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use FirstLast;

use POSIX;
use Math::Random;


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

=head2 setup

Create player's rows in Play table. Words in randomly chosen n-word length cloze sections add up to 1/p of the total clozeable words.

=cut
 
sub setup :Chained('/') :PathPart('play') :CaptureArgs(1) {
	my ($n,$sd) = (12,2); my $p = 1/5;
	my ($self, $c, $exerciseId) = @_;
	my $player = $c->session->{player_id};
	my $leagueId = $c->session->{league};
	my $genre = $c->model("DB::Leaguegenre")->find(
			{ league => $leagueId } )->genre;
	my $wordSet = $c->model('DB::Word')->search(
		{genre => $genre, exercise => $exerciseId, class => 'Word' },
		{ order_by => 'id' } );
	my $playSet = $c->model('DB::Play')->search(
			{player => $player, exercise => $exerciseId},
			{ order_by => 'blank' } );
	if ( $playSet == 0 ) {
		my $wordcount = $wordSet->count;
		my $sections = $p * $wordcount / $n;
		my $sectionlength = $wordcount / $sections;
		my @clozelengths = random_normal($sections,$n,$sd);
		my ($word, $blank);
		$word = $wordSet->next;
		$blank = $word->id;
		foreach my $section ( 1 .. $sections ) {
			my $clozelength = shift @clozelengths;
			my $leadingspaces = random_uniform_integer(
				1,1,$sectionlength-$clozelength-1);
			my $trailingspaces = $sectionlength - (
				$leadingspaces + $clozelength -1 );
			while ( $leadingspaces-- >= 0 ) {
				$word = $wordSet->next;
				last unless $word;
			}
			$blank = $word->id;
			while ( $clozelength-- >= 0 ) {
				$playSet->create({ player => $player,
					exercise => $exerciseId,
					blank => $blank,
					league => $leagueId,
					correct => 0 });
			} continue {
				$word = $wordSet->next;
				last unless $word;
				$blank = $word->id;
			}
			while ( $trailingspaces-- >= 0 ) {
				$word = $wordSet->next;
				last unless $word;
			}
		}
	}
	$c->stash->{exercise} = $exerciseId;
	$c->stash->{genre} = $genre;
	$c->stash->{wordset} = $wordSet;
	$c->stash->{template} = "play/start.tt2";
}

=head2 update

Check answers, fetch all characters and pass to characters/list.tt2 for display.

=cut
 
sub update :Chained('setup') :PathPart('') :CaptureArgs(0) {
	my ($self, $c) = @_;
	my $player = $c->session->{player_id};
	my $leagueId = $c->session->{league};
	my $target = $c->model('DB::Jigsawrole')->find({
			league => $leagueId, player => $player });
	# my $targetId = $target? $target->role: 'all';
	my $targetId = 'all';
	my $exerciseId = $c->stash->{exercise};
	my $genre = $c->model("DB::Leaguegenre")->find(
			{ league => $leagueId } )->genre;
	my $text = $c->model('DB::Exercise')->find(
		{ genre => $genre, id => $exerciseId } );
	$c->stash->{genre} = $genre;
	$c->stash->{exercise} = $exerciseId;
	$c->stash->{text} = $text->id;
	$c->stash->{target} = $targetId;
	my $gameover;
	if ( $c->model("BettDB::Exercise")->find({ id => $exerciseId }) ) {
		for my $allcourse ( 'WH', 'YN', 'S' ) {
			my $standing = $c->model("BettDB::$allcourse")
				->find({ player => $player,
				exercise => $exerciseId,
				league => $leagueId });
			next unless $standing;
			$c->stash($allcourse => $standing);
			$gameover++ if ( $standing->questionchance < 0 or
				$standing->answerchance < 0 );
			$gameover++ if ( $standing->score >=
				$c->config->{$allcourse}->{win} );
			if ( $gameover ) {
				$c->stash->{template} = "gameover.tt2";
				last;
			}
		}
	}
	return if $c->stash->{template} and
					$c->stash->{template} eq "play/gameover.tt2";
	$c->stash->{player_id} = $player;
	$c->stash->{password} = $c->model("DB::Player")->find( $player )
		->password;
	$c->stash->{template} = "play/start.tt2";
}


=head2 clozeupdate

Partly-correct answers are accepted up to the first letter that is wrong.

=cut
 
sub clozeupdate :Chained('update') :PathPart('') :Args(0) {
	my ($self, $c) = @_;
	my $player = $c->session->{player_id};
	my $league = $c->session->{league};
	my $exerciseId = $c->stash->{exercise};
	my $genre = $c->stash->{genre};
	my $exerciseType = $c->model('DB::Exercise')->find(
			{ genre => $genre, id =>$exerciseId },)->type;
	my $textId = $c->stash->{text};
	my $title = $c->model('DB::Text')->find({ id => $textId })->description;
	my $wordSet = $c->model('DB::Word')->search(
		{genre => $genre, exercise => $exerciseId },
			{ order_by => 'id' } );
	my $playSet = $c->model('DB::Play')->search(
			{player => $player, exercise => $exerciseId},
			{ order_by => 'blank' } );
	my $dictionary = $c->model('DB::Dictionary')->search(
			{genre => $genre});
	my $responses = $c->request->params;
	my $play =  $c->model('DB::Play');
	my $score = 0;
	my @cloze = ( { Newline => 1 }, { Newline => 1 } );
	while (my $word = $wordSet->next)
	{
		my $id = $word->id;
		my $unclozed = $word->unclozed;
		my $published = $word->published;
		my $class = $word->class;
		if ( $class eq 'Word' )
		{
			my $entry = $dictionary->find({ word => $published});
			my $kwic = ($entry and $entry->count > 1)? 1: 0;
			if ( $exerciseType eq "FirstLast" )
			{
				chop $published unless length $published <= 2;
			}
			my $target = $playSet->find({ blank=>$id });
			my $correct = $target? $target->correct: 0;
			my $clozed = $word->clozed;
			my $allLetters = length $clozed;
			my $response = $responses->{$id};
			unless ( $target ) {
				push @cloze, $unclozed, '□' x length $clozed;
			}
			elsif ( $correct == $allLetters ) {
				$score += $allLetters;
				push @cloze, $published;
			}
			elsif ( $response )
			{
				my $letters = length $response;
				my $answer = substr $clozed, $correct;
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
	$c->stash->{status_msg} .= "<p>$name has $score letters correct";
	$c->stash->{reversed} = $exerciseType eq "Last"? 1: 0;
	$c->stash->{words} = $wordSet;
}


=head2 questionupdate

Words correctly answered in the text that are also in a comprehension question appear in the question.

=cut
 
sub questionupdate : Local {
	my ($self, $c, $exerciseId) = @_;
	my $player = $c->session->{player_id};
	my $leagueId = $c->session->{league};
	my $question = $c->stash->{question};
	$c->stash->{question_id} = $question->id;
	my $questionWords = $question->words;
	my $answer = $c->request->params->{answer};
	if ( $answer )
	{
		my $correctAnswer = $question->answer;
		my $correct = $answer =~ m/$correctAnswer/i? 1: 0;
		my $quizplay = $c->model('DB::Quiz');
		my $quiz = $quizplay->find({
			league => $leagueId,
			exercise => $exerciseId,
			player => $player,
			question => $question->id, });
		$quiz->update({
			answer => $answer,
			correct => $correct });
		if ( $correct ) {
			$c->stash->{status_msg} =
				"Congratulations, $player, on the correct answer for the
				$exerciseId exercise.
				<p>Full score for this homework.";
			$c->stash->{template} = "play/gameover.tt2";
		}
		else {
			$c->stash->{status_msg} .= " Your answer for the $exerciseId is
				not correct. You cannot change your answer.";
			$c->stash->{template} = "play/start.tt2";
		}
		return;
	}
	my $wordSet = $c->stash->{words};
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
