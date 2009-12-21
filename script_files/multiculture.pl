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
	
	[
        "immigration",
        "Anti-Immigration Group Strong",
	"intercultural",
        "00:49 Dan Stein: I thought it would be good for Julie to tell us a little about what's going on and what Senator Durbin is doing in response to the overwhelming outpouring of calls, faxes and emails that are coming from the American people. How are you doing?
01:01 Julie Kirchner: Hi, Dan. I'm doing just fine, thank you. 
01:03 Dan Stein: Hi, what's going on?
01:05 Julie Kirchner: Well, we've seen a new development happen today. Um, Senator Durbin, apparently has been under a lot of pressure. Your phone calls have made a huge difference. We hear from offices they're getting thousands and thousands and thousands of calls. And overwhelmingly, these calls are opposed to the DREAM Act.

And what's happened today is Senator Durbin has introduced a new amendment. He's redrafted the DREAM Act amendment. And he clearly is retreating. He knows he's having trouble getting support. And he's cutting out bits and pieces. He's trying to, you know, tweak the language a little bit to make it look better in order to get more people to sign on. 

01:43 Dan Stein: Basically you're saying the calls and faxes and ... are working.
01:45 Julie Kirchner: Oh, they're absolutely working.
01:47 Dan STein: He's hitting a wall of opposition. 
01:50 Julie Kirchner: Oh, yeh, absolutely. We had a call from a senator's office today, a staffer who said, uh, FAIR, you need to know that we're a definite No, because our office is getting inundated. Please stop them from calling. 
02:01 Dan Stein: The people need to keep it up, right?
02:02 Julie Kirchner: They need to keep it up. The ... Everyone needs pressure. And, and you need to tell your senators that you will not be fooled by drafts and redrafts and tinkering. It's still the DREAM Act. It's still an amnesty. And we can't be rewarding um, illegal activity.

",
"Dan Stein|Julie Kirchner|Senator Durbin|overwhelming|outpouring|DREAM Act|amendment|redrafted|tweak|sign on|FAIR|definite|inundated|pressure|drafts|tinkering|amnesty|rewarding|illegal activity"
	],
	
	[
        "shock1",
        "What is culture shock?",
	"intercultural",
        "Moving on to our topic of the week. What is culture shock? XXXX

I used a couple of sources, as you'll see in the show notes.

Um, I like some of the things that are discussed here:

It's the impact of moving from a familiar culture to an unfamiliar one.

Or, it's the anxiety that results from losing all familiar sounds and symbols of social intercourse.

Uh, it describes the anxiety and feelings of surprise, disorientation, confusion, et cetera, felt when people move to operate, and when people have to operate within an, an entirely different cultural or social environment, such as a different cult.. country.

Kalvero Oberg was the.. is commonly credited with, with coining the phrase, culture shock. He wrote in 1958 about culture shock. And he found that it is almost like a disease. It has a cause. It has symptoms, and it has a cure.

The main idea, or, or my take on culture shock is, basically, that you move from one culture, or one environment to a new environment. Some people say, it's like that when you move from one state to another state in the USA, or from one province to another province.

",
"XXXX|sources|show notes|impact|familiar|sounds|symbols|social intercourse|disorientation|operate|Kalvero Oberg|credited|coining the phrase|symptoms|cure|take|province"
	],
	
	[
        "shock2",
        "What is culture shock? (Part 2)",
	"intercultural",
        "Mostly, I'm talking about culture shock moving from one country to a new country. And you lose all your social cue, cues. All the ideas you had, ways of interacting with people.

Even if the, the language is the same, there's, there's different body language. There's different values and norms and different ways of doing things. Even things that might seem the same are different. Hand gestures are different. And some countries, you might, er, use one very, er, vulgar hand sign and in another country it might be acceptable, or a way of greeting, or saying good luck famously. 

So, there's a lot of different things that contribute to it, but it's basically the idea that, and I've had this before (I've traveled extensively). And I've had this before: When you arrive in a new country and you initially, it's cool, or whatever. But after a while, you get struck by feelings of depression and loneliness, or whatever.

And it's that, you're taken out of your own environment, out of where you are safe, and you feel .. safe, and uh, uh, uh, secure, basically. And now suddenly, you're, you're ... the ground has been taken from underneath you. 

You don't know how to, how things work necessarily. You don't know where to ...

",
"cue|norms|vulgar|famously|contribute|extensively"
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

[ "intercultural", "immigration", 1, "A lot of people opposed to illegal immigrants called senators in Washington.", "True" ],
[ "intercultural", "immigration", 2, "FAIR doesn't want the DREAM Act to be introduced.", "True" ],
[ "intercultural", "immigration", 3, "The phone calls made some senators retreat from support for the DREAM Act", "True" ],
[ "intercultural", "immigration", 4, "FAIR is unhappy that many people are calling senators' offices.", "False" ],
[ "intercultural", "immigration", 5, "Senator Durbin had been under pressure, but he is not under pressure today.", "False" ],
[ "intercultural", "immigration", 6, "The phone calls did not put pressure on Senator Durbin to make the DREAM Act look better.", "False" ],

[ "intercultural", "shock1", 1, "Culture shock is feelings of surprise when moving to a new environment.", "True" ],
[ "intercultural", "shock1", 2, "When you move to a new environment, the unfamiliar is a shock.", "True" ],
[ "intercultural", "shock1", 3, "Oberg's take on culture shock was it is almost a disease.", "True" ],
[ "intercultural", "shock1", 4, "Culture shock is not like the feelings felt when you move from one state to another.", "False" ],
[ "intercultural", "shock1", 5, "Oberg's main idea was that there is no cure for culture shock.", "False" ],
[ "intercultural", "shock1", 6, "The impact of moving from one culture to another is differnt from culture shock.", "False" ],

[ "intercultural", "shock2", 1, "Hand gestures that might seem the same are different.", "True" ],
[ "intercultural", "shock2", 2, "When you travel, if there's different language, it might be a shock.", "True" ],
[ "intercultural", "shock2", 3, "When you're taken out of a safe, secure environment, the new country might after a while depress you.", "True" ],
[ "intercultural", "shock2", 4, "Even if you don't know how things work, interacting with people is cool, or the same.", "False" ],
[ "intercultural", "shock2", 5, "Even if the language is different, the body language and hand gestures are the same in different countries.", "False" ],
[ "intercultural", "shock2", 6, "When you move to a new environment, initially you feel depression, but after a while, it is cool.", "False" ],

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
