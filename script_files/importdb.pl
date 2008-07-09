#!perl

use strict;
use warnings;
use lib 'lib';

use DBI;
use YAML qw/LoadFile/;

my $yaml = (glob '*.yml')[0];
my $app = LoadFile $yaml;
my $name = $app->{name};
require "$name.pm";
my $modelfile = "$name/Model/${name}DB.pm";
my $modelmodule = "${name}::Model::${name}DB";
# (my $modelmodule = $modelfile) =~ $name . "::Model::" . $name . "DB";
require $modelfile;

my @leagues = qw/j min jin visitors/;

=head1 NAME

importdb.pl - Set up dic db

=head1 SYNOPSIS

perl importdb.pl

=head1 DESCRIPTION

'CREATE TABLE texts (id text, description text, content text, unclozeables text, primary key (id))'

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

my $connect_info = $modelmodule->config->{connect_info};
my $d = DBI->connect( @$connect_info );

my (%CHAR, %VARCHAR, $BIT, $TINYINT, $SMALLINT, $INT, $BIGINT);
my @lengths = qw/1 5 15 25 50 72 500 7500/;
my @ints = qw/BIT TINYINT SMALLINT INT BIGINT/;
if ( $connect_info =~ m/SQLite/ )
{
	@CHAR{@lengths} = (qw/TEXT/) x @lengths;
	@VARCHAR{@lengths} = (qw/TEXT/) x @lengths;
	($BIT, $TINYINT, $SMALLINT, $INT, $BIGINT) = (qw/INTEGER/) x @ints;
}
else {
	%CHAR = map { $_ => "CHAR($_)" } @lengths;
	%VARCHAR = map { $_ => "VARCHAR($_)" } @lengths;
	($BIT, $TINYINT, $SMALLINT, $INT, $BIGINT) = @ints;
}

$d->do("CREATE TABLE dictionaries (genre $VARCHAR{15}, word $VARCHAR{25}, initial $CHAR{1}, stem $VARCHAR{25}, suffix $VARCHAR{15}, count $SMALLINT, primary key (genre, word))");

$d->do("CREATE TABLE exercises (genre $VARCHAR{15}, id $VARCHAR{15}, text $VARCHAR{15}, description $VARCHAR{50}, type $VARCHAR{15}, primary key (genre, id))");

$d->do("CREATE TABLE leaguegenre (league $VARCHAR{15}, genre $VARCHAR{15}, primary key (league, genre))");
my $lsth = $d->prepare("INSERT INTO leaguegenre (league, genre) VALUES  (?,?)");
for my $league ( @leagues )
{
	my $genre = $league eq "j"? "tourism": 
			$league eq "min"? "negotiation":
			$league eq 'jin'? "negotiation":
			$league eq 'visitors'? "demo": "No genre";
	$lsth->execute( $league, $genre );
}

$d->do("CREATE TABLE leagues (id $VARCHAR{15}, name $VARCHAR{25}, field $VARCHAR{25}, primary key (id))");

$lsth = $d->prepare("INSERT INTO leagues (id, name, field) VALUES  (?,?,?)");
for my $league ( @leagues )
{
	my $id = $league;
	my $name = $league eq "j"? "96-1, AFL2": 
			$league eq "min"? "96-1, Min4A":
			$league eq 'jin'? "96-1, Jin4A":
			$league eq 'visitors'? "Visitors": "No Name";
	my $field = $league eq "j"? "Tourism English": 
			$league eq "min"? "Business Negotiation":
			$league eq 'jin'? "Business Negotiation":
			$league eq 'visitors'? "Demonstration Play": "No field";
	$lsth->execute( $id, $name, $field );
}

my $players;
push @{$players->{j}}, [split] for <<J =~ m/^.*$/gm;
9351155	Queen	Queen
9430220	Jason	Jason
9438148	Viola	Viola
9530101 Cindy   Cindy
9530102 Vicky   Vicky
9530103 Michelle        Michelle
9530104 Ivy     Ivy
9530105 Terry   Terry
9530106 Kelly   Kelly
9530108 Angel   Angel
9530109 Lena    Lena
9530111 Jocelyn Jocelyn
9530112 Joyce   Joyce
9530114 Rose    Rose
9530115 Eva     Eva
9530116 Emily   Emily
9530117 Jackson Jackson
9530118 Ken     Ken
9530120 Jill    Jill
9530121 Joseph  Joseph
9530122 Batty   Batty
9530125 Tracy   Tracy
9530126 Vera    Vera
9530127 Kenny   Kenny
9530128 Wen     Wen
9530129 Jack    Jack
9530130 April   April
9530131 Angela  Angela
9530135 Kevin   Kevin
J

push @{$players->{min}}, [split] for <<MIN =~ m/^.*$/gm;
95641002        Cliff   Cliff
95641003        Sylvia  Sylvia
95641004        Jenming Jenming
95641007        Vivi    Vivi
95641008        Vickey  Vickey
95641010        Chanel  Chanel
95641011        Jessica Jessica
95641013        Eddie   Eddie
95641014        James   James
95641015        Ginger  Ginger
95641016        Kevin   Kevin
95641017        Wendy   Wendy
95641018        Nicole  Nicole
95641020        Simon   Simon
95641021        Kyle    Kyle
95641022        Joanne  Joanne
MIN

push @{$players->{jin}}, [split] for <<JIN =~ m/^.*$/gm;
95801001        Michael Michael
95801002        Corinna Corinna
95801003        Eki     Eki
95801005        Kyo     Kyo
95801008        Unknown Unknown
95801009        Risky   Risky
95801012        Unknown1        Unknown1
95801013        Steven  Steven
95801014        Jason   Jason
95801017        Alice   Alice
95801018        Snoopy  Snoopy
JIN

push @{$players->{visitors}}, [split] for <<VISITORS =~ m/^.*$/gm;
1        guest 1
VISITORS

$d->do("CREATE TABLE members (league $VARCHAR{15}, player $INT, primary key (league, player))");

my $msth = $d->prepare("INSERT INTO members (league, player) VALUES  (?,?)");
for my $league ( @leagues )
{
	# my $data = LoadFile "/home/greg/class/$league/li/league.yaml";
	my $leagueid = $league;
	# my $members = $data->{member};
	my $members = $players->{$league};
	for my $member ( @$members )
	{
		$msth->execute( $leagueid, $member->[0] );
	}
}

$d->do("CREATE TABLE players (id $INT, name $VARCHAR{15}, password $VARCHAR{50}, primary key (id))");

my $psth = $d->prepare("INSERT INTO players (id, name, password) VALUES  (?,?,?)");
$psth->execute( 88201, "DrBean", "nok" );
for my $league ( @leagues )
{
	my $members = $players->{$league};
	for my $member ( @$members )
	{
		$psth->execute( $member->[0], $member->[1], $member->[2], );
	}
}

$d->do("CREATE TABLE roles ( id $INT PRIMARY KEY, role $VARCHAR{15})");
my $rsth = $d->prepare("INSERT INTO roles (id, role) VALUES  (?,?)");
$rsth->execute( 1, "official" );
$rsth->execute( 2, "player" );

$d->do("CREATE TABLE rolebearers (player $INT, role $INT, primary key (player, role))");
my $rbsth = $d->prepare("INSERT INTO rolebearers (player, role) VALUES  (?,?)");
$rbsth->execute( 88201, 1 );
for my $league ( @leagues )
{
	my $members = $players->{$league};
	for my $member ( @$members ) { $rbsth->execute( $member->[0], 2 ); }
}


$d->do("CREATE TABLE play (league $VARCHAR{15}, exercise $VARCHAR{15}, player $INT, blank $SMALLINT, correct $TINYINT, primary key (exercise, player, blank))");

$d->do("CREATE TABLE quiz (league $VARCHAR{15}, exercise $VARCHAR{15}, player $INT, question $VARCHAR{15}, correct $TINYINT, primary key (exercise, player, question))");

# SQL Server right-truncating text string!!
# $d->do("CREATE TABLE sessions (id $CHAR{72}, session_data TEXT, expires  $INT,  primary key (id))");
$d->do("CREATE TABLE sessions (id $CHAR{72}, session_data $VARCHAR{7500}, expires  $INT,  primary key (id))");

$d->do("CREATE TABLE questions (genre $VARCHAR{15}, text $VARCHAR{15}, id $VARCHAR{15}, content $VARCHAR{500}, answer $VARCHAR{500}, primary key (genre, text, id))");

# SQL Server right-truncating text string!!
# $d->do("CREATE TABLE texts (id $VARCHAR{15}, description $VARCHAR{50}, content TEXT, unclozeables TEXT, primary key (id))");
$d->do("CREATE TABLE texts (id $VARCHAR{15}, description $VARCHAR{50}, genre $VARCHAR{15}, content $VARCHAR{7500}, unclozeables $VARCHAR{7500}, primary key (id))");

$d->do("CREATE TABLE questionwords (genre $VARCHAR{15}, exercise $VARCHAR{15}, question $VARCHAR{15}, id $SMALLINT, content $VARCHAR{50}, link $SMALLINT, primary key (genre, exercise, question, id))");

$d->do("CREATE TABLE words (genre $VARCHAR{15}, exercise $VARCHAR{15}, id $SMALLINT, class $VARCHAR{15}, published $VARCHAR{500}, unclozed $VARCHAR{500}, clozed $VARCHAR{15}, pretext $CHAR{50}, posttext $CHAR{50}, primary key (genre, exercise, id))");

#$sth = $d->prepare("INSERT INTO texts (id, description, content, unclozeables)
#                                        VALUES  (?,?,?,?)");

my $tsth = $d->table_info('','','%');
my $tables = $tsth->fetchall_hashref('TABLE_NAME');

for my $table ( qw/players leagues members roles rolebearers texts questions words questionwords exercises dictionaries sessions play quiz/ )
{
	if ( ($connect_info)->[0] =~ m/SQLite/ )
	{
		print "$table: $tables->{$table}->{sqlite_sql}\n";
	}
	else {
		print "$table: $tables->{$table}->{'TABLE_NAME'}\n";

	}
}

#while ( my $id = <STDIN> )
#{
#       chop $id;
#       $sth->execute($id);
#       while (my @r = $sth->fetchrow_array)
#       {
#               $, = "\t";
#               print @r, "\n";
#       }
#       print "\n";
#}

$lsth->finish;
$msth->finish;
$psth->finish;
$rsth->finish;
$rbsth->finish;
$tsth->finish;

$d->disconnect;
