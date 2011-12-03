#!/usr/bin/perl 

# Created: 10/21/2011 02:37:36 PM
# Last Edit: 2011 Nov 13, 07:51:08 PM
# $Id$

=head1 NAME

grade_bettdic.pl - Grade bett questions/answers and dic letters written

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use strict;
use warnings;

=head1 SYNOPSIS

perl script_files/grade_dic.pl -l GL00016 -x rueda -o 20 -t 85 > ../001/GL00016/homework/5.yaml

=cut

use lib qw( lib ../bett/lib );

use YAML qw/LoadFile Dump/;

use Grades;

my $script = Grades::Script->new_with_options;
my $id = $script->league;
my $exercise = $script->exercise;
my $two = $script->two;
my $one = $script->one;

my $l = League->new( id => $id );
my $m = $l->members;
my %m = map { $_->{id} => $_ } @$m;

use Bett;
use Bett::Schema;
use Bett::Model::DB;


use dic;
use dic::Schema;
use dic::Model::DB;


=head1 DESCRIPTION

Above 20 percent, grade of 1. Above 85 percent of the letters, a grade of 2. But if sufficient bett questions/answers (as per bett.conf), then a perfect grade, also.

=cut

my $bett_connect_info = Bett::Model::DB->config->{connect_info};
my $bett_d = Bett::Schema->connect( $bett_connect_info );
my %resultset;
#my $courses{Wh} = = $bett_d->resultset('Wh')->search({ league => $id,
#	exercise => $exercise });
$resultset{Yn} = $bett_d->resultset('Yn')->search({ league => $id,
	exercise => $exercise });
$resultset{S} = $bett_d->resultset('S')->search({ league => $id,
	exercise => $exercise });
my $bett_config = Bett->config;

my $dic_connect_info = dic::Model::DB->config->{connect_info};
my $dic_d = dic::Schema->connect( @$dic_connect_info );
my $genre = $dic_d->resultset('Leaguegenre')->find({league=>$id})->genre;
my $members = $dic_d->resultset('Member')->search({ league => $id });
my $play = $dic_d->resultset('Play')->search({ exercise => $exercise });
my $quiz = $dic_d->resultset('Quiz')->search({ exercise => $exercise });
my $words = $dic_d->resultset('Word')->search({ exercise => $exercise,
		genre => $genre });
my $roles = $dic_d->resultset('Jigsawrole')->search({ league => $id });

my ( $p, $g );
for my $player ( keys %m ) {
	my $wordplay = $play->search({ player => $player, league => $id });
	my $roleset = $roles->find({ player => $player, league => $id });
	die "Player ${player}'s role in $id league," unless $roleset;
	my $role = $roleset->role;
	my ($correct, $total) = (0) x 2;
	# my $wordset = $words->search({ target => $role });
	my $wordset = $words->search({ target => "all" });
	while ( my $word = $wordset->next ) {
		my $id = $word->id;
		my $letters = $wordplay->find({ blank => $id });
		$correct += $letters->correct if $letters;
		$total += length $word->clozed;
	}
	$p->{$player}->{letters} = $correct;
	$p->{$player}->{percent} = $total? sprintf('%.0f', 100*$correct/$total): 0;
	my $questionwinner = undef;
	my @courses = qw/Yn S/;
	for my $course ( @courses ) {
	    my $question = $resultset{$course}->find({ player => $player });
	    if ( $question ) { $p->{$player}->{$course} = $question->score }
	    $questionwinner++ if $bett_config->{uc $course}->{win} <=
		    ( $p->{$player}->{$course} || 0 );
	}
	$g->{$player} = $questionwinner ||
		$p->{$player}->{percent} >= $two? 2:
		$p->{$player}->{percent} > $one? 1: 0;
}

print Dump { exercise => $exercise, grade => $g, points => $p,
				cutpoints => { one => $one, two => $two } };


=head1 AUTHOR

Dr Bean C<< <drbean at cpan, then a dot, (.), and org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2011 Dr Bean, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

# End of grade_bettdic.pl

# vim: set ts=8 sts=4 sw=4 noet:


