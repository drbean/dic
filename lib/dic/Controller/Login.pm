package dic::Controller::Login;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

dic::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

Login logic. We let "guest"s in without a password, or ID.

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    my $id       = $c->request->params->{id}       || "";
    my $name     = $c->request->params->{name}     || "";
    my $password = $c->request->params->{password} || "";
    if ( $name eq "guest" )
    {
	    $id = 1;
	    $password = 1;
    }
    if ( $id && $name && $password ) {
        my $username = $id;
        if ( $c->login( $username, $password ) ) {
            $c->session->{player_id} = $id;
            if ( $c->check_user_roles("official") ) {
                $c->stash->{id}      = $id;
                $c->stash->{name}    = $name;
                $c->stash->{leagues} =
                  [ $c->model('DB::League')->search( {} ) ];
                $c->stash->{template} = 'official.tt2';
                return;
            }
            my $member = $c->model("DB::Member")->find( { player => $id } );
            $c->session->{league} = $member->league->id;
            $c->session->{exercise} = undef;
            $c->response->redirect( $c->uri_for("/exercises/list") );
            return;
        }
        else {
            $c->stash->{error_msg} = "Bad username or password.";
            return;
        }
    }
    $c->stash->{template} = 'login.tt2';
}

=head2 official

Set league official is organizing

=cut

sub official : Path : Args(0) {
	my ($self, $c) = @_;
	my $league = $c->request->params->{league} || "";
       if ( $c->check_user_roles("official") )
       {
		$c->session->{league} = $league;
		$c->response->redirect($c->uri_for("/exercises/list"));
		return;
       }
     else {
       # Set an error message
       $c->stash->{error_msg} = "Bad username or password.";
	$c->stash->{template} = 'login.tt2';
      return;
   }
}


=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
