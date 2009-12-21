package dic::Controller::Exercises;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Dictionary;
use FirstLast;
use Ctest;
use Total;
use Kwic;
use Last;
use Lingua::Stem qw/stem/;

=head1 NAME

dic::Controller::Exercises - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 form_create

Display form to collect information for exercise to create

=cut

sub form_create : Local {
	my ($self, $c) = @_;
	$c->stash->{template} = 'exercises/form_create.tt2';
}


=head2 list

Fetch all Exercise objects and pass to exercises/list.tt2 in stash to be displayed

=cut
 
sub list : Local {
    # Retrieve the usual perl OO '$self' for this object. $c is the Catalyst
    # 'Context' that's used to 'glue together' the various components
    # that make up the application
    my ($self, $c) = @_;
    my $leagueid = $c->session->{league};
    my $league = $c->model('DB::League')->find({id=>$leagueid});
    my $genre = $c->model('DB::Leaguegenre')->find({league=>$leagueid})->genre;
    # my $genre = $league->genre->genre;
    # Retrieve all of the text records as text model objects and store in
    # stash where they can be accessed by the TT template
    $c->stash->{exercises} = [$c->model('DB::Exercise')->search(
	    { genre => $genre })];
    # Set the TT template to use.  You will almost always want to do this
    # in your action methods (actions methods respond to user input in
    # your controllers).
    my $player = $c->session->{player_id};
    my @play = $c->model('DB::Play')->search(
	    { league => $league, player => $player },
		{ select => [ 'exercise', { sum => 'correct' } ],
		'group_by' => [qw/exercise/],
		as => [ qw/exercise score/ ],
		});
    my %scores = map { $_->exercise => $_->get_column('score') } @play;
    $c->stash->{scores} = \%scores;
    $c->stash->{league} = $league->name;
    $c->stash->{league} = $league->name;
    $c->stash->{template} = 'exercises/list.tt2';
}


=head2 create

Take text from database and output cloze exercise

=cut

sub create : Local {
	my ($self, $c, $textId, $exerciseType, $exerciseId) = @_;
	my $text = $c->model('DB::Text')->find( { id=>$textId } );
	my $description = $text->description;
	my $content = $text->content;
	my $unclozeables = $text->unclozeables;
	my $league = $c->session->{league};
	my $genre = $c->model('DB::Leaguegenre')->find(
				{ league => $league })->genre;
	my $index=0;
	my $clozeObject = $exerciseType->parse($unclozeables, $content);
	my $cloze = $clozeObject->cloze;
	my $newWords = $clozeObject->dictionary;
	my (@wordRows, @dictionaryList, %wordCount, @wordstemRows);
	my $dictionary = $c->model('DB::Dictionary')->search;
	my $id = 0;
	my @columns = $c->model('DB::Word')->result_source->columns;
	foreach my $word ( @$cloze )
	{
		my $token = $word->{published};
		if ( $token and $newWords->{$token} )
		{
			(my $initial = $token) =~ s/^(.).*$/$1/;
			my $entry = $dictionary->find(
				{ genre => $genre, word => $token });
			my $count = $entry? $entry->count: 0;
			my $stem = (stem $token)->[0];
			my $suffix;
			if ( $stem =~ m/.i$/ )
			{
				my $istem = $stem;
				chop $istem;
				($suffix = lc $token) =~ s/^$istem.(.*)$/$1/;
			}
			else { ($suffix = lc $token) =~ s/^$stem(.*)$/$1/; }
			$dictionary->update_or_create({
				genre => $genre,
				word => $token,
				initial => $initial,
				stem => $stem || '',
				suffix => $suffix || '',
				count =>++$count});
		}
		my $class = ref $word;
		my %row = map { $_ => $word->{$_} } @columns;
		$row{genre} = $genre;
		$row{exercise} = $exerciseId;
		$row{id} = $id++;
		$row{class} = $class;
		push @wordRows, \%row;
	}
	$c->model('DB::Word')->populate( \@wordRows );
	#@dictionaryList = map { m/^(.).*$/;
	#		{ exercise => $exerciseId, word => $_, initial => $1,
	#		count => $newWords->{$_} } } keys %$newWords;
	$c->model('DB::Exercise')->create({
				id => $exerciseId,
				text => $textId,
				genre => $genre,
				description => $description,
				type => $exerciseType
			});
	$c->stash->{exercise_id} = $exerciseId;
	$c->stash->{template} = 'exercises/create_done.tt2';
}


=head2 delete

Delete an exercise

=cut

	sub delete : Local {
# $id = primary key of book to delete
	my ($self, $c, $id) = @_;
	my $exercise = $c->model('DB::Exercise');
	my $words = $exercise->find({id => $id})->words;
	my %entries;
	while (my $word = $words->next)
	{
		my $token = $word->published;
		my $entry = $word->dictionary;
		if ( $entry )
		{
			my $count = $entry->count;
			$entry->update( {count => --$count} );
		}
	}
	$exercise->search({id => $id})->delete_all;
# Set a status message to be displayed at the top of the view
	$c->stash->{status_msg} = "Exercise deleted.";
# Forward to the list action/method in this controller
	$c->forward('list');
# Redirect the user back to the list page instead of forward
               $c->response->redirect($c->uri_for('list',
                   {status_msg => "Exercise deleted."}));
}


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    $c->response->body('Matched dic::Controller::Players in Players.');
}


=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
