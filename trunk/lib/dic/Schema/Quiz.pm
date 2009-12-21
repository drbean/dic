package dic::Schema::Quiz;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("quiz");
__PACKAGE__->add_columns(
  "league",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "exercise",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "player",
  { data_type => "INT", is_nullable => 0, size => undef },
  "question",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "correct",
  { data_type => "TINYINT", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("exercise", "player", "question");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PNFk+5/zLaTWWvrQxCx0ow

#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
#__PACKAGE__->belongs_to( word => 'DB::Word',
#       { 'foreign.league' => 'self.league',
#       'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.blank'});
#__PACKAGE__->belongs_to( special => 'DB::Special',
#       { 'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.blank'});
__PACKAGE__->belongs_to( player => 'dic::Schema::Player' );

# has_many():
#   args: 
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
# __PACKAGE__->has_many(reader => 'DB::Reader', 'text_id');

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');

=head1 NAME

DB::Quiz - A model object representing Players answering comprehension          +Questions composed of Questionwords in an Exercise

=head1 DESCRIPTION

Play rows, identified by league, exercise and player, belong to Players.        +'question' is the ID of the Question (or is it Text) and correct is whether    +the player answered correctly or not (1 or 0).

=cut



# You can replace this text with custom content, and it will be preserved on regeneration
1;
