package FirstLast;  # assumes Some/Module.pm

# Last Edit: 2008 Apr 02, 09:17:36 PM
# $Id$

# http://www.mrc-cbu.cam.ac.uk/~mattd/Cmabrigde/

use strict;
use warnings;

use base qw/LineParser/;

use Parse::RecDescent;
use Word;
use Newline;

=head1 NAME

FirstLast - Cloze all but 1st, last letters of all words.

=head1 SYNOPSIS

See L<Cloze>

=head1 DESCRIPTION

Last letters of 2 letter words are also clozed. 1st letters of 1-letter words are not.

=cut

=head2 parse

Parse text and create cloze


=cut

sub parse
{
	my $self = shift;
	my $unclozeables = shift;
        our $unclozeable = qr/(?:$unclozeables)/;
	my $lines = shift;
	my @text = ();
	our (%dic, @clozeline) = ();
	my $letterGrammar = q[
		{
		my $punctuation = qr/[^A-Za-z0-9\\n]+/;
		my $letter = qr/[A-Za-z0-9]/;
		my $skip = '';
		my ($cword, $fullword);
		my ($middleletters, $inWord) = (0) x 2;
	}
		string: token(s) end | <error>
		token: newline | pass | firstletter | middleletter | lastletter | punctuation
		newline: <reject: $inWord> "\\n" { push @FirstLast::clozeline, Newline->new }
		pass: <reject: $inWord> m/($FirstLast::unclozeable|\\d+:\\d+)(?=$punctuation|$)/m
			{ push @FirstLast::clozeline, $item[2]; }
		firstletter: <reject: $inWord> m/$letter/ 
			{
				$inWord=1;
				$cword = '';
				push @FirstLast::clozeline, $item[2];
				$fullword = $item[2];
			}
		middleletter: <reject: not $inWord> m/$letter(?!$punctuation)/
			{
				$cword .= $item[2];
				$fullword .= $item[2];
			}
		lastletter: <reject: not $inWord> m/$letter(?=$punctuation|$)/m
			{
				$inWord=0;
				$middleletters = length($cword);
				if ( $middleletters <= 0 )
				{
					$cword .= $item[2];
					push @FirstLast::clozeline, 
						Word->new($cword);
				}
				else
				{				
					push @FirstLast::clozeline, 
						Word->new($cword);
					push @FirstLast::clozeline, $item[2];
				}
				$fullword .= $item[2];
				$FirstLast::dic{$fullword}++;
			}
		punctuation: <reject: $inWord> m/$punctuation/
			{ push @FirstLast::clozeline, $item[2]; }
		end: m/^\Z/
		]; 
	my $letterParser = Parse::RecDescent->new($letterGrammar);
	defined $letterParser->string($lines) or die "letterparse NOK.";
	return bless { dictionary => \%FirstLast::dic,
			clozeline => \@FirstLast::clozeline }, $self;
}

=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;  # don’t forget to return a true value from the file
