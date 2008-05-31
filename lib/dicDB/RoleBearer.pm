package dicDB::RoleBearer;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('rolebearers');
# Set columns in table
__PACKAGE__->add_columns(qw/player role/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/player role/);

#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(player => 'dicDB::Player', 'player');
__PACKAGE__->belongs_to(role => 'dicDB::Role', 'role');

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
#__PACKAGE__->has_many(response => 'dicDB::Play',
#	{ 'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.blank'});

=head1 NAME

dicDB::RoleBearer - A model object representing the role of a player

=head1 DESCRIPTION

This is an object that represents a row in the 'rolebearers' table, with the role of the id, the primary key, ie the id of the player, being either 1 or 2 representing, 'player' or 'official', as defined by dicDB::Role.

=cut

1;
