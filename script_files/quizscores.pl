#!perl

=head1 NAME

script_files/quizscores.pl - Dump response of players to comprehension question

=head1 SYNOPSIS

script_files/quizscores.pl

 FLA0018		eden-1	eden-2	Total
 ============================================
 N9461736	80	155	235	
 N9461738	106	219	325	
 
=head1 DESCRIPTION

Dumps responses to comprehension question to standings.yaml in present directory and prints to STDOUT. No attention is paid to what the League schema tells us about what leagues exists at present. Old leagues may have been deleted, but their players remain. Needs to be refactored when Genre schema is produced.

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use warnings;
use lib 'lib';

use Config::General;
use List::MoreUtils qw/uniq/;
use YAML qw/DumpFile/;
use Cwd;
use File::Spec;

my $dir = ( File::Spec->splitpath(getcwd) )[-1];
my @MyAppConf = glob( '*.conf' );
die "Which of @MyAppConf is the configuration file in $dir?"
			unless @MyAppConf == 1;
my %config = Config::General->new($MyAppConf[0])->getall;
my $name = $config{name};
require $name . ".pm";
my $model = "${name}::Schema";
my $modelfile = "$name/Model/DB.pm";
my $modelmodule = "${name}::Model::DB";

my $connect_info = $modelmodule->config->{connect_info};
my $schema = $model->connect( @$connect_info );
my $league = $schema->resultset('League')->find({ id => $dir });
my $genre = $league->genre->get_column('genre') if $league;
my $quizSet = $schema->resultset('Quiz');
my @newExerciseList = uniq $schema->resultset('Exercise')->search({ genre => $genre })->get_column('id')->all if $league;
my @leagueids = uniq $quizSet->get_column('league')->all;
my @exerciseIds = $quizSet->get_column('exercise')->all;
@exerciseIds = uniq sort @exerciseIds;
$, = "\t";
print "In $dir directory:\n";
my $scores;
for my $id ( sort @leagueids )
{
	my @leagueExercises = @exerciseIds;
	push @leagueExercises, @newExerciseList if $dir eq $id and $league;
	@leagueExercises = uniq @leagueExercises;
	print $id . "\t", @leagueExercises , "Total\n";
	print "============================================\n";
	my $results = $quizSet->search({ league => $id });
	while ( my $result = $results->next )
	{
		my $player = $result->get_column('player');
		my $exercise = $result->exercise;
		my $score = $result->get_column('correct');
		$scores->{$id}->{$player}->{$exercise} = $score;
	}
	for my $player ( uniq $quizSet->get_column('player')->all )
	{
		print $player . "\t";
		for my $exercise ( @leagueExercises, "Total")
		{
			$scores->{$id}->{$player}->{$exercise} = '-' if not
				exists $scores->{$id}->{$player}->{$exercise};
			print $scores->{$id}->{$player}->{$exercise} . "\t";
		}
		print "\n";
	}
	print "\n";
}
DumpFile 'quiz.yaml', $scores;
