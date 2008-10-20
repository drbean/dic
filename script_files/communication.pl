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
        "no",
        "Western-Chinese Business: Saying No Without Saying No",
	"intercultural",
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
	]
	];

$schema->populate( 'Text', $texts );

my $questions = [
			[ qw/genre text id content answer/ ],

[ "intercultural", "no", 1, "Chen and Smith are clearly communicating to each other what each other thinks.", "False" ],
[ "intercultural", "no", 2, "Chen uses objections to communicate disagreement with Smith, not a problem with the subject of X.", "True" ],
[ "intercultural", "no", 3, "Smith thinks Chen is on board because he satisfies his two objections with his answer.", "True" ],
[ "intercultural", "no", 4, "Chen doesn't answer when Smith satisfies his objection. This means he agrees that they should do X.", "False" ],
[ "intercultural", "no", 5, "Smith doesn't say, \"We are now doing X,\" because he thinks Chen might disagree with X.", "False" ],
[ "intercultural", "no", 6, "When Chen is silent or his objection is satisfied,  Smith thinks Chen is on board, but Chen thinks he communicated his disagreement.", "True" ],

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
