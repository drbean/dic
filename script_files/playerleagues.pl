#!perl

use strict;
use warnings;
use lib 'lib';

use Config::General;
use Cwd;
use File::Spec;
use List::MoreUtils qw/all/;
use YAML qw/LoadFile/;

BEGIN {
	my @MyAppConf = glob( '*.conf' );
	die "Which of @MyAppConf is the configuration file?"
				unless @MyAppConf == 1;
	my %config = Config::General->new($MyAppConf[0])->getall;
	$::name = $config{name};
	require "$::name.pm"; $::name->import;
	require "$::name/Schema.pm"; $::name->import;
}

my @leagueids = qw/GL00003 GL00022 GL00031 CLA0013 FLA0015 FLB0002 MIA0012 access visitors/;
my $dir = ( File::Spec->splitdir(getcwd) )[-1];
$dir = qr/^(GL000|CLA|FL|MIA)/ if $dir eq 'dic';
@leagueids = grep m/$dir/, @leagueids;

no strict qw/subs refs/;
my $connect_info = "${::name}::Model::DB"->config->{connect_info};
# my $connect_info = [ 'dbi:SQLite:db/demo','','' ];
my $schema = "${::name}::Schema"->connect( @$connect_info );
use strict;

my $leagues = [
		[ qw/id name field/ ],
	[ "GL00003", "GL00003日語文共同學制虛擬班二", "中級英文聽說訓練" ],
	[ "GL00022", "GL00022日語文共同學制虛擬班二", "中級英文聽說訓練" ],
	[ "GL00031", "GL00031日語文共同學制虛擬班二", "中級英文聽說訓練" ],
		[ "CLA0013", "CLA0013日華文大學二甲", "英文聽力及會話" ],
		[ "FLA0015", "FLA0015夜應外大學二甲", "英語會話(二)" ],
		[ "FLB0002", "FLB0002夜應外四技四甲", "英語演說" ],
		[ "MIA0012", "MIA0012日資管大學二甲", "商用英文實務(二)" ],
		[ "MIA0012", "MIA0012日資管大學二甲", "商用英文實務(二)" ],
		[ "access", "英語自學室", "Listening" ],
		[ "visitors", "Visitors", "Demonstration Play" ],
		[ "dic", "Dictation", "Testing" ],
	];

uptodatepopulate( 'League', $leagues );

my $leaguegenres = [
			[ qw/league genre/ ],
			[ "GL00003",	"intermediate" ],
			[ "GL00022",	"intermediate" ],
			[ "GL00031",	"intermediate" ],
			[ "CLA0013",	"teaching" ],
			[ "FLA0015",	"intermediate" ],
			[ "FLB0002",	"speaking" ],
			[ "MIA0012",	"business" ],
			[ "access",	"all" ],
			[ 'visitors',	"demo" ],
			[ 'dic',	"all" ],
		];
uptodatepopulate( 'Leaguegenre', $leaguegenres );

my ($leaguefile, $players);

push @{$players->{GL00022}}, [split] for <<GL00022 =~ m/^.*$/gm;
9421235  林奕廷 yi
9433230  陳瑋茹 wei
9633250  呂孟慈 meng
T9731044 張凱建 kai
U9316005 劉嘉蕙 jia
U9316009 陳婷君 ting
U9316045 鄭宇軒 yu
U9416012 劉宇溱 yu
U9522028 林沿昌 yan
U9522084 謝唯新 wei
U9522105 徐至鴻 zhi
U9592020 彭婉菁 wan
U9592036 蘇木春 mu
U9715024 簡□彥  ?
U9731102 陳衣采 yi
U9731143 林孝芸 xiao
9422221	 張家偉	jia
U9731139 吳詩玉 shi
9433227  黃馨儀 xin
U9692021 溫惠喻 hui
GL00022

push @{$players->{FLB0002}}, [split] for <<FLB0002 =~ m/^.*$/gm;
N9361738 江映霖	ying
N9361749 覃少穎	shao
N9361750 曾思萍	si
N9461708 張佩玲	pei
N9461709 陳詩旻	shi
N9461710 羅亞萍	ya
N9461719 劉昭驊	zhao
N9461725 張□明	jiong
N9461729 蔡純茹	chun
N9461734 張雅臻	ya
N9461735 張琨耀	kun
N9461736 彭珠蓮	zhu
N9461739 林佳汭	jia
N9461745 陳怡蓁	yi
N9461747 李安倫	an
N9461748 陳思羽	si
N9461751 黃芝鈴	zhi
N9461753 葉又寧	you
N9461754 李蕙丞	hui
N9461756 許芷菱	zhi
N9461760 吳雲禎	yun
N9461762 陳震宇	zhen
N9461764 林俊華	jun
N9461766 劉毓汶	yu
U9533039 蕭郁玲	yu
FLB0002

for my $league ( 'FLA0015', 'MIA0012', 'CLA0013', 'GL00003', 'GL00031' ) {
	$leaguefile = LoadFile "/home/drbean/class/$league/league.yaml";
	push @{$players->{$league}}, map {[ $_->{id}, $_->{Chinese}, $_->{password} ]}
					@{$leaguefile->{member}};
}

push @{$players->{FLB0002}}, [split] for <<FLB0002 =~ m/^.*$/gm;
N9361738 江映霖	ying
N9361749 覃少穎	shao
N9361750 曾思萍	si
N9461708 張佩玲	pie
N9461709 陳詩旻	shi
N9461710 羅亞萍	ya
N9461719 劉昭驊	zhao
N9461725 張□明	ming
N9461729 蔡純茹	chun
N9461734 張雅臻	ya
N9461735 張琨耀	kun
N9461736 彭珠蓮	zhu
N9461739 林佳汭	jia
N9461745 陳怡蓁	yi
N9461747 李安倫	an
N9461748 陳思羽	si
N9461751 黃芝鈴	zhi
N9461753 葉又寧	you
N9461754 李蕙丞	hui
N9461756 許芷菱	zhi
N9461760 吳雲禎	yun
N9461762 陳震宇	zhen
N9461764 林俊華	jun
N9461766 劉毓汶	yu
U9533039 蕭郁玲	yu
FLB0002

push @{$players->{MIA0012}}, [split] for <<MIA0012 =~ m/^.*$/gm;
U9633001 林祐年	you
U9633002 李政道	zheng
U9633003 劉家凱	jia
U9633004 王妙如	miao
U9633005 莊政憲	zheng
U9633006 張羽萱	yu
U9633007 楊少杰	shao
U9633009 李泉泰	quan
U9633011 郭虹吟	hong
U9633012 劉家豪	jia
U9633013 羅士涵	shi
U9633014 劉釆怡	cai
U9633015 陳鈺澧	yu
U9633016 張如君	ru
U9633017 陳俊豪	jun
U9633019 蔡宗祐	zong
U9633020 江蘊倫	yun
U9633021 詹國廷	guo
U9633022 邱詩文	shi
U9633023 林暐□ 	wei
U9633024 江采芬	cai
U9633025 李宗曄	zong
U9633026 劉治廷	zhi
U9633027 劉家宏	jia
U9633028 張孟淞	meng
U9633029 楊麗燕	li
U9633030 謝誌紘	zhi
U9633031 吳孟螢	meng
U9633033 鄧善鴻	shan
U9633034 林　群	qun
U9633035 鄭盟穎	meng
U9633036 曾昱文	yu
U9633038 莊惠棋	hui
U9633039 黃仁旗	ren
U9633040 陳恩輝	en
U9633041 顏誌君	zhi
U9633042 李雅茹	ya
U9633043 洪惠菁	hui
U9633044 徐千淳	qian
U9633045 張毅民	yi
U9633046 蘇文煜	wen
U9633047 卜弘成	hong
U9633048 湛洪鈞	hong
U9633049 黃聖萍	sheng
U9633050 王國權	guo
U9633051 洪　寧	ning
U9633052 金詣耘	yi
U9633053 邱紹豐	shao
MIA0012

push @{$players->{access}}, [split] for <<ACCESS =~ m/^.*$/gm;
U9424017	黃季雯	Ji
U9424014	莊詠竹	Yong
U9621048	劉志偉	Zhi
U9511049	黃湛明	Zhan
U9717047	陳YuanWen  YU
P220513110	程小芳	Xiao
U9734022	廖子瑜	Zi
U9734050	黃靖瑋	jing
ACCESS

push @{$players->{visitors}}, [split] for <<VISITORS =~ m/^.*$/gm;
1        guest 1
VISITORS

@{$players->{dic}} = map { @{$players->{$_}} } keys %$players;

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
	push @allLeaguePlayers, values %members;
	push @allLeaguerolebearers, values %rolebearers;
	$members{193001} = [ $league, 193001 ];
}
uptodatepopulate( 'Member', [ [ qw/league player/ ], 
				@allLeaguePlayers ] );

uptodatepopulate( 'Role', [ [ qw/id role/ ], 
[ 1, "official" ],
[ 2, "player" ], ] );

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

=head1 AUTHOR

Dr Bean, C<drbean at (@) cpan dot, yes a dot, org>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
