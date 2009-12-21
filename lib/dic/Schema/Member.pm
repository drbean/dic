package dic::Schema::Member;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("members");
__PACKAGE__->add_columns(
  "league",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "player",
  { data_type => "VARCHAR", is_nullable => 0, size => 10 },
);
__PACKAGE__->set_primary_key("league", "player");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2H0UYSYlc/ex3aLButFiBg

#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(league => 'dic::Schema::League', 'league');

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(player => 'dic::Schema::Player', 'player');

=head1 NAME

DB::Member - A model object representing the JOIN between a player and 
a league

=head1 DESCRIPTION

=cut


# You can replace this text with custom content, and it will be preserved on regeneration
1;
