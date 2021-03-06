package Dic::Controller::Kwic;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use FirstLast;

use List::Util qw/reduce/;

=head1 NAME

Dic::Controller::Kwic - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 list

Fetch all KWIC entries. Will be called only if there are other instances (except for links within 50 characters of the original link?). Show only cloze for entry leading us here. Show KWIC entries for other words with the same stems.

TODO Error message: Use of uninitialized value within %tokensUnclozed in length at /home/drbean/dic/script_files/../lib/dic/Controller/Kwic.pm line 116.

=cut
 
sub list : Local {
	my ($self, $c, $exerciseId, $keyId) = @_;
	my $player = $c->session->{player_id};
	my $league = $c->session->{league};
	my $genre = $c->model("DB::Leaguegenre")->find
			( {league => $league} )->genre;
	my $exercise = $c->model('DB::Exercise')->find(
				    {genre=> $genre, id=>$exerciseId});
	my $jigsawrole = $c->model('DB::Jigsawrole')->find({ league => $league, player=>$player });
	my $target = $jigsawrole->role;
	my $contextlength = 16;
	my $start = $keyId <= $contextlength? 1: $keyId - $contextlength;
	my $end = $keyId + $contextlength;
	my $words= $c->model('DB::Word')->search
			    ({genre => $genre, });
	my $keywordContext = $words->search(
		{exercise => $exerciseId, target => $target },
		{ where => { id => [ $start .. $end ] }, order_by => 'id' } );
	my $playSet = $c->model('DB::Play')->search(
			{player => $player, exercise => $exerciseId},
			{ order_by => 'blank' } );
	my %context; my $prepost = "prekeyword";
	while ( my $word = $keywordContext->next )
	{
		my $id = $word->id;
		my $class = $word->class;
		if ( $id == $keyId )
		{
			$c->stash->{originalpretext} = $context{prekeyword};
			$prepost = "postkeyword";
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
    my $keyword = $words->find(
	    {id => $keyId, exercise => $exerciseId, target => $target} );
    my $stem = $keyword->dictionary->stem;
    my @conflates = $c->model( 'DB::Dictionary' )->search({stem => $stem});
    my (@kwics, %tokenCounts, %tokensUnclozed);
    foreach my $conflate ( @conflates )
    {
	    my $token = $conflate->word;
	    $tokenCounts{ $token } = $conflate->count;
	    my $suffix = $conflate->suffix;
	    my $kwics =  $words->search( {},
        	{ select => [ qw/pretext unclozed clozed posttext/,  ],
        		where => {  class => "Word",
        			genre		=> $genre,
        			published	=> $token,
					exercise	=> $exerciseId,
					id			=> { '!=', $keyId }
						}
			} );
		my ($unclozed, %dupes);
		while ( my $kwic = $kwics->next )
		{
			my $pretext = $kwic->pretext;
			my $posttext = $kwic->posttext;
			$unclozed ||= $kwic->unclozed;
			$tokensUnclozed{$token} ||= $unclozed;
			push @kwics, { pretext => $pretext,
					unclozed => $unclozed,
					clozed => $kwic->clozed,
					suffix => $suffix,
					posttext => $posttext } unless
							$dupes{ $pretext . $posttext };
			$dupes{ $pretext . $posttext }++;
		}
    }
    my $representativeToken = reduce {
	    if ($tokenCounts{$a} > $tokenCounts{$b}) {$a}
	    elsif ($tokenCounts{$a} == $tokenCounts{$b}) {
		    if ( length $a <= length $b ) { $a }
		    else { $b }
		    }
	    else { $b }
	    } keys %tokenCounts;
    my $replength = 0;
	$replength = length $tokensUnclozed{$representativeToken} if 
		%tokensUnclozed;
    @kwics = map {
	    my $unclozeshortening = length($_->{unclozed}) - $replength;
	    $_->{clozed} = substr($_->{unclozed}, -$unclozeshortening,
				    $unclozeshortening, '') . $_->{clozed};
	    my $clozeshortening = length $_->{suffix};
	    substr($_->{clozed}, -$clozeshortening, $clozeshortening, '');
	    $_;
    } @kwics;
    my $published = $keyword->published;
    $c->stash->{stopword} = 1 if $c->model('DB::Stopword')->find({ word => lc($published) });
    $c->stash->{kwics} = \@kwics;
    $c->stash->{title} = $exercise->description;
    $c->stash->{id} = $exerciseId;
    $c->stash->{keyId} = $keyId;
    $c->stash->{target} = $target;
    $c->stash->{reversed} = $exercise->type eq "Last"? 1: 0;
    $c->stash->{template} = 'kwic/list.tt2';
}


=cut

sub index : Private {
    my ( $self, $c ) = @_;
    $c->response->body('Matched Dic::Controller::Players in Players.');
}


=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
