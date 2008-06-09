package dicDB::Special;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('specials');
# Set columns in table
__PACKAGE__->add_columns(qw/exercise id answer/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/exercise id/);

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
__PACKAGE__->has_many(response => 'dicDB::Play',
	{ 'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.blank'});

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');


=head1 NAME

dicDB::Special - A model object representing a special character, ie Blanks or Newline, in a cloze

=head1 DESCRIPTION

Only Blanks is made use of. This is an object that represents a row in the 'specials' table.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through dic::Model::dicDB.
Offline utilities may wish to use this class directly.

=cut

1;
