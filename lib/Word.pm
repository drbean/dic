package Word;

# Last Edit: 2008 Apr 09, 10:42:24 PM
# $Id$

# use base qw/Element/;

=head2 new

	$blanks = Word->new( {unclozed => [qw/b s/], clozed => 'lank', pretext => 'The b', posttext => 's deleted from text'} )

Create an object to represent the blanked letters in a cloze exercise, with the deleted letters (which may be a full word or part of a word), ie the answer, and the text before and after the answer, for a concordance. Note to self: Don't switch namings of hash fields in obscure bottom-level libraries!

=cut

#sub new {
#	my $self = shift;
#	my $args = shift;
#	return bless $args;
#}


=head2 asHTML

	Word->new('lank')->asHTML(14);
	Word->new('lank')->asHTML(14, $dic);
	Word->new('lank')->asHTML(14, $dic, $exerciseId);

Renders a blank as a CGI textfield, eg, the above as, <input type="text" class="look" name="14" size="4" maxlength="4" />  The alternative form returns the output of the asMenu method instead. And the last form adds a link to a KWIC concordance of the missing answer. This special-casing needs to be made easier to control, needs a better API.


=cut

sub asHTML {
	my $self = shift;
	my $answer = $self->{word};
	my $length = length $answer;
	my $name = shift;
	my $dictionary = shift;
	my $exerciseId = shift;
	my $html;
	if ( defined $dictionary ) {
		return $self->asMenu($name, $dictionary);
	}
	if ( $exerciseId ) {
		$html =  $self->withKwic($name, $context);
	}
	else {
		return
qq(<input type="text" class="look" name="$name" size="$length" maxlength="$length"/>);
	}
}


=head2 asMenu

	Word->new('is')->asMenu(14, { in=>1, is=>1, it=>1, });
	# prints  <select name="14"><option selected>i</option>
		<option>is</option><option>it</option> </select>
	
Renders a blank as a form select. The first argument is the name, and the second argument is a dictionary, an anon hash whose keys form the menu options. Because the dictionary amalgamates words from all the different exercises in the database, we remove duplicates. We then Fisher-Yates shuffle a total distractor-1 words, and then shuffle in the right answer. The selected option is an extra distractor consisting of the first letter of the answer.

=cut

sub asMenu {
	my $self = shift;
	my $answer = $self->{answer};
	(my $initial = $answer) =~ s/^(.).*$/$1/;
	my $name = shift;
	my $dictionary = shift;
	my $string = qq(<select name="$name"> );
	$string .= '<option selected>' . $initial . '</option> ';
	my $totalDistractors = 2;
	my @words = map { $_->word } $dictionary->all;
	my %dupes; @dupes{ @words } = ();
	@words = keys %dupes;
	@words = grep { $_ ne $answer } @words;
	for my $i ( 0 .. $totalDistractors - 2 )
	{
		my $j = int rand @words-$i;
		@words[$i,$j] = @words[$j,$i];
	}
	my @answers = ($answer, @words[0 .. $totalDistractors-2]);
	my $pos = int rand $totalDistractors;
	@answers[0,$pos] = @answers[$pos,0];
	$string .= '<option>' . $_ . '</option> ' for grep { defined } @answers;
	$string .= '</select>';
	return $string;
}


=head2 withKwic

	Word->new('is')->withKwic(14, { exerciseId => 9, id => 240 });
	ie <input type="text" class="look" name="14" size="4" maxlength="4" />
	
Renders a blank as a CGI textfield, like asHTML, but adds a link to a kwic concordance of the keyword, excluding the current line.

=cut

sub withKwic {
	my $self = shift;
	my $answer = $self->{word};
	my $length = length $answer;
	my $name = shift;
	my $dictionary = shift;
	my $exerciseId = shift;
	return
qq(<a href=[% Catalyst.uri_for('/play/kwic') %]/$exerciseId/$name>.</a>
<input type="text" class="look" name="$name" size="$length" maxlength="$length"/>);
}


1;
