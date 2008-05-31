package dicDB::Play;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('play');
# Set columns in table
__PACKAGE__->add_columns(qw/league exercise player blank response correct/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/league exercise player blank/);

#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
#__PACKAGE__->belongs_to( word => 'dicDB::Word',
#	{ 'foreign.league' => 'self.league',
#	'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.blank'});
#__PACKAGE__->belongs_to( special => 'dicDB::Special',
#	{ 'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.blank'});
__PACKAGE__->belongs_to( player => 'dicDB::Player' );

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
# __PACKAGE__->has_many(reader => 'dicDB::Reader', 'text_id');

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');


=head1 NAME

dicDB::Play - A model object representing responses of players answering questions in a competition

=head1 DESCRIPTION

This is an object that represents a row in the 'play' table of your application
database.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through dic::Model::dicDB.
Offline utilities may wish to use this class directly.

=cut

1;
