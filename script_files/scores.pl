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

Dumps scores to scores.yaml in present directory and prints to STDOUT. Needs to be refactored when Genre schema is produced.

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

my @MyAppConf = glob( '*.conf' );
die "Which of @MyAppConf is the configuration file?"
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
my $leagueset = $schema->resultset('League');
my @leagueids = uniq $playset->get_column('league')->all;
$, = "\t";
my $scores;
for my $id ( sort @leagueids )
{
	my $league = $leagueset->find({ id => $id });
	my $genre = $league->genre->genre;
	my @exerciseList = uniq $schema->resultset('Exercise')->search({ genre => $genre });
    my @exerciseIds = sort { lc($a) cmp lc($b) } map { $_->id } @exerciseList;
    # my @exerciseHeaders = map { s/-/ /g; s/\b(\w)/\u$1/g; $_ } @exerciseIds;
	print $id . "\t", @exerciseIds , "Total\n";
	print "============================================\n";
    my $play = $playset->search({ league => $id },
		{ select => [ 'player', 'exercise', { sum => 'correct' } ],
		'group_by' => [qw/player exercise/],
		as => [ qw/player exercise score/ ],
		'order_by' => 'player' });
	while ( my $result = $play->next )
	{
		my $player = $result->player->id;
		my $exercise = $result->exercise;
		my $score = $result->get_column('score');
		$scores->{$league}->{$player}->{$exercise} = $score;
		$scores->{$league}->{$player}->{Total} += $score;
	}
	for my $player ( uniq $play->get_column('player')->all )
	{
		print $player . "\t";
		for my $exercise ( @exerciseIds , "Total")
		{
			$scores->{$league}->{$player}->{$exercise} = '-' if not
				exists $scores->{$league}->{$player}->{$exercise};
			print $scores->{$league}->{$player}->{$exercise} . "\t"; # if defined $scores->{$league}->{$player}->{$exercise};
		}
		print "\n";
	}
	print "\n";
}
DumpFile 'scores.yaml', $scores;
