package Ctest;  # assumes Some/Module.pm

# Last Edit: 2008 Jun 13, 06:10:07 PM
# $Id$

use strict;
use warnings;

use List::Util qw/max min/;

use base qw/LineParser/;

use Parse::RecDescent;
use Element;

=head1 NAME

Ctest - Cloze the 2nd half of every word.

=head1 SYNOPSIS

See L<Cloze>

=head1 DESCRIPTION

Number of clozed letters in odd-numbered-lettered words is rounded up, excluding 'a', 'I'.

=cut

=head2 parse

Parse text and create cloze


=cut

sub parse
{
	my $self = shift;
	my $unclozeables = shift;
	chomp $unclozeables;
        our $unclozeable = $unclozeables? qr/(?:$unclozeables)/: undef;
	our $lines = shift;
	my @text = ();
	our @clozeline = ();
	our %dic = ();
	my $letterGrammar = q[
		{
		my $punctuation = qr/[^A-Za-z0-9\\n]+/;
		my $letter = qr/[A-Za-z0-9]/;
		my $skip = '';
		my @cword;
		my $inWord = 0;
		my ($unclozedhalf, $clozedhalf, $offset, $length, $pretext, $posttext, $dicEntry);
	}
		string: token(s) end | <error>
		token: newline | pass | firstletter | middleletter | lastletter | punctuation
		newline: <reject: $inWord> "\\n" { push @Ctest::clozeline, Newline->new }
		firstletter: <reject: $inWord> m/$letter/
			{
				$inWord=1;
				@cword = ($item[2]);
				$offset = List::Util::max(0, $prevoffset-50);
				$length = List::Util::min($prevoffset, 50);
				$pretext = substr($Ctest::lines, $offset, $length);
			}
		middleletter: <reject: not $inWord> m/$letter(?!$punctuation)/
			{
				push @cword, $item[2];
			}
		lastletter: <reject: not $inWord> m/$letter(?=$punctuation|$)/m
			{
				$inWord=0;
				push @cword, $item[2];
				$unclozedhalf = join '',
					@cword[0..($#cword-1)/2];
				$clozedhalf = join '',
					@cword[($#cword+1)/2..$#cword];
				$posttext = substr($text,0,50);
				$dicEntry = join '', @cword;
				$Ctest::dic{$dicEntry}++;
				push @Ctest::clozeline, Word->new
					({ 
						published => $dicEntry,
						unclozed => $unclozedhalf,
						clozed => $clozedhalf,
						pretext=> $pretext,
						posttext => $posttext});
			}
		punctuation: <reject: $inWord> m/$punctuation/
			{ push @Ctest::clozeline, Unclozeable->new
						({published => $item[2]}); }
		end: m/^\Z/
		]; 
	if ( $unclozeables )
	{
		$letterGrammar .= q[
		pass: <reject: $inWord> m/($Ctest::unclozeable|$letter|\\d+:\\d+)(?=$punctuation|$)/m
			{ push @Ctest::clozeline, Unclozeable->new
						({published => $item[2]});
				$Ctest::dic{$item[2]}++ if $item[2] =~m/^\w+$/;}
		]; 
	}
	else {
		$letterGrammar .= q[
		pass: <reject: $inWord> m/($letter|\\d+:\\d+)(?=$punctuation|$)/m
			{ push @Ctest::clozeline, Unclozeable->new
						({published => $item[2]});
				$Ctest::dic{$item[2]}++ if $item[2] =~m/^\w+$/;}
		]; 
	}
	my $letterParser = Parse::RecDescent->new($letterGrammar);
	defined $letterParser->string($lines) or die "letterparse NOK.";
	return bless { dictionary => \%Ctest::dic,
			clozeline => \@Ctest::clozeline }, $self;
}

=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;  # don’t forget to return a true value from the file
