#!/usr/bin/perl 

use strict;
use warnings;
# use lib qw( /var/www/cgi-bin/target/lib );
use lib qw( lib );

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

use dic;
use dic::Schema;
use dic::Model::DB;

my $connect_info = dic::Model::DB->config->{connect_info};
my $d = dic::Schema->connect( @$connect_info );
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
