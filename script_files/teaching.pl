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

push @$texts, [
        "mad",
        "Upset teacher",
	"teaching",
	"all",
	"Teacher: You stop talking when I tell you to stop talking. You've got a complaint for the teacher across the hall. (inaudible) I've been, did, busy doing something. You've been getting out of hand here. You WILL settle down now and you will STAY that way. You're disrespectful to the class across the hall. So when I tell you to stop talking, that means stop whistling and stop acting like an idiot. Okay? You're in grade ten. Act like you're in grade ten.
(Waves to camera)
Students: (laughter)
Teacher: Okay?
Students (inaudible)
Teacher: Grown-up people.
Students: (laughter, whistle, inaudible)
Teacher: I don't want to hear that whistling anymore. From whoever's doing it. It's one of you three. Okay?
Students, Teacher: (action, inaudible)
Teacher: You get out.
Student: You get out of my face.
Teacher: You, go.
Students: Stay. (inaudible)
Teacher: (Student's name), shut that off.
Teacher: It's kind of hard to keep quiet, when you just don't seem to want to be quiet. That's your problem, okay? You just sit there, and (whistle) Quiet.
Student: Sir. When you've been sitting here for like half an hour. And you're not saying anything. And you're just standing up, staring at everybody. Obviously (inaudible) important, somebody's going to talk.
Teacher: (telephones)

",
"Teacher|Student|Students"
	];

push @$questions,
[ "teaching", "mad", 1, "all", "The teacher wants the students to stop getting out of hand.", "True" ],
[ "teaching", "mad", 2, "all", "The students want to talk. They don't want to settle down", "True" ],
[ "teaching", "mad", 3, "all", "It seems kind of hard for the teacher to stop the students getting out of hand.", "True" ],
[ "teaching", "mad", 4, "all", "The student tells the teacher to get out and go in the hall.", "False" ],
[ "teaching", "mad", 5, "all", "The students don't want the student who goes to stay.", "False" ],
[ "teaching", "mad", 6, "all", "Obviously, the teacher is telephoning the student who went, to tell him to stay.", "False" ];

push @$texts, [
        "discipline",
        "Cartoon teacher",
	"teaching",
	"all",
	"Part One.
	
1:00 Grimes: You see what low grades you made on your weekly mathematics test. More than half of you failed. Most of those who passed just got by. Nobody had a hundred percent. This is the poorest class I've had in a long, long time.

Most of you have no foundation at all. Now the trouble's with your attitude. You don't pay enough attention in class. You don't do enough work outside of it. You don't know what the word, 'study' means. You haven't the slightest idea.

Don't you realize that mathematics is an important subject. I tell you right now that unless you get over your lazy habits, and come up to the standards I've set for this class, many of you will have the pleasure of repeating this course next semester.

(To Assistant) Well, what is it?

Assistant: (inaudible)

Grimes: All right. That's all. (To Students) I have to leave for a few minutes. I want you to open your books and work out correct solutions to the problems you missed.

Part Two.

7:45 Grimes: Most of you are disappointed in the low grades you made on this test. So am I. Nearly all of you had trouble with that last problem on ratio. Perhaps I didn't do a good job explaining ratio.

Now ratio is commonly used in everyday life. Mother uses it in the kitchen when she takes a recipe for a big cake and uses proportional amounts of ingredients to make a little cake, and vice versa. 

Let's suppose the recipe called for eight cups of flour and four eggs. I wanted to make a cake half that size. How much would I use?

Student: You need four cups of flour and two eggs.

Grimes: That's right. You boys use it in shop when you read a blueprint.

",
"Part|1:00|7:45|Grimes|mathematics|foundation|slightest|standards|Assistant|ratio|proportional|recipe|flour|blueprint|shop|Student|Students"
	];

push @$texts, [
        "cartoon",
        "Good teacher, bad teacher",
	"teaching",
	"all",
	"Part One.
0:48 Teacher: (points at student) And you. What were you doing?
Student: I, I was just ..
Teacher: Going to what? Throw the eraser I suppose. .. It's a good thing I caught you. I'll make an example out of you. 
Student: But I ..
Teacher: That's enough out of you. Leave this room and report to the principal's office immediately.
Student: (Coughs)
Teacher: Who did that? .. All right, since you think it's so funny. The whole class can stay in for forty-five minutes this afternoon. Then you'll see how funny it is.

Commentator: This is all wrong. Suppose Mr Grimes had tried another approach.

Part Two.

2:02 Fear is a more desirable molder of behavior than respect. The development of mutual undestanding between teacher and pupils will help eliminate disciplinary problems.

Teacher: Suppose I had a blueprint of a bridge. It's going to be a hundred feet wide. But on this drawing, the bridge is only ten inches wide. Now how many feet would each inch represent? (points gun at student)
Student: Ten feet.
Teacher: That's right. Now you're getting it. Let's see if you can do the next one.

Commentator: Classroom control and learning efficiency are products of good teaching. Learning must be made meaningful.
Teacher: What is the ratio between four and a half yards and one and a half feet?
Student: Aw, come on. Cut it out.
Commentator: It must be remembered that some incidents will occur.
Teacher: The right answer is nine. (Shoots student)
Commentator: Skill in handling such occurrences prevent their growth into problems.
Teacher: Well, that was a pretty good catch. For a moment, I thought you'd miss.
Commentator: A friendly attitude with a sprinkling of humor goes a long way toward winning the regard and cooperation of the class.
Student: I get the idea now. You know, I'm beginning to get some sense out of this.
Student: I hope I do better next time.
Commentator: A dangerous weapon provides its own discipline.
	

",
"Part|0:48|2:02|Teacher|Student|Commentator|Grimes|blueprint of a bridge|feet|inches|inch|yards|catch|you'd miss|regard|sprinkling|weapon"
	];

push @$questions,
[ "teaching", "cartoon", 1, "all", "The teacher thinks the student he points at is going to do some thing wrong, but he isn't.", "True" ],
[ "teaching", "cartoon", 2, "all", "The teacher says all the students in the class have to stay in the afternoon, because one student coughed.", "True" ],
[ "teaching", "cartoon", 3, "all", "The teacher supposes he has to control the students with fear. This is wrong.", "True" ],
[ "teaching", "cartoon", 4, "all", "The students want to stay in in the afternoon to see how funny a cough is.", "False" ],
[ "teaching", "cartoon", 5, "all", "The teacher shoots the student because he said the wrong answer.", "False" ],
[ "teaching", "cartoon", 6, "all", "The teacher controls the students in Part One and Part Two with humor.", "False" ];

push @$texts, [
        "pe-1",
        "Student-led PE class",
	"teaching",
	"all",
	"1:13 Natalie: For our PE classroom entry, Genny and I have decided to do a yoga class.
Genny: It's really calming or something. And everybody who's anybody does yoga.
Natalie: I heard that J.Lo lost all her baby weight after the twins just doing yoga.
Genny: She had twins?
Natalie: Where've you been for the last year?
Genny: Hey, cool.

Oscar: Hey, we heard about the new PE class idea. How do we get our idea nominated?
Van Houten: Errm, Well, I think you probably need to make a video or a demo, or something like that, so that we can review it. Umm, because we've got to look at all the options.
Oscar: Okay.
Steven: When is it ... When should we have it in by?
Van Houten: Uh, December 15th.
Steven: Okay.
Van Houten: That'd work. Okay. Bye.

Van Houten: Hi. Hi, ladies.
Genny: We heard about the PE class, the student-led, the class opening thing.
Van Houten: Yup.
Genny: And we were wondering, um, how do we get ourselves nominated.
Van Houten: You mean you have an idea for, for what to do in the class?
Natalie: Oh, yeah.
Van Houten. Okay. And what we're doing is we're having students develop, um, videos or demos, or something like that, so we can view what your idea is and then we can decide.
Genny, Natalie: Okay.
Van Houten: So, if you can have that done by December 15th, we'll review it.
Natalie: How about in ...
Van Houten: Okay, we can go with that. How about January 15th. 
Genny, Natalie: All right. Sounds good!

",
"1:13|Natalie|Genny|J.Lo|baby weight|Oscar|nominated|Van Houten|Steven|options|demo|review"
	];

push @$questions,
[ "teaching", "pe-1", 1, "all", "Oscar and Steven'll develop an idea by December 15th and the ladies'll do it by January 15th.", "True" ],
[ "teaching", "pe-1", 2, "all", "Genny and Natalie get Van Houten to okay having their idea done by January 15th.", "True" ],
[ "teaching", "pe-1", 3, "all", "Van Houten'll review the ideas and decide what to do with the PE class.", "True" ],
[ "teaching", "pe-1", 4, "all", "The students all decided the student-led PE class'll be a yoga class.", "False" ],
[ "teaching", "pe-1", 5, "all", "Van Houten will lead the PE class and students will do PE in it.", "False" ],
[ "teaching", "pe-1", 6, "all", "The ladies wonder if J.Lo lost her twins doing yoga in a PE class.", "False" ];

push @$texts,
[
        "pe-2",
        "Classroom sports",
	"teaching",
	"all",
	"2:39 Steven: Hey. Check it out. We just got, I just got these awesome new hats for classroom sports.
Oscar: (inaudible) They don't even fit on your head.
Steven: You shut up. I got mine for 2008 Wild West showdown, man. (inaudible)

Oscar: Classroom Sports Event One. Classroom sprinting
Steven: First you've got to steal something from your teacher, then leg it to the nearest bathroom in the fastest time possible. Your time runs up when you get inside the bathroom.
Oscar: Let's do it.

Oscar: Classroom Sports Event Two. Classroom rodeo
Steven: First you've got to find a random person. Then you sneak up behind them, jump on their back and see how long you can stay on top of them, like riding a bull. Best time wins.
Oscar: Let's do this.

Steven: Hey, Lawrence. Hold it right there. Got a question for you. Ha, ha! Er, why isn't he moving?

Oscar: Classroom Sports Event Three. Classroom (inaudible)
Steven: You just find a bunch of random stuff. Then you run into a classroom and chuck them at people. And you get points every time you nail someone. Let's do this.

",
"2:39|Steven|Oscar|Wild West|showdown|sprinting|leg|rodeo|a random|sneak|Lawrence|chuck|nail"
	];

push @$questions,
[ "teaching", "pe-2", 1, "all", "In Classroom Sports Event One, you've got to get to the bathroom before the teacher nails you.", "True" ],
[ "teaching", "pe-2", 2, "all", "In Classroom Sports Event Two, you jump on a person's back and stay on for the longest time possible.", "True" ],
[ "teaching", "pe-2", 3, "all", "In Classroom Sports Event Three, you chuck stuff at people and see how many you can nail. ", "True" ],
[ "teaching", "pe-2", 4, "all", "In Classroom Sports Event One, the teacher runs into the bathroom to nail the people who stole her stuff.", "False" ],
[ "teaching", "pe-2", 5, "all", "In Classroom Sports Event Two, Oscar rides on Lawrence's back for a long time.", "False" ],
[ "teaching", "pe-2", 6, "all", "In Classroom Sports Event Three, someone chucks stuff at Steven and Oscar.", "False" ];

push @$texts,
[
        "assess-1",
        "Schools and the city",
	"teaching",
	"all",
	"2:48 Sarah: Speaking of men, isn't that Parfait?
Kerry: Oh, yeh. The one from the Blue Note.
Parfait: Hey, hi, ladies.
Kerry: Hey, Parfait. How are you?
Parfait: Well, I was on my way to Tira, the new wine bar on the East Side.
Kerry: Oh, very nice. We love our wine.
Sarah: We do. Actually we were just discussing high-stakes meets hot shoes.
Parfait: Okay.
Sarah: And wondering why do you think variety is the spice of assessment.
Kerry: You know, shaking up the standardized.
Parfait: Well, because life assesses you in different ways.
Kerry: Ha, ha. Spoken like a true artist.
Parfait: Well, it's true. I mean today, assessment is moving beyond just assessing where you are at one point in time, to measuring the whole process. It's so passe to only assess what has been taught. It's like jazz. You don't focus on one individual note, but the whole piece, the harmony, the confluence of the whole ensemble.
Kerry: Exactly. I mean, we want to take a topic or an idea and be able to assess it from many different ways, to see how learning is occurring.
Parfait: That's true. I mean, how it's occurring and for whom it is occurring as well. Are we using the right assessment method for the right age level?
Sarah: Mmh. It kind of makes you think of fashion too. I mean, let's say, if I wanted to wear some hot-pink candy shoes and a miniskirt, would that be age-appropriate?
Kerry: Mmh-hmm?
Parfait: Good point.
Sarah: But I'm going to try them on anyway, Kerry.

",
"2:48|Sarah|Parfait|Blue Note|Kerry|Tira|wine|East Side|high-stakes|spice|standardized|artist|passe|harmony|confluence|ensemble|hot-pink|candy"
	];

push @$questions,
[ "teaching", "assess-1", 1, "all", "Parfait thinks it is appropriate to use a variety of assessment methods, not just one.", "True" ],
[ "teaching", "assess-1", 2, "all", "Sarah thinks fashion is like assessment. Assessment can learn that variety is the spice of life.", "True" ],
[ "teaching", "assess-1", 3, "all", "Kerry would like to use a variety of assessment methods to see if learning is occurring.", "True" ],
[ "teaching", "assess-1", 4, "all", "Parfait likes assessment to focus on measuring just what has been taught.", "False" ],
[ "teaching", "assess-1", 5, "all", "Sarah isn't going to try on the hot shoes, because they are not appropriate for her.", "False" ],
[ "teaching", "assess-1", 6, "all", "Kerry wants Parfait to speak to artists and like, shake them up.", "False" ];

push @$texts,
[
        "assess-2",
        "Frequency of assessment",
	"teaching",
	"all",
	"1:25 Sarah: Exactly. After all, when you think about it, the fashion runways and the freshman hallways aren't that different.
Kerry: It's true.
Sarah: It's all about taking risks and strutting your stuff.
Kerry: And knowing if you trip and fall, you're not going to ruin your couture. Or better yet, your academic reputation.
Sarah: You know, ???. Less is not always more. I mean, when I first started and I was a fashion fledgling, I only went to one, maybe two, fashion shows a year. And I'm telling you, that just wasn't enough to know what's hot and what's not.
Kerry: That's so true. And, when students are given just a few summative tests a year, it's a very limited view. It doesn't really accurately display what's really going on in the classroom, or reflect what teachers are teaching.
Commentary: When it comes to testing, how often is desirable? Excessive testing gets students focused on, 'How well am I doing,' instead of 'What am I learning?'.
Address whether the time spent testing is disproportionate to the time spent learning.
More testing also creates a focus on short-term memory instead of long-term memory and actual understanding.
And reevaluate exam frequency for younger learners, including timed tests.
Kerry: I think the key message here is balance. Too much perfume, accessories or assessments, uhm, becomes overdone, unnecessary, loses its cachet.
Sarah: And too little leaves no lasting impression at all. 

",
"1:25|Sarah|Kerry|fashion runways|freshman hallways|couture|academic reputation|fledgling|summative|limited|display|reflect|Commentary|desirable|Address|reevaluate|timed|accessories|cachet|lasting"
	];

push @$questions,
[ "teaching", "assess-2", 1, "all", "Kerry and Sarah think fashion, and assessment too, is about taking risks without ruining your stuff.", "True" ],
[ "teaching", "assess-2", 2, "all", "Sarah thinks one or two tests a year isn't enough. You don't know if you are hot or not.", "True" ],
[ "teaching", "assess-2", 3, "all", "Too much testing leaves students focused on memory rather tahan understanding.", "True" ],
[ "teaching", "assess-2", 4, "all", "Sarah and Kerry thinks a few summative tests a year are enough to show what's going on.", "False" ],
[ "teaching", "assess-2", 5, "all", "Kerry and Sarah think balance is not desirable. Too much testing. Not too little.", "False" ],
[ "teaching", "assess-2", 6, "all", "Kerry and Sarah think too much fashion is overdone, but excessive assessment is desirable.", "False" ];

push @$texts,
[
        "assess-3",
        "Quality of assessment",
	"teaching",
	"all",
	"1:38: Sarah: Speaking of 'enthused,' let's go check out the hot pretzel guys and purses.
Commentary: All this talk about outward appearances got us thinking. When it comes to handbags, men and assessments, is it really what's on the outside that counts?
Sarah: You know, all too often this hot for high stakes leads to an emphasis on numbers. Teaching students how to beat the test.
Kerry: That's so true, you know. And before you know it, teachers become more worried about dark circles and fine lines and the fine line between meeting and exceeding expectations.
Sarah: Yes, that's true. Now, I know that we can both appreciate the appearance of this handbag. But I want to know about the quality. I want to know when I look on the inside, is it crafted with care. Does it have long-lasting appeal?
Kerry: Exactly. I mean, is it a classic? Is it going to be just, here one season, gone the next, replaced by other trends crowding your shelf?
Sarah: Does it have velcro?
Sarah, Kerry: (Laughter)
Sarah: Mmh. Yes, I think that's something that all educators need to really consider as they approach their assessment methods.
Kerry: Absolutely. And know that just because something has been taught doesn't mean that it's been learned and retained. You need to put in assessment practices that will have that long-lasting appeal.
Street vendor: Evaluating from inside a classroom, or a purse, what constitutes a quality piece?
Kerry: What does constitute a quality piece?
Commentary: Feedback that supports learning focuses on students' work. It's descriptive. It helps students improve in future iterations, informs but not overwhelms, and is delivered in time to help. 
Street vendor: I think you need this purse for your (inaudible) tonight.
Sarah: Oh, okay.
Kerry: But you know what, fortunately? The State Departments of Education, as well as lots of great teachers, AKA, the Mr Big. They're stepping up and they're really creating some amazing programs and opportunities for people to train and study and learn more about how to incorporate formative assessment methods into the classroom.
Sarah: And the DOE is also creating a lot of robust professional development 
opportunities, mentoring.
Kerry: Exactly.
Street vendor: You know what I think? I think Mr Big is (inaudible) from inside and outside the purse.
Sarah, Kerry: (Laughter)
Kerry: So true. Well, thank you.
Street vendor: Thank you.
Kerry: Have a nice day.

",
"1:38|Sarah|Kerry|Street vendor|Commentary|enthused|pretzel|hot for high stakes|expectations|crafted|classic|velcro|retained|formative assessment|robust|mentoring|inaudible|Laughter"
	];

push @$questions,
[ "teaching", "assess-3", 1, "all", "What's important is the quality of the purses and assessments, not just how they look.", "True" ],
[ "teaching", "assess-3", 2, "all", "Velcro does not appeal to Kerry and Sarah, so they laugh.", "True" ],
[ "teaching", "assess-3", 3, "all", "They think they need to look inside the classroom to assess the quality of a test.", "True" ],
[ "teaching", "assess-3", 4, "all", "Sarah and Kerry do not asssess the quality fo the purses that the guy has.", "False" ],
[ "teaching", "assess-3", 5, "all", "The commentary says feedback does not need to inform students about learning.", "False" ],
[ "teaching", "assess-3", 6, "all", "Sarah and Kerry think how the purse looks on the outside is more important than how it is crafted on the inside.", "False" ];

push @$texts,
[
        "aft-8",
        "Direct action by teachers",
	"teaching",
	"all",
	"Commentary: On November 26, 1946, one of the coldest days of the year, 1,165 teachers from Saint Paul, Minnesota went out on strike. 
Murphy: And it seemed as if the Board of Education was holding the line to such a degree that they were forced to go out on the streets and to a strike. But they were also looking forward to kind of breaking that barrier to negotiating, so that they could move from a kind of moral suasion that had been the, the central way in which school teachers had bargained before to collective bargaining, as was known in the new labor movement that had grown in the 1930s. 
Commentary: The strike which lasted nearly six weeks, was the first organized teachers' strike in the country. A startled nation realized that teachers were now willing to use strike as a weapon to fight for better funding and better schools.

",
"Commentary|Murphy|moral suasion"
	];

push @$questions,
[ "teaching", "aft-8", 1, "all", "The first organized teachers strike in the nation (the U.S.) was in 1946.", "True" ],
[ "teaching", "aft-8", 2, "all", "The teachers were willing to move out on the streets and break the barrier to collective bargaining.", "True" ],
[ "teaching", "aft-8", 3, "all", "The teachers were willing to fight for better funding by moving to collective bargaining, ", "True" ],
[ "teaching", "aft-8", 4, "all", "The new 1930s labor movement in the nation (the U.S.) grew out of the first teachers' strike.", "False" ],
[ "teaching", "aft-8", 5, "all", "The commentary says teachers used moral suasion as a weapon to fight the Saint Paul Board of Education.", "False" ],
[ "teaching", "aft-8", 6, "all", "The Saint Paul Board of Education forced teachers to move in to schools.", "False" ];

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

