package dic::Schema::Questionword;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("questionwords");
__PACKAGE__->add_columns(
  "genre",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "text",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "question",
  { data_type => "SMALLINT", is_nullable => 0, size => undef },
  "id",
  { data_type => "SMALLINT", is_nullable => 0, size => undef },
  "content",
  { data_type => "VARCHAR", is_nullable => 0, size => 50 },
  "link",
  { data_type => "SMALLINT", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("genre", "text", "question", "id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xdh5AAQpLC8Xg9MZVkOoJg

__PACKAGE__->belongs_to( get_question => 'dic::Schema::Question', { 'foreign.id'=>'self.question', 'foreign.genre'=>'self.genre', 'foreign.text'=>'self.text', });
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');
# __PACKAGE__->has_many(questionwords => 'dic::Schema::Questionword',

=head1 NAME

DB::Questionword - A model object representing a word in a Question to a    Exercise.

=head1 DESCRIPTION

Questionwords belong to Exercises, and may be blankable. They will be blanked for a Player who hasn't yet got all the letters correct of the corresponding linked Word (blank) in Play and shown to Players who have. The absence of a link means they are shown to all Players.

Questionwords belong to Exercises, which belong to Texts, which have many Questions. Because Questions belong to Texts, and the Questionwords in them belong to Exercises, the relationship between Text and Exercise is needed to retrieve all the data about a Questionword, and specifically which Question and Text a Questionword comes from.

=cut

# You can replace this text with custom content, and it will be preserved on regeneration
1;
