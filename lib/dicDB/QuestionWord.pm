package dicDB::QuestionWord;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('questionwords');
# Set columns in table
__PACKAGE__->add_columns(qw/genre exercise question id content link/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/genre exercise question id/);

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
#__PACKAGE__->has_many(attempt => 'dicDB::Play',
#	{ 'foreign.genre' => 'self.genre',
#	'foreign.exercise' => 'self.exercise', 'foreign.blank' => 'self.id'});

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above 
#   You must already have the has_many() defined to use a many_to_many().
# __PACKAGE__->many_to_many(readers => 'reader', 'reader');

#__PACKAGE__->might_have(link => 'dicDB::Word',
#	{ 'foreign.genre' => 'self.genre', 'foreign.exercise' => 'self.exercise', 'foreign.id' => 'self.id'});

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
#__PACKAGE__->belongs_to(exercise => 'dicDB::Exercise',
#	{'foreign.genre' => 'self.genre', 'foreign.id' => 'self.exercise', });

=head1 NAME

dicDB::QuestionWord - A model object representing a word in a Question to a Exercise.

=head1 DESCRIPTION

QuestionWords belong to Questions and may be blankable. They will be blanked for a Player who hasn't yet got all the letters correct of the corresponding linked Word (blank) in Play and shown to Players who have. The absence of a link means they are shown to all Players.

Because Questions belong Texts, and the QuestionWords in them belong to Exercises, the relationship between Text and Exercise is needed to retrieve all the data about a QuestionWord, and specifically which Text a QuestionWord belongs_to.

=cut

1;