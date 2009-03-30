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

