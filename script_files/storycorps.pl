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
	"kroenke-1",
        "Tuning a piano at a nursing home",
	"intermediate",
	"all",
	"00:38 A group gathered around in chairs.
00:42 And they were all wearing their nice Christmas clothing, 
00:43 and I thought, Well, how nice, you know, they have no idea that I'm going to bore them to sleep with my tuning. 
00:49 And I’m kind of working along happily and I’m smiling at people. 
00:54 And a few of them were looking at me like, What in the world is he doing? 
00:58 One lady was just glaring at me. 
01:01 Another lady was giving me sympathetic looks (Her name turned out to be Rose). 
01:06 And then the activity director comes in and says:
01:09 OK, everybody, Miss Jennifer was here and she saw that the piano man was tuning the piano, 
01:14 so she’ll be back in January. 
01:18 I didn’t realize they had a concert scheduled that day. 

",
"bore|glaring|sympathetic|activity|director|Jennifer|realize|scheduled"
	],

	[
	"kroenke-2",
        "Mixed reactions of the audience",
	"intermediate",
	"all",
        "01:22 About a third of the people looked highly disappointed. 
01:25 and they were murmuring to each other, trying to tell each other what had happened.
01:30 The angry lady barked at me and said, you know: \"Haven't you ever heard if isn't broke, don't fix it?\" 
01:37 And she stormed off. 
01:38 I had scooted over on my seat out of the view of Rose because she looked so hurt.
01:44 And suddenly, she touched my arm, and it startled me. 
01:50 And I looked. And she was very close to me.
01:54 And she told me very sincerely,
01:57 I've been sitting here the whole time and 
02:00 I've been watching what you do and I can tell that you're the kind of person 
02:06 who would never walk away from this piano until everything was just so. 
02:09 That was a moment where someone did just the right thing, 
02:14 just out of the blue.
02:17 And it did mean something to me.

",
"disappointed|murmuring|barked|stormed|scooted|startled|sincerely|out of the blue"
	],

	[
	"trinka-1",
        "Getting the doorman job",
	"intermediate",
	"all",
        "Debra: How did you get the job as doorman at the Plaza Hotel.
Ed: Well, my father was a garage manager at the Plaza for thirty years.
And he was friends with all the doormen.
And when I graduated from high school, he said,
There's a nice job for you over there.
Just go over and talk to somebody.
One of the doormen was sick and they put the hat and coat on me, which fit very well.
And they put me on the door right away.
And I got outside and started working.
That was my first job.
And then, uh, it was great.

Debra: What was the best tip you ever got? 
Ed: Well, I was always tell the story about Jackie Gleason, for Christmas time. 
He says to me, What was the biggest tip you ever got.
And I says, Well, a hundred dollars.
And he says, Here's a hundred and fifty dollars. Merry Christmas.
And he says, By the way, who was the one who gave you a hundred?
And I says, Well, that was you last year.

",
"Debra|Ed|graduated|tip|Jackie|Gleason|Merry Christmas"
	],

	[
	"trinka-2",
        "How to treat people",
	"intermediate",
	"intermediate",
	"all",
        "Debra: Now, I got to know you because I walk to work every morning, and I cut by the Plaza, and you made my day. \"Good morning, young lady.\" \"Beautiful day.\"
Ed: Eh, that's what it's all about.
Out being in front there and smiling. 
And just making everybody happy.
And that's the whole thing of it.
You know, anybody that comes in here is a VIP.
And when they tell me, Treat them like a VIP, I say I already do.

I had a guest come in one morning, six-thirty in the morning.
And he had to go to a very important meeting.
And he asked me where he could get his shoes shined.
And I says, It don't open till eight o'clock. Our barber shop.
So I said, I tell you what. Give me the shoes and you come back in a half an hour or so and I'll have them done.
I ran down to my locker, got my shoeshine kit, which I have in my locker to shine my shoes,
shined them up for him,
come back up. He come by, put his shoes on,
and he went to the meeting, and he's one of my best friends.
Matter of fact, he comes back to the Plaza all the time.
You know, my father told me years ago,
He said, Be such a man, and live such a life, that if,
Everybody lived a life like yours, this would be God's paradise.
And I go by that.

",
"Plaza|Ed|Debra|shined|barber|locker|shoeshine|kit|paradise"
	],

	[
        "jackson-1",
	"Charles on his mom with Alzheimers",
	"intermediate",
	"all",
        "00:41 My brother Stanley and I came home from school.
00:45 And Mom told us that our aunt wanted to talk to us. 
00:50 So we went out and got in the old pick up and drove over there. 
00:55 And my aunt started telling us that Mom had this disease that my aunt Pearl had had and old Fred and so forth down the line. 
01:06 That's the first day I heard the word, Alzheimers. 
01:10 When we got back to the farm it was dark. 
01:13 And Mom and Dad were in a fight. 
01:15 Dad had gotten home from work and wanted to know where we were at. 
01:18 And she had forgotten where we had gone. 
01:21 They were yelling and screaming at each other. 
01:23 And it was a horrible night for all of us. 
01:26 I was the one that became the care person for my mother at that time. 
01:30 I was thirteen. 
01:32 I got to high school. 
01:34 I was in my senior year. 
01:36 And by this time, Mom was sitting in a rocking chair with a blanket wrapped around her, and all the blinds pulled down. 
01:44 That year, she asked me if I could help her die and I told her I couldn't. 
01:50 And after that, she started trying to run away. 
01:52 Any chance that she thought she could sneak out of the house she would leave. 
01:57 And I'd have to go find her. 

",
"Stanley|Pearl"
	],

	[
        "jackson-2",
	"Charles' own Alzheimers",
	"intermediate",
	"all",
        "02:01 I was diagnosed in 2004 with Alzheimers. 
02:06 I was 50. 
02:07 A friend of mine sent me an email right after my diagnosis. 
02:11 She said, This is terrible. 
02:13 This isn't fair. 
02:14 And this is a horrible thing. 
02:16 And I wrote back to her and I said, Well, it's not that bad. 
02:20 It's not like you're in pain all the time. 
02:24 But, um, it takes a toll on your family, because I know that when they see my failing they get really sad and they don't like to see that. 
02:35 I wish they would try to understand that I may be a little different. 
02:41 There's a time there, where, uh, I will forget everybody's name. 
02:46 But inside, I'm still there. 
02:50 I'm still me. 
02:52 Inside, I'm thinking how much fun I'm having with them. 
02:55 And I, as much as possible, would like to be treated as I have been treated before.


",
"diagnosed"
	],

	[
        "clay-1",
        "Life with Frank Mixon",
	"intermediate",
	"all",
        "I was pregnant when I met him. And he saw me, and walked over towards me, and he said, You're going to be my wife. And a year later, we just one day went down to City Hall and got married. And we had no rings. He tried to give me his class ring, a big ugly thing, and put it on my finger. And I was like, Uh-huh. 

And I remember coming home one day, and he wasn't there. And there was a note on the back of the door. And it said, Go in the bedroom and look on the dresser. And I went in the bedroom and in the front of the dresser. And there was the ring box. A beautiful wedding ring and engagement ring in the box. 

I grabbed those things and I put them on. I just ran out of the house, 'cause I knew where he hung out at. And when he saw me coming, he said, Did you find them? And I was like, Yes, and I was shaking and stuff, like I had just met him. And I handed him the rings and he got down on one knee. He said, Will you be my wife, really be my wife? And I said, Yeah.

",
"pregnant"
	],

	[
        "clay-2",
        "Remembering Frank",
	"intermediate",
	"all",
	"He would come home. And he would say, Uh, what's for dinner. And I would tell him whatever dinner was going to be. And he made me feel like it was magnificent. I mean, if I burnt popcorn, it was the best. You know, that was the kind of guy he was.

I was married to him for seventeen years, and we separated. And he moved to Michigan. I don't know the details, but Frank got into an altercation. They say that this woman was a \"damsel in distress.\" And Frank was helping her. And the woman's boyfriend shot him in the back. 

I had my fourth child with him and he's exactly like his father. Exactly. He never talks above a whisper. He's always happy and laughing. He's the gentleman of all gentlemen. And you know my other three kids are like that because they had him. 

My oldest son, he'll tell you, My biological father's name is So-and-so, but my dad's name is Frank Mixon. And out of all the years that we were separated, I still remember Frank Mixon. Because I honestly believe that he was my first true love.

",
"Michigan|whisper|Frank|Mixon|altercation|damsel in distress"
	],

	];

my $questions = [
			[ qw/genre text id target content answer/ ],

[ "intermediate", "kroenke-1", 1, "all", "A group at a nursing home had gathered to tune a piano", "False" ],
[ "intermediate", "kroenke-1", 2, "all", "Ron was tuning the piano, so people couldn't have the concert.", "True" ],
[ "intermediate", "kroenke-2", 1, "all", "Many people were hurt, because of what had happened.", "True" ],
[ "intermediate", "kroenke-2", 2, "all", "The angry lady thought Ron shouldn't have been trying to fix the piano, because it wasn't broken.", "True" ],
[ "intermediate", "kroenke-2", 3, "all", "It didn't mean a thing to Ron that someone did tell him he did things right.", "False" ],
[ "intermediate", "kroenke-2", 4, "all", "Rose tells Ron: \"You're kind for fixing the piano.\"", "False" ],

[ "intermediate", "trinka-1", 1, "all", "Ed started working at the Plaza after he graduated from high school.", "True" ],
[ "intermediate", "trinka-1", 2, "all", "Ed got his first job at the Plaza when one of the doormen was sick.", "True" ],
[ "intermediate", "trinka-1", 3, "all", "Jackie Gleason gave Ed his biggest tip of one hundred and fifty dollars.", "True" ],
[ "intermediate", "trinka-1", 4, "all", "When Ed got sick, they put a hat and coat on him.", "False" ],
[ "intermediate", "trinka-1", 5, "all", "Jackie Gleason got the best tip from Ed Trinka, one hundred and fifty dollars.", "False" ],
[ "intermediate", "trinka-1", 6, "all", "Jackie Gleason, a garage manager at the Plaza, was Ed's father.", "False" ],

[ "intermediate", "trinka-2", 1, "all", "Ed shone the shoes of a guest at the Plaza because the barber shop wasn't open.", "True" ],
[ "intermediate", "trinka-2", 2, "all", "Ed's thing is to treat guests like VIPs and make them happy, because they are VIPs.", "True" ],
[ "intermediate", "trinka-2", 3, "all", "Ed's father told him to live the life he is living and treat people very well.", "True" ],
[ "intermediate", "trinka-2", 4, "all", "Ed Trinka made Debra's day by smiling and being happy.", "True" ],
[ "intermediate", "trinka-2", 5, "all", "Ed Trinka shined a guest's shoes with his shoeshine kit.", "True" ],
[ "intermediate", "trinka-2", 6, "all", "Debra met Ed when she was working at the Plaza Hotel as a VIP and he shone her shoes.", "False" ],
[ "intermediate", "trinka-2", 7, "all", "Ed shone his shoes because he had an important meeting with a guest.", "False" ],
[ "intermediate", "trinka-2", 8, "all", "Ed shines his shoes every morning because he has an important meeting with Debra.", "False" ],


[ "intermediate", "jackson-1", 1, "all", "Charles had to care for his mom when his mother got Alzheimers.", "True" ],
[ "intermediate", "jackson-1", 2, "all", "Charles' Mom and Dad fought with each other, when she couldn't tell him where Charles was.", "True" ],
[ "intermediate", "jackson-1", 3, "all", "Charles started running away when his mother told him she wanted to die.", "False" ],
[ "intermediate", "jackson-1", 4, "all", "Charles' mom screamed at him, after he got home after dark.", "False" ],

[ "intermediate", "jackson-2", 1, "all", "Charles doesn't like his family treating him as different.", "True" ],
[ "intermediate", "jackson-2", 2, "all", "Charles' family doesn't like to see him forget everybody's name.", "True" ],
[ "intermediate", "jackson-2", 3, "all", "Charles thinks he isn't having fun with his family.", "False" ],
[ "intermediate", "jackson-2", 4, "all", "Charles wants his family to treat him differently, because of his failings.", "False" ],

[ "intermediate", "clay-1", 1, "all", "Rebia didn't want Frank to give her his class ring when they got married.", "True" ],
[ "intermediate", "clay-1", 2, "all", "Frank and Rebia met and one year later, they got married.", "True" ],
[ "intermediate", "clay-1", 3, "all", "Rebia found the rings that Frank gave her on the dresser.", "True" ],
[ "intermediate", "clay-1", 4, "all", "Rebia and Frank got married and later Frank gave her engagement and wedding rings.", "True" ],
[ "intermediate", "clay-1", 5, "all", "Frank gave Rebia some rings when they got married.", "False" ],
[ "intermediate", "clay-1", 6, "all", "Frank found some rings and gave them to Rebia, but she handed them back to him. She didn't like them.", "False" ],
[ "intermediate", "clay-1", 7, "all", "Frank found the rings he gave Rebia when they got married in her dress.", "False" ],

[ "intermediate", "clay-2", 1, "all", "Frank made Rebia feel like she was the best woman.", "True" ],
[ "intermediate", "clay-2", 2, "all", "Rebia has four children but the oldest child is not Frank's.", "True" ],
[ "intermediate", "clay-2", 3, "all", "Rebia and Frank separated but she remembers Frank as the best.", "True" ],
[ "intermediate", "clay-2", 4, "all", "Rebia had four children with Frank.", "False" ],
[ "intermediate", "clay-2", 5, "all", "Frank was not happy if Rebia burnt popcorn.", "False" ],
[ "intermediate", "clay-2", 6, "all", "Frank shot his girlfriend in the back because she was helping a boyfriend.", "False" ],

	];

push @$texts,
[
        "biomom",
        "Relationship of adopted child with birth mother",
	"intermediate",
	"all",
	"Dimasi: When did you decide to give me up for adoption.
Adam: Well, I was in my final year of university, and I wasn't in a serious relationship with anyone. It was kind of a fluke. You know they say it only takes once. And it turned out to be true. And it was probably the loneliest time of my entire life. When I was in the hospital, I was there for hours by myself. And then they took you away, and they wouldn't allow me to see you. But one of the nurses took pity on me and brought you in to my room in the middle of the night one night so that I could count fingers and toes. But then the other, uhm, practice was that in the case of adoption, I had to actually carry you out of the hospital and hand you to the doctor, physically. That was supposed to be an indication of my willingness to give up the child. And, that was hard.
Dimasi: I want you to know that I never was angry. I never resented your decision. I've never had reason to. I knew that I was adopted, and my parents always made it a positive part of my life, that they picked me, that they really wanted me. And I just remember your being a question mark. That part of who I was was just a question mark. And I got to a point in my early twenties when I was just so curious, and I asked my parents if they had, you know, any legal papers or, or hospital papers. And my father took me upstairs and gave me a pile of papers, and that's when I discovered the hospital bill that had your name on it.
Adam: Mmh-hmm.
Dimasi: On all the other papers, your name was blacked out with a magic marker. But there was this one for, like, aspirin.
Adam: Ha, ha, ha.
Dimasi: It was the most inconsequential bill, but there was your name, and it was the first moment that you as a person were concrete to me.
Adam: Mmh.
Dimasi: And it knocked me down.
Adam: I remember that first phone call that we had. You had left me a message. So I had your voice on my machine and I kept listening to it over and over and over again, 'cause it just had never crossed my mind that I would ever hear your voice. I think it was at least midnight by the time I called you, maybe later. And we talked for two or three hours, it just seemed so easy. We haven't shut up much since.
Dimasi: No.  
Adam: Ha, ha, ha.
Dimasi: That's true.
Dimasi: When I describe our relationship to people, I say that you're more like a mentor than a mother. You're a person that I turn to for advice and someone that I enjoy talking to about all the things that I'm passionate about.
Adam: I'm really grateful. I love you.
Dimasi: I love you too.


",
"Adam|Dimasi|resented|fluke|legal|magic marker|aspirin|inconsequential|mentor"
	];

push @$questions,
[ "intermediate", "biomom", 1, "all", "Dimasi discovered her mother's name with a hospital bill.", "True" ],
[ "intermediate", "biomom", 2, "all", "The two people have a good relationship, but the child does not think of her mother as a mother.", "True" ],
[ "intermediate", "biomom", 3, "all", "The first phone call they had, the two people talked for two or three hours.", "True" ],
[ "intermediate", "biomom", 4, "all", "The mother left a message on her child's phone,", "False" ],
[ "intermediate", "biomom", 5, "all", "The father never told his child she was adopted.", "False" ],
[ "intermediate", "biomom", 6, "all", "The father didn't want his child to know her mother's name.", "False" ];

push @$texts,
[
        "biodad",
        "15-minute father",
	"intermediate",
	"all",
	"Shepard: I woke up the morning after I got to Glasgow and I decided to just go to the university to look around, see what I thought. I had the address written down for my biological father and I went there.

I looked down the hallway and I saw a sign with his name. Finally, I just said this is probably the only chance in my life I will ever have to do this.

Walked up to the door and knocked. He looked at me with a look that was not quite hostile, but impatient. I said, Do you have a minute? He said, Sure. And I said, Do you remember living in Connecticut 20 years ago. And he got this kind of odd smile on his face and said, Yes, I remember it.

I said, Well, do you remember a relationship with a woman named Eloise, that you had? And he says, Yes, yes I do.

And I says, Well, uhm, I'm the result of that relationship, And he says, Aaaaaah.

Walks over towards me, and I have this panic that he's going to touch me. But he doesn't. He walks past me and he closes the door and walks back and sits down at the table where I'm seated, and says, So, you're here.

And I said, Yeh. And I told him that I had three questions that I wanted to ask him. He said, Sure. And I said, First, I want to know if there is any history of diseases or things that I needed to be aware of, genetically, just to get that baseline out of the way. And, he said, No, not that I know of.

And then I asked him if he would be willing to just explain a little the circumstances surrounding my birth, and how it came to be that I was born and he left. And for the first time and only time over the course of our fifteen-minute conversation, the grin left his face. And eventually, he said, Well, I think that at that point, Eloise was ready to have a child. And I said, And you were't. And he laughed, and said, No. Never was, never have been, He didn't really offer me anything more.

Ryan: Did you ask your third question?

Shepard: Yeh, I looked at him for a minute, and then I asked my third question, May I take a picture of you? I had a little disposable camera, took a picture of him, and, um, that was that.

It ended with me, saying, Well, I don't want to take up too much of your time. And I said, Goodbye, and he turned to walk back towards his computer, and he says, Goodbye for now.

I don't know if I'll ever contact him, if I will ever want him to be a part of my life in any way. But for now, I don't.

And, so, I walked back through this park in Glasgow back towards this place where I was staying and I felt that I had made a peace with a part of myself that I never expected, that I never even thought possible.

",
"Shepard|Ryan|Glasgow|Connecticut|Eloise|baseline|disposable"
	];

push @$questions,
[ "intermediate", "biodad", 1, "all", "He doesn't know if he he ever wants to contact his father again.", "True" ],
[ "intermediate", "biodad", 2, "all", "The father and child only ever had a fifteen-minute conversation.", "True" ],
[ "intermediate", "biodad", 3, "all", "The father didn't want to have the child but the woman did.", "True" ],
[ "intermediate", "biodad", 4, "all", "The father felt panic that his child had come to ask him questions.", "False" ],
[ "intermediate", "biodad", 5, "all", "The father was hostile to the child when he came to see him.", "False" ],
[ "intermediate", "biodad", 6, "all", "The child wants to see his father again, but the father doesn't want to see his child again.", "False" ];

push @$texts,
[
        "relations-1",
        "Mother tells son about meeting dad",
	"intermediate",
	"all",
	"Sam: How did you meet Dad?
PJ: Well, you know that my mom died when I was seven.
Sam: Yes.
PJ: And you know that I was on my own when I was sixteen. So what I did and what you get to do are going to be two different things, because ..
Sam: Right, I'll always have somebody looking up for me. And, that's you, Dad, and ..
PJ: That's right.
Sam: And pretty much everybody else in our family.
PJ: So, I was 18 years old and, um, I had a fake ID, and I was at this bar.
Sam: You had a fake ID.
PJ: Mmm-mmh. Oh my goodness, I can't believe I'm telling you this. And, um, I was sitting at this barstool and your dad sat down. And I said to your dad, I said,  There's somebody sitting there. And he says, I don't care. I just have to meet you. And, he made me laugh, and that's what I needed right then. That's why I needed to laugh a little.

We talked for about four hours, and then he walked me out to my car, but he never asked me for my phone number. And I got home that night, and I was writing in my diary, Very good-looking, but insecure.

The next day, I was on my couch watching some afternoon TV, folding laundry, and I had told dad what apartment complex I lived in, but I didn't tell him what apartment or where I lived. So he drove in to the apartment complex and just laid his hand on the horn.
Sam: (Laughs)
PJ: And he just was driving through the complex. (Laughs). And I went out on my balcony, and I saw him, and I said, Oh my God, that's that guy from the bar last night, and he was like, Oh, hi, there you are, I've been looking for you! And that's the way he found me.

Sam: What was the best times, the worst times in marriage? And did you ever think of getting divorced?
PJ: You know, over the years, I have thought about getting divorced. Me and your dad were separated once for two years, but we got back together. And we never did get divorced. We came close a couple of times during that time. Umm.
Sam: I remember like, you were like yelling. And you said, You want me to leave with the children? I was like in my bed, and I just heard that.
PJ: I'm sorry you had to hear that, sweetie. Marriage isn't always pretty. I think sometimes we act like little children, and we need to be more mature about it, because it's a privilege to be married to somebody, and you need not to disrespect it like that. Like sometimes we get angry and we do. But we've been together for twenty-three years now. And I think your dad's taught me the meaning of love. Love is as much a feeling as it is an action.
Sam: Right.
PJ: You see what I'm saying.
Sam: I see what you're saying.
PJ: To love somebody is not just how you feel about them, but what you do, also.

",
"PJ|Sam|horn|mature"
	];

push @$questions,
[ "intermediate", "relations-1", 1, "all", "The guy didn't know where she lived, so he drove into the apartment complex looking for her.", "True" ],
[ "intermediate", "relations-1", 2, "all", "The guy sat down and talked to her for four hours.", "True" ],
[ "intermediate", "relations-1", 3, "all", "The couple came close to getting divorced.", "True" ],
[ "intermediate", "relations-1", 4, "all", "The couple were separated, but never thought of getting a divorce.", "False" ],
[ "intermediate", "relations-1", 5, "all", "The couple are always mature, and never angry.", "False" ],
[ "intermediate", "relations-1", 6, "all", "The children wanted to leave Dad and be with Mom.", "False" ];

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

