package Dic::Schema::Rolebearer;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("rolebearers");
__PACKAGE__->add_columns(
  "player",
  { data_type => "VARCHAR", is_nullable => 0, size => 10 },
  "role",
  { data_type => "INT", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("player", "role");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PsKQbaHcdCZfirwldS9DLg

#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(player => 'Dic::Schema::Player', 'player');
__PACKAGE__->belongs_to(role => 'Dic::Schema::Role', 'role');

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
#__PACKAGE__->has_many(response => 'DB::Play',
#       { 'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.blank'});

=head1 NAME

DB::Rolebearer - A model object representing the role of a player

=head1 DESCRIPTION

This is an object that represents a row in the 'rolebearers' table, with the    +role of the id, the primary key, ie the id of the player, being either 1 or 2  +representing, 'player' or 'official', as defined by DB::Role.

=cut


# You can replace this text with custom content, and it will be preserved on regeneration
1;
