package dic::Schema::Word;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("words");
__PACKAGE__->add_columns(
  "genre",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "exercise",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "target",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "id",
  { data_type => "SMALLINT", is_nullable => 0, size => undef },
  "class",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "published",
  { data_type => "VARCHAR", is_nullable => 1, size => 500 },
  "unclozed",
  { data_type => "VARCHAR", is_nullable => 1, size => 500 },
  "clozed",
  { data_type => "VARCHAR", is_nullable => 1, size => 15 },
  "pretext",
  { data_type => "CHAR", is_nullable => 1, size => 50 },
  "posttext",
  { data_type => "CHAR", is_nullable => 1, size => 50 },
);
__PACKAGE__->set_primary_key("genre", "exercise", "target", "id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F4yv/Lar5h2yHp2AWgpW7Q

#
# Set relationships:
#

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
#__PACKAGE__->has_many(attempt => 'DB::Play',
#       { 'foreign.genre' => 'self.genre',
#       'foreign.exercise' => 'self.exercise', 'foreign.blank' => 'self.id'});

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(exercise => 'dic::Schema::Exercise',
        {'foreign.genre' => 'self.genre', 'foreign.id' =>'self.exercise'});
__PACKAGE__->belongs_to(dictionary => 'dic::Schema::Dictionary',
        {'foreign.genre' => 'self.genre', 'foreign.word' =>'self.published'});


# You can replace this text with custom content, and it will be preserved on regeneration
1;
