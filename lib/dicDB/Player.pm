package dicDB::Player;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('players');
# Set columns in table
__PACKAGE__->add_columns(qw/id name password/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/id/);

#
# Set relationships:
#

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
__PACKAGE__->has_many(member => 'dicDB::Member', 'player');
__PACKAGE__->has_many( play => 'dicDB::Play', 'player' );
__PACKAGE__->has_many( roles => 'dicDB::RoleBearer', 'player' );

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
__PACKAGE__->many_to_many(leagues => 'member', 'league');


=head1 NAME

dicDB::Player - A model object representing a player in a league

=head1 DESCRIPTION

This is an object that represents a row in the 'players' table of your application
database.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through dic::Model::dicDB.
Offline utilities may wish to use this class directly.

=cut

1;
