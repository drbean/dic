package dicDB::Play;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('play');
# Set columns in table
__PACKAGE__->add_columns(qw/league exercise player blank correct/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/league exercise player blank/);

#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
#__PACKAGE__->belongs_to( word => 'dicDB::Word',
#	{ 'foreign.league' => 'self.league',
#	'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.blank'});
#__PACKAGE__->belongs_to( special => 'dicDB::Special',
#	{ 'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.blank'});
__PACKAGE__->belongs_to( player => 'dicDB::Player' );

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
# __PACKAGE__->has_many(reader => 'dicDB::Reader', 'text_id');

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');


=head1 NAME

dicDB::Play - A model object representing Players filling in blanks in an Exercise composed of Words

=head1 DESCRIPTION

Play rows, identified by league, exercise and player, belong to Players. 'blank' is the ID of the Word and correct is the number of letters consecutively correctly answered, starting from the head of the clozed part of the word.

=cut

1;
