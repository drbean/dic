package dic::Schema::Pic;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("pics");
__PACKAGE__->add_columns(
  "id",
  { data_type => "SMALLINT", is_auto_increment => 1, is_nullable => 0, size => undef },
  "word",
  { data_type => "VARCHAR", is_nullable => 0, size => 25 },
  "url",
  { data_type => "VARCHAR", is_nullable => 0, size => 100 },
  "title",
  { data_type => "VARCHAR", is_nullable => 0, size => 100 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-08-26 18:19:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:d91UjQuH58wxi2u6MBRYbA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
