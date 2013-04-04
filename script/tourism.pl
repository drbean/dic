#!perl

use strict;
use warnings;
use lib 'lib';

use DBI;
use YAML qw/LoadFile/;

my $yaml = (glob '*.yml')[0];
my $app = LoadFile $yaml;
my $name = $app->{name};
require "$name.pm";
my $modelfile = $name . "/Model/" . $name . "DB.pm";
my $modelmodule = $name . "::Model::" . $name . "DB";
# (my $modelmodule = $modelfile) =~ $name . "::Model::" . $name . "DB";
require $modelfile;

=head1 NAME

tourism.pl - Set up dic db

=head1 SYNOPSIS

perl tourism.pl

=head1 DESCRIPTION

'CREATE TABLE texts (id text, description text, league $VARCHAR{15}, content text, unclozeables text, primary key (league id))'

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


my $connect_info = $modelmodule->config->{connect_info};
my $d = DBI->connect( @$connect_info );

my $sth = $d->prepare("INSERT INTO texts (id, description, genre, content, unclozeables)
                                        VALUES  (?,?,'tourism',?,?)");


$sth->execute(
        "melbourne-1",
        "From Federation Square to Degraves St",
        "01:42 Call in at the Melbourne Visitors Center at Federation Square.
01:45 And ask at the desk for a copy of their Melbourne Walks, Walk Number 4.
01:50 This small brochure is free.
01:52 It will provide you with a route map and information on some of the best laneway and arcade experiences still remaining in the city.
01:58 So let's explore the best parts together.
02:01 The parts you will simply not want to miss.
02:03 Standing outside the Melbourne Visitors Center in Federation Square, ...
02:07 cross St Kilda Road to the corner of St Kilda Road and Flinders Street, and Flinders Street Station.
02:14 Here, by the steps to the station under the clocks, a traditional Melbourne meeting point, ...
02:19 cross Flinders Street to Young and Jackson's Hotel, the pub on the corner, and turn left down Flinders.
02:25 It's a short walk from here down Flinders Street, before we turn right into narrow Degraves Street.

",
"Federation Square|Degraves|Melbourne|brochure|laneway|arcade|St Kilda|Flinders|Young and Jackson's" );

$sth->execute(
        "melbourne-2",
        "Melbourne Clothes Store",
        "05:11 Greg Lawrence: And directly across the road from Smitten Kitten is the retro clothing store, Speed Boy Girl.
05:17 With the most amazing collection of vintage street wear.
05:20 Tops, tees, hats, boots and accessories,
05:23 It's different, funky and very reasonably priced for the quality it carries.
05:27 Chynthia, can you tell me a little about the concept for Speed Boy Girl?
05:31 Chynthia: Well, we have a collection of vintage and new clothes, for both boys and girls.
05:37 We have um.. All our vintage stuff comes from Europe,
05:42 so it's all kind of, um...
05:44 We've got cowboy boots.
05:45 We've got eighties boots.
05:46 All in A-one condition.
05:48 And we've also got, you know, Australian clothes.
05:50 We've got stuff from China. We've got a mixture.
05:54 A.. Our.. the basic concept is to incorporate all styles...
05:58 All the things that we like, no matter what era.
06:00 Greg: Is it street wear for young people mainly?
06:03 Or, do you get different age groups coming in?
06:06 Chynthia: Yeh! Pretty much for young, young people.
06:09 It's kind of a ..
06:10 But it's eclectic. It's a mixture of stuff.
06:12 So you .. everyone can find something.
06:14 Yesterday I sold a, a one of our vintage belts to a 75-year-old lady.
06:20 So we, we, Actually, it's not just for young..
06:22 We cross a lot of um, boundaries.
06:25 It's just.. It's all a bit of everything.
06:26 And if you like it, you know.
06:29 Greg: What's the vibe like in Degraves Street and the laneways around it?
06:32 Chynthia: Oh, it's fantastic.
06:33 The city, look, um, I, you know, I was born and .. born here and grew up in the city and around, around.. close by.
06:39 And the city lately, in the last three or four years has really had a change again.
06:44 'Cause it went quiet for a while and everyone, everyone was sort of doing things outside.
06:48 It's come back in the city, and all the laneways and ...
06:52 And I just think the city's got a lot of action.
06:54 And it's great to be around here.
06:56 Greg Lawrence: You're listening to Destinations Secrets by Talk-n-Tours, the podcast that's your door to unique destination insider experiences.
07:05 I'm Greg Lawrence and right now we're walking down narrow Degraves Street in Melbourne, Australia.

",
"Greg Lawrence|Smitten Kitten|retro|Speed Boy Girl|amazing|collection|vintage|accessories|reasonably|carries|Chynthia|concept|Europe|concept|incorporate|era|eclectic|boundaries|vibe|Degraves|laneways|Destinations Secrets|Talk-n-Tours|podcast|unique destination insider experiences" );

$sth->execute(
        "whisky",
        "Duty-Free Store",
        "Hello. This is uh, Dr Bean.
I'm talking about my trip to Japan, uh, during the winter vacation.
At, uh, Taoyuan International Airport, uh, I bought three bottles of whisky.
Uh, two bottles of Old Parr, and one bottle of Chivas Regal.
Old Parr was 1,050 NT each. Uh, but there was a 20 percent discount. So that means it was about, uh, uh, 800 NT.
Chivas Regal was about 800 NT also.
So altogether...

",
"" );

$sth->execute(
        "jan19",
        "Taking the Train",
        "When I got to uh, Osaka in Japan, I took the train from the airport to uh, Nara.
Uh, the train went from Kanku Airport to Osaka and that cost me about 900 NT (900 yen).
Uh, and I changed in Osaka to another train, which went to Horyuji. And that train to Horyuji cost me about 450 ... yen.
Okay? Uh.

",
"" );

$sth->execute(
        "jan26",
        "Going to a Meeting",
        "On January 26, I went to a meeting in Osaka. And I took the train to a place called Ishikiri, and that cost me about 450 NT, not NT, yen.
At the meeting we had to pay about 600 yen.
And uh, taking the train back, another 450 yen.
So that was about uh, 1,500 yen on January 26.

",
"" );

$sth->execute(
        "jan30",
        "Visiting a Friend",
        "Next Wednesday, on January 30th, I visited a friend.
And, uh, I took uh, one of the bottles of whisky.
Uh, I think it was the Chivas Regal. Yeh. The Chivas Regal.
Uh, and I also went to the supermarket, and I bought uh, some uh, uh, canned fruit and canned fish, which cost me about 1,000 yen.
I took those to uh, these people here, the Matsumotos.
Gave them the whisky and the cans of fruit and fish.
That was on January 30th.

",
"" );

$sth->execute(
        "feb56",
        "Hitchhiking to Tokyo",
        "Next uh, Wednesday, on February the 5th, I hitchhiked to Tokyo, and I bought, uh, the truck driver some coffee.
Uh, that cost me 300 yen.
When I got to, When I got to Tokyo, I took the train to Shinjuku.
That cost me 600 yen.
And then I took another train from Shinjuku to Sendagawa.
And I met my friend. And uh, I had a good time.
Uh (laughs)
Uh, and then I hitchhiked back.
And I'm going to tell you about that in the next uh, next track.

",
"" );

$sth->execute(
        "feb67",
        "Hitchhiking Back to Nara",
        "So on Wednesday evening, I went back to uh, to uh Nara.
I took the train from Shinjuku, sorry, from Shibuya, not Shinjuku.
I took the train from Shibuya, uh, out of Tokyo.
And I hitchhiked uh, back, uh.
Uh, and, uh, for dinner, I bought some bread, and some ham and some cheese, uh, which cost me 750 yen.
Bread, ham and cheese.
And I hitchhiked back to Nara, reaching Nara next morning.
I took the train, which cost me 600 yen, back home.

",
"" );

$sth->execute(
        "feb17",
        "Returning to Taiwan",
        "00:00 And on uh, February 17, that's a Sunday,
00:04 Uh, it's about two weeks ago now, 
00:07 I came back to Taiwan.
00:11 I took the train from Horyuji,
00:13 to the airport,
00:14 which cost me, uh, 1,350 yen.
00:22 And, uh, then I took the, uh, bus from Taoyuan International Airport,
00:35 to Hsinchu,
00:40 which cost me about uh...
00:44 What was it now?
00:45 What was it now?
00:47 Uh, it was about.. 120 NT.
00:54 And that's my journey, my trip, to Japan.

",
"Horyuji|International" );

$sth->execute(
	"singapore-1",
	"Singapore New Year celebrations",
	"Singapore New Year celebrations

1:42 Ni hao, everybody and we are in the Year of the Rat. Yes, it's Chinese New Year here down in Singapore.
1:48 And I'm just walking up Smith Street. We've just had the celebrations and no sooner is it all over than everybody is well back to normal.
1:59 Which I find quite extraordinary myself, but that's just the way it is.
2:02 Well let me give you a bit of a walk-through as to what has actually happened.
2:06 The main events happened along New Bridge Road.
2:11 And along there for about 200 meters, there's just all these characters. There's a stage set up.
2:22 And all the way along, there's the floating dragons as they come along the street.
2:24 And all this range of spectacular events of trying to outdo one another.

",
"extraordinary|walk-through|characters|spectacular|outdo|Singapore New Year celebrations
" );

$sth->execute(
	"singapore-2",
	"Lead-up to New Year",
	"Lead-up to New Year

2:31 Chinese New Year occured on February 6.
2:34 Now the thing is before that, it all started with a whole range of other sort of celebrations.
2:42 For example, back on the 19th of January here, in Singapore there was a thing called the Official Lighting Up and the Opening Ceremony.
2:49 Which was opened by the former Prime Minister Goh Chok Tong.
2:54 And there was supposedly a record-breaking lion dance display of 368 lions.
3:01 There's firecrackers, pyrotechnics, all the usual sort of openings as they come towards the end of the previous year.
3:12 And they get ready in preparations towards the opening of the new Lunar New Year.
3:19 Very similar to a Western New Year, basically.
3:22 You have a New Year's Eve up until the midnight, and then of course from midnight on, there's just this big, massive, huge party which goes off ... like a firecracker, so to speak.

",
"Goh Chok Tong|pyrotechnics|Lead-up to New Year
" );

$sth->execute(
        "singapore-3",
        "Talking to Drum Players",
        "Talking to Drum Players

08:08 Okay, let's go and see. (He grabs his podcast bag and he's going to go ask these guys.)
08:14 These guys run around on these trucks.
08:18 And what they do is they just beat the drums.
08:20 They're very, very popular here.
08:21 We've had them running up and down our house.
08:24 So let's just go ask them if we can understand a little bit more about what they're doing and why they do it.
08:36 Excuse me! Hello. Can you tell me what you're doing?
08:38 What, Why are you, Why are you on the trucks, uh?
08:41 Come on!
08:43 Hello. What's your name? What's your name?
08:45 Boy: Elvin.
08:46 Holden: Where are you from?
08:47 Boy: Singapore.
08:49 Holden: Okay. Whereabouts?
08:50 Boy: Huh?
08:51 Holden: Whereabouts?
08:52 Boy: What?
08:53 Holden: Whereabouts in Singapore?
08:54 Boy: Oh.

",
"podcast|Boy|Elvin|Holden|Talking to Drum Players
" );

$sth->execute(
        "midwest-1",
        "Bed, TV and shower I",
        "Bed, TV and shower I

02:31 Podcaster: You've got wifi, computer connections that you don't need to plug in.
02:36 You've got fast Internet.
02:37 You've got everything here.
02:38 Manager: Certainly. When we opened this hotel we wanted to have, utilize the highest technology that one could.
02:45 And some of the things that people really liked when they traveled to different hotels,
02:50 we found, was the bed, the TV and the shower.
02:53 We went about getting the best of each one of those things.

",
"wifi|highest technology|Podcaster|Manager|utilize|Bed, TV and shower I
" );

$sth->execute(
        "midwest-2",
        "Bed, TV and shower II",
        "Bed, TV and shower II

02:57 And we purchased the best bed that one could make, with a very unique European support system,
03:04 A 42-inch plasma screen TV,
03:06 which when we opened the hotel,
03:07 was the very first hotel in the world to have 42-inch plasma screens in every room.
03:10 And then in the bathroom, we used a 15-inch LCD uh, screen with all the different technologies.

",
"purchased|European support system|plasma screen|Bed, TV and shower II
" );

$sth->execute(
        "midwest-3",
        "Movie system",
        "Movie system

03:16 We also have a on-demand system, movie system, that allows, you know, stop, fast forward, rewind.
03:23 And, and you can, you know, order multiple movies.
03:26 And it uses the highest technology there as well.
03:29 Podcaster: And the gorgeous Rachel Hunter talking us through it all.
03:31 Manager: Ha-ha. Yeh, that's true. Ha-ha-ha.

",
"Podcaster|Manager|Movie system
" );

$sth->execute(
        "midwest-4",
        "Power shower",
        "Power shower

03:33 Podcaster: And of course the shower, a magnificent performance there.
03:37 Not only the water coming down on your head.
03:39 But the detachable unit that you can move around.
03:41 And several jets that come out onto your body, as well.
03:46 Manager: That's correct. I believe there are seven shower heads in each shower.
03:49 Uh. And we call it a power shower, because you're really blown away by the amount of water that's flowing at you.

",
"Podcaster|Manager|magnificent performance|detachable|jets|amount|Power shower
" );

$sth->execute(
        "metropolis-1",
        "Roppongi Ark Hills Sakura Matsuri",
        "Roppongi Ark Hills Sakura Matsuri

16:45 Kamisami Kong: All right, Guy Perryman. From this point in the Metpod, this is where we call our concierge of the Metpod.
16:52 Guy Perryman: Okay.
16:52 Kong: Her name is Hiroko Fukuzawa. And if you will, please hit that little bell on the table.
16:56 Voices: Thank you.
16:57 Hiroko Fukuzawa: I'm here.
16:58 Voices: Oh!
16:59 Kong: There she is.
17:01 Fukuzawa: Yup.
17:03 Perryman: Hi, there. 
17:03 Fukuzawa: Hi, Guy.
17:03 Perryman: Come on in.
17:04 Fukuzawa: Thank you.
17:05 Perryman: What is great?
17:07 Perryman, Fukuzawa, Kong: Laughing.
17:09 Kong: Hiroko always has a must-see, or a must-go for us. 
17:10 Fukuzawa: I do.
17:11 Kong: And what have you got for us this weekend, Hiroko-san?
17:13 Fukuzawa: All right, well, this weekend we have the Roppongi Ark Hills Sakura Matsuri.
17:17 Kong: And of course that's going to be at Ark Hills.
17:20 Fukuzawa: Ark Hills. That's Roppongi 1-chome Station. Right in front of Suntory Hall, Ark Mori Building, ANA Continental, Intercontinental Hotel.
17:28 Um, this is going to go from 11am to 8pm.
17:30 Kong: Wow. This is an all-day affair.
17:32 Fukuzawa: All-day affair. With, uh, live events.
17:35 Kong: For example, what kind of live events?
17:38 Fukuzawa: There will be accordion singers, acoustic guitarists.
17:42 Kong: Ha, ha, ha.
17:43 Fukuzawa: Um, jugglers.
17:44 Kong: Really? Jugglers. Great! Clowns?
17:46 Fukuzawa: Clowns. Comedy shows.
17:48 Kong: Yeh, what about..
17:49 Fukuzawa: Street dancing.
17:50 Kong: Street dancing? Pole dancing?
17:52 Fukuzawa: I'm not sure about that. You've got to go around XXXXXX Roppongi area.
17:53 Kong: I see, I see. Well pole dancing...
17:55 Perryman: No that's in May. That's on the first of May.

",
"Kamisami|Kong|Guy|Perryman|Metpod|Hiroko|Fukuzawa|Voices|Laughing|1-chome|Suntory|Ark Mori|Intercontinental|accordion|acoustic|juggler|Pole|XXXXXX|Roppongi Ark Hills Sakura Matsuri
" );

$sth->execute(
        "south-1",
        "Southern Bed and Breakfast",
        "Southern Bed and Breakfast

00:30 Host: We've been serving bed and breakfast now for six and a half years.
00:34 We thoroughly enjoy it.
	00:36 Amongst our first guests when we started bed and breakfast were two of the publishers of the \"Rough Guide,\" in London.
	00:43 And as a consequence of being published in the \"Rough Guide,\" one of the only two bed and breakfasts in Natchez that are in \"Rough Guide,\"..
00:52 we have a very large percentage of European guests, which we enjoy having. 
00:58 I have traveled in Europe very extensively, and enjoy meeting people from all over, all over the world, actually.

",
"Host|publishers|Rough Guide|London|consequence|Natchez|extensively|Southern Bed and Breakfast
" );

$sth->execute(
        "south-2",
        "Bed and Breakfast Rooms",
        "Bed and Breakfast Rooms

01:04 Podcaster: Beautiful interior timber, very high ceilings.
01:08 My bedroom is very large, with a wonderful, huge, big old bath.
01:11 It's just got a lot of quality.
01:13 I mean, it's not the same as the average B & B experience in Britain, is it?
01:16 Host: Well, it's not like the average B & B experience in Britain.
01:20 Uh, the bed and breakfast in the United States, in particularly in Mississippi, have a tendency to be large, older homes with, uh, very spacious rooms.
01:28 The ceilings are very high in this house, because it's typical of the Victorian architectural style.

",
"Podcaster|Host|interior timber|ceilings|quality|Britain|Mississippi|spacious|Victorian|architectural|Bed and Breakfast Rooms
" );

$sth->execute(
        "south-3",
        "King and other Rooms",
        "King and other Rooms

01:35 Host: The tub in the room where you were is original to the house.
01:40 The tub and lavatory put in in 1890.
01:44 The uh, room is very large with the fireplace.
01:47 that had originally been coal-burning, 's been converted to natural gas logs.
01:51 And we can have that room set up with a king-size bed, or with a pair of twin beds.
01:58 And it has a love seat and a large coffee table, and an overstuffed chair.
02:03 And it has a lighted vanity in it.
02:05 The chandelier in that room was brought from Italy in 1949. It's a Capo di Monte.
02:12 We have another Capo di Monte chandelier in one of our other bedrooms, too, in the ...
02:18 The chandelier in the dining room, which is a very large room, is from Italy.
02:22 It was an antique candle-burning chandelier.
02:27 At the time it was purchased in 1949.
02:29 And has been electrified.
02:32 It's gold over bronze and with a 147 crystal pieces on it.
02:38 I have taken it apart and washed it, so I know how many there are.

",
"Podcaster|Host|fireplace|coal-burning|overstuffed|vanity|chandelier|Capo di Monte|antique|purchased|electrified|bronze|crystal|King and other rooms
" );

$sth->execute(
        "south-4",
        "Southern breakfast",
        "Southern breakfast

02:43 Podcaster: And then a lovely Southern breakfast, bacon and the little sausage patties you have here,
02:49 Cheesy grits, eggs florentine this morning. All lovely.
02:52 And one of the nicest features, cup of coffee before you have breakfast, out on the wide veranda, looking over the magnolia trees.
02:58 It's a lovely feeling here in Mississippi.
03:00 Host: We uh, we really enjoy using the balcony upstairs and the veranda downstairs.
03:05 And have put the furniture out there.

",
"Podcaster|Host|bacon|sausage patties|Cheesy grits|florentine|veranda|magnolia|Mississippi|balcony|Southern breakfast
" );

$sth->execute(
        "south-5",
        "Entertaining guests",
        "Entertaining guests

03:08 Host: When the weather is comfortable, which is most of the year, we enjoy sitting out there, particularly in the mornings and in the evenings.
03:16 And we enjoy having our guests sit out there.
03:18 We, uh, either in the parlor, or out on the verandah in the afternoons.
03:22 We have a glass of wine and cheese and crackers, or various things, whatever I'm in the mood to fix that day.
03:28 And a glass of wine. We just thoroughly enjoy spending time with our guests, and getting to know them.
03:34 The people that we meet are what make the bed and breakfast business worthwhile.

",
"Host|parlor|verandah|worthwhile|Entertaining guests
" );

$sth->execute(
        "budget-1",
        "Europe on Five Dollars a Day",
        "Europe on Five Dollars a Day

01:45 Chris: I'd like to welcome to the show, Pauline Frommer, who's come to talk to us about budget travel.
01:49 Pauline, welcome to the show.
01:50 Pauline: Oh, thanks for having me.
01:53 Chris: Now you come by this topic very naturally.
01:55 You're the daughter of Arthur Frommer, who's been in the budget travel business now for over fifty years, I think is when your father's first guidebook came out.
02:04 Pauline: Yeh, his first guidebook came out in 1957. It was called:
--Well, actually, that was his second guidebook. His first guidebook was for GIs, because he was in--During the Korean War, he was sent to Europe, instead of Korea, and found many cheap places to stay and to see. And he wrote up a guidebook for his fellow GIs, called 'The GI's Guide to Europe.'
02:24 But the one that he's most famous for is 'Europe on Five Dollars a Day.'

",
"Chris|Pauline Frommer|Pauline|guidebook|--Well, actually, that was his second guidebook. His first guidebook was for GIs, because he was in--During the Korean War, he was sent to Europe, instead of Korea, and found many cheap places to stay and to see. And he wrote up a guidebook for his fellow GIs, called 'The GI's Guide to Europe.'|famous|Europe on Five Dollars a Day
" );

$sth->execute(
        "budget-2",
        "Growing up as a traveler",
        "Growing up as a traveler

02:28 Chris: So did you grow up traveling to Europe on five dollars a day with your father?
02:34 Pauline: Oh, yeah!
02:34 Chris: Is that where the love of travel comes from here?
02:36 Pauline: Yep. I started traveling with my parents when I was four months old.
02:40 Chris: Ha, ha, ha.
02:40 Pauline: At that point they would push me into a drawer for the night, and that's where I would sleep.
02:45 And we always traveled on a budget. It was my father's philosophy (and mine too) ..
02:51 that the less you spend, usually the more you enjoy.
02:54 Because when you spend less, you're more likely to go to the places where locals go. To eat, to shop, to hang out.
03:01 And you have a more authentic view of the destination. And you have more adventures.

",
"Chris|Pauline Frommer|Pauline|drawer|philosophy|budget|authentic|destination|Growing up as a traveler
" );

$sth->execute(
        "budget-3",
        "Guidebooks for young people",
        "Guidebooks for young people

05:15 Chris: Interesting. You're just coming out now with another series of guidebooks, the Pauline Frommer Guides.
05:20 Pauline: Mmh-hmm.
05:21 Chris: And again focusing on budget travel for adults, I believe, is the way that you were describing it, when I heard you speak.
05:27 Pauline: Yeh. There are a lot of books out there for backpackers.Folks who want to stay in hostels, and don't mind eating ramen noodles to stretch their budgets.

",
"Chris|Pauline Frommer|Pauline|focusing|budget|adults|backpackers|ramen|stretch|Guidebooks for young people
" );

$sth->execute(
        "budget-4",
        "Guidebooks for adults",
        "Guidebooks for adults

05:36 But there's not much out there, I think, for the average, ordinary American, who is desperate to go out and see the world, but is shocked by the cost of travel. Who may be a little bit squeamish about sharing a room with others, or even sharing a bathroom.
05:53 And so, what these guides do is try and tell those folks how you can travel in an adult manner, with dignity, but still save a heck of a lot of money.
06:04 And the main way we do that, besides we give you every trick in the book for saving money on airfares, which of course is a huge cost in travel.
06:12 But we also try and tell you about alternative accommodations,
06:16 which I think is the best thing since sliced bread in terms of travel.

",
"average|desperate|shocked|squeamish|folks|dignity|heck|every trick in the book|alternative accommodations|sliced bread|in terms of|Guidebooks for adults
" );

$sth->execute(
        "budget-5",
        "New York is expensive",
        "New York is expensive

06:20 Looking at Pauline Frommer's New York, according to American Express, the average cost of a hotel room in New York now--the average--is now 325 dollars a night.
06:32 Chris: Ha, ha, ha.
06:33 Pauline: Which is outrageous. And it makes New York impossible for most travelers. At least American travelers.
06:40 One of the reasons it's so pricey is Europeans are flocking here, because their currency is so strong.
06:44 Chris: Oh, sure.
06:46 Pauline: And New York is the cheapest gateway from Europe.
06:49 But that's neither here nor there.
06:51 So what you do.. The truth is ..
06:53 New York is a very expensive city, even for the people who live here.

",
"American Express|outrageous|One of the reasons it's so pricey|flocking|currency|cheapest gateway|But that's neither here nor there.|truth|New York is expensive
" );

$sth->execute(
        "budget-6",
        "Bed and Breakfasts in New York City",
        "Bed and Breakfasts in New York City

06:57 And so what a lot of the people who live here have started doing is renting out their apartments, just to make a little extra money.
07:05 Or renting out a room in their apartments.
07:09 And if you're a tourist, these apartments cost a third to half as much as you would spend for a regular hotel room.
07:15 And I've seen some spectacular apartments in some of the most pricey areas of town.
07:23 I visited a private B&B where a woman rents out two rooms.
07:26 The two rooms are right on Central Park West.

",
"regular|spectacular|pricey|private|Bed and Breakfasts in New York City
" );

$sth->execute(
        "prices-1",
        "Extended hours over Easter",
        "Extended hours over Easter

26:49 Pete: And I'm going to start.
26:51 Extra hours have been added to some Disney restaurants through March 28th and from April 18th through the 25th.
26:58 These include 1900 Park Fare, which will be serving dinner from four-thirty to nine PM. Cape May Cafe, which is extending its breakfast hours from seven-thirty AM to eleven thirty AM, and Chef Mickey's, which has extended hours for both breakfast and dinner. We'll have links to the full list on our show notes page.

",
"Pete|extending|extended|Extended hours over Easter
" );

$sth->execute(
        "prices-2",
        "Prices up 43% over Easter",
        "Prices up 43% over Easter

27:14 Pete: And of course these extended hours go hand-in-hand with the ridiculous extended price increases that Disney is charging during holiday periods.
27:24 I think we figured out that, uh, uh for the Princess Buffet at, at Norway, uh, what the price was and what the price is now, or what the price is during Easter break, along with a, they're now requiring that you take the Photo Package, is a 43 percent increase in the price...
27:44 Julie: Wow.
27:45 Pete: Over what it was two months ago. It's just absurd. Just absurd.

",
"Pete|Julie|hand-in-hand|ridiculous|periods|Princess Buffet|Norway|break|Photo Package|increase|absurd|Prices up 43% over Easter
" );

$sth->execute(
        "business-1",
        "Business at Disney World",
        "Business at Disney World

25:01 And then this contradicts the report we talked about two weeks ago, where they're saying that, uh, 
25:05 hotel attendance is down.
25:07 When theme parks is up, how can hotel attendance be down?
25:11 Hotel bookings.
25:11 I don't know. I don't know.
25:14 And you get all these groups releasing these reports...
25:16 Right.
25:17 you never know.
25:18 I mean, that's a good report. 
25:20 I'll tell you. If, if downtown Disney is any, was any indication on Saturday night, there's no trouble getting people over, over to property.
25:27 Yeh.
25:27 Cause it was just wall-to-wall people.
25:30 I mean, the next two weeks, as far as the hotels there, they're pretty packed.
25:33 Yeh. Yeh. They are. So,..
25:35 All right. That's going to do it for the news this week.

",
"Business at Disney World
" );

$sth->execute(
        "guide-1",
        "Welcoming tour guide",
        "Welcoming tour guide

00:15 Amateur Traveler, Episode 131.
00:19 Today on the Amateur Traveler, we talk to Elizabeth, who's a VIP tour guide at Walt Disney World in Orlando.
00:26 We'll talk about our favorite rides, our favorite food and all those little surprises, today in the Amateur Traveler.

00:38 Welcome to the Amateur Traveler, I'm your host, Chris Christensen.
00:41 Before we get into the interview with Elizabeth, I do have two new stories for you today.

02:08 Chris: I'd like to welcome to the show, Elizabeth. By popular demand, who is come to talk to us about the Walt Disney World Resort.
02:14 Elizabeth, welcome to the show.
02:17 Elizabeth: Thanks Chris, it's great to be here.

",
"Amateur Traveler|Elizabeth|Walt|Disney|Orlando|Chris Christensen|Chris|By popular demand|Welcoming tour guide
" );

$sth->execute(
        "guide-2",
        "Celebrity question",
        "Celebrity question

02:40 Chris: Now first of all, you have a number of questions, as we talked about beforehand, that people always ask you.
02:46 Some of which you can answer, and some of which you can't.
02:48 So let's start with those to just get those out of the way.
02:51 Elizabeth: Okay. Everybody asks me, when I do a tour at Walt Disney World, and it's a VIP tour...
02:57 They always say, Well, tell me, who have you taken around? What are the celebrities like when you take them on the rides?
03:03 And, yes, I have hosted celebrities, athletes and things like that.
03:06 But, tour guides, they find that these guests are just like you and I and they experience the park and enjoy it just like we all do.
03:13 So they have fun moments and exciting moments out in the park just like you and I.
03:18 But I'm not here to drop any names or anything like that.

",
"Chris|Elizabeth|beforehand|celebrities|drop any names|Celebrity question
" );

$sth->execute(
        "guide-3",
        "Long-line strategy",
        "Long-line strategy

04:00 Jennifer: If we didn't have you, we'd still be in line for Space Mountain.
Chris: Ha. Ha. Ha.
04:04 Jennifer: And I have that in a XXXX book, proudly shown.
04:06 Chris: But the trick, you're saying, to get to the front of the line is to be Tom Cruse.
克里斯：但把戲，你是怎麼說的，去前面的路線是湯姆Cruse 。
04:11 Jennifer: Exactly. And if you're not Tom Cruse, use the FASTPASS system or get there very early in the morning.
珍妮：正是。如果您不是湯姆Cruse，使用FASTPASS系統或獲得有很早就在上午 。
04:17 Chris: And we'll talk more about details, as we talk about strategies then.

",
"Jennifer|Chris|Space Mountain|XXXX|Cruse|proudly shown|FASTPASS|克里斯：但把戲，你是怎麼說的，去前面的路線是湯姆Cruse 。|珍妮：正是。如果您不是湯姆Cruse，使用FASTPASS系統或獲得有很早就在上午。|Long-line strategy
" );

$sth->execute(
        "guide-4",
        "FASTPASS planning",
        "FASTPASS planning

09:00 Chris: And then, what do you do first.
09:03 Jennifer: I think you do need to do some planning for your day.
09:06 And if you are a family that enjoys the roller coasters and the thrill rides...
09:10 you're going to grab FASTPASSes for one of the mountains.
09:15 Grab that FASTPASS and then go on the other mountains, like Big Thunder.
09:19 While you're on Big Thunder, you're waiting for your FASTPASS time to happen.
09:24 You might get a couple of other attractions, especially if you get there right at nine o'clock.
09:29 And then it'll be time for you to use a FASTPASS for, say, Splash Mountain.


",
"Jennifer|Chris|roller coaster|thrill|FASTPASS planning|FASTPASSes|FASTPASS|Big Thunder|attractions|Splash Mountain
" );

$sth->execute(
        "guide-5",
        "What is FASTPASS?",
        "What is FASTPASS?

09:34 Chris: And let's pause here for a second.
Jennifer: Hmm-mmh.
09:37 Chris: And let's not assume that everybody has been to the Park and knows what a FASTPASS is or why they'd want one.
克里斯：不要以為大家都已經到公園，並且知道什麼是FASTPASS是，為什麼您>要想要一個。
09:42 Jennifer: Okay.
珍妮佛：好。
09:43 Chris: So can you go into a little more detail. What is a FASTPASS and why is this really important to know.
克里斯：那麼你是否可以進入小更詳細。什麼是FASTPASS，以及為何這是必要的呢？

",
"Jennifer|Chris|FASTPASS|克里斯：不要以為大家都已經到公園，並且知道什麼是FASTPASS是，為什麼您>要想要一個。|珍妮佛：好。|克里斯：那麼你是否可以進入小更詳細。什麼是FASTPASS，以及為何這是必要的呢？|What is FASTPASS?
" );

$sth->execute(
        "guide-6",
        "FASTPASS explanation",
        "FASTPASS explanation

09:48 Jennifer: Sure. A FASTPASS is included in your Theme Park admission.
09:52 When you go through the turnstiles, the ticket is activated.
09:55 And you can go to ...
09:57 Most of our major attractions have the FASTPASS system.
10:01 Which is basically a virtual reservation, or virtually standing in line.
這基本上是一個虛擬的保留，或虛擬排隊等候的。
10:06 It's a reservation time to come back later ...
10:10 when your wait time would be significantly reduced to five to ten minutes.
這是一個保留回來後，當您的等待時間將大大減少到9時55分鐘。
10:15 Chris: Mmh-hmm.

",
"Jennifer|Chris|FASTPASS explanation|FASTPASS|turnstiles|activated|virtual|significantly|這基本上是一個虛擬的保留，或虛擬排隊等候的。|這是一個保留回來後，當您的等待時間將大大減少到9時55分鐘。
" );

$sth->execute(
        "guide-7",
        "How to get FASTPASS",
        "How to get FASTPASS

00:40 Jennifer: So say you go into the Theme Park at nine am.
00:43 And you go right to Space Mountain, you stick your Theme Park ticket in a machine that's outside, next to the ride.
00:46 the machine will spit back your ticket and it will also give you a reservation time.

",
"Jennifer|Space Mountain|Theme Park|spit|How to get FASTPASS
" );

$sth->execute(
        "guide-8",
        "FASTPASS wait times",
        "FASTPASS wait times

00:55 Usually if you pick nine am to go get your FASTPASS, you will be able to have a time on there that will tell you when to come back. 
 通常如果你拿起九時到您的FASTPASS ，你將能夠有時間就在那裡，會告訴你何時回來。
01:03 Probably it will say between ten and eleven am. So you have an hour free to go do something else. 
 也許它會說之間的10和11分。因此，你有一小時免費去做點事，否則。

",
"Jennifer|FASTPASS wait times|FASTPASS
" );

$sth->execute(
        "guide-9",
        "Wait or come back?",
        "Wait or come back?

01:09  Chris: Okay. And often it's going to cost me the same amount of time if I wait in the line, or if I go do something else and then come back at the FASTPASS time. Right?
01:17 Jennifer: Right. So, you're using your time really wisely.

",
"Chris|Jennifer|Wait or come back
" );

$sth->execute(
        "weddings-1",
        "Wedding segment introduction",
        "Wedding segment introduction

39:34 Pete: We are going to move on to our first segment.
39:37 Julie Martin has been putting together a whole series on Disney weddings.
39:43 And she has our first installment of it today.
39:46 So go ahead, Mrs Martin. Let's see what you have.

",
"Pete|Julie|Martin|Wedding segment introduction
" );

$sth->execute(
        "weddings-2",
        "Types of ceremony",
        "Types of ceremony

39:49 Julie: Well, this is for Walt Disney World, not Disneyland, just to be clear about that.
39:53 And they offer fairy-tale weddings, vow renewals, and commitment ceremonies, that cover everyone.
39:59 which I think is very nice.

",
"Julie|commitment|Types of ceremony
" );

$sth->execute(
        "weddings-3",
        "Source of information",
        "Source of information

40:00 Um, um I'm going to have to do it in segments.
40:02 These are very detailed. I do go over a few prices, but..
40:04 if you want to get more information, um, request a video, or little brochure that will tell you about each type of ceremony that they offer,
40:13 it's www.disneyweddings.go.com.

",
"brochure|Source of information
" );

$sth->execute(
        "weddings-4",
        "Wishes Collection",
        "Wishes Collection

40:18 The first collection I'm going to talk about is the Wishes Collection.
40:21 This one allows you to design the wedding of your dreams.
40:23 You choose every detail, from the icing on the cake to the dance floor to your table settings.

",
"icing|dance|settings|Wishes Collection
" );

$sth->execute(
        "weddings-5",
        "Ceremony locations",
        "Ceremony locations

40:28 Ceremony locations, you have um, quite a few to choose from.
40:32 You could do Disney's Wedding Pavilion at the Grand Floridian, Sea Breeze Point at the Boardwalk Resort, the Yacht Club Resort, or Magic Kingdom.
40:40 Those are your choices.

",
"Ceremony locations
" );

$sth->execute(
        "weddings-6",
        "Epcot Ceremony locations",
        "Epcot Ceremony locations

40:42 In Epcot, you could do Italy's courtyard, Isola, which is directly in front of the Italy pavilion, France, Germany, Japan, China or the UK.
40:51 I think all of those are excellent choices, especially China at night.
40:55 That picture that won our photo contest, that would be gorgeous to have a wedding.
40:58 Pete: Yeh, that is.

",
"Pete|Epcot Ceremony locations
" );

$sth->execute(
        "weddings-7",
        "Soloist as wedding entertainment",
        "Soloist as wedding entertainment

00:00 The entertainment that you can choose from: You have soloists, duets, trios and themed entertainment.
00:05 Now for a soloist, you're going to pay between 525 dollars to 820 dollars.
00:10 You can choose from a flutist, a violinist, a harpist, a pianist, a vocalist, or a guitarist.
00:16 Everything is pricey, guys. It is a wedding. And it is Disney. So keep that in mind.

",
"pricey|Soloist as wedding entertainment
" );

$sth->execute(
        "weddings-8",
        "Duos",
        "Duos

00:21 Um, your duets that you could choose from would be an organist-vocalist duo, guitar-flute duo, harp-flute duo, or harp-guitar duo.
00:28 And these range from 650 to 1200 dollars.
00:31 Ha, ha, ha. Pete's rolling his eyes.
00:34 Pete: Wow!
00:34 Jim: You're just imagining the harp and the flute, aren't you. 
00:37 Well, I think for that much money, the duo better be Simon and Garfunkel.
00:43 Laughter
00:43 X: Just thinking how I can do one of these things.
00:44 Oh, you want to be, you want to get paid that money?
00:45 X: The flutist, or something.

",
"rolling his eyes|Simon|Garfunkel|Laughter|Duos
" );

$sth->execute(
        "weddings-9",
        "Themed entertainment",
        "Themed entertainment

00:48 Oh, Ummh, the themed entertainment. These range in price from 500 to 3000 dollars.
00:53 So, you can choose to have confetti cannon, a bagpiper, a Key West style guitarist, a herald trumper, or a herald trumper trumpeter duo.
01:03 You can also have Major Domo dressed in a Renaissance costume.
01:06 He can carry your rings for you.
01:07 Or you can have an English butler in a proper hat and tails.
01:11 To carry your rings out.

",
"Themed entertainment
" );

$sth->execute(
        "weddings-10",
        "Fireworks",
        "Fireworks

01:13 The private fireworks are only at the wedding Pavilion and that's what costs 3000 dollars.
01:17 Pete: Private fireworks? 
01:18 Julie: Mmh-hmm.
01:20 Pete: Like Wishes?
01:21 Jim: They're not very big. They're inside the wedding Pavilion.
01:23 Laughter
01:25 Julie: And they would go off after he pronounces you man and wife.
01:28 X and Jim: With sparklers. Just a couple of cast members with sparklers.
01:31 Laughter
01:34 Julie: Yeh, so, that's quite expensive.
01:36 X: I've seen that happen a couple of times.
01:37 Julie: So I would imagine it's a pretty nice display.
01:40 It's not a, you know, some guy standing back there with his cigarette lighter setting off smoke bombs. 

",
"Wishes|Julie|Pete|X and Jim|Jim|pronounces|man and wife|sparklers|cast members|display|cigarette lighter|smoke bombs|Laughter|Fireworks
" );

$sth = $d->table_info('','','%');
my $tables = $sth->fetchall_hashref('TABLE_NAME');

for my $table ( qw/texts / )
{
        print "$table: $tables->{$table}->{sqlite_sql}\n";
}

#while ( my $id = <STDIN> )
#{
#       chop $id;
#       $sth->execute($id);
#       while (my @r = $sth->fetchrow_array)
#       {
#               $, = "\t";
#               print @r, "\n";
#       }
#       print "\n";
#}

$sth->finish;
$d->disconnect;
