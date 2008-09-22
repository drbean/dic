#!perl

use strict;
use warnings;
use lib 'lib';

use Config::General;

BEGIN {
	my @MyAppConf = glob( '*.conf' );
	die "Which of @MyAppConf is the configuration file?"
				unless @MyAppConf == 1;
	my %config = Config::General->new($MyAppConf[0])->getall;
	$::name = $config{name};
	require "$::name.pm"; $::name->import;
	require "$::name/Schema.pm"; $::name->import;
}

my @leagues = qw/access GL CLA FLA0005 FLA0018 visitors/;

no strict qw/subs refs/;
my $connect_info = "${::name}::Model::DB"->config->{connect_info};
# my $connect_info = [ 'dbi:SQLite:db/demo','','' ];
my $schema = "${::name}::Schema"->connect( @$connect_info );
use strict;

$schema->deploy;

my $leagues = [
		[ qw/id name field/ ],
		[ "GL", "日語文共同學制虛擬班二", "初中級英文聽說訓練" ],
		[ "CLA", "日華文大學二甲", "英文聽力及會話" ],
		[ "FLA0005", "夜應外大學三甲", "跨文化溝通" ],
		[ "FLA0018", "夜應外大學二甲", "英語會話(一)" ],
		[ "access", "英語自學室", "Student Life, Moon Festival" ],
		[ "visitors", "Visitors", "Demonstration Play" ],
	];
$schema->populate( 'League', $leagues );

my $leaguegenres = [
			[ qw/league genre/ ],
			[ "GL",	"JUST RIGHT" ],
			[ "CLA",	"日華文大學二甲" ],
			[ "FLA0005",	"夜應外大學三甲" ],
			[ "FLA0018",	"夜應外大學二甲" ],
			[ "access",	"thematic" ],
			[ 'visitors',	"demo" ],
		];
$schema->populate( 'Leaguegenre', $leaguegenres );

my $players;

push @{$players->{GL}}, [split] for <<GL0036 =~ m/^.*$/gm;
9633203	周怡慧	Yi
9633206	游宜蓉	Yi
U9413029	陳筱蘋	Xiao
U9523028	丁維遵	Wei
U9593050	焦紹茹	Shao
U9621113	陳昆宏	Kun
U9621114	劉昱汝	YU
U9623005	林承賢	Cheng
U9623007	薛峻凱	JUn
U9624009	邱于哲	YU
U9624034	陳志屏	Zhi
U9624046	薛欣亞	Xin
U9634043	陳則安	Ze
U9714005	張宇涵	YU
U9721010	林文聲	Wen
U9743019	游智閎	Zhi
U9743028	江秉鈞	Bing
GL00036

push @{$players->{GL}}, [split] for <<GL =~ m/^.*$/gm;
M9723009	張耀仁	Yao
U9216005	張復嘉	Fu
9311248	林福星	Fu
9413243	李育函	YU
9413249	賴春甫	Chun
9413250	紀哲民	Zhe
9422301	郭清厚	Qing
9431219	邱莉潔	Li
9431234	江梅玲	Mei
9611202	張煒騰	Wei
9611292	余沛錡	Pei
9616224	宋甘麒	Gan
9616229	蔡莉婷	Li
9616242	林季甫	Ji
T9716005	林艷虹	Yan
T9716044	江佩茹	Pei
T9716050	陳芯俞	Xin
U9422076	顏浚原	JUn
U9422103	陳紀榮	Ji
U9424002	伍孟儒	Meng
U9433028	施伯融	Bo
U9516051	廖川頤	Chuan
U9516059	李育函	YU
U9516060	林育安	YU
U9622077	黃湘淳	Xiang
U9622086	施雅文	Ya
U9622111	張閔淑	Min
U9631019	陳曉萱	Xiao
U9631025	孫蔓萍	Man
U9721010	林文聲	Wen
U9413029	陳筱復	Xiao
M9723021	簡秀金	Xiu
U9623007	薛峻凱	JUn
U9523028	丁維遵	Wei
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

push @{$players->{officials}}, [split] for <<OFFICIALS =~ m/^.*$/gm;
193001	DrBean	ok
OFFICIALS

my %players;
foreach my $league ( 'officials', @leagues )
{
	next unless $players->{$league} and ref $players->{$league} eq "ARRAY";
	my @players = @{$players->{$league}};
	foreach ( @players )
	{
		$players{$_->[0]} = [ $_->[0], $_->[1], $_->[2] ];
	}
}
my $playerpopulator = [ [ qw/id name password/ ], values %players ];
$schema->populate( 'Player', $playerpopulator );

my (%members, %rolebearers);
foreach my $league ( @leagues )
{
	next unless $players->{$league} and ref $players->{$league} eq "ARRAY";
	my @players = @{$players->{$league}};
	foreach my $player ( @players )
	{
		$members{$player->[0]} =  [ $league, $player->[0] ];
		$rolebearers{$player->[0]} =  [ $player->[0], 2 ];
	}
}
$schema->populate( 'Member', [ [ qw/league player/ ], values %members ] );

$schema->populate( 'Role', [ [ qw/id role/ ], 
[ 1, "official" ],
[ 2, "player" ] ] );

$schema->populate( 'Rolebearer', [ [ qw/player role/ ], 
				[ 193001, 1 ], values %rolebearers ] );

=head1 NAME

deploy.pl - Set up db

=head1 SYNOPSIS

perl script_files/deploy.pl

=head1 DESCRIPTION

'CREATE TABLE players (id text, name text, password text, primary key (id))'

=head1 AUTHOR

Dr Bean, C<drbean at (@) cpan dot, yes a dot, org>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

