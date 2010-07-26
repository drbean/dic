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
my $members = $d->resultset('Member')->search({ league => $id });
my $quiz = $d->resultset('Quiz')->search({ exercise => $exercise });

my $standings = LoadFile '/var/www/cgi-bin/target/standings.yaml';

my ( $p, $g );
for my $player ( keys %m ) {
	$p->{$player}->{letters} = $standings->{$id}->{$player}->{$exercise};
	my $questions = $quiz->search({ player => $player });
	my $correct = 0;
	if ( $questions and $questions->isa('DBIx::Class::ResultSet') ) {
		while ( my $question = $questions->next ) {
			$correct++ if $question->correct;
		}
	}
	$p->{$player}->{questions} = $correct;
	$g->{$player} = $correct ||
		$p->{$player}->{letters} >= $two? 2:
		$p->{$player}->{letters} > $one? 1: 0;
}

print Dump $g;
print Dump $p;
