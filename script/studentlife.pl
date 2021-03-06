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

my $eden1 = 
"00:06 Dennis Miller: The first student I talked with was Eden Hartwell, of Mt Upton, New York.
00:09 She's a forensics major. Let's jump right into the conversation.
00:13 Miller: Favorite food.
00:15 Eden: My mom's spaghetti.
00:16 Miller: How does she make that that's your absolute favorite food?
00:19 Eden: She just makes the best sauce.
00:21 Miller: Yeh?
00:22 Eden: Yeh. (laughs)
00:22 Miller: ... have to try that sometime.

";
my $eden2 = 
"00:24 Miller: And your favorite color?
00:24 Eden: Pink.
00:25 Miller: Okay. You're not wearing any pink! (laughs)
00:30 Eden: (laughs)
00:31 Miller: Okay, pink sneakers.
00:32 Eden: Yup.
00:32 Miller: Okay. You got 'em. You got 'em.
00:32 Eden: (laughs)
00:34 Miller: And you said before when you were talking that uh, your whole room is, is done in pink.
00:38 Eden: Yeh. Mmh-hmm.
00:39 Miller: Does your roommate like pink too?
00:41 Eden: I think she likes it, but she doesn't have any pink, there.
00:44 Miller: She also didn't have any choice the way you decorated it.
00:46 Eden: Right. (laughs)
00:47 Miller: (laughs)
00:48 Eden: My half of the room is pink, and hers is whatever color she wants it to be. I don't know. (laughs)
00:53 Miller: Okay, so you guys worked that out beforehand.
00:54 Eden: Yeh.

";

my $texts = [
	[ qw(id description genre target content unclozeables) ],
	[
        "eden-1",
        "Eden",
	"access",
	"all",
	$eden1,
	"Dennis Miller|Miller|forensics|Eden|Hartwell|Upton|spaghetti|sauce"
	],
	
	[
        "eden-1-GL",
        "Eden",
	"JUST RIGHT",
	"all",
	$eden1,
	"Dennis Miller|Miller|forensics|Eden|Hartwell|Upton|spaghetti|sauce"
	],

	[
        "eden-2",
        "The color pink",
	"access",
	"all",
	$eden2,
	"Miller|Eden|sneakers"
	],

	[
        "eden-2-GL",
        "The color pink",
	"JUST RIGHT",
	"all",
	$eden2,
	"Miller|Eden|sneakers"
	],

	[
        "eden-3",
        "Getting to know roommate",
	"access",
	"all",
        "00:55 Miller: Now you were telling me that you got to know your roommate through uh, email during the summer, 
01:01 Eden: Yeh.
01:01 Miller: which struck me as a really good way to do things.
01:04  Miller: Did you contact her, or she contacted you?
01:07 Eden: Actually, during orientation, we had a time, where we just sat with a group of people and talked to them, and then we chose our roommate.
01:15 Eden: So we exchanged emails, and screen names, and everything like that, then.
01:21 Eden: So we had the few months before we came, to get to know each other.
01:24 Miller: Again, that strikes me as a really good way to do things.
01:26 Miller: How did you get to know each other?
01:28 Miller: Did you ask each other what you like?
01:30 Eden: Yeh. We just asked each other what our hobbies were, or sleep habits and things like that.
01:37 Eden: Things that you would ask people that you were going to live with.
01:40 Miller: So when you guys got together during the first days of school, you had pretty much a lot of those things out of the way.
01:46 Eden: Yeh.
01:47 Miller: Okay, I know you like this and you don't like this. 
01:48 Eden: Mmh-hmm. Yeh. So it was really easy to move in that way.

",
"Miller|Eden|orientation|screen names"
	],

	[
        "eden-4",
        "Music and hobbies",
	"access",
	"all",
        "01:52 Miller: Your favorite band.
01:54 Eden: Coheed and Cambria. Mmh-hmm. I just, I really like their music. And my boyfriend introduced them to me and I've been hooked ever since.
02:03 Miller: And I need to ask about your favorite movie?
02:06 Eden: The Nightmare Before Christmas.
02:09 Miller: Your hobbies.
02:09 Eden: My hobbies.
02:11 Eden: I danced for fourteen years.
02:13 Eden: Everything, ballet, tap, jazz.
02:15 Eden: And I did a lot of acting in school.
02:18 Eden: And I have horses.
02:20 Eden: So I ride horseback.
02:23 Eden: And I do a lot of like, crafting. I knit and sew, and crochet.
02:30 Miller: How do you fit all that stuff in.
02:32 Eden: I don't know. (laughs)
02:33 Miller: Ha-ha-ha!

",
"Miller|Eden|Coheed and Cambria|hooked|Nightmare|ballet|tap|jazz|crafting|knit|sew|crochet"
	],

	[
        "eden-5",
        "Saying goodbye",
	"access",
	"all",
        "02:35 Miller: The first day that you came here, that your mother brought you here.
02:39 Eden: Yeh.
02:40 Miller: And she drove away, and you were on your own.
02:43 Miller: What, what were your feelings, right at that point?
02:47 Eden: The whole situation wasn't as hard for me, because I'd been an exchange student last year.
02:52 Eden: So I had already gone through having to be alone and without my parents.
02:57 Eden: So I guess it wasn't as hard as it could have been.
03:01 Eden: But I did get sad when my mom drove away, and she tapped on her brakes.
03:08 Eden: Because she always did that to say goodbye when she left me at the baby sitter.
03:13 Eden: So that was kind of heart-touching. (laughs)
03:15 Miller: Yeh.

",
"Miller|Eden|exchange|tapped"
	],
	
	[
        "family2",
        "Two different households",
	"elementary",
	"all",
        "Here are 2 stories about people living in two different houses. How are the people similar and how are they different?

In the first house, Stanley, Peter, Irene and Alice are all living in the same house. They are all students, and like other students, they do some good things, like studying, and some bad things, like playing computer games when they should be studying.

One of the bad things is: Peter and Stanley often drink in their rooms. even though Irene and Alice never drink. 

They also do some good things, which is good, even if they don't always do them very often.

None of the people in the house ever smokes, which is good. And, Peter and Irene sometimes exercise. That's good. Stanley and Alice exercise, but less often than Peter and Irene.

And, they also often eat vegetables, though Stanley only eats vegetables occasionally.

In another house, Emma, Carrie, Donna and Cindy are living together. They are also students and they also do some good things and some bad things. 

They never do any housework, so the house is very untidy. And Emma and Carrie play a lot of computer games. The others only occasionally play computer games.

All of them also often eat vegetables, which is good. They also all study, but less often than they eat vegetables.

",
"Stanley|Peter|Irene|Alice|Emma|Carrie|Donna|Cindy"
	],

	];

$schema->populate( 'Text', $texts );

my $questions = [
			[ qw/genre text id target content answer/ ],

[ "JUST RIGHT", "eden-1-GL", 1, "all", "The first student Miller talked with was Eden.", "True" ],
[ "JUST RIGHT", "eden-1-GL", 2, "all", "Eden's favorite food is the spaghetti her mom makes.", "True" ],
[ "JUST RIGHT", "eden-1-GL", 3, "all", "Eden thinks her mom's spaghetti is the best because she makes the best sauce.", "True" ],
[ "JUST RIGHT", "eden-1-GL", 4, "all", "Miller doesn't want to try the spaghetti Eden's mom makes.", "False" ],
[ "JUST RIGHT", "eden-1-GL", 5, "all", "Eden doesn't like the spaghetti her mom makes", "False" ],
[ "JUST RIGHT", "eden-1-GL", 6, "all", "Miller hasn't tried the spaghetti Eden's mom makes.", "True" ],

[ "JUST RIGHT", "eden-2-GL", 1, "all", "Eden isn't wearing any pink.", "False" ],
[ "JUST RIGHT", "eden-2-GL", 2, "all", "Eden is wearing pink sneakers.", "True" ],
[ "JUST RIGHT", "eden-2-GL", 3, "all", "Eden's roommate decorated her half of the room in pink.", "False" ],
[ "JUST RIGHT", "eden-2-GL", 4, "all", "Eden and her roommate worked out how to decorate the room beforehand.", "True" ],
[ "JUST RIGHT", "eden-2-GL", 5, "all", "Eden thinks her roomate doesn't like pink.", "False" ],
[ "JUST RIGHT", "eden-2-GL", 6, "all", "Eden decorated her half of the room the way she wanted it to be and her roommate decorated her half of the room the way she wanted it to be.", "True" ],
[ "JUST RIGHT", "eden-2-GL", 7, "all", "The two halves of the room are decorated differently.", "True" ],

[ "elementary", "family2", 1, "all", "Students in both houses often eat vegetables.", "True" ],
[ "elementary", "family2", 2, "all", "None of the people in the second house do housework.", "True" ],
[ "elementary", "family2", 3, "all", "Two of the people in one of the houses drink.", "True" ],
[ "elementary", "family2", 4, "all", "The people in the first house sometimes exercise.", "True" ],
[ "elementary", "family2", 5, "all", "Two of the people in one of the houses play computer games.", "True" ],
[ "elementary", "family2", 6, "all", "One of the people in the first house smokes.", "False" ],
[ "elementary", "family2", 7, "all", "The people in the second house sometimes study.", "True" ],
[ "elementary", "family2", 8, "all", "In both houses, some of the people do some good things and some bad things.", "True" ],

	];

$schema->populate( 'Question', $questions );

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

