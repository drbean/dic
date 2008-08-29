package dic::Schema::Role;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("roles");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", is_nullable => 0, size => undef },
  "role",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eMtLbOMLUApUodxw3X5V7Q

#
# Set relationships:
#

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
__PACKAGE__->has_many(rolebearers => 'dic::Schema::Rolebearer', 'role');

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
#__PACKAGE__->many_to_many(players => 'members', 'player');

=head1 NAME

DB::Role - A model object representing a role

=head1 DESCRIPTION

This is (IMO) a completely useless representation of a row in the 'roles' table +giving each role an ID. (But I can't understand how to use CPAuthorization::
).

=cut
# You can replace this text with custom content, and it will be preserved on regeneration
1;
