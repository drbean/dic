package dicDB::Dictionary;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('dictionaries');
# Set columns in table
__PACKAGE__->add_columns(qw/genre word initial stem suffix count/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/genre word/);

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
#__PACKAGE__->has_many(response => 'dicDB::Play',
#	{ 'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.blank'});

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');


=head1 NAME

dicDB::Dictionary - A model object for a list of answers for a Blank

=head1 DESCRIPTION

An object representing a row in the 'dictionaries' table.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through dic::Model::dicDB.
Offline utilities may wish to use this class directly.

=cut

1;
