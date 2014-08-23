package Dic::Schema::Dictionary;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("dictionaries");
__PACKAGE__->add_columns(
  "genre",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "word",
  { data_type => "VARCHAR", is_nullable => 0, size => 25 },
  "initial",
  { data_type => "CHAR", is_nullable => 0, size => 1 },
  "stem",
  { data_type => "VARCHAR", is_nullable => 0, size => 25 },
  "suffix",
  { data_type => "VARCHAR", is_nullable => 0, size => 15 },
  "count",
  { data_type => "SMALLINT", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("genre", "word");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:d91UjQuH58wxi2u6MBRYbA

# You can replace this text with custom content, and it will be preserved on regeneration
1;
