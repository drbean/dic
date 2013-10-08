package Total;  # assumes Some/Module.pm

# Last Edit: 2013 Oct 08, 08:05:12 PM
# $Id$

# traditional cloze, unlike ctest, has no letters,
# but only every nth (7th) word is clozed.

use strict;
use warnings;

use base qw/LineParser/;

use Parse::RecDescent;
use Word;
use Newline;

=head1 NAME

Total - Cloze all letters of all words.

=head1 SYNOPSIS

	my $clozeObject = Total->parse($unclozeables, $content);
	my $cloze = $clozeObject->cloze;
	my $newWords = $clozeObject->dictionary;

=head1 DESCRIPTION

1-letter words are also clozed.

=cut

=head2 parse

Parse text and create cloze


=cut

sub parse
{
	$::RD_HINT=1;
	my $self = shift;
	my $unclozeables = shift;
	our $unclozeable = $unclozeables? qr/(?:$unclozeables)/: undef;
	my $lines = shift;
	my @text = ();
	our @clozeline = ();
	our %dic = ();
	my $letterGrammar = q[
		{
		my $punctuation = qr/[^A-Za-z0-9\\n]+/;
		my $letter = qr/[A-Za-z0-9]/;
		my $skip = '';
		my $cword;
		my $inWord = 0;
	}
		string: token(s) end | <error>
		token: newline | pass | notlastletter | lastletter | punctuation
		newline: <reject: $inWord> "\\n" { push @Total::clozeline, Newline->new }
		notlastletter: m/$letter(?!$punctuation|$)/m
			{
				$cword .= $item[1];
				$inWord=1;
			}
		lastletter: <reject: not $inWord> m/$letter(?=$punctuation|$)/m
			{
				$cword .= $item[1];
				push @Total::clozeline, Word->new({
					published => $cword
					, unclozed => ''
					, clozed => $cword
					, pretext => ''
					, posttext => ''
					});
				$Total::dic{$cword}++;
				$cword = '';
				$inWord=0;
			}
		punctuation: <reject: $inWord> m/$punctuation/
			{ push @Total::clozeline, Unclozeable->new({
						published => $item[2]
						}); }
		end: m/^\Z/
		]; 
	if ( $unclozeables )
	{
		$letterGrammar .= q[
		pass: <reject: $inWord> m/($Total::unclozeable|$letter|\\d+:\\d+)(?=$punctuation|$)/m
			{ push @Total::clozeline, Unclozeable->new
						({published => $item[2]});
				$Total::dic{$item[2]}++ if $item[2] =~m/^\w+$/;}
		]; 
	}
	my $letterParser = Parse::RecDescent->new($letterGrammar);
	defined $letterParser->string($lines) or die "letterparse NOK.";
	return bless { dictionary => \%Total::dic,
			clozeline => \@Total::clozeline }, $self;
}

=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
1;  # don’t forget to return a true value from the file
