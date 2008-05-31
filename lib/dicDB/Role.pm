package dicDB::Role;

use base qw/DBIx::Class/;  

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('roles');
# Set columns in table
__PACKAGE__->add_columns(qw/id role/);
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
__PACKAGE__->has_many(rolebearers => 'dicDB::RoleBearer', 'role');

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
#__PACKAGE__->many_to_many(players => 'members', 'player');


=head1 NAME

dicDB::Role - A model object representing a role

=head1 DESCRIPTION

This is (IMO) a completely useless representation of a row in the 'roles' table giving each role an ID. (But I can't understand how to use CPAuthorization::
).

=cut

1;
