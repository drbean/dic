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
        "smiths",
        "Jo Smith and Joe Smith",
	"elementary",
        "Just Right Elementary Student's Book. American Edition, by Carol Lethaby, Ana Acevedo and Jeremy Harmer. Copyright Marshall Cavendish, Limited, 2007.

Track 1:

1.  My name is Jo Smith. I'm a dentist. I'm from Argentina. I have one brother, Alberto. He and his wife Patty have one son, Paco. My husband, Peter, is English. We have two sons, Freddy, twelve, and Ricky, eight, and a baby daughter, Monica, eighteen months old.

2. I'm Joe Smith and I'm thirty-eight. I'm an architect. My father is from Scotland and my mother is from Jamaica, in the Caribbean. I'm American. I'm an only child. My wife, Sandra, is a teacher. We have two daughters: Alice, twelve and Neisha, six. We also have a son, Barry, fourteen months old. We live in California.

",
"Carol|Lethaby|Ana|Acevedo|Jeremy|Harmer|Smith|Argentina|Alberto|Patty|Paco|Peter|Freddy|Ricky|Monica|Jamaica|Caribbean|Sandra|Alice|Neisha|Barry|California|Marshall|Cavendish"
	],
	
	[
        "pilot",
        "A life in the sky",
	"elementary",
        "Pilots have interesting lives. They visit many places and meet many people. But is it an easy job? Alan Alder is a pilot. He usually flies from LA to London on Tuesdays. He gets up at five am and he arrives at the airport at six am His flight is at eight o'clock. Eleven hours later he's in London. It is six am in London. Normally, he doesn't go out on the first day. He relaxes: he plays golf, he watches TV and goes to bed early. On Friday, he flies back to LA. Does he like his job? \"It's very hard work,\" he says. \"But the money is good and I have good vacations. Life in the sky is great!\"

",
"Pilots|Alan|Alder"
	],
	
	[
        "postcard",
        "A cool place",
	"elementary",
       "Dear Ed,

I'm writing this postcard at my desk at the office with a sandwich in my hand. I'm learning a lot about the company but I don't have time for any fun! San Jose is cool. Wish you were here!

Paula


Hi!

This place is fun! I'm sitting in the sun, watching the sea and having a delicious Mexican meal. And I'm thinking of you!

Take care!

Steve

",
"San Jose|Mexican|Steve|Paula"
	],
	
	[
        "mobile",
        "Phonewiz",
	"elementary",
       "Nicole is a busy person. She works for a magazine. She writes articles about fashion. She has important meetings every day.

Today, Nicole is in bed with a cold. So, is she just having a rest? No, she's working. She's writing a new article. She's making phone calls, texting people, sending emails and choosing photos on the Internet--all from her comfortable bed.

And she's even listening to music, too!

With Phonewhiz you are always in contact.

Phonewhiz--because life doesn't stop when you are not in the office.

",
"Nicole|Phonewhiz|texting|articles"
	],
	
	[
        "rent1",
        "Renting",
	"elementary",
       "One. Great apartment on the sixth floor. Large kitchen, small dining room, living room, four bedrooms and three bathrooms. Deck. Only three thousand five hundred dollars per month. No pets. Call (217) 364-728 to see it.
       Two. Large house in the country for rent. Four bedrooms, two bathrooms, large dining room, large kitchen. Perfect for a family. Two thousand five hundred dollars per month. Get keys from J. Beal Office, 9:00am to 5:00pm.

",
"Deck|pets|keys|J. Beal Office"
	],
	
	[
        "rent2",
        "Renting (Part2)",
	"elementary",
       "Three. For rent: small house downtown--two bedrooms, kitchen, living room/dining room, bathroom. Near the stores. One thousand five hundred dollars per week. Write to rent\@accomodation.net for appointment.

Four. Apartment for rent: Two hundred dollars per week for one bedroom, perfect for a couple. Small kitchen, living room/dining room, bathroom. Near transportation. Call (0510) 463-849.

",
""
	],
	
	[
        "family1",
        "A football fan",
	"elementary",
       "Meet Larry Frazier. He's twenty-eight years old, from Oakland, and he's a taxi driver. His hobby is football and he loves the Oakland Raiders. He always goes to the games at the Oakland Coliseum.

What about his family? \"He usually plays with us on Saturday, but he never spends Sunday with us,\" say his children, Eric (five) and Amanda (eight). HIs wife doesn't like football and she usually stays with the children when Larry is at the game.

Are Eric and Amanda football fans like their dad? No! They don't like football--they both love watching TV and doing puzzles."

",
""
	],

	[
        "destinations",
        "Orlando or Seattle?",
	"intermediate",
        "Sonia: So which is better, then, Fran? Orlando or Seattle?
Fran: Orlando, definitely. It's more relaxing, and it's cheaper! And it's got lovely beaches.
Sonia: But we always go to the beach. I'd rather do something different this year. Something more interesting. Like a city. Like Seattle.
Fran: There's a problem, then, Sonia.
Sonia: Oh, What's that?
Fran: Because I like beaches. Well, I like beaches better than cities, anyway. And Orlando is sunnier too. And it always rains in Seattle, you know, Sonia.
Sonia: No, it doesn't. And anyway, rain or no rain, there's more to do in Seattle.
Fran: Like what? Museums and things like that? I'd rather stay here in New York!
Sonia: Okay then. You go to the beach and I'll go to Seattle. How's that?
Fran: Oh, all right. You win. This time. But no museums and no walking around in the rain!

",
"Sonia|Fran|Orlando|Seattle"
	],
	
	[
        "stress",
        "Stress: the facts",
	"intermediate",
        "Do you ever feel that you don't know what to do because there are too many things in your life? Then you probably feel stress.

Things that cause stress are called \"stressors.\" One important stressor is change. For example, going to a new school or starting a new job can give you stress. Other common stressors are taking a test or being sick.

But some stress can be good. For example, before a race most athletes feel nervous. This stress helps them get ready.

What makes stress good or bad? Let's look at an example: Jack has a new job in another city. He and his wife are very excited. But their children are sad to leave their family and friends. The move to another city is a good stressor for the parents but a bad one for the children. The parents and the children have different feelings about the situation.

When you are feeling stressed, these tips can help you:

Eat lots of fruit and vegetables and meat and fish without fat. Salad is good too. Don't eat any snacks like potato chips, and don't drink any caffeine. Don't eat too much sugar. Put the chocolate and cakes away.

Do exercise every day. Laugh! Make time for fun.

Talk about your problems.

",
"stressor|athletes|caffeine"
	],
	
	[
        "recipe",
        "Perfect for new cooks",
	"intermediate",
        "Chef: Today's recipe is really easy--perfect for new cooks. First, get your ingredients ready--all the things you need, To start with, we need eggs of course.

Learner chef: Okay, how many?

Chef: Just a few. Six, I think. Okay? Then we need some butter. Just a little. About one ounce.

Learner chef: Okay. What's next?

Chef: Cheese, lots of it. About eight ounces. That's it. And finally, a little cream, just about, uh, two tablespoons? It's not much, but it really makes a difference.

Learner chef: What about salt?

Chef: No salt. The cheese is salty so you really don't need any extra salt. Okay, now we're ready to cook! Look at that. A perfect cheese omelette. All you need now is a salad: three or four tomatoes and lots of olive oil. Mmm, delicious!

",
"Chef|Learner chef|ounce|omelette"
	],

	[
        "media1",
        "The media--a bad influence? (Part 1)",
	"intermediate",
        "Kirsty is fifteen years old. She likes doing what every other girl her age enjoys. She goes to school, she watches TV, and goes shopping with her friends. But Kirsty has an ambition: She wants to be a model. Every week, she saves her allowance to buy magazines. She studies the photos of famous models. They are her role models.

Kirsty's mother, Stella, is not happy. \"It's okay to have ambitions,\", she says. But in Kirsty's case it's becoming an obsession. She thinks about it all the time.\" According to Stella, Kirsty does not have a healthy diet and she exercises more than normal because she wants to be thin. She worries that Kirsty is developing an eating disorder. \"The media are responsible for this situation,\" her mom says.

",
"Kirsty|Stella|ambition|obsession|disorder|media"
	],
	
	[
        "media2",
        "The media--a bad influence? (Part 2)",
	"intermediate",
        " \"The media are responsible for this situation,\" her mom says. \"All the teen magazines and teen programs on TV tell children that the only important thing is how you look--your appearance. They say, 'You want to be happy? Then be thin!'\"

Are the media really responsible for situations like Kirsty's? Kirsty's big sister Donna, 18, disagrees. \"I buy lots of magazines but I don't want to be like the people in them,\" says Donna. \"Magazines show you all kinds of people, not just celebrities. They give information and have nice pictures. That's why I like them.\"

So, who is right? Do the media decide how we look and how we live? Are we all becoming obsessed with celebrities and their lifestyles?

",
"Kirsty|Donna|celebrities|obsessed"
	],
	
	[
        "crocodile1",
        "The crocodile hunter (Part 1)",
	"intermediate",
        "Salvador, 26, is from Brazil. His favorite pet when he was little was a very big snake. He loves all kinds of reptiles. That's why Salvador is now a reptile expert, a herpetologist, or \"herp\" for short. But his favorite reptiles are crocodiles.

\"Crocodiles are great animals,\" says Salvador. \"They belong to a very old group of animals and they are almost the same as the days of the dinosaurs. They live over 100 years.\"

Salvador is working in Zambia, Africa. He's working with crocodiles. People call him a \"crocodile hunter,\" but he doesn't kill crocodiles. Some crocodiles live in popular swimming and fishing areas where tourists like to go and so, of course, they are a danger to people. Salvador catches them and moves them to safe places.

",
"Salvador|Brazil|snake|reptiles|herpetologist|herp|crocodiles|dinosaurs|Zambia|Africa"
	],
	
	[
        "crocodile2",
        "The crocodile hunter (Part 2)",
	"intermediate",
        "Sometimes people are a danger to crocodiles, especially young ones. People kill them for their skin to make very expensive leather,\" Salvador explains. He and his colleagues, the people he works with, are developing an educational program. They are teaching people about crocodiles and people are learning to respect them.

Salvador's hero is Steve Irwin, the famous Australian crocodile hunter. \"Steve's death was very sad,\" he says. \"He was a great guy and his work with reptiles was fantastic. I want to continue the kind of work he did.\"

So are you interested in reptiles? Are you looking for an exciting occupation. Then maybe you too can become a herpetologist.

",
"crocodiles|leather|Salvador|educational|colleagues|Steve|Irwin|Australian|fantastic|reptiles|herpetologist"
	],
	
	[
        "story1",
        "Strange Encounter (Part 1)",
	"intermediate",
        "When he came into the station, Ferdy looked down at all the people below him. Ah yes. There she was. Amelie. the beautiful Amelie, with her long black hair and her incredible blue, blue eyes. She was waiting for him.

Ferdy's eyes scanned the scene in front of him, and then he looked up. Above him, two men were working on the roof. He could see them through the glass. what were they doing there? Perhaps they were cleaning the glass. But perhaps they weren't.

He tried to act normally. He got onto the escalator and went down towards the platforms just like any other normal person. But that was the problem. He wasn't normal. He was different from other people.

Opposite him was the entrance to the platform--her platfrom. Amelie was standing under the number Seven. Perhaps everything was okay.

",
"Ferdy|Amelie|incredible|escalator|platforms"
	],
	
	[
        "story2",
        "Strange Encounter (Part 2)",
	"intermediate",
        "But then he saw two young women in yellow hard hats. They were standing by the coffee bar. He noticed something. They weren't talking or drinking coffee. They were watching everyone in the station, but when he looked at them, they looked away.

Suddently he heard a noise. Someone inside the ticket office was shouting into a cellphone. He turned his head. IT was an old man, and next to him was a woman. His wife? Nothing to worry about. But then the old man saw him. He stopped shouting. He took his cellphone from his ear. He just stared.

Platform 7 was in front of him now. Amelie saw him. She smiled.

Suddenly a woman walked between him and Amelie. She didn't look happy. Then he knew. He was in danger.

Ferdy looked behind him. There was no one. He turned around and ran back up the escalator and into the street. He heard Amelie call his name.

There were three men standing outside and they were waiting for him.

",
"Ferdy|Amelie|incredible|escalator|platforms|stared"
	]

	];

uptodatepopulate( 'Text', $texts );

my $questions = [
			[ qw/genre text id content answer/ ],

[ "elementary", "smiths", 1, "Freddy and Ricky's mother is a dentist.", "True" ],
[ "elementary", "smiths", 2, "The architect's sons and daughter are called Alice, Neisha and Barry.", "True" ],
[ "elementary", "smiths", 3, "The father of Barry's father is from Scotland and the mother of Barry's father is from the Caribbean.", "True" ],
[ "elementary", "smiths", 4, "The dentist is from Argentina and is married to a woman from the Caribbean.", "False" ],
[ "elementary", "smiths", 5, "Freddy, Ricky and Monica's mother is Alice, Neisha and Barry's father.", "False" ],
[ "elementary", "smiths", 6, "The woman whose husband is English has a name like the man whose father is from Scotland.", "True" ],

[ "elementary", "pilot", 1, "Alan flies to London on Tuesdays.", "True" ],
[ "elementary", "pilot", 2, "He gets up early on Tuesdays.", "True" ],
[ "elementary", "pilot", 3, "Alan's flight is at six o'clock", "False" ],
[ "elementary", "pilot", 4, "Alan goes out on Tuesday night.", "False" ],
[ "elementary", "pilot", 5, "Alan is in London for five days.", "False" ],
[ "elementary", "pilot", 6, "Pilots have an easy job.", "False" ],

[ "elementary", "postcard", 1, "Steve and Paula are both eating and writing.", "True" ],
[ "elementary", "postcard", 2, "Paula isn't having fun, but Steve is having fun.", "True" ],
[ "elementary", "postcard", 3, "Paula and Steve are both sitting in the sun.", "False" ],
[ "elementary", "postcard", 4, "Paula and Steve are both writing a postcard.", "True" ],
[ "elementary", "postcard", 5, "Paula and Steve are in Mexico.", "False" ],
[ "elementary", "postcard", 6, "Paula's job is easy and she has a lot of free time.", "False" ],

[ "elementary", "mobile", 1, "Nicole is in bed with a cold, and she is busy.", "True" ],
[ "elementary", "mobile", 2, "Nicole is not in the office. She is in contact with the office from her bed.", "True" ],
[ "elementary", "mobile", 3, "Because Nicole has a cold, she is not working today.", "False" ],
[ "elementary", "mobile", 4, "Nicole is working from her bed just today. Every other day she is in the office.", "True" ],
[ "elementary", "mobile", 5, "Nicole always has time to listen to music.", "False" ],
[ "elementary", "mobile", 6, "In her life, Nicole is not in contact with people .", "False" ],

[ "elementary", "rent1", 1, "The apartment has more bathrooms than the house in the country.", "True" ],
[ "elementary", "rent1", 2, "The apartment and the large house both have large kitchens.", "True" ],
[ "elementary", "rent1", 3, "The large house is more expensive than the apartment on the sixth floor.", "False" ],
[ "elementary", "rent1", 4, "The large house has a larger dining room than the apartment.", "True" ],
[ "elementary", "rent1", 5, "The large house is three thousand five hundred dollars per month.", "False" ],
[ "elementary", "rent1", 6, "The large house has more bedrooms than the apartment on the sixth floor.", "False" ],

[ "elementary", "rent2", 1, "The house downtown is perfect for going to the stores.", "True" ],
[ "elementary", "rent2", 2, "The apartment and the small house both have large kitchens.", "False" ],
[ "elementary", "rent2", 3, "The apartment is perfect for transportation.", "True" ],
[ "elementary", "rent2", 4, "The small house has a small kitchen. The apartment has a large kitchen.", "False" ],
[ "elementary", "rent2", 5, "The small house is one thousand five hundred dollars per week.", "True" ],
[ "elementary", "rent2", 6, "The small house has one bedroom. The apartment has two bedrooms.", "False" ],

[ "elementary", "family1", 1, "Larry is a football player.", "False" ],
[ "elementary", "family1", 2, "Larry likes football.", "True" ],
[ "elementary", "family1", 3, "Larry never goes to watch the Oakland Raiders.", "False" ],
[ "elementary", "family1", 4, "The Oakland Kickers play at the Oakland Coliseum.", "False" ],
[ "elementary", "family1", 5, "Larry never plays with his children.", "False" ],
[ "elementary", "family1", 6, "The children always spend Sunday with Larry.", "False" ],
[ "elementary", "family1", 7, "Liz likes football.", "False" ],
[ "elementary", "family1", 8, "Liz never goes to the football game with Larry.", "True" ],
[ "elementary", "family1", 9, "The children always stay home on Sunday.", "True" ],

[ "intermediate", "destinations", 1, "Fran'd rather go to the beach in Orlando and Sonia'd rather go to museums in Seattle.", "True" ],
[ "intermediate", "destinations", 2, "Orlando's sunnier, more relaxing and cheaper than Seattle. Seattle's rainier and not as cheap as Orlando.", "True" ],
[ "intermediate", "destinations", 3, "Fran and Sonia decide to go to different places.", "False" ],
[ "intermediate", "destinations", 4, "Fran doesn't like going to museums. She likes going to the beach.", "True" ],
[ "intermediate", "destinations", 5, "Fran'd rather stay in New York than go to the beach in Orlando.", "False" ],
[ "intermediate", "destinations", 6, "Sonia'd rather go to rainy Seattle than sunny Orlando.", "True" ],
[ "intermediate", "destinations", 7, "Sonia'd rather go to Seattle by herself than go to Orlando with Fran.", "True" ],

[ "intermediate", "stress", 1, "You feel stress if there is no change in your life.", "False" ],
[ "intermediate", "stress", 2, "Jack and his wife feel good about the move to the new city.", "True" ],
[ "intermediate", "stress", 3, "Stress is good if it helps you get ready for change.", "True" ],
[ "intermediate", "stress", 4, "Stress is bad if you have different feelings about the situation than your family.", "False" ],
[ "intermediate", "stress", 5, "Coffee is good if you are feeling stressed.", "False" ],
[ "intermediate", "stress", 6, "Chocolate is good for people who feel nervous. It helps them get ready.", "False" ],

[ "intermediate", "recipe", 1, "There is lots of olive oil in the omelette.", "False" ],
[ "intermediate", "recipe", 2, "There is no extra salt in the omelette, just the salt in the cheese.", "True" ],
[ "intermediate", "recipe", 3, "The recipe is not easy for new cooks. You need to be a perfect cook.", "False" ],
[ "intermediate", "recipe", 4, "There is a lot of cheese and a little butter and cream in the omelette.", "True" ],
[ "intermediate", "recipe", 5, "There a lot of tomatoes and a little olive oil in the salad.", "False" ],
[ "intermediate", "recipe", 6, "A little cream really makes a difference to the omelette.", "True" ],

[ "intermediate", "media1", 1, "Kirsty needs to diet because she does not have a healthy diet.", "False" ],
[ "intermediate", "media1", 2, "Kirsty's mother, Stella, does not want Kirsty to think about becoming a model all the time.", "True" ],
[ "intermediate", "media1", 3, "Kirsty exercises more than normal so her diet is not a problem.", "False" ],
[ "intermediate", "media1", 4, "Kirsty's mother Stella thinks the media (TV and magazines) is not having a healthy influence on her.", "True" ],
[ "intermediate", "media1", 5, "Kirsty's role models are photos of famous models in magazines.", "False" ],
[ "intermediate", "media1", 6, "Kirsty's mother thinks Kirsty has an obsession because she studies photos all the time and she does not have a healthy diet.", "True" ],

[ "intermediate", "media2", 1, "Kirsty's mom wants the media to tell children how to look and to become thin.", "False" ],
[ "intermediate", "media2", 2, "Kirsty's big sister, Donna, does not think the media is responsible for Kirsty becoming obsessed with her appearance.", "True" ],
[ "intermediate", "media2", 3, "Kirsty's big sister, Donna is obsessed with celebrities and their lifestyles.", "False" ],
[ "intermediate", "media2", 4, "Kirsty's mother wants Kirsty not to be obsessed with appearance.", "True" ],
[ "intermediate", "media2", 5, "Kirsty's mother and big sister agree the media is responsible for Kirsty's situation.", "False" ],
[ "intermediate", "media2", 6, "Kirsty's big sister buys lots of magazines, but she is not obsessed with becoming like the celebrities in them.", "True" ],

[ "intermediate", "crocodile1", 1, "Salvador is from Australia but he is working in Brazil.", "False" ],
[ "intermediate", "crocodile1", 2, "Salvador loves crocodiles and he doesn't kill them.", "True" ],
[ "intermediate", "crocodile1", 3, "Salvador loves reptiles, but he doesn't like snakes.", "False" ],
[ "intermediate", "crocodile1", 4, "Crocodiles in Zambia are a danger to tourists so Salvador catches them.", "True" ],
[ "intermediate", "crocodile1", 5, "In Zambia, crocodiles are not a danger to people who go swimming.", "False" ],
[ "intermediate", "crocodile1", 6, "Crocodiles are like dinosaurs and live 100 years.", "True" ],

[ "intermediate", "crocodile2", 1, "People kill crocodiles to make leather with their skin.", "True" ],
[ "intermediate", "crocodile2", 2, "Salvador is developing a program to show people how to kill crocodiles.", "False" ],
[ "intermediate", "crocodile2", 3, "Young crocodiles are in danger from people. People kill them.", "True" ],
[ "intermediate", "crocodile2", 4, "Salvador's hero is a famous Australian crocodile called Steve Irwin.", "False" ],
[ "intermediate", "crocodile2", 5, "Salvador is sad about Steve Irwin's death.He respected his work.", "True" ],
[ "intermediate", "crocodile2", 6, "People were teaching crocodiles to respect them, but crocodiles killed them.", "False" ],

[ "intermediate", "story1", 1, "Ferdy looked up at the roof and could see two men there.", "True" ],
[ "intermediate", "story1", 2, "Amelie was waiting for Ferdy on Platform Seven.", "True" ],
[ "intermediate", "story1", 3, "Ferdy went down the escalator to the platform where Amelie was standing.", "True" ],
[ "intermediate", "story1", 4, "Amelie was standing on the escalator looking down at Ferdy.", "False" ],
[ "intermediate", "story1", 5, "Ferdy was waiting on the platform for Amelie, working on the roof.", "False" ],
[ "intermediate", "story1", 6, "Ferdy tried to get on the escalator, but it was different. The opposite one was the normal one.", "False" ],

[ "intermediate", "story2", 1, "When he looked at the young women who were looking at everyone, they stopped looking at him.", "True" ],
[ "intermediate", "story2", 2, "When he looked at the old man in the ticket office, the old man stared at him.", "True" ],
[ "intermediate", "story2", 3, "He was worried when an unhappy woman walked in front of him.", "True" ],
[ "intermediate", "story2", 4, "The women wearing hard hats were at the coffee bar, drinking coffee.", "False" ],
[ "intermediate", "story2", 5, "Amelie wasn't happy, but Ferdy wasn't worried.", "False" ],
[ "intermediate", "story2", 6, "Ferdy heard three men call him outside. He was waiting for them", "False" ],

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

script_files/justright.pl - Set up dic db

=head1 SYNOPSIS

perl script_files/justright.pl

=head1 DESCRIPTION

'CREATE TABLE texts (id text, description text, genre text, content text, unclozeables text, primary key (id))'

=head1 AUTHOR

Dr Bean C<drbean at, yes, at (@) cpan, a dot, yes a dot, ie (.) org>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

