package Dic::Schema::Question;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("questions");
__PACKAGE__->add_columns(
  "genre",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "text",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "id",
  { data_type => "SMALLINT", is_nullable => 0, size => undef },
  "target",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "content",
  { data_type => "VARCHAR", is_nullable => 0, size => 500 },
  "answer",
  { data_type => "VARCHAR", is_nullable => 0, size => 500 },
);
__PACKAGE__->set_primary_key("genre", "text", "id", "target");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iWCFlAeel15/IkixzdaDcQ

#
# Set relationships:
#

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
__PACKAGE__->has_many(words => 'Dic::Schema::Questionword',
        { 'foreign.genre' => 'self.genre', 'foreign.text' => 'self.text',
		'foreign.question' => 'self.id', 'foreign.target' => 'self.target' });


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
__PACKAGE__->belongs_to(get_text => 'Dic::Schema::Text',
        {'foreign.target' => 'self.target', 'foreign.id' => 'self.text' });

=head1 NAME

DB::Question - A model object representing a comprehension question about an Exercise

=head1 DESCRIPTION

Questions belong to a Text and have many Questionwords. One Text may have many Questions. Questions have content, ie the text of the question, and one answer.

They belong to a Text rather than Exercise, because they have to be imported  before the Exercise has been created.

Because Questions belong Texts, and the Questionwords in them belong to     Exercises, the relationship between Text and Exercise is needed to retrieve  all the data about a Questionword, and specifically which Question a      Questionword belongs_to.

=cut


# You can replace this text with custom content, and it will be preserved on regeneration
1;
