package Element;

# Last Edit: 2008 12月 23, 08時19分57秒
# $Id$


=head2 new

	$blanks = Element->new

Create an object to represent a section of a text. Newline and Unclozeable will inherit the constructor.

=cut

sub new {
	my $self = shift;
	my $args = shift() || {};
	$args->{class} = $self;
	$args->{published} ||= '';
	$args->{clozed} ||= '';
	$args->{unclozed} ||= '';
	$args->{pretext} ||= '';
	$args->{posttext} ||= '';
	return bless $args, $self;
}


package Word;

use base qw/Element/;

package Newline;

use base qw/Element/;

package Unclozeable;

use base qw/Element/;

1;
