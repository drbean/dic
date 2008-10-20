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
	[ qw(id description genre content unclozeables) ],

	[
        "smiths",
        "Jo Smith and Joe Smith",
	"elementary",
        "Just Right Elementary Student's Book. American Edition, by Carol Lethaby, Ana Acevedo and Jeremy Harmer. Copyright Marshall Cavendish, Limited, 2007.

Track 1:

1.  My name is Jo Smith. I'm a dentist. I'm from Argentina. I have one brother, Alberto. He and his wife Patty have one son, Paco. My husband, Peter, is English. We have two sons, Freddy, twelve, and Ricky, eight, and a baby daughter, Monica, eighteen months old.

2. I'm Joe Smith and I'm thirty-eight. I'm an architect. My father is from Scotland and my mother is from Jamaica, in the Caribbean. I'm American. I'm an only child. My wife, Sandra, is a teacher. We have two daughters: Alice, twelve and Neisha, six. We also have a son, Barry, fourteen months old. We live in California.

",
"Carol|Lethaby|Ana|Acevedo|Jeremy|Harmer|Smith|Argentina|Alberto|Patty|Paco|Peter|Freddy|Ricky|Monica|Jamaica|Caribbean|Sandra|Alice|Neisha|Barry|California|Marshall|Cavendish"
	],
	
	[
        "pilot",
        "A life in the sky",
	"elementary",
        "Pilots have interesting lives. They visit many places and meet many people. But is it an easy job? Alan Alder is a pilot. He usually flies from LA to London on Tuesdays. He gets up at five am and he arrives at the airport at six am His flight is at eight o'clock. Eleven hours later he's in London. It is six am in London. Normally, he doesn't go out on the first day. He relaxes: he plays golf, he watches TV and goes to bed early. On Friday, he flies back to LA. Does he like his job? \"It's very hard work,\" he says. \"But the money is good and I have good vacations. Life in the sky is great!\"

",
"Pilots|Alan|Alder"
	],

	[
        "destinations",
        "Orlando or Seattle?",
	"intermediate",
        "Sonia: So which is better, then, Fran? Orlando or Seattle?
Fran: Orlando, definitely. It's more relaxing, and it's cheaper! And it's got lovely beaches.
Sonia: But we always go to the beach. I'd rather do something different this year. Something more interesting. Like a city. Like Seattle.
Fran: There's a problem, then, Sonia.
Sonia: Oh, What's that?
Fran: Because I like beaches. Well, I like beaches better than cities, anyway. And Orlando is sunnier too. And it always rains in Seattle, you know, Sonia.
Sonia: No, it doesn't. And anyway, rain or no rain, there's more to do in Seattle.
Fran: Like what? Museums and things like that? I'd rather stay here in New York!
Sonia: Okay then. You go to the beach and I'll go to Seattle. How's that?
Fran: Oh, all right. You win. This time. But no museums and no walking around in the rain!

",
"Sonia|Fran|Orlando|Seattle"
	],
	
	[
        "stress",
        "Stress: the facts",
	"intermediate",
        "Do you ever feel that you don't know what to do because there are too many things in your life? Then you probably feel stress.

Things that cause stress are called \"stressors.\" One important stressor is change. For example, going to a new school or starting a new job can give you stress. Other common stressors are taking a test or being sick.

But some stress can be good. For example, before a race most athletes feel nervous. This stress helps them get ready.

What makes stress good or bad? Let's look at an example: Jack has a new job in another city. He and his wife are very excited. But their children are sad to leave their family and friends. The move to another city is a good stressor for the parents but a bad one for the children. The parents and the children have different feelings about the situation.

When you are feeling stressed, these tips can help you:

Eat lots of fruit and vegetables and meat and fish without fat. Salad is good too. Don't eat any snacks like potato chips, and don't drink any caffeine. Don't eat too much sugar. Put the chocolate and cakes away.

Do exercise every day. Laugh! Make time for fun.

Talk about your problems.

",
"stressor|athletes|caffeine"
	]
	];

$schema->populate( 'Text', $texts );

my $questions = [
			[ qw/genre text id content answer/ ],

[ "elementary", "smiths", 1, "Freddy and Ricky's mother is a dentist.", "True" ],
[ "elementary", "smiths", 2, "The architect's sons and daughter are called Alice, Neisha and Barry.", "True" ],
[ "elementary", "smiths", 3, "The father of Barry's father is from Scotland and the mother of Barry's father is from the Caribbean.", "True" ],
[ "elementary", "smiths", 4, "The dentist is from Argentina and is married to a woman from the Caribbean.", "False" ],
[ "elementary", "smiths", 5, "Freddy, Ricky and Monica's mother is Alice, Neisha and Barry's father.", "False" ],
[ "elementary", "smiths", 6, "The woman whose husband is English has a name like the man whose father is from Scotland.", "True" ],

[ "elementary", "pilot", 1, "Alan flies to London on Tuesdays.", "True" ],
[ "elementary", "pilot", 2, "He gets up early on Tuesdays.", "True" ],
[ "elementary", "pilot", 3, "Alan's flight is at six o'clock", "False" ],
[ "elementary", "pilot", 4, "Alan goes out on Tuesday night.", "False" ],
[ "elementary", "pilot", 5, "Alan is in London for five days.", "False" ],
[ "elementary", "pilot", 6, "Pilots have an easy job.", "False" ],

[ "intermediate", "destinations", 1, "Fran'd rather go to the beach in Orlando and Sonia'd rather go to museums in Seattle.", "True" ],
[ "intermediate", "destinations", 2, "Orlando's sunnier, more relaxing and cheaper than Seattle. Seattle's rainier and not as cheap as Orlando.", "True" ],
[ "intermediate", "destinations", 3, "Fran and Sonia decide to go to different places.", "False" ],
[ "intermediate", "destinations", 4, "Fran doesn't like going to museums. She likes going to the beach.", "True" ],
[ "intermediate", "destinations", 5, "Fran'd rather stay in New York than go to the beach in Orlando.", "False" ],
[ "intermediate", "destinations", 6, "Sonia'd rather go to rainy Seattle than sunny Orlando.", "True" ],
[ "intermediate", "destinations", 7, "Sonia'd rather go to Seattle by herself than go to Orlando with Fran.", "True" ],

[ "intermediate", "stress", 1, "You feel stress if there is no change in your life.", "False" ],
[ "intermediate", "stress", 2, "Jack and his wife feel good about the move to the new city.", "True" ],
[ "intermediate", "stress", 3, "Stress is good if it helps you get ready for change.", "True" ],
[ "intermediate", "stress", 4, "Stress is bad if you have different feelings about the situation than your family.", "False" ],
[ "intermediate", "stress", 5, "Coffee is good if you are feeling stressed.", "False" ],
[ "intermediate", "stress", 6, "Chocolate is good for people who feel nervous. It helps them get ready.", "False" ],

	];

$schema->populate( 'Question', $questions );
=head1 NAME

script_files/justright.pl - Set up dic db

=head1 SYNOPSIS

perl script_files/justright.pl

=head1 DESCRIPTION

'CREATE TABLE texts (id text, description text, genre text, content text, unclozeables text, primary key (id))'

=head1 AUTHOR

Dr Bean C<drbean at, yes, at (@) cpan, a dot, yes a dot, ie (.) org>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

