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
        "uniqlo-1",
        "Uniqlo's marketing mix",
	"business",
	"all",
	"Uniqlo is a Japanese clothing brand. It started as a small suit maker in 1963 and is now one of the biggest Japanese clothing companies.

Uniqlo's name has always been connected to the Japanese music scene. Its customers are young and fashionable.

Uniqlo has developed a unique marketing mix. It has the right combination of product, price, promotion and place.

If a clothes company wants to be successful, it needs to have the right marketing mix. Every company has a different marketing mix of product, price, promotion and place.

The product is what Uniqlo sells. The price is how much the customer pays. Promotion is what Uniqlo does to keep Uniqlo in customers' minds. Place is where and how the customer buys Uniqlo clothes.

The company has to make the right decisions about all of product, price, promotion and place to make the most money. And decisions about each of these things affects decisions about the other things.

",
"Uniqlo|Japanese"
	],
	
	[
        "uniqlo-2",
        "Uniqlo's product strategy",
	"business",
	"A",
	"Uniqlo has to design clothes and see if customers like them. But, it also has to know what clothes will be popular in the next six months, in spring or fall, and produce those kind of clothes.

In the fashion industry, clothes are only fashionable for a short time. Uniqlo has to change the style of its clothes all the time.

New styles are developed for the spring and fall season. But when one style of clothes is becoming popular, small changes are continually made in the style to keep it popular.

If these continual small changes are not made, the style can quickly lose popularity.

",
"Uniqlo"
	],
	
	[
        "uniqlo-2",
        "Uniqlo's pricing policy",
	"business",
	"B",
	"Uniqlo has to decide who is going to buy its clothes and decide how much they are willing to pay. It also has to decide how much it costs to produce its clothes. It has to choose a price which covers these costs.

Uniqlo products are medium-priced. People are willing to pay a little more for them because it shows they are successful in their lives.

It is not a low-priced brand. The clothes of people who buy low-priced brands show those people want value for the price they pay.

It is not a high-priced brand. People who buy a high-priced brand will buy it, even if it is cheaper, or even if it is more expensive. People who buy high-priced brands want clothes which are different or have the latest styles.

",
"Uniqlo"
	],
	
	[
        "uniqlo-2",
        "Uniqlo's place strategy",
	"business",
	"C",
	"Place is where Uniqlo products may be bought and also the ways the clothes are delivered or distributed to these places.

Uniqlo controls very carefully the places where its clothes may be bought. It has its own stores, and it has places in department stores, where the customer feels they are in a special Uniqlo store.

It wants to create an environment where the customer has a unique Uniqlo experience. If people can buy Uniqlo clothes anywhere, they don't have that special Uniqlo experience.

And people will think the Uniqlo brand is less fashionable if they can buy Uniqlo clothes anywhere.

",
"Uniqlo|delivered|distributed"
	],
	
	[
        "uniqlo-2",
        "Uniqlo's promotion activities",
	"business",
	"D",
	"The purpose of promotion is to get customers. Promotion includes advertising in magazines or on TV, and mailing of catalogs and newsletters to customers. It also includes getting famous people to wear Uniqlo clothes, the way Michael Jordan endorsed Nike shoes.

Japanese rappers Scha Dara Parr wear Uniqlo clothes. They are paid by Uniqlo to endorse the brand.

Other forms of promotion include discounts, give-away competitions, and participation in public events.

Promotion also includes the style of its public image, that is, the look of Uniqlo stores, Uniqlo displays, Uniqlo packaging and the Uniqlo logo 

All these things have an effect on sales of Uniqlo clothes.

",
"Uniqlo|catalogs|newsletters|Michael Jordan|Nike|Scha Dara Parr|logo"
	],
	
	];

my $questions = [
			[ qw/genre text id target content answer/ ],

[ "business", "uniqlo-1", 1, "all", "Uniqlo's marketing mix is successful.", "True" ],
[ "business", "uniqlo-1", 2, "all", "Uniqlo's decisions about price affect its decisions about promotion.", "True" ],
[ "business", "uniqlo-1", 3, "all", "If Uniqlo decides to sell different clothes, it needs to mind what customers want to pay.", "True" ],
[ "business", "uniqlo-1", 4, "all", "Uniqlo is a young Japanese music maker.", "False" ],
[ "business", "uniqlo-1", 5, "all", "Uniqlo has the same marketing mix as other different companies.", "False" ],
[ "business", "uniqlo-1", 6, "all", "Uniqlo does not make decisions about the combination of product, price, promotion and place in its marketing mix.", "False" ],

[ "business", "uniqlo-2", 1, "A", "If Uniqlo can see what styles will be popular in the next season, it knows if customers will like its clothes or not.", "True" ],
[ "business", "uniqlo-2", 2, "A", "Uniqlo does not have to continue to develop changes to a style if it is becoming popular.", "False" ],
[ "business", "uniqlo-2", 3, "B", "Uniqlo customers will pay more for their clothes because they want to show they are successful", "True" ],
[ "business", "uniqlo-2", 4, "B", "Uniqlo is a low-priced brand, because people who buy it want value for money.", "False" ],
[ "business", "uniqlo-2", 5, "C", "Uniqlo controls the experience customers have by creating a unique experience in its own stores.", "True" ],
[ "business", "uniqlo-2", 6, "C", "People can buy Uniqlo clothes anywhere.", "False" ],
[ "business", "uniqlo-2", 7, "D", "Uniqlo promotes its clothes by advertising and stylizing its public image.", "True" ],
[ "business", "uniqlo-2", 8, "D", "Michael Jordan promotes Uniqlo clothes.", "False" ],

	];

push @$texts, 
[
        "stress-1",
        "Fear",
	"business",
	"A",
	"CLB: So many people have lost their jobs. I am afraid I will be next. Because we work in the Human Resources department, we were responsible for firing those people. Now it is our turn to be fired. It's funny, in a way.

It would be okay if there were less work to do, but with fewer and fewer people here now, there is more and more work to do.

We are under a lot of pressure and there is never enough time to do a good job. In a way, I will be glad when I'm fired. Not really, of course. But, the stress is killing me.

I just can't cope any more. 

",
"CLB|Human Resources"
	];

push @$questions, 
[ "business", "stress-1", 1, "A", "CLB is afraid of losing her job.", "True" ],
[ "business", "stress-1", 2, "A", "The job of the people in the Human Resources Department was to fire people.", "True" ],
[ "business", "stress-1", 3, "A", "There are fewer people, so there is less work to do in the Human Resources Department.", "False" ],
[ "business", "stress-1", 4, "A", "She really will be glad when she has lost her job.", "False" ];

push @$texts,
[
        "stress-1",
        "Pressure and control without support",
	"business",
	"B",
	"SLT: My major complaint is the amount of pressure that management is trying to put on me and my co-workers. It's unbelievable. Everything that doesn't go according to management's plan is my or someone else's fault, management says.

That would be okay if I felt like what I did had an effect. But I don't feel like I have any control over what is happening. Nothing I do seems to have an effect. It's a very stressful situation.

It would also be okay if had some freedom to make my own decisions. But none of us are allowed to think for ourselves. Management is always telling us what to do. Everything we do is monitored. We are expected to follow orders blindly.

And management is not supportive. We are not told we are doing a good job. We are only blamed when management is unhappy. Management doesn't care if we are happy or not. And it doesn't help us to do things which we think are difficult.

I feel like I am falling off a cliff. I can't take it any more.

",
"SLT|monitored|supportive|cliff"
	];

push @$questions, 
[ "business", "stress-1", 1, "B", "SLT feels she has no freedom.", "True" ],
[ "business", "stress-1", 2, "B", "She feels like what she does doesn't help the situation.", "True" ],
[ "business", "stress-1", 3, "B", "She likes to be told what to do.", "False" ],
[ "business", "stress-1", 4, "B", "Management makes it stressful for her by not telling her what to do.", "False" ];

push @$texts,
[
        "stress-1",
        "The physical environment",
	"business",
	"C",
	"RMS: I can't focus on my work, because of the environment. I don't have my own space. I feel like I'm homeless, living in the street. 

Oh, I have a chair and a desk, but I have to share it. And there are always people I don't know walking past me. It is crowded and there are three other people, all in the same area, without even a window.

It's also very noisy with five telephones always ringing, people shouting, and others interrupting me. 

The computers and the air conditioning are noisy too, when they're not broken. Often it's too hot in the office to work.

And of course, I don't have my own computer. I have to share one with the three other people in the same space. I wish they wouldn't download all those files they do. The computer has lots of viruses, of course.

I think I deserve my own office. But I don't get the treatment I deserve from the company, I think.

",
"RMS|homeless|conditioning|viruses|deserve|treatment"
	];

push @$questions, 
[ "business", "stress-1", 1, "C", "RMS thinks he deserves his own computer.", "True" ],
[ "business", "stress-1", 2, "C", "RMS doesn't like the other people downloading files with viruses.", "True" ],
[ "business", "stress-1", 3, "C", "RMS likes the noise of the computers and air conditioning.", "False" ],
[ "business", "stress-1", 4, "C", "RMS always feels at home at the company.", "False" ];

push @$texts,
[
        "stress-1",
        "Slave driver as boss",
	"business",
	"D",
	"Alan: I, and everyone else, is really unhappy with our manager. We can't talk to her. She never listens to what we say. The only time she talks to us is when she has some new order to give us. The only thing she ever says to us is: 'Do this. Do that.' It's impossible to have a conversation with her.

She never tries to understand our point of view. When we ask her for something, the only thing she ever says is, 'No.' Talking to her is like talking to a brick wall. 

I've been patient. We've all been patient, hoping things would change. But the worse the situation the company is in, the worse she has become. She just won't make any effort to see our point of view.

She also never tells us what management is thinking. We have no idea about what management's plans are. If she told us more about what is happening, we would feel much less stress.

Whenever she does speak to us, it is only to criticize us and to blame us for things that are not our fault and to say other unpleasant things. 

We meet our targets, we work long hours. But she never says, 'Well done.' It's very demotivating.

",
"Alan|brick wall|patient|criticize|unpleasant|targets|demotivating"
	];

push @$questions, 
[ "business", "stress-1", 1, "D", "Alan says his manager won't tell him what is happening.", "True" ],
[ "business", "stress-1", 2, "D", "When the manager talks to Alan, she says, Do this, do that.", "True" ],
[ "business", "stress-1", 3, "D", "The manager orders Alan to have a conversation with her, and tell her what he is doing.", "False" ],
[ "business", "stress-1", 4, "D", "Management makes it stressful for Alan by telling him what is happening.", "False" ];

push @$texts,
[
        "stress-2",
        "Medical improvements",
	"business",
	"A",
	"Alan: If we are going to improve our staff's well-being, I think we should offer a free medical check-up every year, and bring in consultants, like Alan Bradshaw, to help with the stress levels.

Someone like him could identify stress hotspots in the company and raise managers awareness of stress and train them in ways to reduce the stress they put on their staff, while still making sure that they get the work done. 

We have a company nurse, but she doesn't have the ability to identify causes of stress. I really think we need a professional stress consultant.

The last thing I think which is important to improving staff well-being is the question of smoking. Healthy workers are happy workers. I think it would be a good idea to have a no-smoking policy everywhere in the company.

So, those are my three recommendations: One, free medical check-ups. Two, a stress expert from outside the company. And, three, a no-smoking policy.

",
"well-being|check-up|consultants|Alan|identify|staff|nurse|professional|policy|recommendations"
	];
	
push @$questions, 
[ "business", "stress-2", 1, "A", "Alan says the company should bring in people like Bradshaw to help with staff's well-being.", "True" ],
[ "business", "stress-2", 2, "A", "Alan thinks the nurse could not help reduce the company's stress level.", "True" ],
[ "business", "stress-2", 3, "A", "Alan recommends, one, free smoking, two, stress hotspots and three, no stress.", "False" ],
[ "business", "stress-2", 4, "A", "Alan, the worker recommending improvements, is Alan Bradshaw, the outside stress expert.", "False" ];

push @$texts,
	[
        "stress-2",
        "Food changes",
	"business",
	"B",
	"BDL: I think the best thing to improve the health and well-being of our staff is to improve the food in the company cafeteria. Generally, the food here isn't healthy. If someone just ate the food available in the company cafeteria, they wouldn't be getting a balanced diet. There is too much fatty, salty, starchy and sweet food, and not enough fish, fruit and vegetables.

And the food here is not good for people's stress levels. You know how drinking coffee or coke can make you feel more tense and excited? That's stress. And research has shown that fatty, salty, starchy and sweet foods also raise people's stress levels.

To reduce these levels, we need to have more natural foods, like fish, fruit and vegetables, in the cafeteria. Perhaps they don't taste so good as the food we have now, but people will feel more relaxed and will live better lives.

",
"BDL|well-being|cafeteria|diet|starchy|tense|natural"
	];

push @$questions, 
[ "business", "stress-2", 1, "B", "BDL shows that food perhaps may improve stress levels in the company.", "True" ],
[ "business", "stress-2", 2, "B", "BDL thinks the cafeteria should have more natural food and less food that tastes good.", "True" ],
[ "business", "stress-2", 3, "B", "BDL thinks that fish and vegetables would improve the taste of the food in the company", "False" ],
[ "business", "stress-2", 4, "B", "BDL shows food that tastes good would improve stress levels in the cafeteria.", "False" ];

push @$texts,
	[
        "stress-2",
        "Sports center",
	"business",
	"C",
	"SLT: To reduce stress here at the company, I think it's important that everyone be involved in a lot of physical activity, like jogging, or swimming, or basketball.

It would be nice to have our own basketball court and swimming pool, but that would be very expensive.

Instead, I think we should talk to the manager of the local sports center and arrange a group membership for everyone at the company. That would probably also be expensive, but the sports center has a good pool and a sauna.

I think a lot of workers would enjoy a swim at lunch time or after work. The sauna is also very relaxing.

And I'm sure their basketball court would be very popular. Even now, many people here are members of the sports center, and they use the basketball court during the lunch hour or after work.

They also have a weight room, where people can use exercise machines.

",
"SLT|physical|membership|sauna|court|weight"
	];

push @$questions, 
[ "business", "stress-2", 1, "C", "SLT would like the company to have memberships for everyone at the sports center.", "True" ],
[ "business", "stress-2", 2, "C", "The sports center has a basketball court, swimming pool, sauna and weight room.", "True" ],
[ "business", "stress-2", 3, "C", "SLT thinks the company should have its own basketball court and swimming pool.", "False" ],
[ "business", "stress-2", 4, "C", "Now not many people use the local sports center. They don't have memberships.", "False" ];

push @$texts,
	[
        "stress-2",
        "Company tours",
	"business",
	"D",
	"KED: I think, to improve everyone's well-being and reduce stress at the company, we should have company tours. Every month, we should all go in buses to an amusement park, or climb a mountain and have a picnic.

Once or twice a year, we should travel to some place of interest, here or overseas, and spend a few days together seeing scenic spots, and having fun.

As an example, I think it would be fun and relaxing for everyone in the company to go to Korea and go shopping and eat Korean food, and bring back some Korean souvenirs.

In winter, we could go skiing there. In summer, it would be nice too, because it would be a lot cooler than Taiwan.

When people are having fun, they can forget about work, and they will come back with good feelings about the company.

So, my idea is one-day company tours, once a month, and three- or four- day tours, once or twice a year.

",
"KED|amusement|picnic|scenic|Korea|winter|skiing"
	];

push @$questions, 
[ "business", "stress-2", 1, "D", "KED thinks it would be fun to go to Korea with people from the company.", "True" ],
[ "business", "stress-2", 2, "D", "KED's idea is that everyone should go on monthly company tours.", "True" ],
[ "business", "stress-2", 3, "D", "KED thinks some people should go to Korea once a month to go shopping.", "False" ],
[ "business", "stress-2", 4, "D", "KED thinks it would be too cold in Korea in winter to go there.", "False" ];

push @$texts,
[
        "conference",
        "Importance of venue",
	"business",
	"A",
	"Alex: Only six more weeks to go till the big day. I'm already full of trepidation.
Max: So am I! We know we've got to get this right. It's a key event for the company. And it will affect our image.
Alex: I'm sure it will! That's why we have to be careful when choosing the venue. So, let's put our heads together... What sort of venue do we need? Let's try and come up with a list of essentials.

Max: It's certainly got to have a spacious conference room.
Alex: Absolutely! We're expecting over seventy delegates, so we'll definitely need a large conference room. In addition, let's not forget that at times, the participants will have to split up into special interest groups, so we'll need access to a number of seminar rooms as well. How many do you reckon?
Max: Preferably four, I'd say, but if we can have more, all the better... Now then ... what else?

",
"Alex|Max|trepidation|spacious|delegates|participants|seminar|Preferably"
	];
	
push @$questions, 
[ "business", "conference", 1, "A", "The conference is a large event for the company.", "True" ],
[ "business", "conference", 2, "A", "Max and Alex need a list of essentials to choose the venue.", "True" ],
[ "business", "conference", 3, "A", "They've already got the right venue, so there's no need for a list.", "False" ],
[ "business", "conference", 4, "A", "They have to be careful because the venue is full already.", "False" ];

push @$texts,
	[
        "conference",
        "Conference spaces",
	"business",
	"B",
	"Max: It's certainly got to have a spacious conference room.
Alex: Absolutely! We're expecting over seventy delegates, so we'll definitely need a large conference room. In addition, let's not forget that at times, the participants will have to split up into special interest groups, so we'll need access to a number of seminar rooms as well. How many do you reckon?
Max: Preferably four, I'd say, but if we can have more, all the better... Now then ... what else?

Alex: Remember the problems we had last year with late arrivals and early departures? Some people spent more time on the airport shuttle than they did on the plane?
Max: Yeah. That was pretty disastrous. We can't allow that to happen again. The venue's got to be within reasonable distance of an international airport.

",
"Max|Alex|spacious|arrivals|departures|shuttle|disastrous|reasonable"
	];

push @$questions, 
[ "business", "conference", 1, "B", "The seminar rooms are for when the participants split up into special interest groups.", "True" ],
[ "business", "conference", 2, "B", "The large conference room has got to be spacious, because they expect over seventy delegates.", "True" ],
[ "business", "conference", 3, "B", "The conference room is for the special interest groups and the seminar rooms are for the late arrivals", "False" ],
[ "business", "conference", 4, "B", "More than four seminar rooms will not be better.", "False" ];

push @$texts,
	[
        "conference",
        "Access to conference venue",
	"business",
	"C",
	"Alex: Remember the problems we had last year with late arrivals and early departures? Some people spent more time on the airport shuttle than they did on the plane?
Max: Yeah. That was pretty disastrous. We can't allow that to happen again. The venue's got to be within reasonable distance of an international airport.

Alex: Right. Let's recap and see what we've got so far ... Three things, I think: reasonable access to an international airport as you've just said. Next, one large conference room, and then preferably four or more seminar rooms. We're getting there ... Anything else?

",
"Alex|Max|disastrous|recap"
	];

push @$questions, 
[ "business", "conference", 1, "C", "They want to allow people to arrive at the venue from the airport quickly.", "True" ],
[ "business", "conference", 2, "C", "Having a venue near an airport will allow people more time at the conference.", "True" ],
[ "business", "conference", 3, "C", "Last year, there was a plane disaster at the conference venue.", "False" ],
[ "business", "conference", 4, "C", "Last year, the conference was in reasonable distance of an international airport.", "False" ];

push @$texts,
	[
        "conference",
        "Leisure activities",
	"business",
	"D",
	"Alex: Right. Let's recap and see what we've got so far ... Three things, I think: reasonable access to an international airport as you've just said. Next, one large conference room, and then preferably four or more seminar rooms. We're getting there ... Anything else?

Max: Fun, of course! All work and no play makes managers dull conference participants. So the venue's got to provide a wide choice of leisure activities.
Alex: Fine. Let me write that down .. so .. a wide choice of leisure activities. Yeah, I agree, that's important. The conference program's really intensive, so the delegates will need to relax, I'm sure.

",
"Alex|Max|dull|intensive|access|reasonable"
	];

push @$questions, 
[ "business", "conference", 1, "D", "The conference is very intensive, so it has got to be at a fun venue, ", "True" ],
[ "business", "conference", 2, "D", "If there is no play at the conference, the participants will be very dull.", "True" ],
[ "business", "conference", 3, "D", "The conference is sure to be intensive, so preferably delegates will not relax.", "False" ],
[ "business", "conference", 4, "D", "Managers make conferences dull, so preferably they will choose to do leisure activities.", "False" ];

push @$texts,
[
        "hotels",
        "Moroccan hotel",
	"business",
	"A",
	"The Long Beach Hotel in Casablanca, Morocco is a five-star hotel on the beach, so it is very nice, but there is not much to do in the area around the hotel. 
    
It has a lot of nice facilities, like a large swimming pool and a sauna, and a very large tropical garden where you can sit and eat and drink. It also has shops and a good nightclub where you can have fun in the evening.

But there is not much you can do when you go outside the hotel. The town is one hour away by car. (The airport is the same distance away.) 

There are two large conference rooms which both hold seventy people, but there are no smaller seminar rooms for smaller groups. This will be a big problem, because the conference participants will split up into smaller special interest groups to discuss things that are important for them.

The cost of the venue works out at 1,500 dollars per participant. This includes all meals and entertainment at the night club and other places.


",
"Casablanca|Morocco"
	];
	
push @$questions, 
[ "business", "hotels", 1, "A", "The hotel doesn't have seminar rooms.", "True" ],
[ "business", "hotels", 2, "A", "The hotel is close to the airport.", "False" ];

push @$texts,
	[
        "hotels",
        "Czech hotel",
	"business",
	"B",
	"Hotel Moda in Prague, the capital of the Czech Republic, is a four-star hotel, but it is quite a lot cheaper than the other hotels and there are a lot of things to do and see in Prague.
    
The hotel is a little older and smaller than the other hotels. But the bedroom are large and there is one conference room and two seminar rooms, so participants will be able to split up into three or more special interest groups.

Other attractions include a large swimming pool (which is, however, open to the public), a sauna, a hairdressing salon and satellite TV.

The price of 950 dollar per participant includes meals and two guided tours. Prague is a very interesting old city, so there is a lot to do in it. However the hotel is a half-hour subway ride away from the center of the city, and the hotel, and Prague, generally, is very crowded in summer.


",
"Moda|Prague|Czech|hairdressing salon"
	];

push @$questions, 
[ "business", "hotels", 1, "B", "The hotel is the cheapest of the hotels.", "True" ],
[ "business", "hotels", 2, "B", "There is not much to do in Prague.", "False" ];

push @$texts,
	[
        "hotels",
        "Island hotel",
	"business",
	"C",
	"Hotel Matong, on Tiamon, an island off the east coast of Malaysia, is a five-star hotel with a relaxing atmosphere, but it is a long way to the nearest airport.

It is quite a large hotel, so there are many large and small conference rooms. People can split up into many small special interest groups. It also has beautiful tropical gardens where you can sit and talk. There is also a golf course, tennis courts, and a soccer field.

The cost of the venue is 1,350 dollars per participant, including meals. There is perhaps less to do than at the other three hotels, but this may be okay if the purpose of the conference is to discuss business problems.

The beautiful island setting is peaceful and quiet, so participants may be able to get a lot done. The disadvantage is that it is a long way from the nearest airport. You have to ride a boat to get to the island.

",
"Matong|Tiamon"
	];

push @$questions, 
[ "business", "hotels", 1, "C", "There may not be much to do on the island.", "True" ],
[ "business", "hotels", 2, "C", "It is not very relaxing at the hotel because of the soccer, tennis and golf.", "False" ];

push @$texts,
	[
        "hotels",
        "Las Vegas hotel",
	"business",
	"D",
	"The Hotel Colossus is a big hotel in Las Vegas, in the U.S. It is the most expensive of the four hotels, but it has the most facilities.

The five-star hotel looks magnificent and has very big bedrooms, outstanding conference rooms, and many smaller seminar rooms, which however cost extra.

The price is 1,950 dollars, including meals, and one tour, and each participant gets fifty dollars spending money at the casino which is in the hotel, itself.

Las Vegas is famous for casinos, but there are many other things that visitors can do in and around Las Vegas. The free use of a car to get to these places is included in the price.

Of course, the casinos are the big attraction. This may be a disadvantage because the hotel is very, very busy, day and night. It may be difficult to keep tourists out of the conference area, and separate them from participants.

The airport is close to Las Vegas, so this is one advantage of the venue.

",
"Colossus|Las Vegas|casino"
	];

push @$questions, 
[ "business", "hotels", 1, "D", "The hotel has a casino.", "True" ],
[ "business", "hotels", 2, "D", "The disadvantage is there is no way to get to places.", "False" ];

push @$texts,
[
        "plans",
        "Creating plans",
	"business",
	"A",
	"It's important to have clear goals. Running a business is like taking a trip. Just remember that if you don't know where you want to go, and you go ahead without a plan, it's your fault when you are unhappy about what happens to the business. Choose a structure carefully for your business based on that plan. That structure will determine how the business is run.

Planning is very, very important. Before talking to people who want to use your service or product, you need to do a lot of planning. But it is also very important to talk to clients. You need to see if you have what they are looking for. If you don't have what they want, perhaps your business plans won't be successful.

",
"fault|based|clients"
	];

push @$questions, 
[ "business", "plans", 1, "A", "If you don't know what you want your business to do, perhaps it won't be successful.", "True" ],
[ "business", "plans", 2, "A", "Before planning your business, you need to see if people want what you have.", "False" ];

push @$texts,
	[
        "plans",
        "Working with plans",
	"business",
	"B",
	"Businesses never stop learning new things. The people who run businesses should never stop learning. Business plans may or may not need to change with that new learning. The hard work that goes into creating a business plan will be repaid again and again, if the plan is constantly held in mind. The plan should not be regarded as a boring thing that you create only because other people, for example, your bank or shareholders, want to see it.

The plan you have written down can be shown to many different people whenever they want to see a business plan. So the hard work writing down the business plan also should not be regarded as a waste of time. It can be reused many times.

",
"repaid|constantly|shareholders"
	];

push @$questions, 
[ "business", "plans", 1, "B", "New learning should constantly be held in mind when considering business plans and whether they need to change.", "True" ],
[ "business", "plans", 2, "B", "The business plan that you create is a thing that should not be shown to other people.", "False" ];

push @$texts,
	[
        "plans",
        "Ownership of the plan",
	"business",
	"C",
	"Businesses which grow fast always have good plans and good business planning processes. This has been identified as one of the main reasons for their success. The best business get all the people in the business excited about the plan and make sure everyone feels the company's goals are their personal goals.

You can't impose a plan on people and expect them to get excited about it and to follow it.  Everyone needs to know what the goal of the company is and to be excited about having a role in reaching that goal. That only happens when everyone feels they themselves are creating the goals of the company and new goals for themselves, at the same time. It doesn't happen when people feel they are just following someone else's goals.

",
"identified|impose"
	];

push @$questions, 
[ "business", "plans", 1, "C", "At businesses which grow fast, people feel they have a role in creating and reaching the goals of the company.",  "True" ],
[ "business", "plans", 2, "C", "To grow a business fast, you need to impose a plan. You can't expect everyone to feel excited about the plan.", "False" ];

push @$texts,
	[
        "plans",
        "William Kendall",
	"business",
	"D",
	"William Kendall is a successful businessman who became very good at planning ahead. When he owned a business called Covent Garden Soup Company, he found it very difficult to sell it. That was because everyone thought he was a very good businessman. They thought if they bought the company, they wouldn't do as well as him running it. So they thought it would not be a good idea to buy it.

Therefore, when he started at his next company, Green and Black Chocolates, he immediately started thinking about how to sell it. He went to a very big chocolate company, Cadbury's and asked them if they would like to invest ten percent in the company. They did. And now Cadbury's has bought all of his company. That was his plan.

",
"Covent Garden Soup|Cadbury's|invest"
	];

push @$questions, 
[ "business", "plans", 1, "D", "Everyone thought Kendall's company wouldn't be as good if they bought it. So they didn't.", "True" ],
[ "business", "plans", 2, "D", "Kendall didn't plan that Cadbury's would buy his chocolate company.", "False" ];

push @$texts,
[
        "kendall",
        "William Kendall and the New Covent Garden Soup Company",
	"business",
	"A",
	"William Kendall's parents had a successful farm, so he was learning about the business of food from childhood. He later became a lawyer and a banker and this helped him learn about business practices.

His wife had also inherited a farm, but she and her family knew nothing about farming. Helping her family running the farm, he learned how to cook. He enjoyed making soup. He thought selling fresh soup would be a good idea. He thought fresh soup would be popular, and he could make a lot of money, because it tastes better than soup in a can.

A company which also had the idea of selling fresh soup contacted him and he started working there. After some years he became the chief executive of the company, called the New Covent Garden Soup Company. He stayed there for nine years. And sales went from two million pounds to more than twenty million pounds.

When he saw that the New Covent Garden Soup Company had become successful and there was little for him to do, he decided he wanted to do something else. But it was difficult for him to find someone to buy the business from him. People realized that the company was successful because he was in control. They thought that if someone else took over the company, it wouldn't be as successful as it had been before.

It took him two years to get a shareholder of the New Covent Garden Soup Company to buy the company. The shareholder was only willing to take over the New Covent Garden Soup Company if William Kendall joined this other company.

",
"William Kendall|practices|inherited|chief executive|Covent Garden|shareholder"
	];

push @$questions, 
[ "business", "kendall", 1, "A", "People thought the business was successful because he was running it.", "True" ],
[ "business", "kendall", 2, "A", "People wouldn't take over the company because it was successful.", "False" ];

push @$texts,
	[
        "kendall",
        "William Kendall and organic food",
	"business",
	"B",
	"While William Kendall was at the New Covent Garden Soup Company, the company started marketing organic soups, soups made from vegetables grown without any farm chemicals, in addition to soups made from ordinary materials treated with farm chemicals.

These organic soups were very popular. Kendall realized that lots of people wanted to eat food that was organic and made from natural, unpolluted ingredients. He stopped using farm chemicals on his own farm and with the money he made selling his share of the New Covent Garden Soup Company he bought Green and Black Chocolate from Craig Sams, a very strong supporter of organic foods. Green and Black Chocolate was completely organic. It had no farm chemicals.

Green and Black Chocolate was very popular with people who only ate organic foods. But Kendall could see that everyone was concerned about healthy food and he believed that Green and Black would become more and more popular in the future.

William Kendall didn't believe in organic foods when he was young. But he saw the success of organic soups and Green and Black Chocolate and that interested him. He realized that people wanted to be connected to the food they eat. They wanted to know about the food they eat. They wanted to have a personal relationship with the food they eat and the people who grow it.

When he took over Green and Black, the company had sales of two million pounds. When the company was sold to a very big chocolate company, six years later, it had sales of twenty-two million pounds.

",
"William Kendall|Covent Garden|chemicals|unpolluted|Chocolate|Craig Sams|supporter"
	];

push @$questions, 
[ "business", "kendall", 1, "B", "The chocolate was more popular with people who ate organic foods. But later it became very popular with everyone.", "True" ],
[ "business", "kendall", 2, "B", "He didn't believe organic foods and chocolate could become popular.", "False" ];

push @$texts,
	[
        "kendall",
        "Planning to sell the business",
	"business",
	"C",
	"<NOT SO IMPORTANT>

William Kendall didn't believe in organic foods when he was young. But he saw the success of organic soups and Green and Black Chocolate and he thought that was interesting. He realized that people wanted to be connected to the food they eat. They wanted to know about the food they eat. They wanted to have a personal relationship with the food they eat and the people who grow it.

People who eat organic food feel they are connected to the food because they are eating food which is pure and does not have chemicals added to it. They feel they know this food and the people who grow it better. It feels more like real food.

When he took over Green and Black, he had to think about what would happen if Green and Black, which was organic, became very popular. Green and Black was already very popular with people who were strong supporters of organic food like its founder, Craig Sams, but not very popular with people who normally didn't think much about organic food. They didn't know about the chocolate, or felt it was different and strange.

</NOT SO IMPORTANT>

But William Kendall was expecting that everyone would start buying the chocolate. When it became very popular, he thought he would want to sell his share in it and start another business.

What he did was get Cadbury's, a very big chocolate company, but which does not produce organic chocolate, to buy five percent of the company's shares. Some people said Green and Black should not have a relationship with a non-organic chocolate company. They thought it was a bad idea, but he thought it was a good idea, because small companies like Green and Black need to cooperate with big companies, like Cadbury's, rather than compete with them. He thought if they compete with them, they must lose.

Only a very big company would be able to buy Green and Black if its chocolates became very popular. And it would be easier for a company with a cooperative relationship with Green and Black to buy it than a company with a competitive relationship.

Then, in only six years, sales rose from two million pounds to twenty-two million pounds.

When Cadbury's bought Green and Black, a lot more people who believed in organic food were very unhappy. But William Kendall was very happy, because he had made a lot of money and his plan had worked.

He had involved a very big company in his business from the start, and they were very willing to take over the business when it made a lot of money.

",
"<NOT SO IMPORTANT>|</NOT SO IMPORTANT>|William Kendall|organic|Chocolate|connected|personal|pure|chemicals|supporters|Craig Sams|founder|share|Cadbury's|cooperate|compete|involved"
	];

push @$questions, 
[ "business", "kendall", 1, "C", "He had a cooperative relationship with the big chocolate company. His plan was that it buy his company.",  "True" ],
[ "business", "kendall", 2, "C", "Everyone who believed in organic chocolate was happy when the big chocolate company bought his company.", "False" ];

push @$texts,
	[
        "kendall",
        "Motivation and control",
	"business",
	"D",
	"<NOT SO IMPORTANT>
	
Teresa Graham said in the most successful businesses, all the people at the company feel they are part of the plan. Everyone understands what the company is trying to do and everyone believes what they do helps the company achieve its goals.

She says this is really important and one of the reasons for their success.

But how do you get everyone in the company to feel that they are an important part of the company's plans? You can't just tell people what the plan is and expect them to follow the plan. If you tell people your plan for your business, Teresa Graham says only some people will follow the plan. The best employees will not follow the plan.

She says businesses need to involve everyone in the company in the discussion and creation of their plans. She says the way to make sure everyone plays their part in achieving the company's goals is to make sure everyone takes part in creating the plans.

Everyone needs to understand how what they do helps the company achieve its goals, and everyone needs to have personal goals, which they believe in and are connected to the company's goals. When everyone knows what the company is trying to do, and everyone is excited about helping, the company has lots more power.

This only happens when people feels they played a a part in developing the company's plans.

</NOT SO IMPORTANT>

William Kendall has something similar, but different, to say about the role of the company's leaders in managing people. He says the company's owners need to give their managers lots of freedom. He says the company's owners need to find skilled managers and let them do their job the way the managers want to.

The owners shouldn't be telling their managers how to do their job. The owners have to concentrate on growing the business, and thinking about how the company can develop new plans, not about how people should be carrying out the plans the company has already developed.

When William Kendall first was a businessman at the New Covent Garden Soup Company, he said they made many mistakes. He said they tried to do everything themselves. Later he said they brought in a group of skilled managers to do marketing, production and administration at the company. This took pressure off the owners and they could spend their time thinking of what the company should do next.

He says managers should not be given too much freedom, but he also said sometimes too much freedom is better than too little freedom.

He says at the New Covent Garden Soup Company he learned how to give people a lot of freedom, but not too much freedom. The problem is getting everyone in the business excited about reaching the company's goals and making sure they only do what they are supposed to do to at the same time. The business's employees need to be motivated, but they also need to be controlled.

",
"<NOT SO IMPORTANT>|</NOT SO IMPORTANT>|Teresa Graham|William Kendall|role|skilled|concentrate|Covent Garden|freedom"
	];

push @$questions, 
[ "business", "kendall", 1, "D", "He says freedom and control are both important, and managers are motivated by freedom.", "True" ],
[ "business", "kendall", 2, "D", "He says it is better to do everything rather than have managers with too much freedom.", "False" ];

push @$texts,
[
        "sales",
        "More effective sales activity meeting",
	"business",
	"A",
	"A year ago, two marine equipment manufacturers, Muller and Peterson joined to form a large company, MPM. The Muller and Peterson sales teams were put together, and the Muller Sales Manager, that is, you, became Sales Manager of the new team and Peterson's Sales Manager, that is, B, became Deputy Sales Manager.
    The ideas of the two sales teams were very different. A meeting is going to be held to decide how the two teams can work together more effectively. You will lead the meeting with the support of B, the Deputy Sales Manager. It is your job to listen to the sales people's opinions and to agree on a plan which will improve the atmosphere in the department and help staff to work together more effectively.
    IMPORTANT NOTE: In fact, you are impressed by the Muller sales representatives. You think they are better sales people than the Peterson ones. You think their ambition and energy are good for the company. They also make more money for the company.

",
"marine|Muller|Peterson|Deputy"
	];

push @$questions, 
[ "business", "sales", 1, "A", "You are the manager of the MPM sales team and B is your deputy.", "True" ],
[ "business", "sales", 2, "A", "You think the Peterson sales representatives have more ambition and energy than the Muller ones.", "False" ];

push @$texts,
	[
        "sales",
        "More effective sales activity meeting",
	"business",
	"B",
	"A year ago, two marine equipment manufacturers, Muller and Peterson joined to form a large company, MPM. The Muller and Peterson sales teams were put together, and the Muller Sales Manager, that is, A, became Sales Manager of the new team and Peterson's Sales Manager, that is, you, became Deputy Sales Manager.
    The ideas of the two sales teams were very different. A meeting is going to be held to decide how the two teams can work together more effectively. A, as Sales Manager, will lead the meeting, and you, as Deputy Sales Manager, will help him/her.  It is your job to listen to the sales people's opinions and to agree on a plan which will improve the atmosphere in the department and help staff to work together more effectively.
    IMPORTANT NOTE: In fact, you are impressed more by the Peterson sales representatives. You think they have a more positive attitude. You think their efficiency and good customer service are important for the future success of the company.

",
"marine|Muller|Peterson|Deputy"
	];

push @$questions, 
[ "business", "sales", 1, "B", "You are the deputy manager of the MPM sales team and your job is to help A, the MPM sales manager.", "True" ],
[ "business", "sales", 2, "B", "In your opinion, the Peterson sales representatives can improve their attitude, their efficiency and their customer service.", "False" ];

push @$texts,
	[
        "sales",
        "Muller sales representatives' ideas",
	"business",
	"C",
	"You are a member of the Muller sales team which has been joined with the Peterson sales team in a new company, MPM. The other team was very different. There is going to be a meeting to decide how the two teams can work together more effectively. The meeting will be run by the Sales Manager (A) and the Deputy Sales Manager (B).
    Relationships: Your team is mainly interested in how much money you can make. You think the company's main aim is to maximize profit.
    Delivery dates: You promise early delivery dates, but the company often cannot meet the dates, and customers complain.
    Reports: You often send in short sales reports which are late and incomplete. And you often forget to send follow-ups when customers place an order.
    Payment system: You are happy with the present system of low basic salary and high commission.
    Sharing information: You are competitive and keep information to yourself, rather than sharing it with co-workers.
    Customer loyalty: You are an aggressive sales person and put pressure on the customers to buy. You often give expensive gifts to customers to buy their loyalty.

",
"Muller|Peterson|MPM|Deputy"
	];

push @$questions, 
[ "business", "sales", 1, "C", "You are aggressive and promise early delivery but the company cannot deliver by that date.",  "True" ],
[ "business", "sales", 2, "C", "You are happy with a low salary, because you cannot put pressure on your manager.", "False" ];

push @$texts,
	[
        "sales",
        "Peterson sales representatives' ideas",
	"business",
	"D",
	"You are a member of the Peterson sales team which has been joined with the Muller sales team in a new company, MPM. The other team was very different. There is going to be a meeting to decide how the two teams can work together more effectively.
    Relationships: Your team is interested in working as a team, not how much money you make. You think the company's main aim is to keep the customer happy. Then it will make a profit.
    Delivery dates: You believe the company should always meet its delivery dates. So you don't promise early delivery dates.
    Reports: You always send in good, informative sales reports before the deadline. And you always send follow-ups when customers place an order.
    Payment system: You would like a higher basic salary and bonuses if you exceed the monthly target.
    Sharing information: You believe staff should share information about customers to maximize sales.
    Customer loyalty: You do not put pressure on the customers to buy. You do not give expensive gifts to customers. You build loyalty by gaining their trust.

",
"Muller|Peterson|MPM"
	];

push @$questions, 
[ "business", "sales", 1, "D", "Your team shares information because you believe it should work as a team.", "True" ],
[ "business", "sales", 2, "D", "You believe you should not make a profit, because it would not make the customer happy.", "False" ];

push @$texts,
[
        "nicholson",
        "Nicholson on management",
	"business",
	"A",
	"Managers need to understand what motivates people. There are some things that motivate everyone, like, people care about their families, everybody wants to make a difference, everybody wants to be respected. But then, more difficult is understanding how everyone is unique and different. And different to the way that you as a manager think. The secret, therefore is to try to know what the world looks for them, through their eyes, that is, the eyes of another person.
  In order to do that, you need to be good at asking questions and listening to people. You need to ask not just any question, but questions that really tell you about what a person's drivers, or unique motivators are. You need to ask questions to find out what other people are concerned about in this situation that you and they are both in.

",
"drivers"
	];

push @$questions, 
[ "business", "nicholson", 1, "A", "Everyone is different but some things motivate everyone.", "True" ],
[ "business", "nicholson", 2, "A", "Good managers get everyone to think the same things.", "False" ];

push @$texts,
	[
        "nicholson",
        "Nicholson on management",
	"business",
	"B",
	"Everything is happening much faster nowadays. We used to be going at fifty kilometers per hour. And now we are going at one hundred and fifty kilometers per hour. People are doing more and trying to do more and more in less and less time. Efficiency is good, but because people are working so hard, they don't have time to think about their goals and what they are trying to achieve. The most important things is to stand back and take a bird's eye view, or the view from a helicopter and see how everything fits into the bigger picture, and to take time to reflect. We don't do enough thinking, reflecting, about what we are trying to do. It's one of the things that get driven out by the time pressure that every one is under. So, standing back and taking the wider view is what I recommend people to do.

",
"Efficiency|helicopter|reflect"
	];

push @$questions, 
[ "business", "nicholson", 1, "B", "Everything is going faster, so people have no time to think about they're doing.", "True" ],
[ "business", "nicholson", 2, "B", "Everything is going faster, so people have a good bird's eye view of the bigger picture.", "False" ];

push @$texts,
	[
        "nicholson",
        "Nicholson on management",
	"business",
	"C",
	"Working with people from other countries can be difficult, because what you think isn't what people from other cultures think. We assume everyone thinks the same way, but that's not true. Normally, we don't even think about the differences in the way people think. Of course, when we do work with people from other countries, we realize they are different and they think differently. But do they think the same thing about us? Do they think we are different, or do they think they are the same as us? 
  
Actually, the cultural differences, although they're important, are not very big. The real differences are the differences between individual people. Just because everyone from Africa looks the same, that doesn't mean they all think the same. Just because everyone from India looks the same, doesn't mean they all think the same. They're all unique and you need to remember that. Treat everyone as an individual, not according to your understanding of the cultural group.

",
"India|Africa"
	];

push @$questions, 
[ "business", "nicholson", 1, "C", "Cultural differences are real but not as important as individual differences.",  "True" ],
[ "business", "nicholson", 2, "C", "People from India or from Africa are all the same.", "False" ];

push @$texts,
	[
        "nicholson",
        "Nicholson on management",
	"business",
	"D",
	"Nicole Wilson: I am a woman and I am a manager. My boss always takes my good ideas to the owner of the company and says they are his own, thus getting all the credit. I have decided to resign, because he is stealing my ideas.
  Nigel Nicholson: Women often suffer from this kind of treatment. But look on the bright side: your boss likes your ideas.  It's the credit you're missing.

  What you could do is put your ideas down in writing, and arrange meetings to talk about them with the boss. Say you want to cooperate. Emphasize your desire to collaborate with your boss for the sake of the company. At the meeting, tell him what he could do to support you better and ask him what you could do to support him better. This would give you the opportunity to say that you would like more explicit recognition for your good ideas. But be prepared for your boss to ask you to do more for him.


",
"Nicole Wilson|Nigel Nicholson|suffer|collaborate|explicit"
	];

push @$questions, 
[ "business", "nicholson", 1, "D", "The woman tells the boss her good ideas but the boss tells the owner they are his ideas.", "True" ],
[ "business", "nicholson", 2, "D", "The boss tells the owner of the company he is stealing the woman's ideas.", "False" ];

push @$texts,
[
        "oliver",
        "The difficult sales rep",
	"business",
	"A",
	"You are Charles, the chief executive of a camping equipment company in France. Jacques is your production manager. He is responsible for making the tents and other equipment that your company sells. Todd is your marketing manager. He is responsible for selling your products. The marketing department is very successful, partly because Oliver, one of Todd's sales representatives is a very good salesman. You like both Oliver and Todd. But Oliver and Todd are fighting. You agree Oliver is a difficult employee, but you have been friends with him for years. He is very valuable to the company. You'd like to keep Oliver happy if possible, and to find ways to deal with the situation. The sales from his area amount to twenty-four percent of the business's total sales.

",
"Charles|France|Jacques|Todd|Oliver"
	];

push @$questions, 
[ "business", "oliver", 1, "A", "", "True" ],
[ "business", "oliver", 2, "A", "Good managers get everyone to think the same things.", "False" ];

push @$texts,
	[
        "oliver",
        "The difficult sales rep",
	"business",
	"B",
	"Oliver: I've been thinking a lot recently, Todd. I think you probably know, I'm not happy here at all. And I feel I've got to do something about it.
Todd: Really? What exactly is the problem?
Oliver: I think you know it, Todd. Jacques let me down badly with that order. He just wouldn't make any effort for me, so we've lost the order. It means I don't get the commission, and it'll also affect my bonus.
Todd: Oliver, you must understand. You can't promise a customer that we'll deliver in three weeks. It's a busy time at the moment. Jacques's working under a lot of pressure.
Oliver: Maybe, but let's face it. Jacques's no good as a production manager. He can't deal with pressure. He just says, Sorry I can't help. But it's not just Jacques..
Todd: Oh yes?
Oliver: Well, to be honest, I'm not happy with the way you run the department.


",
"Oliver|Todd|Jacques"
	];

push @$questions, 
[ "business", "oliver", 1, "B", "Oliver is not happy with the way Jacques deals with his orders,", "True" ],
[ "business", "oliver", 2, "B", "Oliver lets Jacques get his commission and bonus.", "False" ];

push @$texts,
	[
        "oliver",
        "The difficult sales rep",
	"business",
	"C",
	"Oliver: Well, to be honest, I'm not happy with the way you run the department.
Todd: I'm listening.
Oliver: The trouble with you is, you always want to know where I am, every second of the day. You give me no space. You want to control me all the time. How can I meet my sales targets if I have to spend all the time writing reports, answering your telephone messages and attending meetings? I've got to be out there selling, twenty-four hours every day.
Todd: Maybe, but you can't just do what you like, when you like, Oliver. Discipline is important.
Oliver: Discipline! Control! Look, I've had enough. I've give everything to this company. But no one cares. So, I've decided to resign. You'll get my letter in the morning and I'll send a copy to Charles. He won't be pleased, I'm sure. We've been friends for years. But I just can't work with you Todd. There's no other solution.


",
"Oliver|Todd"
	];

push @$questions, 
[ "business", "oliver", 1, "C", "Oliver wants Todd to let him do everything his way.",  "True" ],
[ "business", "oliver", 2, "C", "Oliver wants more discipline and control from Todd.", "False" ];

push @$texts,
	[
        "oliver",
        "The difficult sales rep",
	"business",
	"D",
	"You are Todd, the marketing manager of the camping equipment company. Oliver is a very good salesman. But he doesn't listen to you. You want Charles to punish Oliver. You tell Charles that Oliver spends too much money on entertainment and expensive gifts for his customers. He also has not introduced you to the biggest buyers in his area. He says the buyers are too busy to meet you. But you think his plan is to leave the company, join a different company and get the buyers to switch to his new company's products. You want to get to know the buyers to make sure that Charles doesn't take his buyers with him. Oliver also ignores your phone messages and does not write sales reports.

",
"Todd|Oliver|punish|switch"
	];

push @$questions, 
[ "business", "oliver", 1, "D", "Todd wants to meet Oliver's buyers, to make sure he can keep them if Oliver leaves.", "True" ],
[ "business", "oliver", 2, "D", "Todd wants Oliver to leave the company.", "False" ];

push @$texts,
	[
        "career",
        "Getting ahead in the eyes of AWB",
	"business",
	"A",
	"What's important, I think, is to be organized. You need to have a plan. You need to know what to do each day. Have something you can look at to see how you are going today, this month and this year. When you look at this plan, do you see that things are going according to the plan? Or is the plan completely meaningless?

Also, get to know your co-workers and do things with them after work and on the weekends. Get together not just with people in the same office, but with workers in other parts of your company too.

All this is a lot of work, so you need to have a life outside work. You need to spend time with your family. Have a good time with them, so that you can come back to work feeling good. This will help you do a good job at the company.

",
"organized|according|meaningless"
	];
	
push @$questions, 
[ "business", "career", 1, "A", "AWB thinks planning, getting together with co-workers and having a life outside work are important.", "True" ],
[ "business", "career", 2, "A", "AWB thinks you need to plan a lot and spend a lot of time at work with co-workers so you can't do things outside work.", "False" ];

push @$texts,
	[
        "career",
        "Getting ahead in the eyes of BDL",
	"business",
	"B",
	"What's important, I think, is to think about what you are doing. What you think while you are working is as important as what you do. Don't think about the weekend when you are at work. Think about what you are doing at that moment. How could you do it better? What is the purpose of what you are doing? Keep that in mind.

But have your own goals. Your goals are different than your company's goals. Do you want to be doing the same thing for the rest of your career? Think also about what kind of work you want to be doing in the future and think about what you have to do to get that kind of work.

If you're unhappy with your present job, don't just accept it and keep on working in the job, even though you don't like it. Find ways to make the job a better job in your eyes. If you can't make the job a better job, look for a new job.

",
"purpose|accept"
	];
	
push @$questions, 
[ "business", "career", 1, "B", "BDL thinks thinking about the job and your future career are important. If thinking about your job doesn't make it better, get a better job.", "True" ],
[ "business", "career", 2, "B", "BDL thinks you have to think about your future job, rather than your job at the moment. A future job is a better job.", "False" ];

push @$texts,
	[
        "career",
        "Getting ahead in the eyes of SLT",
	"business",
	"C",
	"Don't think of your job as something just you do. You are part of a team. Your success depends on what the other people in your team do too. Make sure other people understand that their success depends on what you do too. If they know you are working for them, this will make it easier for you to get them to work for you.

Be dissatisfied if things are too easy. Prefer to do the difficult thing. Solving a difficult problem, or surviving a difficult situation is very satisfying. But, be prepared for failure and learn from that failure. Try something different and achieve something great.

It's also important to be organized. You need to have a plan. You need to know what to do each day. Have something you can look at to see how you are going today, this month and this year. When you look at this plan, do you see that things are going according to the plan? Or is the plan completely meaningless?

",
"success|depends|surviving|situation|organized|according|meaningless"
	];
	
push @$questions, 
[ "business", "career", 1, "C", "SLT thinks planning and getting other people to work with you to achieve difficult things are important.", "True" ],
[ "business", "career", 2, "C", "SLT thinks success is easy if you get other people to do your work. You don't even need to plan.", "False" ];

push @$texts,
	[
        "career",
        "Getting ahead in the eyes of KED",
	"business",
	"D",
	"Try to better yourself all the time. There is always some skill you can learn for your job and how to do it better. If the company offers you training, take the training. You can study too, part-time at colleges in the evening or weekend, and by reading. Be a life-long learner.

Talk to your boss. Let management know what you think. If you want something, ask for it. They may not give it to you, but perhaps they will negotiate with you for something less. A raise which is smaller than you wanted is better than no raise at all.

What's important, I think, is to think about what you are doing. What you think while you are working is as important as what you do. Don't think about the weekend when you are at work. Think about what you are doing at that moment. How could you do it better? What is the purpose of what you are doing? Understand what you are doing.

",
"better|training|management|negotiate|raise"
	];
	
push @$questions, 
[ "business", "career", 1, "D", "KED thinks learning skills and thinking about the job are important. And telling the boss what you think. Perhaps the boss will give you a raise.", "True" ],
[ "business", "career", 2, "D", "KED thinks doing the job is more important than thinking or talking about it. And skills don't need to be learned because the boss won't give you a raise, if you do learn them.", "False" ];

uptodatepopulate( 'Text', $texts );
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


This library is free software, you scan redistribute it and/or modify
it under the same terms as Perl itself.

=cut

