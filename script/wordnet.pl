#!perl

use strict;
use warnings;

# use List::Util qw/max min/;
use lib qw/lib/;
use Ctest;

use WordNet::QueryData;
use IO::All;
my $io = io '../class/tourism/jan19.txt';
my $jan = $io->slurp;

my $unclozeable = 'Osaka|Nara';
my $parse = Ctest->parse($unclozeable, $jan);

my $dic = $parse->dictionary;
my $clozeline = $parse->cloze;
# print map { $_ } @$clozeline;

my $wn = WordNet::QueryData->new;
my @senses;

for my $word ( keys %$dic )
{
	my @querystrings = $wn->querySense($word);
	for my $pos ( @querystrings )
	{
		my @querystrings = $wn->querySense($pos);
		#if ( ref $pos eq "ARRAY" )
		#{
		#	for my $sense ( @$pos )
		#	{		
		#		# (my $n = $pos) =~ s/^.*(\d+)$/$1/;
		#		push @senses, $sense;
		#	}
		#}
		#else {
		#	push @senses, $pos;
		#}
	       for my $sense ( @querystrings )
	       {
		       # my $gloss = $wn->querySense($sense, 'glos');
		       # print $wn->querySense($sense, 'glos');
		       (my $gloss = ($wn->querySense($sense,'glos'))[0]) =~
						       s/^(.*?); ".*$/$1/;
			print $gloss . "\n";
	       }
	}
}
