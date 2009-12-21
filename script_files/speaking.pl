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

push @$texts, [
        "feng",
        "Eric Feng stage fright interview",
	"speaking",
	"all",
	"Pauline Oliveiro: Welcome to the F-CUBE interview. Now, does the thought of public speaking immediately make you break out in sweat, or give you a sort of panic attack?

Well, hopefully, we can help in the next ten minutes or so. Welcome to the F-CUBE interview. With me, Melanie Oliveiro and authors of the book, Kelvin Lim and Eric Feng.

Now, they have written the FAQ, or Frequently Asked Questions Book on Public Speaking. It aims to answer all your questions about speaking to a large or small crowd. And hopefully help you become a confident, credible, and compelling speaker.

...

1:05 Now guys, I've got to ask you, Now, why do people suffer from stage fright before making a public speech? Where does this fear come from? And why do we have this fear in common, all of us.

Eric Feng: All right. Hello, good evening. My name's Eric. So, let me attempt to answer the question. 

I think over the years, I've realized that it's not public speaking that people are afraid of. It's public humiliation. And that itself is a source of a lot of stage fright for speakers. 

And, um, I think another reason as well is the uncertainty. Uncertainty of the topic. They do not know what to say. They do not know who the audience are, and whether the audience will accept them. or their speeches. So that itself are some of the causes for the stage fright.

Pauline Oliveiro: So they are presupposing failure as opposed to facing it head-on on the day itself.

Eric Feng: Right, correct.

Pauline Oliveiro: I see, okay.

",
"Pauline Oliveiro|F-CUBE|sweat|panic attack|Kelvin Lim|Eric Feng|Frequently Asked Questions Book on|confident|credible|compelling|1:05|humiliation|presupposing"
	];

push @$questions,

[ "speaking", "feng", 1, "all", "Feng says speakers face uncertainty giving a speech and this is a source of stage fright.", "True" ],
[ "speaking", "feng", 2, "all", "Feng says speakers fear being humiliated before an audience, not speaking itself.", "True" ],
[ "speaking", "feng", 3, "all", "Oliveiro says speakers are not hopeful and think they will fail, before they give the speech.", "True" ],
[ "speaking", "feng", 4, "all", "In this first minute of the interview, Feng answers speakers' questions how they can get over their fear.", "False" ],
[ "speaking", "feng", 5, "all", "Feng says speakers do not know their topics well, so they are afraid of humiliation.", "False" ],
[ "speaking", "feng", 6, "all", "Oliveiro asks Feng why he is afraid of answering her question about public speaking", "False" ];

push @$texts, [
        "garrett",
        "Speech start",
	"speaking",
	"all",
	"1:36 Thank you, Claire. That's really the nicest introduction I've ever had.

And I, I really do need to say how very .. grateful and touched I was to be invited to do this. 

Recordist: (inaudible)

Garrett: This? I've got something on.

Recordist: Yeah, but (inaudible)

Garrett: What am I supposed to be doing? I can talk loud too. I used to be an actress, you know. ... Rumble, rumble. ... Am I live? 

Recordist: Yeah. (inaudible)

Garrett: (inaudible) I've already got something on my belt.

Recordists: (inaudible)

Garrett: Oh, I need two.

Audience: (laughter)

Garrett: Yeah, I'm technologically challenged. In a major way. Claire and her Twitter account. Let me tell you. Rotsa Ruck.

Okay. So I was just starting to get sentimental. And say, how very much appreciated this, the honor of being asked to speak to CALICO, is.

And CALICO usually gets outside speakers for the, for the, uh, the keynotes. And, and, uhm, they give us lots of interesting perspectives from outside the field. And some of them tend to talk down to us. And I really liked what Claire said about, you know, I'm, I'm one of us.

So, you could, you could, at least be sure that I won't do that.

But I'm very humble about speaking to this audience, because, uhm, all of you who know me (and I think that's probably a fair number of you) know perfectly well that all I can do is sort of talk in general terms about things that I can't do but that you can. 

And that makes me feel very diffident and very hesitant. But as long as, sort of, the big-picture discussions are of any use to anybody, well, that seems to be the kind of thing that I'm relatively good at.

Maybe we should form a new version of the old bromide, you know, Those who can do, those who can't give keynotes.

Audience: (Some laughter)

",
"Recordist|Garrett|Audience|1:36|major way|Claire|Twitter account|sentimental|CALICO|perspectives|diffident|hesitant|bromide"
	];

push @$questions,

[ "speaking", "garrett", 1, "all", "Garrett thinks she may not need two things on her belt, but she is 'technologically challenged.'", "True" ],
[ "speaking", "garrett", 2, "all", "Garrett appreciates the honor of being asked to give a keynote at CALICO.", "True" ],
[ "speaking", "garrett", 3, "all", "Garrett feels diffident and hesitant because the audience is more technologically able than her.", "True" ],
[ "speaking", "garrett", 4, "all", "The recordists are hesitant and diffident about giving Garrett things for her belt.", "False" ],
[ "speaking", "garrett", 5, "all", "Garrett is very good at technology, but not very good at big-picture discussions.", "False" ],
[ "speaking", "garrett", 6, "all", "Garrett says speakers have talked down to the audience, and she will too, because she is one of them.", "False" ];

push @$texts, [
        "mrbean",
        "Best man's speech",
	"speaking",
	"all",
	"2:14 Groom: Next came my trusted best man.
Best Man: Oh, right, right. Heh-heh. Right. Well, ha-ha, right. Um, ah, ladies and gentlemen, and fellow survivors of that stunning stag party. How did those two girls get under the table, and what the hell were they up to with that tooth paste.
Heh-heh. Right, well. Um, well. Ah, just before I left the house, um, this afternoon, he-he-he, I said to myself, you know, the last thing you must do is forget your speech. Um, and so sure enough, when I left the house, ooh, ha-ha-ha, the last thing I did, yes, you've guessed it, was to forget my speech. So, it's all ad lib, I'm afraid.
Er, um, er, er, ah, ah, ah, ah, ah, ah, ah-ah-ah. Ah-ah-ah-ah-ah-ah-ah-ah-ah. Ah! Ha-ha-ha, ha-ha-ha.
Right, well, anyway, well, now, where should I begin. I'd like to begin now. Ha ha ha. Right, well, well.
Well, I've known the groom, ever since we first went to school together at the age of eight. And you know he hasn't changed a bit.
Uh, well, that's not quite true, of course. He didn't have his beard then.
And I tell you this. He wouldn't have been able to do whatever he was doing last night with those two extraordinary, extraordinary, um, .. extraordinary how little people change, isn't it. Yeh.
Uh, uh, uh. er, although I know I've changed a great deal. Because I used to be an absolute arse. Always blurting things out when I shouldn't. For instance, this afternoon, I'm sure I wouldn't have been able to resist mentioning the bizarre sight that greeted my eyes when I opened this man's bedroom door earlier this morning. Yes, but, but enough of that.
Er, ha-ha-ha, he's started making gestures at me now, which I think means he wants me to cut my speech short.
Um, so suffice to say, I think he'll make a ripping husband. Then I think his wife's ripping too. And, er I can only hope that the dress will hold out. 
So, I'd like to propose a toast, to go with the pate.
Ha-ha, um, to the groom and to his lovely horse, er wife. It's all starting to come back to me, now. Um, and I just know that their marriage will be as happy and satisfied as I was when I paid off those two prostitutes earlier this morning.

",
"2:14|Groom|Best Man|stag party|arse|blurting|suffice to say|ripping|pate"
	];

push @$questions,

[ "speaking", "mrbean", 1, "all", "The best man forgot to bring the speech, so he has to ad lib.", "True" ],
[ "speaking", "mrbean", 2, "all", "The groom is not happy with the best man's speech, so he wants him to cut it short.", "True" ],
[ "speaking", "mrbean", 3, "all", "The best man thinks the groom's wife is a horse.", "True" ],
[ "speaking", "mrbean", 4, "all", "Last night the best man and the groom were with the groom's wife-to-be.", "False" ],
[ "speaking", "mrbean", 5, "all", "The best man used to be an arse, but now he isn't an arse because he resists mention bizarre things.", "False" ],
[ "speaking", "mrbean", 6, "all", "The groom's wife will be happy knowing what the groom was doing last night at the stag party.", "False" ];

push @$texts, [
        "interview-1",
        "Sonia Leigh: Musician",
	"speaking",
	"all",
	"3:47 Nick: So on September fourth of this year, Sonia Leigh, one of Georgia's best (inaudible) singer-songwriters, will be joining the Georgia Music Hall of Fame's Live at Five series at the Hard Rock Cafe in downtown Atlanta for a performance that is actually pretty unusual. It's five o'clock at the end of the work day. A great way to blow off some steam. And believe you me, Sonia Leigh will help you blow off some steam. It's good to see you.
Sonia: Good to see you, Nick.
Nick: For those of our listeners that haven't yet heard your music, and they're going to hear some in just a few minutes, and hopefully they'll come out to the show. You know, what would you say to somebody that's never heard Sonia Leigh. What are you about?
Sonia: Well we're mostly about just getting out and uh, .. blowing off some steam. Just like everybody else. It's, it's basically, music is my release and, uh, sometimes that fire kind of catches on to the crowd and so that's basically what I play music for, is to blow off steam.
Nick: And you started really young.
Sonia: Yes.
Nick: How did that happen?
Sonia: Uh, I guess just naturally. My father ...

",
"3:47|Nick|Sonia|Leigh|Georgia|Hall of Fame|Live at Five|Hard Rock Cafe|Atlanta"
	];

push @$questions,

[ "speaking", "interview-1", 1, "all", "Nick says listeners hopefully will come to hear Sonia blow off some steam.", "True" ],
[ "speaking", "interview-1", 2, "all", "Sonia likes to blow off steam for a crowd with her music.", "True" ],
[ "speaking", "interview-1", 3, "all", "The performance is unusual because it is at five o'clock, after work.", "True" ],
[ "speaking", "interview-1", 4, "all", "If there is a fire in the crowd, Sonia will use steam  to blow it out.", "False" ],
[ "speaking", "interview-1", 5, "all", "Sonia is unusual because she blows steam at the crowd at a performance.", "False" ],
[ "speaking", "interview-1", 6, "all", "The performance is at the Georgia Music Hall of Fame in Atlanta.", "False" ];


push @$texts, [
        "interview-2",
        "Jazz fan speaks",
	"speaking",
	"all",
	"Bradford: Welcome to the Jazz St Louis podcast. I'm Gene Dobbs Bradford and today, I'm joined by noted jazz scholar, and host of Jazz Unlimited, on KWMU, Dennis Owsley. Dennis, thanks for joining us today.
Owsley: Ah, it's good to be here, Gene. Be a lot of fun.
Bradford. We're here today to talk a little about Blue Note records and their seventieth anniversary. And, um, you've done quite a bit of research on Blue Note and, uh, have done several shows on your show on KWMU, Jazz Unlimited, but, uh, for those listeners out there, who may not be as familiar with it, (Certainly most people if you are a jazz fan you know a little bit about Blue Note. You've heard the name), but perhaps you could tell us just what is so important. Why is this such a milestone for jazz.
Owsley: Well Blue Note is really kind of the gold standard for jazz recordings. Uh, they have had a track record that goes back to 1939 of producing great recordings. Doesn't mean hits. Hits are different than great recordings, quite often.
Bradford: Mmh-hmm.
Owsley: So, uh, ...

",
"Jazz|St Louis|Gene Dobbs|Bradford|Dennis|Owsley|Blue Note|milestone|gold standard|track record"
	];

push @$questions,

[ "speaking", "interview-2", 1, "all", "Bradford has a jazz show and Owsley hosts a different jazz show on KWMU.", "True" ],
[ "speaking", "interview-2", 2, "all", "Owsley is not the host of the Jazz St Louis podcast. Bradford is.", "True" ],
[ "speaking", "interview-2", 3, "all", "Blue Note has produced great jazz records since 1939.", "True" ],
[ "speaking", "interview-2", 4, "all", "Most jazz fans are not familiar with Blue Note.", "False" ],
[ "speaking", "interview-2", 5, "all", "The Blue Note anniversary is a milestone for Bradford and Owsley.", "False" ],
[ "speaking", "interview-2", 6, "all", "Owsley is having his seventieth anniversary at Blue Note.", "False" ];



push @$texts, [
        "language-1",
        "Talking monkey",
	"speaking",
	"all",
	"1:10 A common question among the foreign community here in China is \"Do you speak Chinese?\" Well, my answer is yes, but with a somewhat metaphysical qualification. Yes, I speak Chinese. I work in it, I can negotiate in it, I can do business in it. However I’m unsure that when I do speak Chinese, that I am really \"me\" — or maybe even human. Because to the non-philosophy majors out there (ie, those with a real education) \"metaphysics\" often means \"confusion.\" Please allow me to explain.

To my Chinese friends and co-workers, I am neither funny nor witty in Chinese, though I like to think I am (maybe mistakenly) in my native language. I am certainly interesting in Chinese, in the same sense that monkeys are amusing when taught to use simple sign language. I can talk in Chinese, but it's not communication. Maybe, It's, it's desperation. Some people say I am \"bright\" because I can pick up the language or, or \"clever\" because I can mimic an accent. Yet I don’t consider those attributes to be necessarily \"human.\" The reason being, communication has nothing to do with fluency and everything to do with culture.

In China, to be human is to use the Chinese language and to use it properly. Anthropologists have discovered rudimentary Chinese characters scratched into turtle shells and cattle bones many thousands of years old. To be Chinese is to be attached to that history by some unseen umbilical cord which feeds you and keeps you alive. To really speak Chinese, you must incorporate that history into your very being.

",
"1:10|metaphysical qualification|non-philosophy|metaphysics|witty|desperation|mimic|Anthropologists|rudimentary|turtle shells|cattle bones|umbilical cord"
	];

push @$questions,

[ "speaking", "language-1", 1, "all", "He thinks he is not funny in Chinese, but he thinks he is interesting in Chinese.", "True" ],
[ "speaking", "language-1", 2, "all", "He thinks he is like a monkey in Chinese. He is not \"human\".", "True" ],
[ "speaking", "language-1", 3, "all", "He is not attached to Chinese culture, so he cannot be \"human\" in Chinese.", "True" ],
[ "speaking", "language-1", 4, "all", "He thinks that fluency is necessary to speak the Chinese language properly.", "False" ],
[ "speaking", "language-1", 5, "all", "He thinks Chinese culture is rudimentary and not human, because of scratched characters.", "False" ],
[ "speaking", "language-1", 6, "all", "People say to him that his Chinese is not human, because he is bright and clever.", "False" ];



push @$texts, [
        "language-2",
        "Pronunciation and confidence",
	"speaking",
	"all",
	"1:31 Second, focus on your tones. I'm going to repeat this because I wish someone had been firmer with me when I first started. Focus on your tones. I would've saved myself a lot of time and trouble, if I had truly paid a way, attention to the way I was pronouncing words from the very beginning. After my second year of studying, I finally went to China for the first time. It was only then that I realized that all those corrections my teacher kept giving me on my tones were really super-duper. unbelievably important. 

In fact, once in China, after two years of not doing it right, I had to essentially relearn my spoken Chinese and all because I hadn't paid enough attention to memorizing tones in the first place. 

That first summer in China, I had a friend who over enunciated every tone. It drove me bonkers. But after six weeks, his Chinese kicking my Chinese's ass. Big time.

4:09 You can't be that far from your peers, so don't be intimidated by them. I'm going to give you an example. During a summer program I did in southern China, we had a project called Practicum. Every week we went out in groups taking turns surveying people about a topic related to our curriculum. It was supposed to get us interacting with real Chinese people while practicing our new vocabulary and grammar. We would practice speaking when asking questions and practice listening when recording answers. 

This one girl in our class always seemed so impressive to me. She would interview people and sit there looking engaged and involved. One week we were grouped together. It was her turn and she asked her questions one by one. And she, as always, looked immersed in the conversation while her other partners and I were absolutely bewildered not understanding a word being said.

After she finished, she thanked the interviewee and turned back to us. We asked what she had said, explaining that we didn't understand a word of what the woman had told her. She just shrugged her shoulders and said, I don't know. Neither did I. 

Confidence and bravado are easily faked with a nod and a smile. Never be intimidated by what you think someone knows. 

",
"1:31|tones|focus|firmer|trouble|truly|attention|corrections|super|unbelievably|essentially|relearn|summer|enunciated|bonkers|4:09|peers|intimidated|program|southern|project|Practicum|groups|surveying|topic|curriculum|supposed|interacting|practicing|impressive|interview|engaged|involved|immersed|bewildered|shrugged|Confidence|bravado|faked|intimidated"
	];

push @$questions,

[ "speaking", "language-2", 1, "all", "Rachel's first example is about her friend who paid attention to memorizing tones. ", "True" ],
[ "speaking", "language-2", 2, "all", "The girl in Rachel's class didn't understand but faked it with a nod and a smile.", "True" ],
[ "speaking", "language-2", 3, "all", "Rachel said to study pronouncing and not be intimidated by partners.", "True" ],
[ "speaking", "language-2", 4, "all", "Rachel's friend kicked her, because she hadn't paid attention to studying Chinese.", "False" ],
[ "speaking", "language-2", 5, "all", "One girl was impressive because she understood what the woman said to her.", "False" ],
[ "speaking", "language-2", 6, "all", "Rachel kicked her friend because his Chinese drove her bonkers.", "False" ];



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

