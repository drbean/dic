package Kwic;  # assumes Some/Module.pm

# Last Edit: 2008 Apr 02, 09:20:35 PM
# $Id$

use strict;
use warnings;

use base qw/LineParser/;

use Word;
use Newline;

=head1 NAME

Kwic - Cloze all letters of all words and create a dictionary and concordance.

=head1 SYNOPSIS

	my $clozeObject = Kwic->parse($unclozeables, $content);
	my $cloze = $clozeObject->cloze;
	my $newWords = $clozeObject->dictionary;
	my $concordance = $clozeObject->kwic;

=head1 DESCRIPTION

A refactoring of Total.pm that uses regex, instead of Parse::RecDescent and build a kwic concordance as well.

=cut

=head2 parse

Parse text and create cloze

=cut

sub parse
{
	my $self = shift;
	my $unclozeables = shift;
	my $punctuation='[-\t .!?,;:\'"]+';
        my $pass = qr/$unclozeables|\d+:\d+|$punctuation/;
	my $lines = shift;
	my ( $pos, %dic, @clozeline, %kwic );
	LOOP:
	{
		if ($lines =~ m/\G\n/gc)
		{ push @clozeline, Newline->new; redo LOOP }
		elsif ($lines =~ m/\G$pass/gc)
		{ push @clozeline, $&; redo LOOP }
		elsif ($lines =~ m/\G\w+\b/gc)
		{
			$pos = pos $lines;
			$dic{$&}++; 
			push @clozeline, Word->new(
				{ word => $&,
				pretext=> substr($`,($pos-50),50),
				posttext => substr($',0,50)}
			);
			redo LOOP
		}
		elsif ( $lines =~ m/\Z/gc ) { last LOOP }
		else {
			$pos = pos $lines;
			die "No parse of " . (substr $lines, $pos, 50);
		}
	}
	return bless { dictionary => \%dic, clozeline => \@clozeline, }, $self;
}

=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
1;  # don’t forget to return a true value from the file
