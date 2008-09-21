package dic::Schema::Leaguegenre;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("leaguegenre");
__PACKAGE__->add_columns(
  "league",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "genre",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
);
__PACKAGE__->set_primary_key("league", "genre");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X/T80EwYFgHTk/HH08umVQ

#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(getleague => 'dic::Schema::League', 'league');

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
#__PACKAGE__->has_many(leagues => 'dic::Schema::Leagues',
#       { 'foreign.id' => 'self.league', 'foreign.id' => 'self.blank'});

=head1 NAME

DB::Member - A model object representing the JOIN between a league and 
a player

=head1 DESCRIPTION

=cut

# You can replace this text with custom content, and it will be preserved on regeneration
1;