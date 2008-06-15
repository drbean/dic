package dicDB::Exercise;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('exercises');
# Set columns in table
__PACKAGE__->add_columns(qw/genre id text description type/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/genre id/);

#
# Set relationships:
#

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
__PACKAGE__->has_many(words => 'dicDB::Word',
	{ 'foreign.genre' => 'self.genre', 'foreign.exercise' => 'self.id'});
__PACKAGE__->has_many(questionwords => 'dicDB::QuestionWord',
	{ 'foreign.genre' => 'self.genre', 'foreign.exercise' => 'self.id'});


# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');

__PACKAGE__->belongs_to( text => 'dicDB::Text', { 'foreign.id'=>'self.text' });

=head1 NAME

dicDB::Player - A model object representing a dictation text in a competition

=head1 DESCRIPTION

This is an object that represents a row in the 'texts' table of your application
database.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through dic::Model::dicDB.
Offline utilities may wish to use this class directly.

=cut

1;
