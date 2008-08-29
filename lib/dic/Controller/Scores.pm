package dic::Controller::Scores;

use strict;
use warnings;
use List::Util qw/sum/;
use List::MoreUtils qw/any/;
use base 'Catalyst::Controller';
use FirstLast;

=head1 NAME

dic::Controller::Scores - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 list

Fetch all Score objects (in a league) and pass to scores/list.tt2 in stash to be displayed TODO When exercises are deleted we still want to keep scores. But how will the exerciseHeaders reflect the exercise the kept score is for. order_by => exercise is not sufficient.

=cut
 
sub list : Local {
    my ($self, $c) = @_;
	my $league = $c->session->{league};
    my $play = $c->model('DB::Play')->search({ league => $league },
		{ select => [ 'player', 'exercise', { sum => 'correct' } ],
		'group_by' => [qw/player exercise/],
		as => [ qw/player exercise score/ ],
		'order_by' => 'player' });
	my $scores;
	my %exerciseList;
	while ( my $result = $play->next )
	{
		my $player = $result->player->id;
		my $exercise = $result->exercise;
		my $score = $result->get_column('score');
		$scores->{$player}->{$exercise} = $score;
		$scores->{$player}->{Total} += $score;
	        $exerciseList{$exercise}++;
	}
    my @exerciseIds = sort { lc($a) cmp lc($b) } keys %exerciseList;
    # my @exerciseHeaders = map { s/-/ /g; s/\b(\w)/\u$1/g; $_ } @exerciseIds;
    my @exerciseHeaders = @exerciseIds;
    $c->stash->{exercises} = [@exerciseHeaders, 'Total'];
    $c->stash->{scores} = $scores;
    $c->stash->{template} = 'scores/list.tt2';
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
