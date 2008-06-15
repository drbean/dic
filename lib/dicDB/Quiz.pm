package dicDB::Quiz;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('quiz');
# Set columns in table
__PACKAGE__->add_columns(qw/league exercise player question correct/);
#__PACKAGE__->add_columns(qw/league exercise player text correct/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/league exercise player question/);

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

dicDB::Quiz - A model object representing Players answering comprehension Questions composed of QuestionWords in an Exercise

=head1 DESCRIPTION

Play rows, identified by league, exercise and player, belong to Players. 'question' is the ID of the Question (or is it Text) and correct is whether the player answered correctly or not (1 or 0).

=cut

1;
