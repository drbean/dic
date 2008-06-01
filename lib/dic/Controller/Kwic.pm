package dic::Controller::Kwic;

use strict;
use warnings;
use base 'Catalyst::Controller';
use FirstLast;

=head1 NAME

dic::Controller::Kwic - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 list

Fetch all KWIC entries. Will be called only if there are other instances (and for links within 50 characters of the original link?). Show only cloze for entry leading us here.

=cut
 
sub list : Local {
	my ($self, $c, $exerciseId, $keyId) = @_;
	my $player = $c->session->{player_id};
	my $league = $c->session->{league};
	my $genre = $c->model("dicDB::LeagueGenre")->find
			( {league => $league} )->genre;
	my $exercise = $c->model('dicDB::Exercise')->find(
				    {genre=> $genre, id=>$exerciseId});
	my $contextlength = 16;
	my $start = $keyId <= $contextlength? 1: $keyId - $contextlength;
	my $end = $keyId + $contextlength;
	#my $keyword = $c->model('dicDB::Word')->find( { id => $keyId,
	#		    genre => $genre, exercise => $exerciseId} );
	my $words= $c->model('dicDB::Word')->search(
			    {genre => $genre, exercise => $exerciseId},
				{ where => { id => [ $start .. $end ] },
				order_by => 'id' } );
	my $playSet = $c->model('dicDB::Play')->search(
			{player => $player, exercise => $exerciseId},
			{ order_by => 'blank' } );
	my %context; my $prepost = "prekeyword"; my $keyword;
	while ( my $word = $words->next )
	{
		my $id = $word->id;
		my $class = $word->class;
		if ( $id == $keyId )
		{
			$c->stash->{originalpretext} = $context{prekeyword};
			$prepost = "postkeyword";
			$keyword = $word->published;
			$c->stash->{keyword} = { clozed => $word->clozed,
						unclozed => $word->unclozed };
		}
		elsif ( $word->class eq "Newline" )
		{
			push @{$context{$prepost}}, { Newline => 1 };
		}
		elsif ( $class eq 'Word' )
		{
			my $played = $playSet->find({ blank=>$id });
			my $correct = $played? $played->correct: 0;
			my $clozed = $word->clozed;
			my $answered = substr $clozed, 0, $correct;
			my $length = length($clozed)-length($answered);
			push @{$context{$prepost}}, { length => $length,
					unclozed => $word->unclozed,
					answered => $answered,
					};
		}
		else { push @{$context{$prepost}}, $word->published; }
	}
    $c->stash->{originalposttext} = $context{postkeyword};
    $c->stash->{kwics} = [ $c->model('dicDB::Word')->search( {},
		{ select => [ qw/pretext posttext/,  ],
			where => {  class => "Word",
				genre => $genre,
				published => $keyword,
				-nest => [
				exercise => { '!=', $exerciseId },
				id => { '!=', $keyId } ]
			}
		} ) ];
    $c->stash->{title} = $exercise->description;
    $c->stash->{id} = $exerciseId;
    $c->stash->{reversed} = $exercise->type eq "Last"? 1: 0;
    $c->stash->{template} = 'kwic/list.tt2';
}


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
