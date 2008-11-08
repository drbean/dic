#!perl

use strict;
use warnings;
use lib 'lib';

use Config::General;
use Cwd;
use File::Spec;

BEGIN {
	my @MyAppConf = glob( '*.conf' );
	die "Which of @MyAppConf is the configuration file?"
				unless @MyAppConf == 1;
	my %config = Config::General->new($MyAppConf[0])->getall;
	$::name = $config{name};
	require "$::name.pm"; $::name->import;
	require "$::name/Schema.pm"; $::name->import;
}

my @leagueids = qw/access GL00032 GL00037 GL00036 GL00040 GL00042 CLA FLA0005 FLA0018 visitors/;
my $dir = ( File::Spec->splitdir(getcwd) )[-1];
@leagueids = grep m/$dir/, @leagueids;

no strict qw/subs refs/;
my $connect_info = "${::name}::Model::DB"->config->{connect_info};
# my $connect_info = [ 'dbi:SQLite:db/demo','','' ];
my $schema = "${::name}::Schema"->connect( @$connect_info );
use strict;

my $leagues = [
		[ qw/id name field/ ],
	[ "GL00032", "GL00032日語文共同學制虛擬班二", "初級英文聽說訓練" ],
	[ "GL00037", "GL00037日語文共同學制虛擬班二", "初級英文聽說訓練" ],
	[ "GL00036", "GL00036日語文共同學制虛擬班二", "中級英文聽說訓練" ],
	[ "GL00040", "GL00040日語文共同學制虛擬班二", "中級英文聽說訓練" ],
	[ "GL00042", "GL00042日語文共同學制虛擬班二", "中級英文聽說訓練" ],
		[ "CLA", "日華文大學二甲", "英文聽力及會話" ],
		[ "FLA0005", "夜應外大學三甲", "跨文化溝通" ],
		[ "FLA0018", "夜應外大學二甲", "英語會話(一)" ],
		[ "access", "英語自學室", "Listening" ],
		[ "visitors", "Visitors", "Demonstration Play" ],
	];
$schema->populate( 'League', $leagues );

my $leaguegenres = [
			[ qw/league genre/ ],
			[ "GL00032",	"elementary" ],
			[ "GL00037",	"elementary" ],
			[ "GL00036",	"intermediate" ],
			[ "GL00040",	"intermediate" ],
			[ "GL00042",	"intermediate" ],
			[ "CLA",	"elementary" ],
			[ "FLA0005",	"interculture" ],
			[ "FLA0018",	"intermediate" ],
			[ "access",	"all" ],
			[ 'visitors',	"demo" ],
		];
$schema->populate( 'Leaguegenre', $leaguegenres );

my $players;

push @{$players->{GL00036}}, [split] for <<GL00036 =~ m/^.*$/gm;
9633203	周怡慧	Yi
9633206	游宜蓉	Yi
U9413029	陳筱蘋	Xiao
U9523028	丁維遵	Wei
U9621113	陳昆宏	Kun
U9621114	劉昱汝	YU
U9623005	林承賢	Cheng
U9623007	薛峻凱	JUn
U9624009	邱于哲	YU
U9624034	陳志屏	Zhi
U9624046	薛欣亞	Xin
U9634043	陳則安	Ze
U9714005	張宇涵	YU
U9721007	丁信源	Xin
U9721010	林文聲	Wen
U9721024	邱元弘	YUan
U9721028	李智凱	Zhi
U9743019	游智閎	Zhi
U9743028	江秉鈞	Bing
U9731020	陳彥兆	Yan
GL00036

push @{$players->{GL00032}}, [split] for <<GL00032 =~ m/^.*$/gm;
9531202	彭奕達	Yi
9531206	莊君緌	JUn
9533202	蔡奇融	Qi
9533203	黃偉珉	Wei
9533214	周立夫	Li
9533216	羅心伶	Xin
9533220	許雅菱	Ya
9533224	簡均玲	JUn
9533227	鄭鈺姮	YU
9533244	張瑋真	Wei
9533246	林孟潔	Meng
T9711003	余吉承	Ji
T9721106	徐弘彥	Hong
U9414040	黃怡菁	Yi	
U9424031	白睿中	Rui
U9513044	林憶伶	Yi
U9616010	陳鴻品	Hong
U9616018	李洵	XUn
U9631006	陳新慶	Xin
U9631008	廖峻凱	JUn
U9716011	陳奕銘	Yi
U9716053	李芩芳	Qin
GL00032

push @{$players->{GL00040}}, [split] for <<GL00040 =~ m/^.*$/gm;
9411298	鄭又綸	You
9433237	吳佳馨	Jia
U9411082	趙巡漢	XUn
U9416008	吳國彬	Guo
U9417029	李家銘	Jia
U9417039	李怡瑩	Yi
U9423044	江全緒	QUan
U9433002	李統一	Tong
U9462038	黃琦涵	Qi
U9533047	溫立欣	Li
U9631044	林羽辰	YU
U9631050	吳曼榕	Man
U9718023	陳家音	Jia
U9722113	潘志良	Zhi
U9722122	藍嘉祥	Jia
U9722129	何宗承	Zong
GL00040

push @{$players->{GL00037}}, [split] for <<GL00037 =~ m/^.*$/gm;
9413249	賴春甫	Chun
9413250	紀哲民	Zhe
9431219	邱莉潔	Li
9431234	江梅玲	Mei
9611202	張煒騰	Wei
9613212	李美樺	Mei
9613262	薛偉凡	Wei
9616210	黃慧瑜	Hui
9616242	林季甫	Ji
T9716005	林艷虹	Yan
T9716050	陳芯俞	Xin
U9422076	顏浚原	JUn
U9422103	陳紀榮	Ji
U9424002	伍孟儒	Ming
U9433028	施伯融	Bo
U9516051	廖川頤	Chuan
U9516059	李育函	YU
U9516060	林育安	YU
U9622055	高健紘	Jian
U9714127	謝妙宜	Mia
U9714131	黃世慈	Shi
U9721147	陳顧文	Gu
U9721149	葉啟倫	Qi
GL00037

push @{$players->{GL00042}}, [split] for <<GL00042 =~ m/^.*$/gm;
9631251	紀旻岱	Min
U9316016	黃慧?	Hui
U9414001	黃采薇	Cai
U9418023	廖婉如	Wan
U9514074	邱秀穎	Xiu
U9524011	卓峻瑋	JUn
U9524018	楊欣蓓	Xin
U9533015	池易昌	Yi
U9533016	郭蓮瑩	Lian
U9593021	曾淑玲	Shu
U9593034	伍麗儒	Li
U9611090	劉志隆	Zhi
U9613047	林俊男	JUn
U9618029	余恆安	Heng
U9621086	王彥棋	Yan
U9621087	蔡豐任	Feng
U9722104	鄭龍家	Long
U9722108	王嘉俊	Jia
U9722110	鄭煜叡	YU
GL00042

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
N9561764	郭政勳	Zheng
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

push @{$players->{FLA0018}}, [split] for <<FLA0018 =~ m/^.*$/gm;
N9361748	徐銘鴻	Ming
N9461734	張雅臻	Ya
N9461736	彭珠蓮	Zhu
N9461738	劉佳佳	Jia
N9461753	葉又寧	You
N9461756	許芷菱	Zhi
N9532037	邱錦玉	Jin
N9561721	劉芳君	Fang
N9561737	唐淑芬	Shu
N9561766	劉發州	Fa
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
N9661717	黃路加	Lu
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
N9661741	林妤容	YU
N9661742	吳筱涵	Xiao
N9661743	羅惠娟	Hui
N9661744	劉惠蓉	Hui
N9661745	吳桂麗	Gui
N9661746	吳書儀	Shu
N9661747	邱靖棋	Jing
N9661748	楊妙雲	Miao
N9661750	王育祥	YU
U9533039	蕭郁玲	YU
FLA0018

push @{$players->{access}}, [split] for <<ACCESS =~ m/^.*$/gm;
U9424017	黃季雯	Ji
U9424014	莊詠竹	Yong
U9621048	劉志偉	Zhi
U9511049	黃湛明	Zhan
ACCESS

push @{$players->{visitors}}, [split] for <<VISITORS =~ m/^.*$/gm;
1        guest 1
VISITORS

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
$schema->populate( 'Player', $playerpopulator );

my (@members, %rolebearers);
foreach my $league ( @leagueids )
{
	next unless $players->{$league} and ref $players->{$league} eq "ARRAY";
	my @players = @{$players->{$league}};
	foreach my $player ( @players )
	{
		push @members,  [ $league, $player->[0] ];
		$rolebearers{$player->[0]} =  [ $player->[0], 2 ];
	}
}
$schema->populate( 'Member', [ [ qw/league player/ ], @members ] );

$schema->populate( 'Role', [ [ qw/id role/ ], 
[ 1, "official" ],
[ 2, "player" ] ] );

$schema->populate( 'Rolebearer', [ [ qw/player role/ ], 
				[ 193001, 1 ],
				values %rolebearers ] );

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
