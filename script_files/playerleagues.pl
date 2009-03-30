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

my @leagueids = qw/GL00003 GL00022 CLA0013 FLA0015 MIA0012 access visitors/;
my $dir = ( File::Spec->splitdir(getcwd) )[-1];
$dir = qr/^(GL000|CLA|FLA|MIA)/ if $dir eq 'dic';
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
		[ "CLA0013", "日華文大學二甲", "英文聽力及會話" ],
		[ "FLA0015", "夜應外大學二甲", "英語會話(二)" ],
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
			[ "CLA0013",	"elementary" ],
			[ "FLA0015",	"intermediate" ],
			[ "MIA0012",	"business" ],
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
U9693023	吳馨宜	Xin
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
[ 2, "player" ],
[ 3, "playerA" ],
[ 4, "playerB" ],
[ 5, "playerC" ],
[ 6, "playerD" ] ] );

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
