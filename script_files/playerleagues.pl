#!perl

use strict;
use warnings;
use lib 'lib';

use Config::General;
use Cwd;
use File::Spec;
use List::MoreUtils qw/all/;

BEGIN {
	my @MyAppConf = glob( '*.conf' );
	die "Which of @MyAppConf is the configuration file?"
				unless @MyAppConf == 1;
	my %config = Config::General->new($MyAppConf[0])->getall;
	$::name = $config{name};
	require "$::name.pm"; $::name->import;
	require "$::name/Schema.pm"; $::name->import;
}

my @leagueids = qw/GL00003 GL00022 CLA FLA0015 access visitors/;
my $dir = ( File::Spec->splitdir(getcwd) )[-1];
$dir = qr/^(GL000|CLA|FLA)/ if $dir eq 'dic';
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
		[ "CLA", "日華文大學二甲", "英文聽力及會話" ],
		[ "FLA0015", "夜應外大學二甲", "英語會話(二)" ],
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
			[ "CLA",	"elementary" ],
			[ "FLA0015",	"intermediate" ],
			[ "access",	"all" ],
			[ 'visitors',	"demo" ],
			[ 'dic',	"all" ],
		];
uptodatepopulate( 'Leaguegenre', $leaguegenres );

my $players;

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
GL00022

push @{$players->{GL00031}}, [split] for <<GL00031 =~ m/^.*$/gm;
GL00031

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

push @{$players->{FLA0015}}, [split] for <<FLA0015 =~ m/^.*$/gm;
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
FLA0015

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
[ 2, "player" ] ] );

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
