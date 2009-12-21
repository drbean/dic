package dic::Controller::Pics;

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use Flickr::API;

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
			genre => $genre, id => $wordId })->published;
	my $pics = $c->model('DB::Pic');
	$c->stash->{template} = 'pics/list.tt2';
	my $total = 400;
	my @oldurls = $pics->search({ word => $word });
	unless ( @oldurls ) {
		my $api = Flickr::API->new({key =>
			'ea697995b421c0532215e4a2cbadbe1e',
			secret => 'ab2024b750a9d1f2' });
		my $r = $api->execute_method('flickr.photos.search',
			{ tags => $word, per_page => $total, api_key =>
				'ea697995b421c0532215e4a2cbadbe1e' });
		unless ( $r->{success} ) {
			$c->stash->{error_msg} = $r->{error_message};
			return;
		}
		my @newurls;
		for my $n ( 0 .. $total-1 ) {
			my $photo = $r->{tree}->{children}->[1]->
				{children}->[2*$n+1]->{attributes};
			my $title = $photo->{title};
			next unless defined $title and $title =~ m/$word/i;
			my %row;
			$row{title} = $photo->{title};
			$row{id} = undef;
			$row{word} = $word;
			$row{url} = 'http://farm' . $photo->{farm} .
				'.static.flickr.com/'.  $photo->
				{server} .  '/'.  $photo->{id} . '_' .
				$photo->{secret} . '_t.jpg';
			push @newurls, \%row;
		}
		$pics->populate(\@newurls);
		$c->stash->{urls} = \@newurls;
	}
	$c->stash->{urls} = \@oldurls;
	$c->stash->{urls} ||= [];
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
