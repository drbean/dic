package dic::Schema::Text;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("texts");
__PACKAGE__->add_columns(
  "id",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "description",
  { data_type => "VARCHAR", is_nullable => 0, size => 50 },
  "genre",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "target",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "content",
  { data_type => "VARCHAR", is_nullable => 0, size => 7500 },
  "unclozeables",
  { data_type => "VARCHAR", is_nullable => 0, size => 7500 },
);
__PACKAGE__->set_primary_key("id");
# __PACKAGE__->set_primary_key("id", "target");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yJ/w76ICBXQndZISwHCaCA

#
# Set relationships:
#

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
__PACKAGE__->has_many(questions => 'dic::Schema::Question',
        { 'foreign.genre' => 'self.genre', 'foreign.text' => 'self.id', });
		# 'foreign.target' => 'self.target', });


# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');

=head1 NAME

dic::Schema::Texts - A model object representing a dictation text in a competition 

=head1 DESCRIPTION

# unclozeables are separated by '|'

=cut

# You can replace this text with custom content, and it will be preserved on regeneration
1;
