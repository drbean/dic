package dic::Controller::Pics;

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use Flickr::API;
use Lingua::Stem;
use Lingua::EN::Infinitive;
use Lingua::EN::Conjugate qw/past participle gerund/;

=head1 NAME

dic::Controller::Pics - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 find

Find a Flickr picture. Would be good to be able to hit database only once for all the pictures with one tag. Perhaps I should do that when building the exercise. Doing it JIT, need to instantiate API object each time.
	$c->stash->{url} = 'http://farm4.static.flickr.com/3515/3470432168_8e8509962d.jpg';

=cut
 
sub find : Local {
	my ($self, $c, $exerciseId, $wordId) = @_;
	my $league = $c->session->{league};
	my $genre = $c->model("DB::Leaguegenre")->find
			( {league => $league} )->genre;
	my $word = $c->model('DB::Word')->find({exercise=>$exerciseId,
			genre => $genre, id => $wordId });
	my $tag = $word->published;
	my $lctag = lc $tag;
	my $stem = Lingua::Stem::stem($lctag)->[0];
	my $canonize = Lingua::EN::Infinitive->new;
	my @infinit;
	for ( ($canonize->stem($lctag))[0..1] ) { push @infinit, $_ if $_ }
	my @conjugates = map {( past($_), participle($_), gerund($_))} @infinit;
	my $tags = join ',', $tag, $lctag, @infinit, @conjugates;
	my $titlesearch = join '|', $lctag, @infinit, @conjugates;
	my $titleregex = qr/$titlesearch/i;
	$c->stash->{exerciseid} = $word->exercise->id;
	$c->stash->{title} = $word->exercise->description;
	my $pics = $c->model('DB::Pic');
	$c->stash->{template} = 'pics/list.tt2';
	my $fetched = 300;
	my $needed = 20;
	my $page = 1;
	my @oldurls = $pics->search({ word => $stem });
	unless ( @oldurls ) {
		my $api = Flickr::API->new({key =>
			'ea697995b421c0532215e4a2cbadbe1e',
			secret => 'ab2024b750a9d1f2' });
		my $r = $api->execute_method('flickr.photos.search',
			{ tags => $tags, per_page => $fetched,
				page => $page++, api_key =>
				'ea697995b421c0532215e4a2cbadbe1e' });
		unless ( $r->{success} ) {
			$c->stash->{error_msg} = $r->{error_message};
			return;
		}
		my @newurls;
		for my $n ( 0 .. $fetched-1 ) {
			my $photo = $r->{tree}->{children}->[1]->
				{children}->[2*$n+1]->{attributes};
			next unless $photo->{title} =~ $titleregex;
			my $owner = $photo->{owner};
			next if $pics->search({ owner => $owner })->count;
			my %row;
			$row{title} = $photo->{title};
			$row{id} = undef;
			$row{word} = $stem;
			$row{owner} = $owner;
			$row{url} = 'http://farm' . $photo->{farm} .
				'.static.flickr.com/'.  $photo->
				{server} .  '/'.  $photo->{id} . '_' .
				$photo->{secret} . '_t.jpg';
			$pics->update_or_create( \%row );
			push @newurls, \%row;
			$needed--;
		}
		$c->stash->{urls} = \@newurls;
	}
	else { $c->stash->{urls} = \@oldurls; }
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
