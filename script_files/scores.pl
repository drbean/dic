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

Dumps scores to scores.yaml in present directory and prints to STDOUT. No attention is paid to what the League schema tells us about what leagues exists at present. Old leagues may have been deleted, but their players remain. Needs to be refactored when Genre schema is produced.

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

my $dir = getcwd;
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
my @leagueids = uniq $playset->get_column('league')->all;
my @exerciseIds = uniq $playset->get_column('exercise')->all;
$, = "\t";
print "In $dir directory:\n";
my $scores;
for my $id ( sort @leagueids )
{
	print $id . "\t", @exerciseIds , "Total\n";
	print "============================================\n";
    my $play = $playset->search({ league => $id },
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
		for my $exercise ( @exerciseIds , "Total")
		{
			$scores->{$id}->{$player}->{$exercise} = '-' if not
				exists $scores->{$id}->{$player}->{$exercise};
			print $scores->{$id}->{$player}->{$exercise} . "\t";
		}
		print "\n";
	}
	print "\n";
}
DumpFile 'standings.yaml', $scores;
