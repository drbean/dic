package dicDB::Word;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('words');
# Set columns in table
__PACKAGE__->add_columns(qw/genre exercise id class published unclozed clozed pretext posttext/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/genre exercise id/);

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
#__PACKAGE__->has_many(attempt => 'dicDB::Play',
#	{ 'foreign.genre' => 'self.genre',
#	'foreign.exercise' => 'self.exercise', 'foreign.blank' => 'self.id'});

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(exercise => 'dicDB::Exercise',
	{'foreign.genre' => 'self.genre', 'foreign.id' =>'self.exercise'});
__PACKAGE__->belongs_to(entry => 'dicDB::Dictionary',
	{'foreign.genre' => 'self.genre', 'foreign.word' =>'self.published'});

=head1 NAME

dicDB::Word - A model object representing a string or a special object, ie Word or Newline, in a cloze text 

=head1 DESCRIPTION

This is an object that represents a row in the 'words' table.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through dic::Model::dicDB.
Offline utilities may wish to use this class directly.

=cut

1;
