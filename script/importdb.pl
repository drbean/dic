#!perl

use strict;
use warnings;
use lib 'lib';

use DBI;
use Config::General;

use Cwd;

( my $MyAppDir = getcwd ) =~ s|^.+/([^/]+)$|$1|;
my $app = lc $MyAppDir;
my %config = Config::General->new("$app.conf")->getall;
my $name = $config{name};
require "$name.pm";
my $modelfile = "$name/Model/DB.pm";
my $modelmodule = "${name}::Model::DB";
# (my $modelmodule = $modelfile) =~ $name . "::Model::" . $name . "DB";
require $modelfile;

my @leagues = qw/access GL CLA FLB0008 FLA0005 FLA0018 visitors/;

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
# my $connect_info = [ 'dbi:SQLite:db/demo','','' ];
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
	my $genre = $league eq "GL"? "JUST RIGHT":
			$league eq "CLA"? "日華文大學二，三甲":
			$league eq "FLA0005"? "夜應外大學三甲":
			$league eq "FLA0018"? "夜應外大學二甲":
			$league eq "access"? "thematic":
			$league eq 'visitors'? "demo": "No genre";
	$lsth->execute( $league, $genre );
}

$d->do("CREATE TABLE leagues (id $VARCHAR{15}, name $VARCHAR{25}, field $VARCHAR{25}, primary key (id))");

$lsth = $d->prepare("INSERT INTO leagues (id, name, field) VALUES  (?,?,?)");
for my $league ( @leagues )
{
	my $id = $league;
	my $name = $league eq "GL"? "初中級英文聽說訓練": 
		$league eq "CLA"? "日華文大學二,三甲":
		$league eq "FLB0008"? "夜應外四技四甲":
		$league eq "FLA0005"? "夜應外大學三甲":
		$league eq "FLA0018"? "夜應外大學二甲":
		$league eq "Chinese"? "":
		$league eq 'access'? "英語自學室":
		$league eq 'visitors'? "Visitors": "No Name";
	my $field = $league eq "GL"? "English Conversation": 
		$league eq "CLA"? "英文聽力":
		$league eq "FLB0008"? "高階英文寫作":
		$league eq "FLA0005"? "跨文化溝通":
		$league eq "FLA0018"? "英語會話(一)":
		$league eq 'access'? "Student Life, Moon Festival":
		$league eq 'visitors'? "Demonstration Play": "No field";
	$lsth->execute( $id, $name, $field );
}

my $players;

push @{$players->{GL}}, [split] for <<GL =~ m/^.*$/gm;
U9743028	江秉鈞	Jim
U9721010	林文聲	Vincent
U9413029	陳筱復	Aprilita
M9723021	簡秀金	Tina
U9623007	薛峻凱	Tony
U9523028	丁維遵	Victor
U9424031	白睿中	Rui
U9414040	黃怡菁	Yi	
U9414020	黃鉦致	Zheng
9533220	許雅菱	Ya
9533202	蔡奇融	Qi
9531206	莊君緌	JUn
9533203	黃偉珉	Wei
9533216	羅心伶	Xin
9533244	張瑋真	Wei
U9616910	陳鴻品	Hong
U9616018	李洵	XUn
9411298	鄭又綸	You
9433237	吳佳馨	Jia
M9714001	葉俊宏	JUn
U9411082	趙巡漢	XUn
U9416008	吳國彬	Guo
U9417029	李家銘	Jia
U9417039	李怡瑩	Yi
U9423044	江全緒	QUan
U9531034	溫佳蓉	Jia
U9531043	張雯鈞	Wen
U9531058	黃柔瑄	Rou
U9718023	陳家音	Jia
U9722113	潘志良	Zhi
U9722122	藍嘉祥	Jia
U9722129	何宗承	Zong
GL

# in CLA, and also in FLA0005
# N9561725	吳凱婷	Kai
# N9561713	袁敏萱	Min
# N9561741	林麗佳	Li
# N9561759	古嘉珮	Jia
push @{$players->{CLA}}, [split] for <<CLA =~ m/^.*$/gm;
U9693001	沈佳其	Jia
U9693002	江佩珊	Pei
U9693003	葉亭妤	Ting
U9693004	葉依柔	Yi
U9693005	葉佳元	Jia
U9693006	官志皇	Zhi
U9693007	吳佩儒	Pei
U9693008	林漢萭	Han
U9693009	劉佳綺	Jia
U9693011	胡譯文	Yi
U9693012	林貞婷	Zhen
U9693013	吳莉欣	Li
U9693015	鍾秉成	Bing
U9693016	吳純芳	Chun
U9693017	莊雅婷	Ya
U9693018	童建爵	Jian
U9693020	楊鈞茜	JUn
U9693021	鄧舒帆	Shu
U9693022	周育慈	YU
U9693023	吳馨宜	Xin
U9693024	李明翰	Ming
U9693025	李庭萱	Ting
U9693028	王祥垣	Xiang
U9693029	陳婕妤	Jie
U9693030	賴?岑	?
U9693031	余宛錚	Wan
U9693032	李孟頻	Meng
U9693033	林鈺心	YU
U9693034	彭湘華	Xiang
U9693035	翁君儀	JUn
U9693036	吳姵儀	Pei
U9693037	李明濬	Ming
U9693038	賴逸平	Yi
U9693039	陳姵穎	Pei
U9693040	池采逸	Cai
U9693041	李欣蔓	Xin
U9693042	陳柔妤	Rou
U9693043	盧蕙芳	Hui
U9693044	彭希柔	Xi
U9693045	林怡君	Yi
U9693046	蔡逸璇	Yi
U9693047	張舒涵	Shu
U9693048	林琇瑩	Xiu
U9693050	黃昱傑	YU
U9693052	中山成華	Cheng
U9693053	張綺玲	Qi
U9693054	陳偉生	Wei
U9693055	羅文聰	Wen
N9561713	袁敏萱	Min
N9561725	吳凱婷	Kai
N9561741	林麗佳	Li
N9561759	古嘉珮	Jia
N9561761	林家伶	Jia
CLA

push @{$players->{FLA0005}}, [split] for <<FLA0005 =~ m/^.*$/gm;
N9361748	徐銘鴻	Ming
N9361759	陳潔意	Jie
N9561706	江依璇	Yi
N9561709	謝佳妡	Jia
N9561711	蔣佳宜	Jia
N9561712	廖彧貞	Yu
N9561713	袁敏萱	Min
N9561714	江吉泰	Ji
N9561715	廖重生	Chong
N9561717	陳怡吟	Yi
N9561719	駱文義	Wen
N9561722	李欣怡	Xin
N9561724	張玉珮	YU
N9561725	吳凱婷	Kai
N9561726	鄭百芬	Bai
N9561729	張雅婷	Ya
N9561730	姚佩伶	Pei
N9561731	邱士珍	Shi
N9561735	林夢瑩	Meng
N9561736	鄭汝幸	Ru
N9561741	林麗佳	Li
N9561743	蔡嘉瑋	Jia
N9561748	傅龍三	Long
N9561756	徐珮翎	Pei
N9561757	蔣堰婷	Yan
N9561759	古嘉珮	Jia
FLA0005

# N9361748	徐銘鴻	Ming in both FLA 0005, 0018
push @{$players->{FLA0018}}, [split] for <<FLA0018 =~ m/^.*$/gm;
N9461734	張雅臻	Ya
N9461736	彭珠蓮	Zhu
N9461738	劉佳佳	Jia
N9461753	葉又寧	You
N9461756	許芷菱	Zhi
N9661701	賴淑惠	Shu
N9661702	周品嫻	Pin
N9661704	?琮婷	Cong
N9661705	吳嘉怡	Jia
N9661706	葉雅婷	Ya
N9661707	鄧雅雯	Ya
N9661708	邱于芳	YU
N9661709	徐曉彤	Xiao
N9661712	胡語倫	YU
N9661714	劉軒齊	XUan
N9661715	陳奕學	Yi
N9661716	周雅雯	Ya
N9661717	黃路加	Ru
N9661718	鍾明諺	Ming
N9661719	周于婷	YU
N9661720	林碧珍	Bi
N9661722	廖婉秀	Wan
N9661723	謝文秀	Wen
N9661724	林逸喬	Yi
N9661725	吳采薇	Cai
N9661727	賴恩聖	En
N9661728	黃聖昱	Sheng
N9661730	劉芯惠	Xin
N9661731	林庭萱	Ting
N9661733	陳家洋	Jia
N9661734	曾佩茹	Pei
N9661737	廖政福	Zheng
N9661738	鄭淑鈴	Shu
N9661740	汪大智	Da
N9661741	林妤容	Hao
N9661742	吳筱涵	Xiao
N9661743	羅惠娟	Hui
N9661744	劉惠蓉	Hui
N9661745	吳桂麗	Jia
N9661746	吳書儀	Shu
N9661747	邱靖棋	Jing
N9661748	楊妙雲	Miao
N9661750	王育祥	YU
N9661751	周啟揚	Qi
FLA0018

# push @{$players->{access}}, [split] for <<ACCESS =~ m/^.*$/gm;
# ACCESS

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
$psth->execute( 193001, "DrBean", "ok" );
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
$rbsth->execute( 193001, 1 );
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
