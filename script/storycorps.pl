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
        "jacksonandtrinka-1",
	"The happy doorman",
	"intermediate",
	"A",
        "Ed Trinka worked as a doorman at the Plaza Hotel, a very old and very famous hotel in New York. His job was to greet guests as they came into the hotel, help them get out of their cars, and help them with their bags. This was very simple to do.

But he also had to do something which was more difficult to do. That was the job of making guests feel important and happy about staying at the Plaza. Ed did a very good job of this, because he was a happy and friendly person.

He didn't do this because the boss, Shane, said he had to. He did it because he liked people. One time, a guest wanted his shoes shined very early in the morning, before the shoe shine stand was open, so he shone the shoes himself, not because the boss said he had to, but because Ed just wanted to help.

 He just made people around him feel happy, even when they weren't very happy before seeing him. Someone like Jackie Gleason was not a happy person, even though he made other people laugh. He used to make Jackie Gleason feel happy, so Gleason gave him very big tips. And, he was friendly even with people passing in the street like Debra Goodman.


",
"Trinka|Plaza|Jackie Gleason|Debra Goodman"
	],
	
	[
        "jacksonandtrinka-1",
	"Plaza work relationships",
	"intermediate",
	"B",
        "Ed Trinka has now stopped working at the Plaza. He is sixty-five. He worked there for forty-six years. His father also worked at the Plaza Hotel and he got Ed the job as doorman. The employees made a lot of the decisions about who could work at the hotel. If your relatives worked at the hotel, it was easier to get a job there.

Managers found it very difficult to control the doormen and other staff at the hotel. The staff didn't listen to the managers. Shane, the general manager told Ed to treat everyone like a VIP, but Ed didn't really listen to Shane. He told Shane I already do treat everyone like a VIP.

Fortunately, Ed was very popular with the guests at the Plaza, a very expensive and famous old hotel. All the guests had lots of money. And many of them were famous and important. They really were VIPs.

Ed stopped working for the Plaza for a while because he didn't like Shane telling him what to do. But when Shane asked him to come back to the Plaza Hotel, he returned. Ed said he never had a bad day working at the hotel, but that may not really be true. One thing that made Ed unhappy was the death of his wife, who was working at the hotel too. Now he is looking for a new wife.


",
"Trinka|Plaza|Shane"
	],
	
	[
        "jacksonandtrinka-1",
	"Treatment of Charles' mother by father",
	"intermediate",
	"C",
        "Charles Jackson didn't really have a happy family life after his mother, Lotte got Alzheimer's disease. At first Jack, his father, and Lotte, argued a lot. Before he realized Lotte had Alzheimer's, Jack thought Lotte was being careless and stupid. This made him very angry with her. When Jack started shouting at Lotte, Lotte would started shouting back at him. Gradually Jack realized that Lotte's behavior wasn't under her control. But this didn't make him any happier. He was very unhappy that his wife was slowly losing her mind. All this made Charles, his brother, and especially his mother, unhappy too.

Charles father and his brother gradually started spending as little time at home as they could. Charles' father told him it was his job to look after his mother and before he went to school in the morning and after he came home from school, he had to feed her and help her go to the bathroom.

When he got home in the afternoon, he would always find Lotte sitting in a rocking chair with a blanket around her and the blinds pulled down. She was so unhappy that she asked Charles to help her die. Charles couldn't agree to do that.

Later she became unable to walk. But before that she started trying to run away. She would leave the house and just walk away from the house with no idea of where she was going or what she was looking for. Charles used to lock the door to prevent her leaving, but she would try to jump out the window, or she would leave the house when Jack wasn't looking.

",
"Alzheimer's|Jack|Lotte|Charles|Jackson"
	],
	
	[
        "jacksonandtrinka-1",
	"Charles' desire for better treatment",
	"intermediate",
	"D",
        "When Charles turned 50, he started having problems with memory at work and home. He couldn't remember how to get to work, and he couldn't remember if he had eaten breakfast or not. Other people were the first to notice. His wife, Carol didn't know much about Alzheimer's but she knew that Charles' mother had had Alzheimer's.

She asked him to get diagnosed. When the doctors told him he had Alzheimer's, he already knew was the condition was like, as a result of his experience with his mother. He knew what was going to happen. He would gradually forget everything and stop doing things and would just sit in a chair all day. That was helpful to him. He didn't feel as worried as he might have about what was going to happen to him.

A friend, Brenda sent him an email after she found out. She thought the idea of losing your mind was horrible, and felt disturbed that Charles was going to turn into this kind of person. He said he was less worried, and he asked her not to stop being a friend.

He thought that the condition itself was not as bad as the treatment that people with Alzheimer's get from their family and friends. He remembered his father's treatment of his mother, and hoped that his wife and his children would not treat him the same way as that. He wanted them to treat him the same way as they always had. He wanted them to love him and to understand that even though he might act differently, he was still the same person inside and he was still having fun with them.

",
"Alzheimer's|diagnosed|horrible|disturbed"
	],

	[
        "clay-1",
        "Life with Frank Mixon",
	"intermediate",
	"all",
        "00:37 I was pregnant when I met him.
00:40 And he saw me, and walked over towards me, and he said, You're going to be my wife.
00:45 And a year later, we just one day went down to City Hall and got married. 
00:54 And we had no rings. 
00:55 He tried to give me his class ring, a big ugly thing, and put it on my finger. 
01:00 And I was like, Uh-huh. 
01:03 And I remember coming home one day, and he wasn't there. 
01:08 And there was a note on the back of the door. 
01:10 And it said, Go in the bedroom and look on the dresser. 
01:13 And I went in the bedroom and in the front of the dresser, there was the ring box. 
01:19 A beautiful wedding ring and engagement ring. 
01:22 I grabbed those things and I put them on. 
01:25 I just ran out of the house, 'cause I knew where he hung out at. 
01:26 And when he saw me coming, he said, Did you find the note? 
01:35 And I said, Yes, and I was shaking and stuff, like I had just met him. 
01:38 And I handed him the rings and he got down on one knee and said, Will you be my wife, really be my wife? 
01:42 And I said, Yeah.


",
"pregnant"
	],

	[
        "clay-2",
        "Remembering Frank",
	"intermediate",
	"all",
        "02:06 I was married to him for seventeen years, and we separated. And he moved to Michigan. 
02:11 I don't know the details, but Frank got into an altercation. 
02:17 They say that this woman was a \"damsel in distress.\" 
02:22 And Frank was helping her. And the woman's boyfriend shot him in the back. 
02:30 I had my fourth child with him and he's exactly like his father. Exactly. 
02:40 He never talks above a whisper. He's always happy and laughing. He's the gentleman of all gentlemen. 
02:49 And you know my other three kids are like that because they had him. 
02:54 My oldest son, he'll tell you, My biological father's name is So-and-so, but my dad's name is Frank Mixon. 
03:02 And out of all the years that we were separated, I still remember Frank Mixon. 
03:10 Because I honestly believe that he was my first true love.

",
"altercation|damsel in distress"
	],

	];

uptodatepopulate( 'Text', $texts );

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

[ "intermediate", "jacksonandtrinka-1", 1, "A", "Ed was good at the difficult part of the doorman's job, which was making people feel happy and important.", "True" ],
[ "intermediate", "jacksonandtrinka-1", 2, "A", "Ed found it difficult to work at the Plaza because he had to shine shoes and make unhappy people feel happy.", "False" ],
[ "intermediate", "jacksonandtrinka-1", 3, "B", "Ed was unhappy about a few things at the hotel, like Shane telling him how to do his job.", "True" ],
[ "intermediate", "jacksonandtrinka-1", 4, "B", "Ed worked for forty-six years without a stop, because he loved every day on the job.", "False" ],
[ "intermediate", "jacksonandtrinka-1", 5, "C", "Charles' father didn't treat his mother well, and this made everyone unhappy.", "True" ],
[ "intermediate", "jacksonandtrinka-1", 6, "C", "Charles ran away from home after his mother lost her mind and tried to lock him in the house.", "False" ],
[ "intermediate", "jacksonandtrinka-1", 7, "D", "Charles' wife asked him to get diagnosed. He wanted her not to treat him differently.", "True" ],
[ "intermediate", "jacksonandtrinka-1", 8, "D", "Charles thought it horrible that he would start acting like his mother.", "False" ],

[ "intermediate", "clay-1", 1, "all", "Frank gave Rebia some rings when they got married.", "False" ],
[ "intermediate", "clay-2", 1, "all", "Rebia had four children with Frank.", "False" ],

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

