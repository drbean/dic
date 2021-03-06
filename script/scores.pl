#!perl

=head1 NAME

script_files/scores.pl - Dump scores of players in leagues

=head1 SYNOPSIS

script_files/scores.pl GL00006

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
use FindBin qw/$Bin/;
use lib "$Bin/../lib";

use Config::General;
use List::MoreUtils qw/any uniq/;
use YAML qw/DumpFile/;
use IO::All;
use Cwd; use File::Basename;
use Dic;
use Net::FTP;

my $id = $ARGV[0] || basename( getcwd );

my $connect_info = Dic::Model::DB->config->{connect_info};
my $schema = Dic::Schema->connect( $connect_info );
my $playset = $schema->resultset('Play');
my $league;
$league = $schema->resultset('League')->find({ id => $id }) if $id;
my ($genre, @newExerciseList);
if ( $league ) {
	$genre = $league->genre->get_column('genre');
	@newExerciseList = uniq $schema->resultset('Exercise')->search({ genre =>
		$genre })->get_column('id')->all;
}
my @playingleagues = uniq $playset->get_column('league')->all;
my @leagues = (any { $_ eq $id } @playingleagues) ? ( $id ): @playingleagues;
my @exerciseIds = $playset->get_column('exercise')->all;
@exerciseIds = uniq sort @exerciseIds;
my $remote = "standings.txt";
my $local = $genre? "/tmp/$genre/$remote": "/tmp/$remote";

my $ftp = Net::FTP->new('web.nuu.edu.tw') or die "web.nuu.edu.tw? $@";
$ftp->login('greg', '') or die "web.nuu.edu.tw login? $@";
if ( $genre ) {
	$ftp->cwd("public_html/$genre") or die
		"web.nuu.edu.tw/~greg/public_html/$genre? $@";
}
else {
	$ftp->cwd("public_html") or die
		"web.nuu.edu.tw/~greg/public_html? $@";
}

my $io = io($local) or die "No score print to $local? $@";
my $output = "Standings\n";
my $scores;
for my $id ( sort @leagues )
{
	my @leagueExercises;
	@leagueExercises = @newExerciseList if $league;
	my $leagueplay = $playset->search({ league => $id });
	my $league = $schema->resultset('League')->find({ id => $id });
	push @leagueExercises, $leagueplay->get_column('exercise')->all;
	@leagueExercises = uniq @leagueExercises;
	@leagueExercises = qw/alex cindy dave jeff kelly mindy neil rena shane vicky/;
	$output .= join "\t", $id."\t", @leagueExercises, "Total\n";
	$output .= "============================================\n";
    my $play = $leagueplay->search( [
			{exercise => 'alex'},
			{exercise => 'cindy'},
			{exercise => 'dave'},
			{exercise => 'jeff'},
			{exercise => 'kelly'},
			{exercise => 'mindy'},
			{exercise => 'neil'},
			{exercise => 'rena'},
			{exercise => 'shane'},
			{exercise => 'vicky'},
			 ],
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
		$output .= $player . "\t";
		for my $exercise ( @leagueExercises, "Total")
		{
			my $score = $scores->{$id}->{$player}->{$exercise};
			$score ||= '-';
			$output .= $score . "\t";
		}
		$output .= "\n";
	}
	$output .= "\n";

	$io->print( $output );

	$ftp->binary;
}

io('-')->print( $output );
$io->close;
	$ftp->put($local) or die "put $remote on web.nuu.edu.tw? $@";

