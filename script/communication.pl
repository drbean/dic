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
        "no",
        "Western-Chinese Business: Saying No Without Saying No",
	"intercultural",
	"all",
        "Chinese have many ways of saying No without saying No.

One of the, most important, or most common ways, the Chinese say No, without saying No, is they use objections as a way of communicating disagreement.

What is an objection? An objection is a request for more information, before you can make a decision.

So the Westerner says, 'Hey, I think we should do X.' Mr Chen now, gives an objection to doing X, 'Oh, X will cost a lot of money.'

Well, Mr Smith now goes, 'Well, yeh, yeh, yeh. It'll cost a lot of money.' But that, he now satisfies that objection.

And now back to Chen. Now if Chen is silent or changes the subject to another objection, it means now he is satisfied with the first objection, and that now he moves to another one: 'Well, it'll be disruptive.'

Mr Smith goes, 'Well, yeh, it'll be disruptive. But you're a good manager. You'll be able to solve that.' In Smith's mind, when Chen doesn't answer, that means agreement. To Chen, he thinks, he's clearly communicated doing X is 'a bad idea. We shouldn't do it.'

When Mr Smith now doesn't go, 'Okay, we are now doing X,' (because he doesn't feel he has to. It's already been communicated), he walks away, thinking, 'Good. We're going to do X. Mr Chen's on board.' Mr Chen walks away, thinking, 'Good, I've explained why we can't do X. Now we have to find another way to do it.'

This happens all the time in Asia. It's because of different rules of communication. The rule that I believe Westerners should know is, Two objections means disagreement.

Actually, there's a, a, bigger rule. Anything other than Yes, means No.


",
"Chen|Smith|yeh|Hey|on board"
	],
	
	[
        "questions",
        "Western-Chinese Business: Questioning Practices",
	"intercultural",
	"all",
        "Welcome to Greg Bissky, our next presentation.

Different cultures develop different rules of communication, way of using language in order to be polite, in order to be clear, in order to transfer messages. Called rules of communication.

Now, as you can see at the top there, the Western rule is, Ask questions if you don't understand. Is this important? How many of you have children? We teach our children to ask questions. We teach students to ask questions. And, you know, how many of you have heard the old saw, The only stupid question is one you don't ask.

Why? Well, asking questions is important to Westerners, because we are measuring efficiency and effectiveness and if you don't know what you should be doing, you're probably going to make a mistake. Murphy's Law. Ask the questions first, and that now we stop the mistake before it starts.

Well, the Chinese have the rule. The rule is, Don't let people know you don't (And there's another word at the far end) understand.

Huh? Don't let people know you don't understand?

Well, I could spend all day, just talking about that one rule.

What it means is that it means the Chinese will not ask the question. How many of you have been in a meeting. The meeting's over and you go, All right, are there any questions, and you just get this nice smile. Well, thank you very much, clap, clap, clap and they leave, and you leave.

And then, now you think, Well, nobody asked the questions. Therefore, they all understand. Well, I tell you, if it's a Chinese audience, I can almost guarantee that there are questions. It's no-one will ask the question. No-one...

The Chinese are never trained from childhood up to ask questions. Does it mean the Chinese won't ask questions? No, they certainly will ask questions. However, you have to now XXXXX (phrase them/approach them?) in a different way. You have to create an environment where the Chinese feel comfortable in asking questions.

The short rule here is, is that, Never do anything in groups. How big is a group? Three or more people. And if you want to find out what Chinese know, what their opinions are, whether they've got any questions, the easiest way to do it is arrange one-on-ones. Takes up your time, you know, but, you know, your time is not valuable. When you're in Chinese Asia, the only thing that's valuable is the results that you achieve. And you're going to have to recognize that you're going to have to put in beggar factor inputs.

Here's another one, State your honest opinion, even if you disagree. This is quite important, once again in Western culture. Western culture is based on disagreements. 

We now have a meeting, and we all sit together and we now talk, and all of us agree. How boring. XXXXX What are we here for? We're just wasting time. The only interesting meetings are meetings where people disagree.

[cut]

Chinese communicate negatives and disagreements indirectly. Now the Chinese disagree? Damn right, they do. However, they will do everything they can not to disagree openly, to disagree indirectly.


",
"Greg Bissky|presentation|transfer messages|saw|efficiency|effectiveness|Murphy's Law|far end|guarantee|trained|XXXXX|phrase them/approach them|valuable|results|achieve|recognize|beggar factor inputs|cut|negatives|Damn right"
	],
	
	[
        "smiling",
        "The meaning of smiles in the US and Germany",
	"intercultural",
	"all",
        "Erica Gingerich: What form of non-verbal communication matters most in business?

Robert Gibson: Just to take one example, perhaps, um, it'd be good to talk about smiling. This seems very simple. Human beings smile all over the world. But they actually smile at different times and the smiling has a different meaning in different countries.

One has to avoid over-generalization, but there's a frequently-experienced difference between the USA and Germany, as to when people smile.

Researchers say that actually there's a different attitude to smiling. Let's just look at what smiling really means in those two countries.

I think in Germany, people smile for a reason. And they often say about the Americans, Ah, people smile all the time. This is superficial. This is actually insincere, or maybe even dishonest.

And if you talk to Americans about Germans, they can often say, Ah, the Germans are really unfriendly. When I go in the service encounter, a shop or I'm doing business, they never seem to smile.

Now, what's the reason for this? I think in Germany, the smile is something reserved for a particular occasion, or has a particular cause. There is a reason for the smile. 

In America, researchers talk about the 'contact smile.' You smile when you meet someone, before you even say something. So, if you understand that, that there is a different reason for the smile, then I think you can avoid this misinterpretation of the situation.

",
"Erica Gingerich|Robert Gibson|particular occasion"
	],
	
	[
        "secondlife",
        "Don't Stand So Close To Me",
	"intercultural",
	"all",
        "This feels pretty wierd, doesn't it. It's like I'm breaking some unwritten rule, right? Well, psychologists would say I'm breaking about two or three at once.

Too much staring, too little personal space. Put them together and suddenly something's got to give. You've got to break eye contact, or get away.

It's actually called the Elevator Effect. Funny thing is, it's not confined to elevators. It happens in all sorts of places. Even in a place where almost all the other unwritten rules don't apply.

4:50 Rosenfeld: But why do we follow these rules in a virtual world? Why should things like interpersonal distance and eye contact even matter?

Yi: So there's probably both a hard-wired innate component to it, as well as a social component to it. And we're so used to these norms, you know, as we're growing up, that, you know, when someone violates them unexpectedly, it's incredibly, uh, psychologically uncomfortable when they do that.

",
"Elevator Effect|confined|virtual|hard-wired innate component|social|norms|violates"
	]
	];

uptodatepopulate( 'Text', $texts );

my $questions = [
			[ qw/genre text id target content answer/ ],

[ "intercultural", "no", 1, "all", "Chen and Smith are clearly communicating to each other what each other thinks.", "False" ],
[ "intercultural", "no", 2, "all", "Chen uses objections to communicate disagreement with Smith, not a problem with the subject of X.", "True" ],
[ "intercultural", "no", 3, "all", "Smith thinks Chen is on board because he satisfies his two objections with his answer.", "True" ],
[ "intercultural", "no", 4, "all", "Chen doesn't answer when Smith satisfies his objection. This means he agrees that they should do X.", "False" ],
[ "intercultural", "no", 5, "all", "Smith doesn't say, \"We are now doing X,\" because he thinks Chen might disagree with X.", "False" ],
[ "intercultural", "no", 6, "all", "When Chen is silent or his objection is satisfied,  Smith thinks Chen is on board, but Chen thinks he communicated his disagreement.", "True" ],

[ "intercultural", "questions", 1, "all", "Bissky's rule is: 'Chinese people will ask questions if they don't understand you.'", "False" ],
[ "intercultural", "questions", 2, "all", "Bissky's rule is: 'Chinese people will not ask questions if they are in a big group.'", "True" ],
[ "intercultural", "questions", 3, "all", "A Bissky rule is: 'Chinese people will not state their disagreement honestly.'", "True" ],
[ "intercultural", "questions", 4, "all", "A Bissky rule is: 'It is better to deal with Chinese people in groups of three or more people.'", "False" ],
[ "intercultural", "questions", 5, "all", "A Bissky rule is: 'Westerners don't like to have meetings where people will disagree.'", "False" ],
[ "intercultural", "questions", 6, "all", "A Bissky rule is: 'One-on-ones are the best way to get Chinese to state their honest opinion.'", "True" ],

[ "intercultural", "smiling", 1, "all", "People in Germany maybe think people in the US are dishonest when they smile.", "True" ],
[ "intercultural", "smiling", 2, "all", "Shop people in Germany often don't smile when they talk.", "True" ],
[ "intercultural", "smiling", 3, "all", "Americans think Germans are unfriendly in service encounters.", "True" ],
[ "intercultural", "smiling", 4, "all", "People in Germany and the US have similar attitudes to smiling.", "False" ],
[ "intercultural", "smiling", 5, "all", "Germans think Americans are very friendly because they smile a lot.", "False" ],
[ "intercultural", "smiling", 6, "all", "The contact smile is a smile for when you misinterpret a situation.", "False" ],

[ "intercultural", "secondlife", 1, "all", "Too much staring and too little personal space is psychologically uncomfortable.", "True" ],
[ "intercultural", "secondlife", 2, "all", "The Elevator Effect is an unwritten rule about breaking eye contact or being too confined.", "True" ],
[ "intercultural", "secondlife", 3, "all", "People growing up get used to interpersonal distance and eye contact rules.", "True" ],
[ "intercultural", "secondlife", 4, "all", "People are comfortable when someone violates their personal space.", "False" ],
[ "intercultural", "secondlife", 5, "all", "Personal space and eye contact rules don't apply where there is no space.", "False" ],
[ "intercultural", "secondlife", 6, "all", "Staring rules are not followed in elevators and virtual worlds.", "False" ],

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
