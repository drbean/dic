package dicDB::Reader;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('readers');
# Set columns in table
__PACKAGE__->add_columns(qw/league text_id player_id/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/league text_id player_id/);

#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(text => 'dicDB::Text',
	{ 'foreign.id' => 'self.text_id', 'foreign.league' => 'self.league'});

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(reader => 'dicDB::Player', 'player_id');


=head1 NAME

dicDB::Member - A model object representing the JOIN between a player and 
the text the player is reading

=head1 DESCRIPTION

This is an object that represents a row in the 'readers' table of your 
application database.  It uses DBIx::Class (aka, DBIC) to do ORM.

You probably won't need to use this class directly -- it will be automatically
used by DBIC where joins are needed.

For Catalyst, this is designed to be used through dic::Model::dicDB.
Offline utilities may wish to use this class directly.

=cut

1;
