package dicDB::Question;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('questions');
# Set columns in table
__PACKAGE__->add_columns(qw/genre text id content answer/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/genre text id/);

#
# Set relationships:
#

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
__PACKAGE__->has_many(words => 'dicDB::QuestionWord',
	{ 'foreign.genre' => 'self.genre', 'foreign.text' => 'self.text', 'foreign.question' => 'self.id'});


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
__PACKAGE__->belongs_to(text => 'dicDB::Text',
	{'foreign.genre' => 'self.genre', 'foreign.id' => 'self.text' });


=head1 NAME

dicDB::Question - A model object representing a comprehension question about an Exercise

=head1 DESCRIPTION

Questions belong to a Text and have many Questionwords. One Text may have many Questions. Questions have content, ie the text of the question, and one answer.

They belong to a Text rather than Exercise, because they have to be imported before the Exercise has been created.

Because Questions belong Texts, and the QuestionWords in them belong to Exercises, the relationship between Text and Exercise is needed to retrieve all the data about a QuestionWord, and specifically which Question a QuestionWord belongs_to.

=cut

1;
