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

my $texts = [ [ qw(id description genre target content unclozeables) ] ];
my $questions = [ [ qw/genre text id target content answer/ ] ];

push @$texts, [
        "time",
        "Tension between being perfect and being productive",
	"teaching",
	"all",
	"1:23 Sure. I think if there's one thing, principle that guided my preparation for teaching, but also scholarship, as I'll explain later, is this tension between being perfect and being productive.

1:41 Um, you have to do great work, but it can't always be perfect. Especially, the first time. And I think that's especially true when you're preparing for teaching. Uh, given all the responsibilities a tenure-track faculty member has, starting a new job, uh, you know, the most important of which is getting his or her research or scholarly program up and going, and productive.

2:06 Uh, you can't spend all of your time preparing a course, or two courses, because you've got other things to do. And I think anybody who has the experiment, the experience of preparing a course knows that it can take all of your time, and more. So you just have to limit how much time you put into the preparation of a course the first time you teach it.

2:36 I think the thing to keep in mind is that you're going to be teaching the rest of your career. And you're probably going to be teaching a course multiple times. And so when you teach it the first time, it should be really good. But it doesn't have to be perfect.

",
"1:23|1:41|2:06|2:36|scholarship|tenure-track faculty member|research or scholarly program|multiple"
	];

push @$questions,
[ "teaching", "time", 1, "all", "Preparing to teach can take too much time", "True" ],
[ "teaching", "time", 2, "all", "The first course you teach shouldn't be perfect.", "True" ],
[ "teaching", "time", 3, "all", "Teachers have to do other things as well as teach.", "True" ],
[ "teaching", "time", 4, "all", "All a teacher's courses should be perfect, even a first course.", "False" ],
[ "teaching", "time", 5, "all", "A teacher has other responsibilities as well as teaching, but he or she can also teach a perfect course.", "False" ],
[ "teaching", "time", 6, "all", "You can't think about making your course better after the first time.", "False" ];

push @$texts, [
        "energy",
        "Energy needed by beginning teachers",
	"teaching",
	"all",
	"0:45 Kady Amundson: I loved the energy of today. I loved the fact that everybody is really, really positive about what we can do in New Orleans.
0:50 Amanda Sias: I'll give it a 70 percent chance, that what he said would be counted as realistic.
0:57 John Merrow: Amanda Sias and Kady Amundson are teachers at Rabouin High School. Amanda has been teaching for ten years. Kady is brand new, a member of Teach For America. I sat down with them and Jason Denlinger, a second-year teacher, shortly after Paul Vallas addressed the New Orleans teachers for the first time.
1:16 John Merrow: Let me see, let me see, now, Kady, you’re sort of the new kid on the block. The veteran teacher is skeptical. You SEEM pretty enthusiastic.
1:30 Kady Amundson: It’s hard to be skeptical when you don’t - we haven’t had the life experience that Amanda’s had. So it’s - you know, I don’t - I don’t have the life experience - I don’t have the teaching experience, so I’m naturally not going to be as skeptical because I don’t - I just don’t have the experience. So for me it was probably a little bit more motivating. It was good to see a united front and just to see that number of people that are here between, like, the new teachers, the veteran teachers that return - people returning to New Orleans that are going to teach, and just, like, what the RSD actually looks like.  The most important thing to me was just being in a room with all of these people that are - have the same goal. We’re all trying to improve education in New Orleans within our classroom, within our school, and, you know, on a broader level. So.
2:24 John Merrow: In some sense, though, it was kind of like a revival meeting. Does that stay with you?
2:28 Kady Amundson: Well, the energy is good because you have to have energy to sustain just teaching in general. Like it’s not a nine to five type of job. I mean it’s pretty much consuming, like, you - you have to be involved in your school in so many different ways. And just being a classroom teacher at all takes so much preparations of - just the energy there, just - it’s - I kind of feed off that, knowing that there are other people that are excited about it and they, you know, really want to be here. So that energy was very good.
3:05 John Merrow: Let me ask Jason.

",
"0:45|0:50|0:57|1:16|1:30|2:24|2:28|3:05|Amanda Sias and Kady Amundson are teachers at Rabouin High School. Amanda has been teaching for ten years. Kady is brand new, a member of Teach For America. I sat down with them and Jason Denlinger, a second-year teacher, shortly after Paul Vallas addressed the New Orleans teachers for the first time.|Kady|Amundson|Amanda|Sias|New Orleans|I'll give it a 70 percent chance, that what he said would be counted as realistic.|John Merrow|Let me see, let me see, now, Kady, you’re sort of the new kid on the block. The veteran teacher is skeptical. You SEEM pretty enthusiastic.|It was good to see a united front and just to see that number of people that are here between, like, the new teachers, the veteran teachers that return - people returning to New Orleans that are going to teach, and just, like, what the RSD actually looks like.  The most important thing to me was just being in a room with all of these people that are - have the same goal. We’re all trying to improve education in New Orleans within our classroom, within our school, and, you know, on a broader level. So.|In some sense, though, it was kind of like a revival meeting. Does that stay with you?|sustain|consuming|feed off|Let me ask Jason."
	];

push @$questions,
[ "teaching", "energy", 1, "all", "The new teacher is enthusiastic, but the old teacher is skeptical.", "True" ],
[ "teaching", "energy", 2, "all", "The new teacher said she is not going to be as skeptical as the veteran teacher, because she doesn't have as much experience teaching.", "True" ],
[ "teaching", "energy", 3, "all", "The new teacher said the other teachers gave her energy.", "True" ],
[ "teaching", "energy", 4, "all", "The new teacher said it wasn't motivating to be with the other teachers.", "False" ],
[ "teaching", "energy", 5, "all", "The new teacher was skeptical about having enough energy to teach.", "False" ],
[ "teaching", "energy", 6, "all", "The new teacher said she had to be involved in just her classroom.", "False" ];

push @$texts, [
        "accent",
        "American accents",
	"teaching",
	"all",
	"4:25 Bill: .. interesting. I mean, I think for the first few answers, Robert and I both answered the same way. Uh, Kevin, how about you. It says C-O-T and C-A-U-G-H-T. Same or different?
Kevin: Well, those are definitely different. 
Bill: Oh, really? OK. So, What's C-O-T?
Kevin: Well, 'cot' is what you sleep on. And if you get 'caught,' then uh, it's 'cot' and 'caught.'
Bill: 'Cot' and 'caught.' I was caught sleeping on my cot.
Kevin: Oh, no, no, no. I was caught sleeping on my cot.
Bill: My cot. That reminds me of like, sort of an upstate New York...
Kevin: Right. I was broadening it out. It's 'cot.' You know, you just ...
Bill: 'Cot,' right.
Kevin: Mmh. Rhymes with 'rod' or 'Tod.'
Bill; The other one, ummh. Past tense of 'catch.' I say 'caught.'
Robert: Yes, so do I. I say, 'caught.'
Kevin: No, I do an 'or.'
Robert: I got caught in the cot.
Bill: Caught in the cot.
Kevin: See, now, people from outside Chicago, they say, 'Chicago.' And in Chicago, we say, 'Chicago.'
Bill: 'Chicago.'
Kevin: 'Chicago.' Yeh. It's an Indian word, but, uh, .. And it's, not, we don't do that with everything. But it's an example of the pronunciation that's in 'caught.' It's the same kind of 'Chicago', 'or.'

Bill: So, I don't think we'll go through all thirteen of these, but some of these are interesting. Um, D-O-N, the name, and D-A-W-N?
Robert: Yeh, that's the same thing. Don and Dawn.
Bill: Don and Dawn.
Kevin: Oh, no. It's really different. Don and Dawn.
Bill: Don and Dawn.

",
"4:25|Bill|Kevin|Robert|upstate|Chicago"
	];

push @$questions,
[ "teaching", "accent", 1, "all", "For Kevin from Chicago, the sounds in 'cot' a
nd 'caught' are quite different.", "True" ],
[ "teaching", "accent", 2, "all", "For Bill and Robert, the sounds in 'cot' and
'caught' are more similar than for Kevin.", "True" ],
[ "teaching", "accent", 3, "all", "For Bill and Robert the sounds in 'Don' and 'Dawn' are very similar.", "True" ],
[ "teaching", "accent", 4, "all", "For Kevin from Chicago, the sounds in 'Don' and 'Dawn' are almost the same.", "False" ],
[ "teaching", "accent", 5, "all", "For Bill and Robert, the sounds in 'cot' and 'caught' are quite different.", "False" ],
[ "teaching", "accent", 6, "all", "For Kevin, the sounds in 'Don' and 'Dawn' are very similar.", "False" ];

push @$texts, [
        "100percent",
        "Giving 100percent",
	"teaching",
	"all",
	"2:49 Slade: In previous years, you knew as a principal, that you didn't have to make the playoffs and you would still have your job. But she set the tone. XXX I expect the playoffs, the Super Bowl. And if you don't do that, then I will take action. And she delivered on that. A lot of folks lost their jobs. And these were people who would do nothing. As far as I'm concerned, they wouldn't give a 100 percent. This is a job, if you don't give a 100 percent in one play, it could have a major effect on your job. If you don't go outside after school, you could have a big gang fight.

6:30 Merrow: I've heard talk of your legendary commute. Tell me about your commute.
Slade: Oh, I live in um, I live in Pennsylvania. So it's a two-hour commute. By car, yeh, two hours. It's a hundred miles.
Merrow: What do you do? Books on tape?
Slade: Well, you basically, I usually have the radio off. I just .. It gives me a chance to think about what to do when I come in...

7:20 Merrow: So you spend your time thinking.
Slade: Basically, I mean .. This is a very .. exciting, fun job for me, I mean, I'm not in my job XXX, but it's a very complex job. So that's why some people don't do well XXX
Merrow: So what time .. time of day do you get up?
Slade: I get up at four-thirty. And I only go to sleep like at twelve. But the adrenalin's flowing so much that you stay excited. You stay up. I don't start getting tired until like, about nine o'clock.
Merrow: When do you head for home?
Slade: I leave here like at seven-thirty, eight o'clock. At night. So, it's a twelve-hour day.
Merrow: Wow.

",
"2:49|Slade|previous|years|principal|playoffs|job|set the tone|Super Bowl|action|delivered|folks|nothing|As far as I'm concerned|play|major effect|outside|gang|fight|DC|issue|legendary commute|Pennsylvania|adrenalin|flowing|XXX"
	];

push @$questions,
[ "teaching", "100percent", 1, "all", "Slade commutes two hours to the job and two hours home.", "True" ],
[ "teaching", "100percent", 2, "all", "In the car, he thinks about the job and what to do on the job.", "True" ],
[ "teaching", "100percent", 3, "all", "He thinks a lot of people don't give 100 percent.", "True" ],
[ "teaching", "100percent", 4, "all", "He gets up at seven-thirty and heads home at four-thirty.", "False" ],
[ "teaching", "100percent", 5, "all", "He doesn't think his job is fun.", "False" ],
[ "teaching", "100percent", 6, "all", "A lot of people lost their jobs because they were in a big fight.", "False" ];

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

