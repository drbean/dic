#!perl

# Last Edit;
# $Id$

use strict;
use warnings;
use lib 'lib';

use Config::General;
use Cwd;
use File::Spec;
use List::Util qw/first shuffle/;
use List::MoreUtils qw/all/;
use YAML qw/LoadFile Dump/;

BEGIN {
	my @MyAppConf = glob( '*.conf' );
	die "Which of @MyAppConf is the configuration file?"
				unless @MyAppConf == 1;
	my %config = Config::General->new($MyAppConf[0])->getall;
	$::name = $config{name};
	$::leagues = $config{leagues};
	require "$::name.pm"; $::name->import;
	require "$::name/Schema.pm"; $::name->import;
}

no strict qw/subs refs/;
my $connect_info = "${::name}::Model::DB"->config->{connect_info};
# my $connect_info = [ 'dbi:SQLite:db/demo','','' ];
my $schema = "${::name}::Schema"->connect( @$connect_info );
use strict;

my $genre = $ARGV[0];

my @leagues = $schema->resultset('Leaguegenre')->search({ genre => $genre });
my @leagueids = map { $_->getleague->id } @leagues;
die "No leagues in \"$genre\" genre," unless @leagueids;
my ($groupfile, $players, @allLeaguerolebearers, $grouproles);

for my $id ( @leagueids ) {
	my $dir = "$::leagues/$id";
	my $league = LoadFile "$dir/league.yaml";
	my $members = $league->{member};
	my $groupwork = "$dir/$league->{groupwork}";
	my @subdirs = grep { -d } glob "$groupwork/*";
	my $lastsession = ( sort map m/^$groupwork\/(\d+)$/, @subdirs )[-1];
	my $jigsawpath = "$groupwork/$lastsession";
	my $jigsawfile = "$jigsawpath/jigsaw.yaml";
	my $loadedfile = -e $jigsawfile? $jigsawfile: "$jigsawpath/groups.yaml";
	my $groups = LoadFile $loadedfile;
	my $players = $schema->resultset('Player');
	my %rolebearers;
	for my $group ( keys %$groups ) {
		my @roleIds = shuffle ( 'A'..'D' );
		# my @roleIds = ( 'A'..'D' );
		die "${id}'s $group group?" unless ref $groups->{$group} eq 'ARRAY';
		my @members = @{$groups->{$group}};
		for my $n ( 0 .. @members-1 ) {
			my $name = $groups->{$group}->[$n];
			next unless $name;
			my $member = first { $_->{name} eq $name } @$members;
			my $Chinese = $member->{Chinese};
			my $count = $players->count( { name=>$Chinese } );
			die "$name in $id league $group group not a Player"
							unless $count;
			my $playerid = $member->{id};
			die "$name in $id league $group has $playerid id"
							unless $playerid;
			my $player = $players->find( { id => $playerid } );
			die "2 ${name}s in $id league, 1 in $group" if
							$rolebearers{$playerid};
			my $role = $roleIds[$n];
			$rolebearers{$playerid} = [ $id, $playerid, $role ];
			$grouproles->{$id}->{$group}->{$role} = $name . "\t" . $playerid;
		}
		push @allLeaguerolebearers, values %rolebearers;
	}
}

print Dump $grouproles;

uptodatepopulate( 'Jigsawrole', [ [ qw/league player role/ ], 
	# [ 193001, 1 ],
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

script_files/jigsawroles.pl - assign text sections to individual players in group

=head1 SYNOPSIS

perl script_files/jigsawroles.pl intermediate

=head1 DESCRIPTION

INSERT INTO jigsawroles (league, player, role) VALUES (?, ?, ?)

=head1 AUTHOR

Dr Bean, C<drbean at (@) cpan dot, yes a dot, org>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
