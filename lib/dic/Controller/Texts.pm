package dic::Controller::Texts;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

dic::Controller::Texts - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index : Private {
    my ( $self, $c ) = @_;

    $c->response->body('Matched dic::Controller::Texts in Texts');
}


=head2 list

Fetch all Text objects and pass to texts/list.tt2 in stash to be displayed

=cut
 
sub list : Local {
    # Retrieve the usual perl OO '$self' for this object. $c is the Catalyst
    # 'Context' that's used to 'glue together' the various components
    # that make up the application
    my ($self, $c) = @_;
    my $league = $c->session->{league};
    my $genre = $c->model("dicDB::LeagueGenre")->find({league=>$league})->genre;
    # Retrieve all of the text records as text model objects and store in
    # stash where they can be accessed by the TT template
    $c->stash->{texts} = [$c->model('dicDB::Text')->search({genre => $genre})];
    # Set the TT template to use.  You will almost always want to do this
    # in your action methods (actions methods respond to user input in
    # your controllers).
    $c->stash->{template} = 'texts/list.tt2';
}

=head2 form_create

Display form to collect information for text to add

=cut

sub form_create : Local {
	my ($self, $c) = @_;

# Set the TT template to use
	$c->stash->{template} = 'texts/form_create.tt2';
}


=head2 form_create_do

Take information from form and add to database

=cut

sub form_create_do : Local {
	my ($self, $c) = @_;
	my $id     = $c->request->params->{id}     || 'N/A';
	my $genre     = $c->request->params->{genre}     || 'N/A';
	my $description     = $c->request->params->{description}     || 'N/A';
	my $content    = $c->request->params->{content}    || 'N/A';
	my $unclozeables = $c->request->params->{unclozeables} || '1';
	$unclozeables =~ s/\r\n/|/g;
	my $text = $c->model('dicDB::Text')->create({
		id => $id,
	       genre   => $genre,
	       description   => $description,
	       content  => $content,
	       unclozeables => $unclozeables
	   });
	$c->stash->{text} = $text;
	$c->stash->{template} = 'texts/create_done.tt2';
}


=head2 delete

Delete a text

=cut

sub delete : Local {
# $id = primary key of book to delete
	my ($self, $c, $id) = @_;
# Search for the book and then delete it
	$c->model('dicDB::Text')->search({id => $id})->delete_all;
# Set a status message to be displayed at the top of the view
	$c->stash->{status_msg} = "Text deleted.";
# Redirect the user back to the list page instead of forward
               $c->response->redirect($c->uri_for('/texts/list',
                   {status_msg => "Text deleted."}));
}


=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
