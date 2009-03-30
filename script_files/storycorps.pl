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
        "Ed Trinka, Plaza Hotel doorman",
	"all",
	"all",
        "00:20 Welcome to the StoryCorps podcast.
00:23 In this episode, a story from New York City. 
00:25 The Plaza Hotel first opened its doors at the foot of Central Park a hundred years ago this week. 
00:30 For nearly 45 of those years, Plaza Hotel doorman Ed Trinka has greeted hotel guests and passers-by.
00:37 That's how Debra Goodman met him.
00:40 They struck up a friendship and Debra brought Ed to StoryCorps to talk about working at a New York landmark for nearly half a century.

",
"StoryCorps|podcast|episode|Plaza|greeted|Ed|Trinka|Debra|Goodman|landmark|century"
	],

	[
	"trinka-2",
        "Getting the doorman job",
	"all",
	"all",
        "00:46 Debra: How did you get the job as doorman at the Plaza Hotel.
00:50 Ed: Well, my father was a garage manager at the Plaza for thirty years.
00:54 And he was friends with all the doormen.
00:55 And when I graduated from high school, he said,
00:57 There's a nice job for you over there.
00:58 Just go over and talk to somebody.
01:00 One of the doormen was sick and they put the hat and coat on me, which fit very well.
01:03 And they put me on the door right away.
01:06 And I got outside and started working.
01:07 That was my first job.
01:09 And then, uh, it was great.

",
"Debra|Ed|graduated"
	],

	[
	"trinka-3",
        "Tip story",
	"all",
	"all",
        "01:10 Debra: What was the best tip you ever got? 
01:13 Ed: Well, I was always tell the story about Jackie Gleason, for Christmas time. 
01:15 He says to me, What was the biggest tip you ever got.
01:17 And I says, Well, a hundred dollars.
01:19 And he says, Here's a hundred and fifty dollars. Merry Christmas.
01:22 And he says, By the way, who was the one who gave you a hundred?
01:24 And I says, Well, that was you last year.

",
"Debra|Ed|Jackie|Gleason|Christmas|Merry"
	],

	[
	"trinka-4",
        "Treating guests",
	"all",
	"all",
        "01:26 Debra: Now, I got to know you because I walk to work every morning, and I cut by the Plaza, and you made my day. \"Good morning, young lady.\" \"Beautiful day.\"
01:32 Ed: Eh, that's what it's all about.
01:35 Out being in front there and smiling. 
01:36 And just making everybody happy.
01:38 And that's the whole thing of it.
01:39 You know, anybody that comes in here is a VIP.
01:42 And when they tell me, Treat them like a VIP, I say I already do.

",
"Plaza|VIP|Ed|Debra"
	],

	[
	"trinka-5",
        "Shoeshine story and how to treat people",
	"all",
	"all",
        "01:45 I had a guest come in one morning, 6:30 in the morning.
01:49 And he had to go to a very important meeting.
01:51 And he asked me where he could get his shoes shined.
01:53 And I says, It don't open till eight o'clock. Our barber shop.
01:56 So I said, I tell you what. Give me the shoes and you come back in a half an hour or so and I'll have them done.
02:01 I ran down to my locker, got my shoeshine kit, which I have in my locker to shine my shoes,
02:06 shined them up for him,
02:07 come back up. He come by, put his shoes on,
02:09 and he went to the meeting, and he's one of my best friends.
02:12 Matter of fact, he comes back to the Plaza all the time.
02:14 You know, my father told me years ago,
02:16 He said, Be such a man, and live such a life, that if,
02:19 Everybody lived a life like yours, this would be God's paradise.
02:23 And I go by that.

",
"shined|barber|locker|shoeshine|kit|paradise"
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
	"all",
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
	"all",
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

[ "all", "trinka-1", 1, "all", "Ed Trinka has worked for nearly a hundred years at the Plaza.", "False" ],
[ "all", "trinka-2", 1, "all", "When Ed got sick, they put a hat and coat on him.", "False" ],
[ "all", "trinka-3", 1, "all", "Jackie Gleason got the best tip from Ed Trinka, a hundred and fifty dollars.", "False" ],
[ "all", "trinka-4", 1, "all", "Ed Trinka made Debra's day by smiling and being happy.", "True" ],
[ "all", "trinka-5", 1, "all", "Ed Trinka shined a guest's shoes with his shoeshine kit.", "True" ],

[ "intermediate", "jackson-1", 1, "all", "Charles had to care for his mom when his mother got Alzheimers.", "True" ],
[ "intermediate", "jackson-1", 2, "all", "Charles' Mom and Dad fought with each other, when she couldn't tell him where Charles was.", "True" ],
[ "intermediate", "jackson-1", 3, "all", "Charles started running away when his mother told him she wanted to die.", "False" ],
[ "intermediate", "jackson-1", 4, "all", "Charles' mom screamed at him, after he got home after dark.", "False" ],

[ "intermediate", "jackson-2", 1, "all", "Charles doesn't like his family treating him as different.", "True" ],

[ "all", "clay-1", 1, "all", "Frank gave Rebia some rings when they got married.", "False" ],
[ "all", "clay-2", 1, "all", "Rebia had four children with Frank.", "False" ],

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

