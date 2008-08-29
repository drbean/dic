package dic::Controller::Leagues;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

dic::Controller::Leagues - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    $c->response->body('Matched dic::Controller::Leagues in Leagues.');
}


=head2 list

Fetch all league objects and pass to leagues/list.tt2 in stash to be displayed

=cut
 
sub list : Local {
    # Retrieve the usual perl OO '$self' for this object. $c is the Catalyst
    # 'Context' that's used to 'glue together' the various components
    # that make up the application
    my ($self, $c) = @_;

    # Retrieve all of the leauge records as leauge model objects and store in
    # stash where they can be accessed by the TT template
    $c->stash->{leagues} = [$c->model('DB::League')->all];
    
    # Set the TT template to use.  You will almost always want to do this
    # in your action methods (actions methods respond to user input in
    # your controllers).
    $c->stash->{template} = 'leagues/list.tt2';
}

=head2 url_create

Create a book with the supplied title, rating, and author

=cut

sub url_create : Local {
# In addition to self & context, get the title, rating, &
# author_id args from the URL.  Note that Catalyst automatically
# puts extra information after the "/<controller_name>/<action_name/"
# into @_
	my ($self, $c, $id, $name, $field, $player_id) = @_;

# Call create() on the book model object. Pass the table
# columns/field values we want to set as hash values
	my $league = $c->model('DB::League')->create({
	       id => $id,
		name  => $name,
	       field => $field
	   });

# Add a record to the join table for this league, mapping to
# appropriate player
	# $league->add_to_members({player => $player_id});
# Note: Above is a shortcut for this:
$league->create_related('members', {player_id => $player_id});
	$c->stash->{league} = $league;
# Set the TT template to use
	$c->stash->{template} = 'leagues/create_done.tt2';
}


=head2 form_create

Display form to collect information for league to create

=cut

sub form_create : Local {
	my ($self, $c) = @_;

# Set the TT template to use
	$c->stash->{template} = 'leagues/form_create.tt2';
}


=head2 form_create_do

Take information from form and add to database

=cut

sub form_create_do : Local {
	my ($self, $c) = @_;

# Retrieve the values from the form
	my $id     = $c->request->params->{id}     || 'N/A';
	my $name     = $c->request->params->{name}     || 'N/A';
	my $field    = $c->request->params->{field}    || 'N/A';
	my $player_ids = $c->request->params->{player_ids} || '1';
	my @player_ids = split ' ', $player_ids;

# Create the league
	my $league = $c->model('DB::League')->create({
		id => $id,
	       name   => $name,
	       field  => $field,
	   });
# Handle relationship with members
	$league->add_to_members({player => $_}) for @player_ids;

# Store new model object in stash
	$c->stash->{league} = $league;

# Avoid Data::Dumper issue mentioned earlier
# You can probably omit this
	$Data::Dumper::Useperl = 1;

# Set the TT template to use
	$c->stash->{template} = 'leagues/create_done.tt2';
}

=head2 delete

Delete a league

=cut

	sub delete : Local {
	my ($self, $c, $id) = @_;
	$c->model('DB::League')->search({id => $id})->delete_all;
	$c->stash->{status_msg} = "League deleted.";
	# $c->forward('list');
	# $c->response->redirect($c->uri_for('/leagues/list'));
	$c->response->redirect($c->uri_for('/leagues/list',
		{status_msg => "League deleted."}));
}




=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
