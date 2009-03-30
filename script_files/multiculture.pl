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

no strict qw/subs refs/;
my $connect_info = "${::name}::Model::DB"->config->{connect_info};
# my $connect_info = [ 'dbi:SQLite:db/demo','','' ];
my $schema = "${::name}::Schema"->connect( @$connect_info );
use strict;

my $texts = [
	[ qw(id description genre content unclozeables) ],
	[
        "nyc",
        "New York City multiculturalism",
	"intercultural",
        "BBC: Let's return now to Leonard Lopate at WNYC.

Lopate: And you know, Madelika, the ... just our daily experience, uh, is a revelation when you think about diversity. My haircutter is from Morocco. My building superintendent is from Albania. My cab driver last night was from the Cote d'Ivoire.

And, uh, we have uh, a call to Shan Con. Shan, uh, what's it like being a hyphenated American in New York?

Shan, are you there?

Shan: Hi, yeh. Uh, actually I'm half Pakistani, half Irish. which is a combination I think you can only find in New York City.

Lopate: And what is your experience in New York? Why would you call New York the most diverse city in the world?

Shan: Well, you know, just where I am, where I live in Brooklyn, on my block, we have a Ukrainian-run laundromat, a Korean-run Tex-Mex restaurant, and a pizzeria owned and operated by a Latino family.

I mean, if I need a dose of diversity, all I need to do is open my bedroom window, and the smell just wafts right in.


",
"BBC|Leonard|Lopate|Madelika|Morocco|Albania|Cote d'Ivoire|Shan|Con|Pakistani|Irish|Brooklyn|Ukrainian|Korean|Tex-Mex|pizzeria|Latino|dose|wafts"
	],
	
	[
        "swiss",
        "Multilingualism in Switzerland",
	"intercultural",
        "10:47 Andrea: But, um, all right, why we are here today. Because I know that, uh, you are into this multi-language, or .. How can we call it?
10:55 Stephanie: Multi-, multi-, multi-lingual stuff.
10:58 Andrea: All right.
10:59 Stephanie: Languages on the Internet, mixing languages.
11:01 Andrea: Now for example. I'm living and working in Finland.
11:06 Stephanie: Yes.
11:06 Andrea: And you see there are people XXX XXX Finnish, but also Swedish. So we have two languages in the same country. You come from Switzerland. There you have actually, three official ...
11:16 Stephanie: Well, what's interesting is uh .. So Finland has one official language.
11:20 Andrea: Yes, that's Finnish.
11:21 Stephanie: Which is Finnish. Yes, but so, because, there's one interesting thing, is that often you have more, um.. If the community is labeled as multi-lingual, people are often less multi-lingual in the community. So, so, take Switzerland. Switzerland has got four linguistic regions, okay. French, German, Italian and Romansh. But that doesn't mean that everybody in Switzerland speaks those four languages. The reason the country is multilingual and needs more than one official language is that people usually speak one of the four.
11:59 Andrea: Yeh.
11:59 Stephanie: Okay? Then, culturally, we are encouraged to learn other languages so we become multilingual. But if you have a community where everybody speaks two languages, then you can choose one as the official one.
12:11 Andrea: But now, how do you see this, you know, on the Web. Where for example, we have, er, a blog. ....

",
"Andrea|Stephanie|Finland|XXX|Finnish|Swedish|Switzerland|French|German|Italian|Romansh|Web|blog"
	],
	
	[
        "bilingual",
        "Bilingual Education",
	"intercultural",
        "Jennifer Low: As graduates of the first Ethnic Studies classes returned to work in their communities, they found cultural training and sensitivity lacking in public schools.

Immigrant students, arriving through the Immigration Act of 1965, were often expected to quickly assimilate and learn in English-Only classrooms. 

Educators, lawyers and activists, trained during the Third World Student Strike, wanted to ensure that these students would be taught to value their cultural heritage and their primary languages.

The legal struggle for bilingual education began in the schools of San Francisco's Chinatown and would culminate in the US Supreme Court in 1974.

Anita Lau: If you look at the whole history of bilingual education, or education to serve the English, the English learning in general. And I think that, you know, if uh.. you know we cannot talk about without mentioning about the law case XXX in 1974, which you know, was named the Lau versus Nichols.

",
"Jennifer Low|Ethnic Studies|Immigration Act|lawyers|activists|Third World Student Strike|heritage|primary|legal struggle|San Francisco|culminate|US Supreme Court|Lau versus Nichols"
	],
	];
	
uptodatepopulate( 'Text', $texts );

my $questions = [
			[ qw/genre text id content answer/ ],

[ "intercultural", "nyc", 1, "Shan Con likes being in New York, one of the most diverse cities in the world.", "True" ],
[ "intercultural", "nyc", 2, "Shan Con is from New York City, but he is half-Pakistani, half-Irish.", "True" ],
[ "intercultural", "nyc", 3, "Lopate's haircutter, building superintendent and cab driver are all not from New York.", "True" ],
[ "intercultural", "nyc", 4, "Lopate is a hyphenated American and Shan Con is not a hyphenated American.", "False" ],
[ "intercultural", "nyc", 5, "On the block in Brooklyn where Shan Con lives, there is a laundromat run by Moroccans.", "False" ],
[ "intercultural", "nyc", 6, "The smell in Shan Con's bedroom is bad, because of the Ukrainian, Korean and Latino combination.", "False" ],

[ "intercultural", "swiss", 1, "There are four official languages in Switzerland, but most people only speak one of those languages.", "True" ],
[ "intercultural", "swiss", 2, "In Finland, the official language is Finnish, but some people speak Swedish.", "True" ],
[ "intercultural", "swiss", 3, "Finland and Switzerland are different. There is more than one official language in Switzerland.", "True" ],
[ "intercultural", "swiss", 4, "Stephanie says that multilingual communities always have people who speak more than one language.", "False" ],
[ "intercultural", "swiss", 5, "There are three official languages in Switzerland: French, German, and Swiss.", "False" ],
[ "intercultural", "swiss", 6, "In both Switzerland and Finland, one language is the dominant language.", "False" ],

[ "intercultural", "bilingual", 1, "Immigrant children were expected to learn English very quickly.", "True" ],
[ "intercultural", "bilingual", 2, "Educators found schools would not teach the primary language.", "True" ],
[ "intercultural", "bilingual", 3, "Bilingual education in the US began in San Francisco's Chinatown.", "True" ],
[ "intercultural", "bilingual", 4, "Activists in the Lau versus Nichols law case didn't want bilingual education in schools .", "False" ],
[ "intercultural", "bilingual", 5, "The US Supreme Court struggled to get bilingual education into schools in 1974.", "False" ],
[ "intercultural", "bilingual", 6, "Activists in the Student Strike wanted bilingual students to assimilate quickly.", "False" ],

	];

uptodatepopulate( 'Question', $questions );

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

studentlife.pl - Set up dic db

=head1 SYNOPSIS

perl studentlife.pl

=head1 DESCRIPTION

'CREATE TABLE texts (id text, description text, genre text, content text, unclozeables text, primary key (id))'

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
