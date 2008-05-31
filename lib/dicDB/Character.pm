package dicDB::Character;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('characters');
# Set columns in table
__PACKAGE__->add_columns(qw/exercise id character/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/exercise id/);

__PACKAGE__->might_have(special => 'dicDB::Special',
	{ 'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.id'});

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
__PACKAGE__->has_many(attempt => 'dicDB::Play',
	{ 'foreign.exercise' => 'self.exercise', 'foreign.blank' => 'self.id'});
# __PACKAGE__->has_many(blank => 'dicDB::Play', 'blank');


# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');


=head1 NAME

dicDB::Characters - A model object representing a token parsed, ie an ordinary string of 1 or more characters, or Blanks or Newline, in a cloze

=head1 DESCRIPTION

This is an object that represents a row in the 'characters' table.

=cut

1;
