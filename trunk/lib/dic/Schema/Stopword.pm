package dic::Schema::Stopword;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("stopwords");
__PACKAGE__->add_columns(
  "id",
  { data_type => "SMALLINT", is_nullable => 0, size => undef },
  "word",
  { data_type => "VARCHAR", is_nullable => 0, size => 50 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xdh5AAQpLC8Xg9MZVkOoJg

# __PACKAGE__->belongs_to( get_question => 'dic::Schema::Question', { 'foreign.id'=>'self.question', 'foreign.genre'=>'self.genre', 'foreign.text'=>'self.text', });
# __PACKAGE__->belongs_to( get_text => 'dic::Schema::Text', { 'foreign.id'=>'self.question', 'foreign.genre'=>'self.genre', });
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');
# __PACKAGE__->has_many(questionwords => 'dic::Schema::Questionword',

=head1 NAME

DB::Questionword - A model object representing a word in a Question to a    Exercise.

=head1 DESCRIPTION

Stopwords are words that do not provide useful results on searches in databases. In this case, searching for tags on pictures.

# You can replace this text with custom content, and it will be preserved on regeneration

=cut

1;
