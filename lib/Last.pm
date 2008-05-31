package Last;  # assumes Some/Module.pm

# Last Edit: 2008 May 28, 08:22:49 AM
# $Id$

use strict;
use warnings;
use List::Util qw/min max/;

use base qw/LineParser/;

use Parse::RecDescent;
use Element;
# use Word;
# use Newline;
# use Unclozeable;

=head1 NAME

Last - Cloze all but last letters of all words.

=head1 SYNOPSIS

See L<Cloze>

=head1 DESCRIPTION

Last letters of 2 letter words and 1st letters of 1-letter words are not clozed. This is a variation on FirstLast parser, but seeks to be a Total one and still allow a letter for an easy KWIC link.

=cut

=head2 parse

Parse text and create cloze


=cut

sub parse
{
	my $self = shift;
	my $unclozeables = shift;
        our $unclozeable = $unclozeables? qr/(?:$unclozeables)/: undef;
	our $lines = shift;
	my @text = ();
	our (%dic, @clozeline) = ();
	my $letterGrammar = q[
		{
		my $punctuation = qr/[^A-Za-z0-9\\n]+/;
		my $letter = qr/[A-Za-z0-9&]/;
		my $skip = '';
		my $cword;
		my $inWord = 0;
		my ($unclozedhalf, $clozedhalf, $offset, $length, $pretext, $posttext, $dicEntry);
	}
		string: token(s) end | <error>
		token: newline | pass | firstletter | middleletter | lastletter | punctuation
		newline: <reject: $inWord> "\\n"
			{ push @Last::clozeline, Newline->new }
		firstletter: <reject: $inWord> m/$letter/ 
			{
				$inWord=1;
				$cword = $item[2];
				$offset = List::Util::max(0, $prevoffset-50);
				$length = List::Util::min($prevoffset, 50);
				$pretext = substr($Last::lines, $offset, $length);
			}
		middleletter: <reject: not $inWord> m/$letter(?!$punctuation)/
			{
				$cword .= $item[2];
			}
		lastletter: <reject: not $inWord> m/$letter(?=$punctuation|$)/m
			{
				$inWord=0;
				$clozedhalf = $cword;
				$unclozedhalf = $item[2];
				$posttext = substr($text,0,50);
				$dicEntry = $cword . $item[2];
				push @Last::clozeline, Word->new
					({
						published => $dicEntry,
						clozed => $clozedhalf,
						unclozed => $unclozedhalf,
						pretext=> $pretext,
						posttext => $posttext});
				$Last::dic{$dicEntry}++;
			}
		punctuation: <reject: $inWord> m/$punctuation/
			{ push @Last::clozeline, Unclozeable->new
						({published => $item[2]}); }
		end: m/^\Z/
		]; 
	if ( $unclozeables )
	{
		$letterGrammar .= q[
		pass: <reject: $inWord> m/($Last::unclozeable|$letter|\\d+:\\d+)(?=$punctuation|$)/m
			{ push @Last::clozeline, Unclozeable->new
						({published => $item[2]});
				$Last::dic{$item[2]}++ if $item[2]=~ m/^\w+$/;}
		]; 
	}
	else {
		$letterGrammar .= q[
		pass: <reject: $inWord> m/($letter|\\d+:\\d+)(?=$punctuation|$)/m
			{ push @Last::clozeline, Unclozeable->new
						({published => $item[2]});
				$Last::dic{$item[2]}++ if $item[2]=~ m/^\w+$/;}
		]; 
	}
	my $letterParser = Parse::RecDescent->new($letterGrammar);
	defined $letterParser->string($lines) or die "letterparse NOK.";
	return bless { dictionary => \%Last::dic,
			clozeline => \@Last::clozeline }, $self;
}

=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;  # don’t forget to return a true value from the file
