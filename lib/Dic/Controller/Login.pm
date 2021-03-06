package Dic::Controller::Login;

# $Id$

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Dic::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

Login logic. We used to let "guest"s in without a password, or ID and also redirect to exercise list. Now we redirect to the exercise, if it appears as the one argument.

=cut

sub index : Path : Args(0) {
	my ( $self, $c ) = @_;
	my $id	   = $c->request->params->{id}		  || "";
	my $name	 = $c->request->params->{name}		|| "";
	my $password = lc $c->request->params->{password} || "";
	if ( $id && $name && $password ) {
		my $username = $id;
		if ( $c->authenticate( { id => $username, password => $password } ) ) {
			$c->session->{player_id} = $id;
			$c->session->{question}  = undef;
			my $officialrole = 1;
			if ( $c->check_user_roles($officialrole) ) {
				$c->stash->{id}   = $id;
				$c->stash->{name} = $name;
				my @leagues = $c->model('DB::League')->search({});
				$c->stash->{leagues} = \@leagues;
				my $jigsawroles = $c->model('DB::Jigsawrole');
				my $oldrole = $jigsawroles->search( { player => $id } )->next;
				if ($oldrole) {
					$c->stash->{oldrole} = $oldrole->role;
				}
				$c->stash->{jigsawroles} =
				  [ $jigsawroles->get_column('role')->func('DISTINCT') ];
				$c->stash->{template} = 'official.tt2';
				return;
			}
			my @memberships =
			  $c->model("DB::Member")->search( { player => $id } );
			my @leagues;
			my $exercise = $c->request->query_params->{exercise} ||
				$c->session->{exercise};
			my @id_dupes = $c->model("DB::Exercise")->search( {id => $exercise });
			for my $exercise (@id_dupes) {
				my $genre = $exercise->genre;
				$c->session->{genre} = $genre;
				for my $membership (@memberships) {
					push @leagues, $membership->league if
						$membership->league->genre->genre eq $genre;
				}
			}
			die "No exercise with id, \"$exercise\", and genre, \"" .
				$c->session->{genre} . "\". Please contact Dr Bean." unless @leagues;
			if ( @leagues > 1 ) {
				$c->stash->{id}	   = $id;
				$c->stash->{name}	 = $name;
				$c->stash->{leagues}  = \@leagues;
				$c->stash->{template} = 'membership.tt2';
				return;
			}
			$c->session->{league} = $leagues[0]->id;
			if ( defined $c->session->{exercise} ) {
				my $exercise = $c->session->{exercise};
				$c->response->redirect(
					$c->uri_for("/play/$exercise"), 303 );
			}
			else {
				$c->response->redirect( $c->uri_for("/exercises/list"), 303 );
			}
			return;
		}
		else {
			$c->stash->{error_msg} = "Bad username or password.";
		}
	}
	else {
		$c->stash->{error_msg} = "You need id, name and password.";
	}
	$c->response->header( 'Cache-Control' => 'no-cache' );
	$c->stash->{template} = 'login.tt2';
}

=head2 official

Set league official is organizing. Use session player_id to authenticate the participant. Also set jigsaw role the official is taking.

=cut

sub official : Local {
	my ($self, $c) = @_;
	my $league = $c->request->params->{league} || "";
	my $jigsawrole = $c->request->params->{jigsawrole} || "";
	my $password = lc $c->request->params->{password} || "";
	my $username = $c->session->{player_id};
	if ( $c->authenticate( {id =>$username, password=>$password} ) ) {
		# my $officialrole = "official";
		my $officialrole = 1;
		if ( $c->check_user_roles($officialrole) ) {
			$c->session->{league} = $league;
			$c->model('DB::Jigsawrole')->update_or_create(
				{ league => $league, player => $username, role => $jigsawrole } )
					if defined $jigsawrole;
			$c->response->redirect($c->uri_for("/exercises/list"), 303);
			return;
		}
		else {
			# Set an error message
			$c->stash->{error_msg} = "Bad official name or password?";
			$c->stash->{template} = 'login.tt2';
			return;
		}
	}
	$c->response->header( 'Cache-Control' => 'no-cache' );
	$c->stash->{error_msg} = "No '$username' username or bad password?";
	$c->stash->{template} = 'login.tt2';
}


=head2 membership

Set league multi-membership player is participating in.

=cut

sub membership : Local {
	my ($self, $c) = @_;
	my $league = $c->request->params->{league} || "";
	my $password = $c->request->params->{password} || "";
	$c->session->{league} = $league;
	if ( defined $c->session->{exercise}) {
		my $exercise = $c->session->{exercise};
		$c->response->redirect(
			$c->uri_for( "/play/$exercise" ), 303 );
	}
	else {
		$c->response->redirect( $c->uri_for("/exercises/list"), 303 );
	}
	return;
	return;
}


=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
