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
	[ qw(id description genre target content unclozeables) ],

	[
        "smiths",
        "Jo Smith and Joe Smith",
	"elementary",
	"all",
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
	"all",
        "Pilots have interesting lives. They visit many places and meet many people. But is it an easy job? Alan Alder is a pilot. He usually flies from LA to London on Tuesdays. He gets up at five am and he arrives at the airport at six am His flight is at eight o'clock. Eleven hours later he's in London. It is six am in London. Normally, he doesn't go out on the first day. He relaxes: he plays golf, he watches TV and goes to bed early. On Friday, he flies back to LA. Does he like his job? \"It's very hard work,\" he says. \"But the money is good and I have good vacations. Life in the sky is great!\"

",
"Pilots|Alan|Alder"
	],
	
	[
        "postcard",
        "A cool place",
	"elementary",
	"all",
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
	"all",
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
	"all",
       "One. Great apartment on the sixth floor. Large kitchen, small dining room, living room, four bedrooms and three bathrooms. Deck. Only three thousand five hundred dollars per month. No pets. Call (217) 364-728 to see it.
       Two. Large house in the country for rent. Four bedrooms, two bathrooms, large dining room, large kitchen. Perfect for a family. Two thousand five hundred dollars per month. Get keys from J. Beal Office, 9:00am to 5:00pm.

",
"Deck|pets|keys|J. Beal Office"
	],
	
	[
        "rent2",
        "Renting (Part2)",
	"elementary",
	"all",
       "Three. For rent: small house downtown--two bedrooms, kitchen, living room/dining room, bathroom. Near the stores. One thousand five hundred dollars per week. Write to rent\@accomodation.net for appointment.

Four. Apartment for rent: Two hundred dollars per week for one bedroom, perfect for a couple. Small kitchen, living room/dining room, bathroom. Near transportation. Call (0510) 463-849.

",
""
	],
	
	[
        "family1",
        "A football fan",
	"elementary",
	"all",
       "Meet Larry Frazier. He's twenty-eight years old, from Oakland, and he's a taxi driver. His hobby is football and he loves the Oakland Raiders. He always goes to the games at the Oakland Coliseum.

What about his family? \"He usually plays with us on Saturday, but he never spends Sunday with us,\" say his children, Eric (five) and Amanda (eight). His wife, Liz, doesn't like football and she usually stays with the children when Larry is at the game.

Are Eric and Amanda football fans like their dad? No! They don't like football--they both love watching TV and doing puzzles.

",
"Larry Frazier|Oakland Raiders|Coliseum|Eric|Amanda|Liz"
	],
	
	[
        "picture1",
        "Present progressive",
	"elementary",
	"all",
       "The two pictures at the top of page fifty-nine in the book are interesting. I think the artist who drew the pictures did a good job.

       Do you recognize the man at the back sitting at the table in the picture on the left? It's George Clooney, a movie star.

       The man and woman at the front of that picture are talking about him. The woman says to the man not to turn around. But the man doesn't believe it is George Clooney. He turns around and looks, and says the man is not George Clooney.

       Anyway, the man, who may or may not be George Clooney, is sitting next to a woman. The woman is wearing a coat.

       In the other picture, on the right, there are two people. The woman is standing behind a sign that says, New York Fashion Week. And the man is wearing a camera around his neck.

       He's taking photos of the models. It is a fashion show. The woman is standing behind the sign because she doesn't have a ticket. She is trying to avoid being seen.


",
"George Clooney"
	],
	
	[
        "picture2",
        "Describing second picture",
	"elementary",
	"all",
       "The picture at the bottom of page fifty-nine is interesting. I like the poses that the artist has given Colin and David, at the back on the left.

Colin has his head thrown back, as if he is laughing, or as if he doesn't take David seriously. David has his head turned away, but is looking at Colin, as if he doesn't like what Colin is saying.

Paul, the older guy on the right, is also interesting. He is sitting up very straight. He is holding his hands together. He is smiling, as if he knows someone is taking his picture.

Mary and Danny at the front look like they have been drawn by a different artist. They are looking at each other. What are those pieces of white paper they are eating?

Louise and Shimran also have interesting poses. Louise's head is turned in Shimran's direction but she is not looking at Shimran. Shimran is not looking at Louise either. Her head is thrown back. I think she has something wrong with her neck. What is she holding in her hand? It looks like a white plate with little red, yellow and green balls on it.

",
"Colin|David|poses|artist|Paul|Mary|Danny|Louise|Shimran"
	],
	
	[
        "dubai",
        "Desert meeting",
	"access",
	"all",
       "Sally drives onto the ferry in Iran or Iraq, somewhere. And then she drives off the ferry in Dubai. And she drives to the airport in Dubai. And uh, meets her friend, who's, uh, uh,  come from somewhere like, uh, Europe, or America, or, um, ah, uh, the Soviet Union, Russia somewhere.

And, uh, then, they drive along the coast, and suddenly, Sally turns into the desert, and drives up a sand dune and down the other side. And there are, uh, two men and three camels waiting for them.

We don't know what's happening here. Why are they, why are they, uh, why are the men waiting for them? Uh, what do, uh, Sally and her friend uh, intend to do?

One scenario is that, uh, Sally and, uh, uh, her friend are members of the CIA and they've come to get information from these two men about, ah, where bin Laden is.

Another scenario is that, ah, the camels are sick and Sally's friend is a doctor, but she doesn't speak any Arabic, so Sally has come with her to talk to the men in Arabic. 

A third scenario is that they're, uh, on a, uh a, uh, tourist vacation and they want to ride the camels around in the desert.

What do you think is happening in this story? It's kind of, uh, uhm, curious, isn't it. Curious story. 

",
"Sally|Iran|Iraq|Dubai|Europe|America|Soviet Union|Russia|scenario|CIA|bin Laden|Arabic|tourist vacation|curious"
	],
	
	[
        "bridewriter",
        "Bride and Writer scenarios",
	"access",
	"all",
       "I'm going to read the cards that we, um, ah, did last week. First is about the, ah, Sally's friend getting married to the Arab prince, and the terrorists who are the prince's, ah, servants are going to try and kill her.

Okay. 

Sally is an American woman living in Iraq. She is a member of the American Army in Iraq, and carries guns with her. She is very good with the guns and at hand fighting.

Sally's friend is getting married to a rich Arab prince. She feels nervous because she has never seen the prince before. She has only talked to him on the Internet.

The two men are servants of a rich Arab prince. But they are also terrorists, and they hate Americans. The prince told them to bring him his bride, but they intend to kill her.

The three camels are a gift from the Arab prince for his bride's friends and family. The three camels are too big to fit in the car. Sally and her friend will escape into the desert on the camels.

The other one is about, uh, Sally and Sally's friend. Sally's friend is a writer about horses. And now she's writing an article about riding camels.

Here we go.

Sally is an English teacher in Iran. She takes the ferry from Iran to Dubai to meet her friend who writes articles for horse-riding magazines. She has never ridden a horse or a camel.

Sally's friend likes to ride horses, but she has always wanted to ride a camel. Now she is writing about riding camels in Dubai. But she doesn't know anything about riding camels. 

The two men are tour guides. They speak very good English. They take people on camel tours for one-day, and two-day trips in the desert. They have been riding camels since they were children. Their guests find riding camels exhausting.

The three camels are very gentle, but even gentle camels sometimes bite and spit. It is very uncomfortable riding a camel, because they swing their bodies from left to right when they are walking. It's like being on a ship.

",
"exhausting"
	],

	[
        "destinations",
        "Orlando or Seattle?",
	"intermediate",
	"all",
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
	"all",
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
	"all",
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
	"all",
        "Kirsty is fifteen years old. She likes doing what every other girl her age enjoys. She goes to school, she watches TV, and goes shopping with her friends. But Kirsty has an ambition: She wants to be a model. Every week, she saves her allowance to buy magazines. She studies the photos of famous models. They are her role models.

Kirsty's mother, Stella, is not happy. \"It's okay to have ambitions,\", she says. But in Kirsty's case it's becoming an obsession. She thinks about it all the time.\" According to Stella, Kirsty does not have a healthy diet and she exercises more than normal because she wants to be thin. She worries that Kirsty is developing an eating disorder. \"The media are responsible for this situation,\" her mom says.

",
"Kirsty|Stella|ambition|obsession|disorder|media"
	],
	
	[
        "media2",
        "The media--a bad influence? (Part 2)",
	"intermediate",
	"all",
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
	"all",
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
	"all",
        "Sometimes people are a danger to crocodiles, especially young ones. People kill them for their skin to make very expensive leather,\" Salvador explains. He and his colleagues, the people he works with, are developing an educational program. They are teaching people about crocodiles and people are learning to respect them.

Salvador's hero is Steve Irwin, the famous Australian crocodile hunter. \"Steve's death was very sad,\" he says. \"He was a great guy and his work with reptiles was fantastic. I want to continue the kind of work he did.\"

So are you interested in reptiles? Are you looking for an exciting occupation. Then maybe you too can become a herpetologist.

",
"crocodiles|leather|Salvador|educational|colleagues|Steve|Irwin|Australian|fantastic|reptiles|herpetologist"
	],
	
	[
        "crocintro",
        "Crocodiles",
	"intermediate",
	"all",
        "Crocodiles or alligators are really a special kind of reptile. They have the strongest bite of any animal, but it is possible to stop them opening their mouths just by tieing them shut with strong rubber bands.

They have been on the earth for 200 million years. Dinosaurs became extinct 65 million years ago. Crocodiles are still almost the same as they were then.

Salvador is from Brazil, where he had reptiles as pets, but he is now working in Zambia on a program to educate people about crocodiles and move them to areas where they are not a danger, to stop them from being killed. He thinks it is okay to use crocodile skin for leather, but he also thinks crocodiles need protection too.

Steve Irwin was from Australia, where he had a zoo with crocodiles. He was very famous because he fought with them, wrestling them in movies and on TV. There is a video on Youtube of him crying over a dead crocodile. Were his tears 'crocodile tears?' He also is now dead. He was Salvador's role model. He didn't kill crocodiles either.

Hundreds of people die each year from crocodile attacks in Africa and elsewhere. Tourists like to swim when they visit, but the crocodiles are a danger. However crocodiles, especially young ones, also need protection. They are killed for their skins to make expensive shoes. Salvador is trying to tell people about crocodiles and get them to respect them.

",
"Crocodiles|alligators|rubber|Dinosaurs|Youtube|leather|Salvador|educational|Steve|Irwin|Australian|crocodile tears"
	],
	
	[
        "story1",
        "Strange Encounter (Part 1)",
	"intermediate",
	"all",
        "When he came into the station, Ferdy looked down at all the people below him. Ah yes. There she was. Amelie. the beautiful Amelie, with her long black hair and her incredible blue, blue eyes. She was waiting for him.

Ferdy's eyes scanned the scene in front of him, and then he looked up. Above him, two men were working on the roof. He could see them through the glass. what were they doing there? Perhaps they were cleaning the glass. But perhaps they weren't.

He tried to act normally. He got onto the escalator and went down towards the platforms just like any other normal person. But that was the problem. He wasn't normal. He was different from other people.

Opposite him was the entrance to the platform--her platform. Amelie was standing under the number Seven. Perhaps everything was okay.

",
"Ferdy|Amelie|incredible|escalator|platforms"
	],
	
	[
        "story2",
        "Strange Encounter (Part 2)",
	"intermediate",
	"all",
        "But then he saw two young women in yellow hard hats. They were standing by the coffee bar. He noticed something. They weren't talking or drinking coffee. They were watching everyone in the station, but when he looked at them, they looked away.

Suddenly he heard a noise. Someone inside the ticket office was shouting into a cellphone. He turned his head. It was an old man, and next to him was a woman. His wife? Nothing to worry about. But then the old man saw him. He stopped shouting. He took his cellphone from his ear. He just stared.

Platform 7 was in front of him now. Amelie saw him. She smiled.

Suddenly a woman walked between him and Amelie. She didn't look happy. Then he knew. He was in danger.

Ferdy looked behind him. There was no one. He turned around and ran back up the escalator and into the street. He heard Amelie call his name.

There were three men standing outside and they were waiting for him.

",
"Ferdy|Amelie|incredible|escalator|platforms|stared"
	],
	
	[
        "meeting",
        "Arranging when and where to meet",
	"intermediate",
	"all",
        "Kim: What time shall we meet, Max?
Max: I could be there by about 11.
Kim: Okay, where do you suggest?
Max: Well, Kim, I could wait at the top of the escalator, you know, by the entrance.
Kim: I've got a better idea. How about under the clock by Platform Three?
Max: Okay, that sounds good. Eleven o'clock it is then. Under the clock.
Kim: Fine. See you there.

",
"Kim|Max"
	],
	
	[
        "vowel",
        "Cop/Cap/Cup",
	"intermediate",
	"all",
        "Amelie back clock drop front hang jump ladder mud opposite plank platform scanned someone son top tunnel under.

",
""
	],
	
	[
        "memory1",
        "Short-term memory",
	"intermediate",
	"all",
        "Q: I met a guy at a party. We met again a few days later and I couldn't remember his name! I felt bad. What's wrong with my memory?

	A: We all forget things. We throw away information that we don't need any more. You put the man's name in your short-term memory. That's the bit of your brain that keeps things you don't need to remember for very long--like a telephone number you only use once. You forgot the man's name because it wasn't very important to you.

	Q: What is long-term memory?

	A: Long-term memory is where we keep information we need to remember for a long time. It is like a filing cabinet with different drawers. One drawer contains memories of things that happened to you a long time ago, like your first day at school or a summer vacation. This is your episodic memory. It stores the episodes that make up your life.

",
"Q|A|short-term memory|brain|filing cabinet|drawers|episodic"
	],
	
	[
        "memory2",
        "Long-term memory",
	"intermediate",
	"all",
        "A: This is your episodic memory.

It stores the episodes that make up your life. You don't think about these things all the time. But then something, like a smell or a song, brings that memory back and suddenly you remember everything about it.

Another drawer is your semantic memory. In this drawer keep information like important historical dates and facts about your country. Your brain only opens this drawer when you need to use the information, for example in a test.

Q: People say that you never forget how to do things like riding a bicycle. Is this true?

A: Yes. This is called procedural memory because it stores procedures, or the way to do things. It helps you remember skills you learned in your life, things like how to ride a bike or how to use a cellphone. These memories stay in the brain all your life.

",
"Q|A|episodic|semantic|historical|procedural"
	],
	[
        "smiths",
        "Jo Smith and Joe Smith",
	"JUST RIGHT",
        "Just Right Elementary Student's Book. American Edition, by Carol Lethaby, Ana Acevedo and Jeremy Harmer. Copyright Marshall Cavendish, Limited, 2007.

Things that cause stress are called \"stressors.\" One important stressor is change. For example, going to a new school or starting a new job can give you stress. Other common stressors are taking a test or being sick.

But some stress can be good. For example, before a race most athletes feel nervous. This stress helps them get ready.

What makes stress good or bad? Let's look at an example: Jack has a new job in another city. He and his wife are very excited. But their children are sad to leave their family and friends. The move to another city is a good stressor for the parents but a bad one for the children. The parents and the children have different feelings about the situation.

When you are feeling stressed, these tips can help you:

Eat lots of fruit and vegetables and meat and fish without fat. Salad is good too. Don't eat any snacks like potato chips, and don't drink any caffeine. Don't eat too much sugar. Put the chocolate and cakes away.

Do exercise every day. Laugh! Make time for fun.

Talk about your problems.

",
"stressor|athletes|caffeine"
	]

	];

uptodatepopulate( 'Text', $texts );

my $questions = [
			[ qw/genre text id target content answer/ ],

[ "elementary", "smiths", 1, "all", "Freddy and Ricky's mother is a dentist.", "True" ],
[ "elementary", "smiths", 2, "all", "The architect's sons and daughter are called Alice, Neisha and Barry.", "True" ],
[ "elementary", "smiths", 3, "all", "The father of Barry's father is from Scotland and the mother of Barry's father is from the Caribbean.", "True" ],
[ "elementary", "smiths", 4, "all", "The dentist is from Argentina and is married to a woman from the Caribbean.", "False" ],
[ "elementary", "smiths", 5, "all", "Freddy, Ricky and Monica's mother is Alice, Neisha and Barry's father.", "False" ],
[ "elementary", "smiths", 6, "all", "The woman whose husband is English has a name like the man whose father is from Scotland.", "True" ],

[ "elementary", "pilot", 1, "all", "Alan flies to London on Tuesdays.", "True" ],
[ "elementary", "pilot", 2, "all", "He gets up early on Tuesdays.", "True" ],
[ "elementary", "pilot", 3, "all", "Alan's flight is at six o'clock", "False" ],
[ "elementary", "pilot", 4, "all", "Alan goes out on Tuesday night.", "False" ],
[ "elementary", "pilot", 5, "all", "Alan is in London for five days.", "False" ],
[ "elementary", "pilot", 6, "all", "Pilots have an easy job.", "False" ],

[ "elementary", "postcard", 1, "all", "Steve and Paula are both eating and writing.", "True" ],
[ "elementary", "postcard", 2, "all", "Paula isn't having fun, but Steve is having fun.", "True" ],
[ "elementary", "postcard", 3, "all", "Paula and Steve are both sitting in the sun.", "False" ],
[ "elementary", "postcard", 4, "all", "Paula and Steve are both writing a postcard.", "True" ],
[ "elementary", "postcard", 5, "all", "Paula and Steve are in Mexico.", "False" ],
[ "elementary", "postcard", 6, "all", "Paula's job is easy and she has a lot of free time.", "False" ],

[ "elementary", "mobile", 1, "all", "Nicole is in bed with a cold, and she is busy.", "True" ],
[ "elementary", "mobile", 2, "all", "Nicole is not in the office. She is in contact with the office from her bed.", "True" ],
[ "elementary", "mobile", 3, "all", "Because Nicole has a cold, she is not working today.", "False" ],
[ "elementary", "mobile", 4, "all", "Nicole is working from her bed just today. Every other day she is in the office.", "True" ],
[ "elementary", "mobile", 5, "all", "Nicole always has time to listen to music.", "False" ],
[ "elementary", "mobile", 6, "all", "In her life, Nicole is not in contact with people .", "False" ],

[ "elementary", "rent1", 1, "all", "The apartment has more bathrooms than the house in the country.", "True" ],
[ "elementary", "rent1", 2, "all", "The apartment and the large house both have large kitchens.", "True" ],
[ "elementary", "rent1", 3, "all", "The large house is more expensive than the apartment on the sixth floor.", "False" ],
[ "elementary", "rent1", 4, "all", "The large house has a larger dining room than the apartment.", "True" ],
[ "elementary", "rent1", 5, "all", "The large house is three thousand five hundred dollars per month.", "False" ],
[ "elementary", "rent1", 6, "all", "The large house has more bedrooms than the apartment on the sixth floor.", "False" ],

[ "elementary", "rent2", 1, "all", "The house downtown is perfect for going to the stores.", "True" ],
[ "elementary", "rent2", 2, "all", "The apartment and the small house both have large kitchens.", "False" ],
[ "elementary", "rent2", 3, "all", "The apartment is perfect for transportation.", "True" ],
[ "elementary", "rent2", 4, "all", "The small house has a small kitchen. The apartment has a large kitchen.", "False" ],
[ "elementary", "rent2", 5, "all", "The small house is one thousand five hundred dollars per week.", "True" ],
[ "elementary", "rent2", 6, "all", "The small house has one bedroom. The apartment has two bedrooms.", "False" ],

[ "elementary", "family1", 1, "all", "Larry is a football player.", "False" ],
[ "elementary", "family1", 2, "all", "Larry likes football.", "True" ],
[ "elementary", "family1", 3, "all", "Larry never goes to watch the Oakland Raiders.", "False" ],
[ "elementary", "family1", 4, "all", "The Oakland Kickers play at the Oakland Coliseum.", "False" ],
[ "elementary", "family1", 5, "all", "Larry never plays with his children.", "False" ],
[ "elementary", "family1", 6, "all", "The children always spend Sunday with Larry.", "False" ],
[ "elementary", "family1", 7, "all", "Liz likes football.", "False" ],
[ "elementary", "family1", 8, "all", "Liz never goes to the football game with Larry.", "True" ],
[ "elementary", "family1", 9, "all", "The children always stay home on Sunday.", "True" ],

[ "elementary", "picture1", 1, "all", "The man in the picture on the right is taking photos of the models.", "True" ],
[ "elementary", "picture1", 2, "all", "The woman sitting at the table in the front thinks the man sitting at the back is George Clooney.", "True" ],
[ "elementary", "picture1", 3, "all", "The woman sitting at the table at the back is wearing a coat.", "True" ],
[ "elementary", "picture1", 4, "all", "The man sitting at the front believes the man is George Clooney.", "False" ],
[ "elementary", "picture1", 5, "all", "George Clooney is sitting at the table at the front.", "False" ],
[ "elementary", "picture1", 6, "all", "The woman standing behind the sign is a fashion model.", "False" ],

[ "elementary", "picture2", 1, "all", "David is looking at Colin.", "True" ],
[ "elementary", "picture2", 2, "all", "The woman sitting at the table in the front on the left looks like she is eating a piece of paper.", "True" ],
[ "elementary", "picture2", 3, "all", "The woman sitting at the table at the back is wearing green.", "True" ],
[ "elementary", "picture2", 4, "all", "Paul is looking at Claire.", "False" ],
[ "elementary", "picture2", 5, "all", "Danny is sitting in front of Shimran.", "False" ],
[ "elementary", "picture2", 6, "all", "Shimran is looking at Louise.", "False" ],

[ "intermediate", "dubai", 1, "all", "In the story, Sally came from somewhere like Iran or Iraq.", "True" ],
[ "intermediate", "dubai", 2, "all", "In one scenario, the two friends are on a vacation in the desert.", "True" ],
[ "intermediate", "dubai", 3, "all", "In one scenario, Sally speaks Arabic, but Sally's friend doesn't.", "True" ],
[ "intermediate", "dubai", 4, "all", "In one scenario, Sally's friend is a doctor who is on vacation.", "False" ],
[ "intermediate", "dubai", 5, "all", "In one scenario, Sally is a friend of bin Laden, and bin Laden is waiting for them.", "False" ],
[ "intermediate", "dubai", 6, "all", "In one scenario, Sally has information for the men about bin Laden's camels.", "False" ],

[ "elementary", "bridewriter", 1, "all", "Sally will help her friend escape when the terrorist try to kill her.", "True" ],
[ "elementary", "bridewriter", 2, "all", "Riding camels will be more exhausting for Sally than Sally's friend.", "True" ],
[ "elementary", "bridewriter", 3, "all", "The prince does not know that his servants want to kill his bride.", "True" ],
[ "elementary", "bridewriter", 4, "all", "Sally and her friend will find it uncomfortable speaking to the tour guides.", "False" ],
[ "elementary", "bridewriter", 5, "all", "The prince told his servants to kill his bride.", "False" ],
[ "elementary", "bridewriter", 6, "all", "Sally intends to kill the camels so she can fit them in her car.", "False" ],

[ "intermediate", "destinations", 1, "all", "Fran'd rather go to the beach in Orlando and Sonia'd rather go to museums in Seattle.", "True" ],
[ "intermediate", "destinations", 2, "all", "Orlando's sunnier, more relaxing and cheaper than Seattle. Seattle's rainier and not as cheap as Orlando.", "True" ],
[ "intermediate", "destinations", 3, "all", "Fran and Sonia decide to go to different places.", "False" ],
[ "intermediate", "destinations", 4, "all", "Fran doesn't like going to museums. She likes going to the beach.", "True" ],
[ "intermediate", "destinations", 5, "all", "Fran'd rather stay in New York than go to the beach in Orlando.", "False" ],
[ "intermediate", "destinations", 6, "all", "Sonia'd rather go to rainy Seattle than sunny Orlando.", "True" ],
[ "intermediate", "destinations", 7, "all", "Sonia'd rather go to Seattle by herself than go to Orlando with Fran.", "True" ],

[ "intermediate", "stress", 1, "all", "You feel stress if there is no change in your life.", "False" ],
[ "intermediate", "stress", 2, "all", "Jack and his wife feel good about the move to the new city.", "True" ],
[ "intermediate", "stress", 3, "all", "Stress is good if it helps you get ready for change.", "True" ],
[ "intermediate", "stress", 4, "all", "Stress is bad if you have different feelings about the situation than your family.", "False" ],
[ "intermediate", "stress", 5, "all", "Coffee is good if you are feeling stressed.", "False" ],
[ "intermediate", "stress", 6, "all", "Chocolate is good for people who feel nervous. It helps them get ready.", "False" ],

[ "intermediate", "recipe", 1, "all", "There is lots of olive oil in the omelette.", "False" ],
[ "intermediate", "recipe", 2, "all", "There is no extra salt in the omelette, just the salt in the cheese.", "True" ],
[ "intermediate", "recipe", 3, "all", "The recipe is not easy for new cooks. You need to be a perfect cook.", "False" ],
[ "intermediate", "recipe", 4, "all", "There is a lot of cheese and a little butter and cream in the omelette.", "True" ],
[ "intermediate", "recipe", 5, "all", "There a lot of tomatoes and a little olive oil in the salad.", "False" ],
[ "intermediate", "recipe", 6, "all", "A little cream really makes a difference to the omelette.", "True" ],

[ "intermediate", "media1", 1, "all", "Kirsty needs to diet because she does not have a healthy diet.", "False" ],
[ "intermediate", "media1", 2, "all", "Kirsty's mother, Stella, does not want Kirsty to think about becoming a model all the time.", "True" ],
[ "intermediate", "media1", 3, "all", "Kirsty exercises more than normal so her diet is not a problem.", "False" ],
[ "intermediate", "media1", 4, "all", "Kirsty's mother Stella thinks the media (TV and magazines) is not having a healthy influence on her.", "True" ],
[ "intermediate", "media1", 5, "all", "Kirsty's role models are photos of famous models in magazines.", "False" ],
[ "intermediate", "media1", 6, "all", "Kirsty's mother thinks Kirsty has an obsession because she studies photos all the time and she does not have a healthy diet.", "True" ],

[ "intermediate", "media2", 1, "all", "Kirsty's mom wants the media to tell children how to look and to become thin.", "False" ],
[ "intermediate", "media2", 2, "all", "Kirsty's big sister, Donna, does not think the media is responsible for Kirsty becoming obsessed with her appearance.", "True" ],
[ "intermediate", "media2", 3, "all", "Kirsty's big sister, Donna is obsessed with celebrities and their lifestyles.", "False" ],
[ "intermediate", "media2", 4, "all", "Kirsty's mother wants Kirsty not to be obsessed with appearance.", "True" ],
[ "intermediate", "media2", 5, "all", "Kirsty's mother and big sister agree the media is responsible for Kirsty's situation.", "False" ],
[ "intermediate", "media2", 6, "all", "Kirsty's big sister buys lots of magazines, but she is not obsessed with becoming like the celebrities in them.", "True" ],

[ "intermediate", "crocintro", 1, "all", "Salvador is from Australia but he is working in Brazil.", "False" ],
[ "intermediate", "crocintro", 2, "all", "Salvador loves crocodiles and he doesn't kill them.", "True" ],
[ "intermediate", "crocintro", 3, "all", "Salvador loves reptiles, but he doesn't like snakes.", "False" ],
[ "intermediate", "crocintro", 4, "all", "Crocodiles in Zambia are a danger to tourists so Salvador catches them.", "True" ],
[ "intermediate", "crocintro", 5, "all", "In Zambia, crocodiles are not a danger to people who go swimming.", "False" ],
[ "intermediate", "crocintro", 6, "all", "Crocodiles are like dinosaurs and live 100 years.", "True" ],
[ "intermediate", "crocintro", 7, "all", "People kill crocodiles to make leather with their skin.", "True" ],
[ "intermediate", "crocintro", 8, "all", "Salvador is developing a program to show people how to kill crocodiles.", "False" ],
[ "intermediate", "crocintro", 9, "all", "Young crocodiles are in danger from people. People kill them.", "True" ],
[ "intermediate", "crocintro", 10, "all", "Salvador's hero is a famous Australian crocodile called Steve Irwin.", "False" ],
[ "intermediate", "crocintro", 11, "all", "Salvador is sad about Steve Irwin's death.He respected his work.", "True" ],
[ "intermediate", "crocintro", 12, "all", "People were teaching crocodiles to respect them, but crocodiles killed them.", "False" ],

[ "intermediate", "crocodile1", 1, "all", "Salvador is from Australia but he is working in Brazil.", "False" ],
[ "intermediate", "crocodile1", 2, "all", "Salvador loves crocodiles and he doesn't kill them.", "True" ],
[ "intermediate", "crocodile1", 3, "all", "Salvador loves reptiles, but he doesn't like snakes.", "False" ],
[ "intermediate", "crocodile1", 4, "all", "Crocodiles in Zambia are a danger to tourists so Salvador catches them.", "True" ],
[ "intermediate", "crocodile1", 5, "all", "In Zambia, crocodiles are not a danger to people who go swimming.", "False" ],
[ "intermediate", "crocodile1", 6, "all", "Crocodiles are like dinosaurs and live 100 years.", "True" ],

[ "intermediate", "crocodile2", 1, "all", "People kill crocodiles to make leather with their skin.", "True" ],
[ "intermediate", "crocodile2", 2, "all", "Salvador is developing a program to show people how to kill crocodiles.", "False" ],
[ "intermediate", "crocodile2", 3, "all", "Young crocodiles are in danger from people. People kill them.", "True" ],
[ "intermediate", "crocodile2", 4, "all", "Salvador's hero is a famous Australian crocodile called Steve Irwin.", "False" ],
[ "intermediate", "crocodile2", 5, "all", "Salvador is sad about Steve Irwin's death.He respected his work.", "True" ],
[ "intermediate", "crocodile2", 6, "all", "People were teaching crocodiles to respect them, but crocodiles killed them.", "False" ],

[ "intermediate", "story1", 1, "all", "Ferdy looked up at the roof and could see two men there.", "True" ],
[ "intermediate", "story1", 2, "all", "Amelie was waiting for Ferdy on Platform Seven.", "True" ],
[ "intermediate", "story1", 3, "all", "Ferdy went down the escalator to the platform where Amelie was standing.", "True" ],
[ "intermediate", "story1", 4, "all", "Amelie was standing on the escalator looking down at Ferdy.", "False" ],
[ "intermediate", "story1", 5, "all", "Ferdy was waiting on the platform for Amelie, working on the roof.", "False" ],
[ "intermediate", "story1", 6, "all", "Ferdy tried to get on the escalator, but it was different. The opposite one was the normal one.", "False" ],

[ "intermediate", "story2", 1, "all", "When he looked at the young women who were looking at everyone, they stopped looking at him.", "True" ],
[ "intermediate", "story2", 2, "all", "When he looked at the old man in the ticket office, the old man stared at him.", "True" ],
[ "intermediate", "story2", 3, "all", "He was worried when an unhappy woman walked in front of him.", "True" ],
[ "intermediate", "story2", 4, "all", "The women wearing hard hats were at the coffee bar, drinking coffee.", "False" ],
[ "intermediate", "story2", 5, "all", "Amelie wasn't happy, but Ferdy wasn't worried.", "False" ],
[ "intermediate", "story2", 6, "all", "Ferdy heard three men call him outside. He was waiting for them", "False" ],

[ "intermediate", "meeting", 1, "all", "Max suggests eleven o'clock is okay.", "True" ],
[ "intermediate", "meeting", 2, "all", "Max suggests meeting at the top of the escalator by the entrance.", "True" ],
[ "intermediate", "meeting", 3, "all", "Kim suggests meeting under the clock by Platform Three.", "True" ],
[ "intermediate", "meeting", 4, "all", "Max suggests eleven o'clock is not okay.", "False" ],
[ "intermediate", "meeting", 5, "all", "Kim's better idea is to wait at the top of the escalator.", "False" ],
[ "intermediate", "meeting", 6, "all", "Max suggests it is better to meet under the clock.", "False" ],

[ "intermediate", "vowel", 1, "all", "The vowels in 'someone' are the same sound as the vowel in 'mud.'", "True" ],
[ "intermediate", "vowel", 2, "all", "The vowel in 'hang' is the same sound as the vowel in 'back.'", "True" ],
[ "intermediate", "vowel", 3, "all", "The vowel in 'drop' is the same sound as the vowel in 'clock.'", "True" ],
[ "intermediate", "vowel", 4, "all", "The vowel in 'clock' is the same sound as the vowel in 'front.'", "False" ],
[ "intermediate", "vowel", 5, "all", "The vowel in 'son' is the same sound as the vowel in 'top.'", "False" ],
[ "intermediate", "vowel", 6, "all", "The vowels in 'someone' are the same sound as the vowel in 'drop.'", "False" ],

[ "intermediate", "memory1", 1, "all", "Everybody forgets things.'", "True" ],
[ "intermediate", "memory1", 2, "all", "We forget things that we don't need anymore.'", "True" ],
[ "intermediate", "memory1", 3, "all", "The women would have remembered the name of the man if it had been very important.'", "True" ],
[ "intermediate", "memory1", 4, "all", "Things in short-term memory are remembered better than those in long-term memory.'", "False" ],
[ "intermediate", "memory1", 5, "all", "A memory of your first day in school is in short-term memory.'", "False" ],
[ "intermediate", "memory1", 6, "all", "Episodic memory is remembering where things are in the different drawers of a filing cabinet.'", "False" ],

[ "intermediate", "memory2", 1, "all", "Memory for facts are in another drawer than memories of episodes in your life.'", "True" ],
[ "intermediate", "memory2", 2, "all", "Semantic memory can be useful in exams.'", "True" ],
[ "intermediate", "memory2", 3, "all", "A smell can bring back memories.'", "True" ],
[ "intermediate", "memory2", 4, "all", "Procedural memory allows you to bring back telephone numbers you remember.'", "False" ],
[ "intermediate", "memory2", 5, "all", "Semantic memories are like pictures, or feelings of past events.'", "False" ],
[ "intermediate", "memory2", 6, "all", "A smell or a song can bring back memories of how to ride a bicycle.'", "False" ],

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

