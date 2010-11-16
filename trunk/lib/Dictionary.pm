package Dictionary;  # assumes Some/Module.pm

# Last Edit: 2008 Apr 02, 09:12:26 PM
# $Id: /mi/svndic/trunk/lib/Dictionary.pm 1397 2008-04-05T04:15:24.532792Z greg  $

use strict;
use warnings;

use base qw/LineParser/;

use Parse::RecDescent;
use Word;
use Newline;

=head1 NAME

Dictionary -  Create a dictionary of clozed words.

=head1 SYNOPSIS

See L<Cloze>

=head1 DESCRIPTION

Cloze all but 1st letter of all words and create a dictionary.

=cut

=head2 parse

Parse text and create cloze and dictionary


=cut

sub parse
{
	my $self = shift;
	my $unclozeables = shift;
        our $unclozeable = qr/(?:$unclozeables)/;
	my $lines = shift;
	my @text = ();
	our @clozeline = ();
	our %dic = ();
	my $letterGrammar = q[
		{
		my $punctuation = qr/[^A-Za-z0-9'\\n]+/;
		my $name = qr/[A-Z][-A-Za-z0-9']*/; # qr/\u\w\w*\b/;
		my $letter = qr/[A-Za-z0-9']/;
		my $skip = '';
		my $cword;
		my $inWord=0;
		}
		string: token(s) end | <error>
		token: newline | pass | firstletter | middleletter | lastletter | punctuation
		newline: <reject: $inWord> "\\n" { push @Dictionary::clozeline, Newline->new }
		pass: <reject: $inWord> m/($Dictionary::unclozeable|\\w|\\d+:\\d+)(?=$punctuation|$)/m
			{ push @Dictionary::clozeline, $item[2]; }
		firstletter: <reject: $inWord> m/$letter/ 
			{
				$inWord=1;
				$cword = $item[2];
			}
		middleletter: <reject: not $inWord> m/$letter(?!$punctuation)/
			{
				$cword .= $item[2];
			}
		lastletter: <reject: not $inWord> m/$letter(?=$punctuation|$)/m
			{
				$inWord=0;
				$cword .= $item[2];
				push @Dictionary::clozeline,
							Word->new($cword);
				$Dictionary::dic{$cword}++;
			}
		punctuation: <reject: $inWord> m/$punctuation/
			{ push @Dictionary::clozeline, $item[2]; }
		end: m/^\Z/
		]; 
	my $letterParser = Parse::RecDescent->new($letterGrammar);
	defined $letterParser->string($lines) or die "letterparse NOK.";
	return bless { dictionary => \%Dictionary::dic,
			clozeline => \@Dictionary::clozeline }, $self;
}

=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
1;  # don’t forget to return a true value from the file
