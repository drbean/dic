#!perl

use strict;
use warnings;
use lib 'lib';

use Config::General;
use Cwd;
use File::Spec;
use List::MoreUtils qw/all/;
use YAML qw/LoadFile/;

use Dic;
use Dic::Model::DB;
use Dic::Schema;

my %config = Config::General->new( "dic.conf" )->getall;
my $connect_info = Dic::Model::DB->config->{connect_info};
my $schema = Dic::Schema->connect( $connect_info );


my $leaguegenres = [
			[ qw/league genre/ ],
			[ "FLA0015",	"conversation" ],
			[ "FLA0017",	"conversation" ],
			[ "FLA0022",	"business" ],
			[ "FLA0026",	"esp" ],
			[ "FLA0027",	"presentation" ],
			[ "1J0",	"call" ],
			[ "2L2",	"speaking" ],
			[ "MB2",	"speaking" ],
#			[ "self_access",	"access" ],
		];
my @leagueids =  map $_->[0], @$leaguegenres[1..$#$leaguegenres];

my $leaguedirs = $config{leagues};
my ($leaguefile, $players);
my $leagues = [ [ qw/id name field/ ] ];
for my $leagueId ( @leagueids ) {
	( my $id = $leagueId ) =~ s/^([[[:alpha:]][[:digit:]]]).*$/$1/;
	$leaguefile = LoadFile "$leaguedirs/$id/league.yaml";
	push @$leagues, [ $leagueId, $leaguefile->{league}, $leaguefile->{field} ];
	push @{$players->{$leagueId}},
		map {[ $_->{id}, $_->{Chinese}, $_->{password} ]}
					@{$leaguefile->{member}};
}

uptodatepopulate( 'League', $leagues );

uptodatepopulate( 'Leaguegenre', $leaguegenres );

push @{$players->{officials}}, [split] for <<OFFICIALS =~ m/^.*$/gm;
193001	DrBean	ok
OFFICIALS

my %players;
foreach my $league ( 'officials', @leagueids )
{
	next unless $players->{$league} and ref $players->{$league} eq "ARRAY";
	my @players = @{$players->{$league}};
	foreach ( @players )
	{
		$players{$_->[0]} = [ $_->[0], $_->[1], $_->[2] ];
	}
}
my $playerpopulator = [ [ qw/id name password/ ], values %players ];
uptodatepopulate( 'Player', $playerpopulator );

my (@allLeaguerolebearers, @allLeaguePlayers);
foreach my $league ( @leagueids )
{
	my (%members, %rolebearers);
	next unless $players->{$league} and ref $players->{$league} eq "ARRAY";
	my @players = @{$players->{$league}};
	foreach my $player ( @players )
	{
		$members{$player->[0]} =  [ $league, $player->[0] ];
		$rolebearers{$player->[0]} =  [ $player->[0], 2 ];
	}
	$members{193001} = [ $league, 193001 ];
	push @allLeaguePlayers, values %members;
	push @allLeaguerolebearers, values %rolebearers;
}
uptodatepopulate( 'Member', [ [ qw/league player/ ], 
				@allLeaguePlayers ] );

uptodatepopulate( 'Role', [ [ qw/id role/ ], 
[ 1, "official" ],
[ 2, "player" ],
[ 3, "amateur" ], ] );

uptodatepopulate( 'Rolebearer', [ [ qw/player role/ ], 
				[ 193001, 1 ],
				@allLeaguerolebearers ] );

sub uptodatepopulate
{
	my $class = $schema->resultset(shift);
	my $entries = shift;
	my $columns = shift @$entries;
	foreach my $row ( @$entries )
	{
		my %hash;
		@hash{@$columns} = @$row;
		$class->update_or_create(\%hash);
	}
}


=head1 NAME

script_files/playerleagues.pl.pl - populate leagues, players, members, roles, rolebrarer tables

=head1 SYNOPSIS

perl script_files/playerleagues.pl

=head1 DESCRIPTION

INSERT INTO players (id, name, password) VALUES (?, ?, ?)

Actually UPDATE or INSERT. So it can be used when new players are added.

=head1 AUTHOR

Dr Bean, C<drbean at (@) cpan dot, yes a dot, org>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
