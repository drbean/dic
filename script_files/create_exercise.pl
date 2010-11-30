#!/usr/bin/perl 

# Created: 西元2010年11月30日 09時59分46秒
# Last Edit: 2010 11月 30, 10時36分26秒
# $Id$

=head1 NAME

create_exercise.pl - Run parser (eg Ctest) on text 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";

use Dictionary;
use FirstLast;
use Ctest;
use Progressive;
use Total;
use Kwic;
use Last;
use Lingua::Stem qw/stem/;
use Net::FTP;

use dic;
use dic::Model::DB;
my $connect_info = dic::Model::DB->config->{connect_info};
my $schema = dic::Schema->connect( @$connect_info );

=head1 SYNOPSIS

perl script_files/create_exercise Parser textId1 textId2 ..

=cut

sub run {
    my $exerciseType = shift @ARGV;
    my @textIds = @ARGV;
    for my $textId ( @textIds ) {
	my $texts = $schema->resultset('Text')->search( { id=>$textId } );
	while ( my $text = $texts->next ) {
		my $description = $text->description;
		my $content = $text->content;
		my $unclozeables = $text->unclozeables;
		my $genre = $text->genre;
		my $target = $text->target;
		my $index=0;
		my $clozeObject = $exerciseType->parse($unclozeables, $content);
		my $cloze = $clozeObject->cloze;
		my $newWords = $clozeObject->dictionary;
		my (@wordRows, @dictionaryList, %wordCount, @wordstemRows);
		my $dictionary = $schema->resultset('Dictionary')->search;
		my $id = 1;
		my @columns = $schema->resultset('Word')->result_source->columns;
		foreach my $word ( @$cloze )
		{
			my $token = $word->{published};
			if ( $token and $newWords->{$token} )
			{
				(my $initial = $token) =~ s/^(.).*$/$1/;
				my $entry = $dictionary->find(
					{ genre => $genre, word => $token });
				my $count = $entry? $entry->count: 0;
				my $stem = (stem $token)->[0];
				my $suffix;
				if ( $stem =~ m/.i$/ )
				{
					my $istem = $stem;
					chop $istem;
					($suffix = lc $token) =~ s/^$istem.(.*)$/$1/;
				}
				else { ($suffix = lc $token) =~ s/^$stem(.*)$/$1/; }
				$dictionary->update_or_create({
					genre => $genre,
					word => $token,
					initial => $initial,
					stem => $stem || '',
					suffix => $suffix || '',
					count =>++$count});
			}
			my $class = ref $word;
			my %row = map { $_ => $word->{$_} } @columns;
			$row{genre} = $genre;
			$row{exercise} = $textId;
			$row{target} = $target;
			$row{id} = $id++;
			$row{class} = $class;
			push @wordRows, \%row;
		}
		$schema->resultset('Word')->populate( \@wordRows );
		#@dictionaryList = map { m/^(.).*$/;
		#		{ exercise => $textId, word => $_, initial => $1,
		#		count => $newWords->{$_} } } keys %$newWords;
		my $exercise = $schema->resultset('Exercise')->update_or_create({
					id => $textId,
					text => $textId,
					genre => $genre,
					description => $description,
					type => $exerciseType
				});
	}
    }
}

run unless caller;


=head1 DESCRIPTION

Create comprehension questions and cloze exercise.

=cut

=head1 AUTHOR

Dr Bean C<< <drbean at cpan, then a dot, (.), and org> >>

=cut

=head1 COPYRIGHT & LICENSE

Copyright 2010 Dr Bean, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

# End of create_exercise.pl

# vim: set ts=8 sts=4 sw=4 noet:


