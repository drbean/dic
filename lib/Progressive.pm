package Progressive;  # assumes Some/Module.pm

# Last Edit: 2009 10月 27, 17時35分02秒
# $Id$

use strict;
use warnings;

use List::Util qw/max min/;
use List::MoreUtils qw/any/;

use base qw/LineParser/;

use Parse::RecDescent;
use Element;

=head1 NAME

Progressive - Cloze the 2nd half of every word.

=head1 SYNOPSIS

See L<Cloze>

=head1 DESCRIPTION

Number of clozed letters in odd-numbered-lettered words is rounded up, excluding 'a', 'I'.

=cut

=head2 parse

Parse text and create cloze. The context around the word has to alter length if it's at the start or end of the line, I think.


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
		my ($word, @word);
		my $inWord = 0;
		my ($unclozedhalf, $clozedhalf, $offset, $length,
			$pretext, $posttext);
		my @easy = qw/
that have with this from they say will would there their what about get which when make like time just know take people into year your good some could them other than then look only come over think also back after use our work first even want because these give day most /;
	}
		string: token(s) end | <error>
		token: newline | pass | firstletter | middleletter | lastletter | punctuation
		newline: <reject: $inWord> "\\n" { push @Progressive::clozeline, Newline->new }
		firstletter: <reject: $inWord> m/$letter/
			{
				$inWord=1;
				@word = ($item[2]);
				$offset = List::Util::max(0, $prevoffset-50);
				$length = List::Util::min($prevoffset, 50);
				$pretext = substr($Progressive::lines, $offset, $length);
			}
		middleletter: <reject: not $inWord> m/$letter(?!$punctuation)/
			{
				push @word, $item[2];
			}
		lastletter: <reject: not $inWord> m/$letter(?=$punctuation|$)/m
			{
				$inWord=0;
				push @word, $item[2];
				$word = join '', @word;
				if ( List::MoreUtils::any { $word =~
					m/^$_[[:alpha:]]{0,2}$/ } @easy )
				{
					$unclozedhalf = $word[0];
					$clozedhalf = join '',
						@word[1..$#word];
				}
				else {
					$unclozedhalf = join '',
						@word[0..($#word-1)/2];
					$clozedhalf = join '',
						@word[($#word+1)/2..$#word];
				}
				$posttext = substr($text,0,50);
				$Progressive::dic{$word}++;
				push @Progressive::clozeline, Word->new
					({ 
						published => $word,
						unclozed => $unclozedhalf,
						clozed => $clozedhalf,
						pretext=> $pretext,
						posttext => $posttext});
			}
		punctuation: <reject: $inWord> m/$punctuation/
			{ push @Progressive::clozeline, Unclozeable->new
						({published => $item[2]}); }
		end: m/^\Z/
		]; 
	if ( $unclozeables )
	{
		$letterGrammar .= q[
		pass: <reject: $inWord> m/($Progressive::unclozeable|$letter|\d+:\d+)(?=$punctuation|$)/m
			{ push @Progressive::clozeline, Unclozeable->new
						({published => $item[2]});
				$Progressive::dic{$item[2]}++ if $item[2] =~m/^\w+$/;}
		]; 
	}
	else {
		$letterGrammar .= q[
		pass: <reject: $inWord> m/($letter|\d+:\d+)(?=$punctuation|$)/m
			{ push @Progressive::clozeline, Unclozeable->new
						({published => $item[2]});
				$Progressive::dic{$item[2]}++ if $item[2] =~m/^\w+$/;}
		]; 
	}
	my $letterParser = Parse::RecDescent->new($letterGrammar);
	defined $letterParser->string($lines) or die "letterparse NOK.";
	return bless { dictionary => \%Progressive::dic,
			clozeline => \@Progressive::clozeline }, $self;
}

=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;  # don’t forget to return a true value from the file
