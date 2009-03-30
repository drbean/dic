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

push @{$players->{GL00003}}, [split] for <<GL00003 =~ m/^.*$/gm;
9411218 鐘得源	de
9411245 石世丞	shi
9411294 邱暐翔	wei
9423234 楊馥源	fu
9431208 梁筑君	zhu
9431215 李卉羚	hui
9431223 鄒惠鈞	hui
9521220 張家瑋	jia
9521224 林琨淵	kun
9521263 曾嘉農	jia
9521265 蘇柏元	bo
9521286 吳冠陞	guan
9522239 王仁宇	ren
9522287 張玉郎	yu
9613220 徐仁泰	ren
9622205 黃勁傑	jing
9622231 郭濬銘	jun
9623202 詹之嶢	zhi
9623210 張榮華	rong
T9721138 陳羿銘 yi
U9410003 陳柏翰 bo
U9415049 蕭羽婷 yu
U9416039 黃耀慶 yao
U9422014 王彥倫 yan
U9422033 鄭禮寶 li
U9422103 陳紀榮 ji
U9510004 徐嘉駿 jia
U9516002 陳琪樺 qi
U9531008 陳妍妃 yan
U9531010 楊雅惠 ya
U9611062 簡崇名 chong
U9611092 薛安順 an
U9611102 謝奕辰 yi
U9611112 趙紹棠 shao
U9611114 周逸人 yi
U9617037 陳冠融 guan
U9617045 謝舒嵐 shu
U9621063 陳昱全 yu
U9621073 張鈺暘 yu
U9621109 張文瑄 wen
U9623003 洪會嘉 hui
U9631012 洪偉勛 wei
U9631029 曾姵綺 pei
U9631045 何怡如 yi
U9721107 林鈺為 yu
U9721119 黃聖弼 sheng
U9721126 汪孟庭 meng
U9721133 何盈宗 ying
U9742009 鄭惠云 hui
U9742011 蔡秀艾 ying
U9631013 吳依婷	yi
U9611083 吳昶均 chang
U9721150 楊宗融 zong
U9522075 林士雄 shi
GL00003

push @{$players->{GL00022}}, [split] for <<GL00022 =~ m/^.*$/gm;
9421235  林奕廷 yi
9433230  陳瑋茹 wei
9633250  呂孟慈 meng
T9731044 張凱建 kai
U9316005 劉嘉蕙 jia
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

push @{$players->{GL00031}}, [split] for <<GL00031 =~ m/^.*$/gm;
9422264 郭健宏  jian
9531222 詹凡儀  fan
9431228 曹曼萱	man
9521270 鄭智遠	zhi
9522291 李宗賢	zong
9531202 彭奕達	yi
9531234 邱鈺婷	yu
9531243 丁亭云	ting
9531249 許博雅	bo
9611218 黃世杰	shi
9616208 陳珮熏	pei
9616211 江柏緯	bo
9621244 謝宇恆	yu
9622215 劉欣怡	xin
9622245 王萬慶	wan
9622271 黃裕恩  yu
T9731047 朱英鳳	ying
U9410005 黃彥綾	yan
U9410022 許楷青	kai
U9413010 陳美華	mei
U9415058 劉子豪	zi
U9417037 顏凡鈞	fan
U9422070 鄒銘珊	ming
U9424014 莊詠竹	yong
U9513015 劉美芬	mei
U9513041 陳妍君	yan
U9513044 林憶伶	yi
U9513046 陳麗萍	li
U9513049 葉政忠	zheng
U9514016 李昇儒	sheng
U9521110 郭忻柔	xin
U9522019 張　騰	teng
U9522061 趙士豪	shi
U9522063 林書平	shu
U9522079 張勝傑	sheng
U9522104 陳泱銓	yang
U9592050 陳宜萱	yi
U9611100 柯建賢	jian
U9613031 戴昀杏	yun
U9613032 許　彤	tong
U9621107 董冠緯	guan
U9622075 周　杰	jie
U9633036 曾昱文	yu
U9633049 黃聖萍	sheng
U9633050 王國權	guo
U9724028 唐虹琳	hong
U9731046 黃　旻	yu
U9416004 鄭美蓉 mei
U9621092 李允傑 yun
U9621107 董冠緯 guan
GL00031

push @{$players->{CLA0013}}, [split] for <<CLA0013 =~ m/^.*$/gm;
U9693001	沈佳其	jia
U9693002	江佩珊	pei
U9693003	葉亭妤	ting
U9693004	葉依柔	yi
U9693005	葉佳元	jia
U9693006	官志皇	zhi
U9693007	吳佩儒	pei
U9693008	林漢萭	han
U9693009	劉佳綺	jia
U9693011	胡譯文	yi
U9693012	林貞婷	zhen
U9693013	吳莉欣	li
U9693015	鍾秉成	bing
U9693016	吳純芳	chun
U9693017	莊雅婷	ya
U9693018	童建爵	jian
U9693020	楊鈞茜	jun
U9693021	鄧舒帆	shu
U9693022	周育慈	yu
U9693023	吳馨宜	xin
U9693024	李明翰	ming
U9693025	李庭萱	ting
U9693028	王祥垣	xiang
U9693029	陳婕妤	jie
U9693030	賴?岑	?
U9693031	余宛錚	wan
U9693032	李孟頻	meng
U9693033	林鈺心	yu
U9693034	彭湘華	xiang
U9693035	翁君儀	jun
U9693036	吳姵儀	pei
U9693037	李明濬	ming
U9693038	賴逸平	yi
U9693039	陳姵穎	pei
U9693040	池采逸	cai
U9693041	李欣蔓	xin
U9693042	陳柔妤	rou
U9693043	盧蕙芳	hui
U9693044	彭希柔	xi
U9693045	林怡君	yi
U9693046	蔡逸璇	yi
U9693047	張舒涵	shu
U9693048	林琇瑩	xiu
U9693050	黃昱傑	yu
U9693052	中山成華	cheng
U9693053	張綺玲	qi
U9693054	陳偉生	wei
U9693055	羅文聰	wen
N9561713	袁敏萱	min
N9561725	吳凱婷	kai
N9561741	林麗佳	li
N9561759	古嘉珮	jia
N9561761	林家伶	jia
N9561764	郭政勳	zheng
CLA0013

$leaguefile = LoadFile "/home/drbean/class/FLA0015/league.yaml";
push @{$players->{FLA0015}}, map {[ $_->{id}, $_->{Chinese}, $_->{password} ]}
				@{$leaguefile->{member}};

push @{$players->{FLB0002}}, [split] for <<FLB0002 =~ m/^.*$/gm;
N9361738 江映霖	ying
N9361749 覃少穎	shao
N9361750 曾思萍	si
N9461708 張佩玲	pei
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

$leaguefile = LoadFile "/home/drbean/class/MIA0012/league.yaml";
push @{$players->{MIA0012}}, map {[ $_->{id}, $_->{Chinese}, $_->{password} ]}
				@{$leaguefile->{member}};

push @{$players->{access}}, [split] for <<ACCESS =~ m/^.*$/gm;
U9424017	黃季雯	Ji
U9424014	莊詠竹	Yong
U9621048	劉志偉	Zhi
U9511049	黃湛明	Zhan
U9717047	陳YuanWen  YU
P220513110	程小芳	Xiao
U9734022	廖子瑜	Zi
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
