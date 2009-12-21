package Newline;

# Last Edit: 2008 Apr 09, 02:38:30 PM
# $Id$


=head2 new

	$blanks = Newline->new

Create an object to represent the newline in a text.

=cut

#sub new {
#	my $self = shift;
#	return bless { published => __PACKAGE__ };
#}


=head2 asHTML

	Newline->new()->asHTML();

Renders a newline as a HTML <br> element break tag.


=cut

sub asHTML {
	my $self = shift;
	return qq(\n<br>\n);
}


1;
