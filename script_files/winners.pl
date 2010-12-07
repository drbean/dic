#!perl

=head1 NAME

script_files/winners.pl - Dump scores of players in leagues in order

=head1 SYNOPSIS

script_files/scores.pl

 FLA0018		eden-1	eden-2	Total
 ============================================
 N9461738	106	219	325	
 N9461736	80	155	235	
 
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
use dic;
use Net::FTP;

my $id = $ARGV[0] || basename( getcwd );

my $connect_info = dic::Model::DB->config->{connect_info};
my $schema = dic::Schema->connect( @$connect_info );
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
$, = "\t";
my $remote = "results.txt";
my $local = $genre? "/tmp/$genre/$remote": "/tmp/$remote";
my $io = io($local) or die "No score print to $local? $@";
$io->print("Standings\n");
my $scores;
for my $id ( sort @leagues )
{
	my @leagueExercises;
	@leagueExercises = @newExerciseList if $league;
	my $leagueplay = $playset->search({ league => $id });
	my $league = $schema->resultset('League')->find({ id => $id });
	push @leagueExercises, $leagueplay->get_column('exercise')->all;
	@leagueExercises = uniq @leagueExercises;
	$io->append( $id, @leagueExercises , "Total\n" );
	$io->append( "============================================\n" );
$, = "\t";
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
	my %tally;
	$, = undef;
	for my $player ( uniq $play->get_column('player')->all )
	{
		my $result = $player . "\t";
		for my $exercise ( @leagueExercises, "Total")
		{
			my $score = $scores->{$id}->{$player}->{$exercise};
			$score ||= '-';
			$result .= $score . "\t";
		}
		$result .= "\n";
		$tally{$player} = $result;
	}
	my @order = sort { $scores->{$id}->{$b}->{Total} <=>
						$scores->{$id}->{$a}->{Total} } keys %tally;
	my @results = map { $tally{$_} } @order;
	$io->append( @results , "\n" );
}

$io->close;

my $ftp = Net::FTP->new('web.nuu.edu.tw') or die "web.nuu.edu.tw? $@";
$ftp->login('greg', '1514') or die "web.nuu.edu.tw login? $@";
if ( $genre ) {
	$ftp->cwd("public_html/$genre") or die
		"web.nuu.edu.tw/~greg/public_html/$genre? $@";
}
else {
	$ftp->cwd("public_html") or die
		"web.nuu.edu.tw/~greg/public_html? $@";
}
$ftp->binary;
$ftp->put($local) or die "put $remote on web.nuu.edu.tw? $@";

