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
        "tate",
        "Ed Tate's three speaking tips",
	"speaking",
	"all",
	"00:30 Griffin: I suppose this is a stupid question, but ..
00:32 What is, like if you had to say, the three most important things that public speaking, uh, public speakers should do to, to excel?
00:41 Tate: Well, I think there are several mistakes that .. I focus on business presenters .. and what I see in a business environment are several things.
00:48 Number one, they focus on their, their computers and their content.
They don't spend enough time focusing on connecting with their audiences.
And, I think that's probably the biggest mistake.
So that's one of the things we talked about here today.
I think it's both. It's both content and connection.
And I think presenters need to think about how they're going to .. their material relates to the audience.
01:09 I also need .. I think that people need to be a little bit more mindful of there's different types of learning styles.
There's some people who like to listen to things. There's some people who like to watch, and there's some people who like to do.
And if you saw my presentation today, you'd see that I incorporate all three modalities.
So that's something else to focus on, not so much on your expertise, but focus on how people will get your message.
01:32 And what I try to do, as opposed to speak, like the traditional speaker, I try to create a memorable experience that people talk about.
",
"00:30|00:32|00:41|00:48|01:09|01:32|Tate|Griffin|incorporate|modalities"
	],
	
	];

my $questions = [
			[ qw/genre text id target content answer/ ],

[ "speaking", "tate", 1, "all", "Tate says to focus on the audience as much as on the subject.", "True" ],
[ "speaking", "tate", 2, "all", "Tate says speakers need to be mindful of different things people focus on.", "True" ],
[ "speaking", "tate", 3, "all", "Tate says presenters need to focus on what the audience thinks, not what the speaker says.", "True" ],
[ "speaking", "tate", 4, "all", "Tate thinks speakers don't spend enough time focusing on their computers and content.", "False" ],
[ "speaking", "tate", 5, "all", "Tate says speakers think too much about different learning styles.", "False" ],
[ "speaking", "tate", 6, "all", "Tate says speakers need to be more mindful of their speaking style and their expertise as speakers.", "False" ],

	];

push @$texts, [
        "chasm",
        "The effect of mispronouncing 'chasm'",
	"speaking",
	"all",
	"1:26 Winograd really has a beautiful voice, resonant pitch, crystal-clear diction, good rate.
1:30 You could tell from that clip that she was right on with all the aspects of her delivery.
1:35 But you probably caught her mistake as quickly as I did.
1:39 And I'm betting that you cringed, just as I did.

...

2:06 But the bigger question is, why should such a simple error have such a huge impact on my perception of her.
2:12 Everyone makes mistakes, right?
2:14 It doesn't mean she's completely stupid, right?
2:17 Well, unfortunately, it caused me, and very probably many others, to have a reflex action that said, precisely that.
2:25 It comes down to what we've been talking about for the last few weeks. Credibility.
2:31 Mispronouncing a word is a mistake that is most often made by children. Therefore we associate mispronunciations with immaturity, not credibility.

...

3:13 So, how do you avoid this. Like I mentioned before, anyone can make a mistake. 
3:19 Here's how to make sure you don't mistake pronunciation.
3:24 When you write a speech, be sure that you write from your own vocabulary base, using words that you are familiar with.
3:33 If you do introduce a new word, just make sure you look it up before you use it.
3:37 You might be saying, Well, Winograd's comments sounded off-the-cuff. They weren't scripted beforehand. So how do you avoid mispronunciation mistakes in the moment?
3:46 Well, I doubt that her comments were off-the-cuff. When people are speaking extemperaneously, they rarely use words that aren't a part of their natural language pattern.

4:00 And the perils of not practicing. It would have only taken one person to hear the mispronunciation to correct it.
4:08 If they had and if she had pronounced the word correctly, who knows, she might have won some more votes.

",
"1:26|1:30|1:35|1:39|2:06|2:12|2:14|2:17|2:25|2:31|3:13|3:19|3:24|3:37|3:46|4:00|4:08|Winograd|resonant|crystal|diction|clip|cringed|reflex action|Credibility|immaturity|off-the-cuff|scripted|extemperaneously"
	];

push @$questions,

[ "speaking", "chasm", 1, "all", "Mispronouncing a word might mean people perceive you as stupid.", "True" ],
[ "speaking", "chasm", 2, "all", "To avoid pronunciation mistakes, you should practice before speaking.", "True" ],
[ "speaking", "chasm", 3, "all", "You might make mispronunciation mistakes if you use words you don't know.", "True" ],
[ "speaking", "chasm", 4, "all", "Everyone makes mistakes, so people don't think you are stupid if you mispronounce words.", "False" ],
[ "speaking", "chasm", 5, "all", "To avoid pronunciation mistakes, Winograd should have written her words down.", "False" ],
[ "speaking", "chasm", 6, "all", "Practicing beforehand with other people will not cause you to correct your mistakes.", "False" ];

push @$texts, [
        "fright",
        "Stage fright on podium",
	"speaking",
	"all",
	"0:55 Relax. Here are some tips for overcoming stage fright. Think quiet thoughts. Before you take the podium, think calming thoughts. Pretend you are at the beach, or gently rocking in a boat. Breathe deeply. Walk slowly. As you move toward the podium, walk slowly. Keep breathing calmly. Smile. When you come to the podium, or the center of the room, smile at the audience. Pause for a moment and make eye contact. The people in the room are not vampires.

Focus on your message. Deliver your speech either from a script or note cards. Focus on what you want to say, not what you think people want to hear.

As helpful as these tips are, they will not take away all your butterflies. They will simply ground most of them. And that's a good thing. Many a veteran actor or musician has lost his cookies before a performance. Your challenge is to channel that nervousness into energy that you can put into your words, your voice and your gestures. So go for it. You have nothing to lose but your fears. Break a leg.

",
"0:55|tips|rocking in a boat|vampires|ground|veteran|actor|musician|lost his cookies"
	];

push @$questions,

[ "speaking", "fright", 1, "all", "Nervousness is good if you can channel that energy into delivering your speech.", "True" ],
[ "speaking", "fright", 2, "all", "If you can focus on what to say, you will channel some energy into your message.", "True" ],
[ "speaking", "fright", 3, "all", "It is a good thing to have some butterflies before a performance.", "True" ],
[ "speaking", "fright", 4, "all", "He says the tips are not very good for overcoming for stage fright.", "False" ],
[ "speaking", "fright", 5, "all", "You can take butterflies or cookies and deliver them to the audience to overcome stage fright.", "False" ],
[ "speaking", "fright", 6, "all", "You can overcome all your fears with the tips. And that's a good thing.", "False" ];


push @$texts, [
        "message",
        "Defining the message",
	"speaking",
	"all",
	"1:00 So how do you define your message?

Listen up.

Consider the situation. Ask yourself what is going on in the workplace. Determine what your audience needs to know about what your team is working on and why it's important.

That concept should form the backbone of your presentation.

Communicate what people need to know. Give people the facts. Link your facts to benefits. Demonstrate that what your team does makes things better because it offers a new solution, improves quality, or reduces costs. 

Use stories. Make the facts come alive with stories. 

Translate what you do into benefits for stakeholders, customers, employees, or shareholders. 

Defining the message is really an act of discipline. It is synchronizing your mind with your words to deliver a coherent statement about what is important.

What you include focuses attention. What you do not include is immaterial. Give people the information they can get nowhere else or from anyone else. 

That's a good starting point, and will enable you to quickly hone in on what needs to be said and why.


",
"1:00|workplace|Determine|team|Link|benefits|Demonstrate|offers|solution|quality|costs|stakeholders|customers|employees|shareholders|discipline|synchronizing|coherent|immaterial|hone"
	];

push @$questions,

[ "speaking", "message", 1, "all", "Baldoni considers stories to be a benefit for audiences.", "True" ],
[ "speaking", "message", 2, "all", "Baldoni considers giving people facts they can get from anyone is not what needs to be said.", "True" ],
[ "speaking", "message", 3, "all", "Baldoni communicates that people need to consider what the audience wants to know.", "True" ],
[ "speaking", "message", 4, "all", "Baldoni offers a new, improved solution to giving presentations.", "False" ],
[ "speaking", "message", 5, "all", "In the presentation, Baldoni used stories to communicate to people how to define their message.", "False" ],
[ "speaking", "message", 6, "all", "Baldoni translates his message for the benefit of people not included in the audience.", "False" ];



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

