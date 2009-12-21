package FirstLast;  # assumes Some/Module.pm

# Last Edit: 2008 Jun 01, 10:26:31 AM
# $Id$

use strict;
use warnings;

use base qw/LineParser/;

use Parse::RecDescent;
use Element;

=head1 NAME

FirstLast - Cloze all but 1st, last letters of all words.

=head1 SYNOPSIS

See L<Cloze>

=head1 DESCRIPTION

Last letters of 2 letter words are also clozed. 1st letters of 1-letter words are not. See http://www.mrc-cbu.cam.ac.uk/~mattd/Cmabrigde/


=cut

=head2 parse

Parse text and create cloze. To work around dic's View having just one unclozed part coming before the clozed part, the Last letter is treated as a separate Unclozeable, except for the Dictionary and some trickery is done with published and clozed accessors.

=cut

sub parse
{
	my $self = shift;
	my $unclozeables = shift;
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
		my $inWord = 0;
		my ($first, $clozedletters, $offset, $length, $pretext);
	}
		string: token(s) end | <error>
		token: newline | pass | firstletter | middleletter | lastletter | punctuation
		newline: <reject: $inWord> "\\n" { push @FirstLast::clozeline, Newline->new }
		firstletter: <reject: $inWord> m/$letter/ 
			{
				$inWord=1;
				$first = $item[2];
				$clozedletters = '';
				$offset = List::Util::max(0, $prevoffset-50);
				$length = List::Util::min($prevoffset, 50);
				$pretext = substr($FirstLast::lines, $offset, $length);
			}
		middleletter: <reject: not $inWord> m/$letter(?!$punctuation)/
			{
				$clozedletters .= $item[2];
			}
		lastletter: <reject: not $inWord> m/$letter(?=$punctuation|$)/m
			{
				$inWord=0;
				my $middle = length($clozedletters);
				my $lastletter = $item[2];
				my $clozedhalf = $clozedletters;
				$clozedhalf .= $lastletter if $middle <= 0;
				my $pub = $first . $clozedhalf;
				$pub .= $lastletter unless $middle <= 0;
				$FirstLast::dic{$pub}++;
				my $posttext = substr($text,0,50);
				push @FirstLast::clozeline, 
					Word->new({
						published => $pub,
						unclozed => $first,
						clozed => $clozedhalf,
						pretext => $pretext,
						posttext => $posttext
					});
				push @FirstLast::clozeline, Unclozeable->new({
					published => $lastletter,})
						unless ( $middle <= 0 );
			}
		punctuation: <reject: $inWord> m/$punctuation/
			{ push @FirstLast::clozeline, Unclozeable->new
						({published => $item[2]});
			}
		end: m/^\Z/
		]; 
	if ( $unclozeables )
	{
		$letterGrammar .= q[
		pass: <reject: $inWord> m/($FirstLast::unclozeable|$letter|\\d+:\\d+)(?=$punctuation|$)/m
			{ push @FirstLast::clozeline, Unclozeable->new
						({published => $item[2]});
				$FirstLast::dic{$item[2]}++ if $item[2] =~m/^\w+$/;}
		]; 
	}
	else {
		$letterGrammar .= q[
		pass: <reject: $inWord> m/($letter|\\d+:\\d+)(?=$punctuation|$)/m
			{ push @FirstLast::clozeline, Unclozeable->new
						({published => $item[2]});
				$FirstLast::dic{$item[2]}++ if $item[2] =~m/^\w+$/;}
		]; 
	}
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
