package dic::Schema::Exercise;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("exercises");
__PACKAGE__->add_columns(
  "genre",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "id",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "text",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "description",
  { data_type => "VARCHAR", is_nullable => 0, size => 50 },
  "type",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
);
__PACKAGE__->set_primary_key("genre", "id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:o0KPEBgCYRaRNsT0RCtavA

#
# Set relationships:
#

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
__PACKAGE__->has_many(words => 'dic::Schema::Word',
        { 'foreign.genre' => 'self.genre', 'foreign.exercise' => 'self.id'});
# __PACKAGE__->has_many(questionwords => 'dic::Schema::Questionword',
#	{ 'foreign.genre' => 'self.genre', 'foreign.text' => 'self.text'});


# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(questions => 'questions', 'questions');

__PACKAGE__->belongs_to( text => 'dic::Schema::Text', { 'foreign.id'=>'self.text' });

# You can replace this text with custom content, and it will be preserved on regeneration
1;
