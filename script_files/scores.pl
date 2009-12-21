#!perl

=head1 NAME

script_files/scores.pl - Dump scores of players in leagues

=head1 SYNOPSIS

script_files/scores.pl

 FLA0018		eden-1	eden-2	Total
 ============================================
 N9461736	80	155	235	
 N9461738	106	219	325	
 
=head1 DESCRIPTION

Dumps scores to standings.yaml in present directory and prints to STDOUT. No attention is paid to what the League schema tells us about what leagues and what exercises exist at present. Old leagues and exercises may have been deleted, but their players and exercise play results remain (unless a different exercise with the same name as a deleted one is added later?). A schema exercise without scores will still be included in the computed scores. Needs to be refactored when Genre schema is produced.

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use warnings;

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
# require $modelfile;

my $connect_info = $modelmodule->config->{connect_info};
my $schema = $model->connect( @$connect_info );
my $playset = $schema->resultset('Play');
my $league = $schema->resultset('League')->find({ id => $dir });
my $genre = $league->genre->get_column('genre') if $league;
my @newExerciseList;
@newExerciseList = uniq $schema->resultset('Exercise')->search({ genre => $genre })->get_column('id')->all if $league;
			 
my @leagueids = uniq $playset->get_column('league')->all;
my @exerciseIds = $playset->get_column('exercise')->all;
@exerciseIds = uniq sort @exerciseIds;
$, = "\t";
print "In $dir directory:\n";
my $scores;
my @leagues = glob ('*');
for my $dir ( @leagues )
{
	my $leagueplay = $playset->search({ league => $id });
	# my @leagueExercises = @exerciseIds;
	my @leagueExercises;
	if ( $dir eq $id and $league ) {
		push @leagueExercises, @newExerciseList;
	}
	elsif ( $dir eq 'dic' or $dir eq 'target' or $dir eq 'access' ) {
		my $league = $schema->resultset('League')->find({ id => $id });
		my $genre = $league->genre->get_column('genre') if $league;
		my @newExerciseList = $leagueplay->get_column('exercise')->all;
		push @leagueExercises, @newExerciseList;
	}
	@leagueExercises = uniq @leagueExercises;
	print $id . "\t", @leagueExercises , "Total\n";
	print "============================================\n";
    my $play = $leagueplay->search( undef,
		{ select => [ 'player', 'exercise', { sum => 'correct' } ],
		'group_by' => [qw/player exercise/],
		as => [ qw/player exercise score/ ],
		'order_by' => 'player' });
	while ( my $result = $play->next )
	{
		my $player = $result->get_column('player');
		my $exercise = $result->exercise;
		my $score = $result->get_column('score');
		$scores->{$id}->{$player}->{$exercise} = $score;
		$scores->{$id}->{$player}->{Total} += $score;
	}
	for my $player ( uniq $play->get_column('player')->all )
	{
		print $player . "\t";
		for my $exercise ( @leagueExercises, "Total")
		{
			my $score = $scores->{$id}->{$player}->{$exercise};
			$score ||= '-';
			print $score . "\t";
		}
		for my $player ( uniq $play->get_column('player')->all )
		{
			print $player . "\t";
			for my $exercise ( @exerciseIds , "Total")
			{
				$scores->{$dir}->{$id}->{$player}->{$exercise} = '-' if not
					exists $scores->{$dir}->{$id}->{$player}->{$exercise};
				print $scores->{$dir}->{$id}->{$player}->{$exercise} . "\t"; # if defined $scores->{$dir}->{$player}->{$exercise};
			}
			print "\n";
		}
		print "\n";
	}
	chdir "..";
}
DumpFile 'standings.yaml', $scores;
