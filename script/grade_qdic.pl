#!/usr/bin/perl 

# Created: 10/21/2011 02:37:36 PM
# Last Edit: 2014  8月 23, 15時14分33秒
# $Id$

=head1 NAME

grade_qdic.pl - Grade questions/answers and dic letters written

=head1 VERSION

Version 0.01

=cut

use strict;
use warnings;
# use lib qw( /var/www/cgi-bin/target/lib );
use lib qw( lib );

=head1 SYNOPSIS

perl script_files/grade_qdic.pl -l GL00016 -x rueda -o 20 -t 85 > ../001/GL00016/homework/5.yaml

=cut

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

use Dic;
use Dic::Schema;
use Dic::Model::DB;

=head1 DESCRIPTION

Above 20 percent, grade of 1. Above 85 percent of the letters, a grade of 2. But if correct answers to question(s), then a perfect grade, also.

=cut

my $connect_info = Dic::Model::DB->config->{connect_info};
my $d = Dic::Schema->connect( @$connect_info );
my $genre = $d->resultset('Leaguegenre')->find({league=>$id})->genre;
my $members = $d->resultset('Member')->search({ league => $id });
my $play = $d->resultset('Play')->search({ exercise => $exercise });
my $quiz = $d->resultset('Quiz')->search({ exercise => $exercise });
my $words = $d->resultset('Word')->search({ exercise => $exercise,
		genre => $genre });
my $roles = $d->resultset('Jigsawrole')->search({ league => $id });

my ( $p, $g );
for my $player ( keys %m ) {
	my $wordplay = $play->search({ player => $player, league => $id });
	my $roleset = $roles->find({ player => $player, league => $id });
	die "Player ${player}'s role in $id league," unless $roleset;
	my $role = $roleset->role;
	my ($correct, $total) = (0) x 2;
	my $wordset = $words->search({ target => $role });
	while ( my $word = $wordset->next ) {
		my $id = $word->id;
		my $letters = $wordplay->find({ blank => $id });
		$correct += $letters->correct if $letters;
		$total += length $word->clozed;
	}
	$p->{$player}->{letters} = $correct;
	$p->{$player}->{percent} = $total? sprintf('%.0f', 100*$correct/$total): 0;
	my $questions = $quiz->search({ player => $player });
	$correct = undef;
	if ( $questions and $questions->isa('DBIx::Class::ResultSet') ) {
		while ( my $question = $questions->next ) {
			$correct += $question->correct if defined $question->correct;
		}
	}
	$p->{$player}->{questions} = $correct;
	$g->{$player} = $correct ||
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

# End of grade_dic.pl

# vim: set ts=8 sts=4 sw=4 noet:
