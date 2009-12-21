package dic::Controller::Dictionary;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use FirstLast;

=head1 NAME

dic::Controller::Dictionary - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 list

Fetch all dictionary entries and output frequency counts (in each exercise?). See mysql tutorial for SUM, COUNT explanation.

=cut
 
sub list : Local {
    my ($self, $c, $league) = @_;
    $c->stash->{words} = [$c->model('DB::Dictionary')->search(
		{ league => $league },
		{ select => [ 'word', { sum => 'count' } ],
		'group_by' => 'word',
		as => [ qw/word sum/ ],
		} ) ];
    # Set the TT template to use.  You will almost always want to do this
    # in your action methods (actions methods respond to user input in
    # your controllers).
    $c->stash->{template} = 'dictionary/list.tt2';
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
