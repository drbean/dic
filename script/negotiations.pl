#!perl

use strict;
use warnings;
use lib 'lib';

use DBI;
use YAML qw/LoadFile/;

my $yaml = (glob '*.yml')[0];
my $app = LoadFile $yaml;
my $name = $app->{name};
require "$name.pm";
my $modelfile = $name . "/Model/" . $name . "DB.pm";
my $modelmodule = $name . "::Model::" . $name . "DB";
# (my $modelmodule = $modelfile) =~ $name . "::Model::" . $name . "DB";
require $modelfile;

=head1 NAME

negoatations.pl - Set up dic db

=head1 SYNOPSIS

perl negotiations.pl

=head1 DESCRIPTION

'CREATE TABLE texts (id text, description text, content text, unclozeables text, primary key (id))'

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

my $connect_info = $modelmodule->config->{connect_info};
my $d = DBI->connect( @$connect_info );

my $sth = $d->prepare("INSERT INTO texts (id, description, genre, content, unclozeables)
                                        VALUES  (?,?,'negotiation',?,?)");

$sth->execute(
        "strike-1",
        "Traditional approach to negotiations",
        "08:09 Susskind: For our listeners who don't know what interest-based negotiation is, can you describe that.
08:15 And then describe how that kind of collaborative deproach, approach has some advantages and some differences over, uh, the more adversarial approach.
08:23 Bordone: Sure. So, uh, the interest-based approach is a broad term that ... started really with a seminal book by Roger Fisher and Bill Ury, um, here at the Program on Negotiation in the early 80s, called, Getting to Yes.
08:39 The idea of this is simple.
08:41 Um, most people tend to, in their negotiations, speak in terms of demands...
08:47 Susskind: And concessions.
08:49 Bordone: Speak in terms of ... Yes. Like here's my demand. Here's my offer. Here's my position.
08:53 And then the other side will throw out a competing set of offers, demands, positions.
08:58 And the negotiation process, then, is as you said, it is basically a haggling, uh, where people are making concessions ...
09:08 And the winner, quote quote winner, is the party that makes the fewest concessions that are the smallest. Like it hold out the longest.

",
"Susskind|Bordone|quote quote|For our listeners who don't know what interest-based negotiation is, can you describe that.|And then describe how that kind of collaborative deproach, approach has some advantages and some differences over, uh, the more adversarial approach.|Sure. So, uh, the interest-based approach is a broad term that ... started really with a seminal book by Roger Fisher and Bill Ury, um, here at the Program on Negotiation in the early 80s, called, Getting to Yes.|competing" );

$sth->execute(
        "strike-2",
        "Interest-based approach",
        "09:17 Interest-based bargaining looks at a particular position, uh, and says that position actually represents a set of deeper, underlying concerns.
09:31 And if we can get the parties to actually focus on that set of deeper, underlying concerns....
09:39 Then.. A lot of those deeper, underlying concerns are actually shared.
09:40 And the parties will be able to be more creative with each other in ways that will actually be better for both sides.
09:49 So one important message, uh, that I would want our listeners to understand is,
09:52 Interest-based bargaining shouldn't be confused with being nice.
09:58 And it shouldn't be confused with being soft.
10:01 It has to, to do with being ... getting a better outcome for yourself.

",
"particular|represents|deeper, underlying concerns|shared|creative|message|confused|outcome" );

$sth->execute(
        "strike-3",
        "An Example",
        "10:05 Susskind: Right. It's, it sounds like it's about being tough on the issues, rather than on the people.
10:11 Bordone: That's right. You know, And we, you, one can take a very simple, uh, you know, example..
10:16 If you and I were, uh, negotiating over ...
10:21 A salary. Uh, if you were going to come, work full-time for the Program on Negotiation.
10:27 And you might say, I want X dollars a week.
10:31 That's your position.
10:33 Clearly, one thing you want is money.
10:35 But if I ask you, why do you want this X amount.
10:37 Susskind: What my interest is.
10:38 Bordone: What your interest is. Right.
10:40 You might lay out a whole bunch of things.
10:43 Some of it related to: paying for food.
10:47 Some of it related to: finding an apartment.
10:50 And I might be able to say:
10:52 It turns out Harvard has some housing opportunities that are fifty percent of market value.
10:58 We could help you get that.
11:00 You know, it turns out, that if you work here, actually,
11:04 lunches are free three days a week.
11:07 The idea here is...
11:09 It doesn't mean that you wouldn't rather get more money than less.
11:11 Of course you would.
11:14 But the reason why you are stuck on a certain amount has to do with some other interests.
11:17 that I may be able to provide for you at a rate that's cheaper than just paying you the money.
11:25 Susskind: And I guess it sounds like, something about the collaborative way of approaching negotiations fosters the collection of interests more readily than the adversarial model where you're much more guarded, much more ...
11:34 You're engaged in posturing. And.. And you want to look fierce, without saying why you want what you're saying you want.

",
"Susskind|Bordone|housing opportunities|And I guess it sounds like, something about the collaborative way of approaching negotiations fosters the collection of interests more readily than the adversarial model where you're much more guarded, much more ...|You're engaged in posturing. And.. And you want to look fierce, without saying why you want what you're saying you want." );

$sth->execute(
        "strike-4",
        "Network-Guild Conflict",
        "03:00 Bordone: Uh, so what they're trying to do is leverage a third party, um, to gain sympathy.
03:07 Um, are there ways that the parties can ..
03:12 over the next week increase the pain for one or the other?
03:17 Uh, those kinds of moves, I think,
03:19 Internally, like the parties are saying ..
03:20 this'll put the network in a weaker position when we sit at the table.
03:24 Or, this'll put the guild in a weaker position.
03:26 Susskind: Um-hmm.
03:26 Bordone: Uh, if I were thinking about advice that I'd want to give these parties, I would say..
03:32 This is probably not how you want to come to the table next Monday.
03:36 Susskind: Um-hmm.
03:36 Bordone: Right. Instead, I'd be thinking about ..
03:39 What are some of the things we could do to show shared interests, shared concerns at the table?
03:45 Are there mediators or third parties who both sides actually trust?
03:53 And both sides uh, think could play a productive role?
03:55 And how could we engage them over the course of the next week?
03:59 And maybe bring them to the table?
04:01 How could we, uh, think about the individual parties at the table.
04:06 And who might be more, uh able to influence the other side in a productive way.
04:10 And how can we give them leadership roles at the table?
04:15 To the degree that they're individuals who have rancor or bitterness,
04:18 Uh maybe give them a less dominant role.
04:20 So that's the kind of preparation that you'd hope might happen over the next week,
04:26 so that when parties sit there, um, things actually haven't gotten worse, but rather better.
04:30 Susskind: Um-hmm.

",
"Susskind|Bordone|leverage a third party|gain sympathy|increase the pain|Internally|network|guild|shared|mediators|productive|engage|rancor or bitterness|less dominant" );

$sth->execute(
        "strike-5",
        "Betting on the future",
        "13:58 Bordone: Other real interesting ...
14:01 (again just focusing on this issue)
14:02 is, A lot of, I think, both sides are quite concerned about what might happen in the future.
14:11 And they have different expectations about what that future might look like.
14:16 So, what they're doing now is ..
14:16 They're haggling, they're fighting..
14:20 over their different expectations.
14:23 A source of value in a negotiation..
14:25 would be to say,
14:27 You have different expectations about the future.
14:29 Instead of fighting about it,
14:31 place a bet on it.
14:33 So using contingencies, uh, in contracts, 
14:36 can be a way of breaking impasse.
14:38 Susskind: Can you give an example of that?
14:40 Bordone: Sure. I'm going to use actually a baseball example.
14:44 So Alex Rodriguez, right?
14:45 Susskind: Um.
14:45 Bordone: Uh, Alex Rodriguez XXXX the New York Yankees XXXX another decade or so.
14:53 Um, he may be very, very confident that he's going to break Barry Bond's home run record.
15:01 The Yankees might be less confident.
15:05 They might hope it's going to happen.
15:07 They think it's a great idea if it happens.
15:09 It's really good for them.
15:10 It's going to bring a lot of revenue in.
15:12 They're not as certain as he is, right?
15:14 Why? Because he's confident of his own abilities.
15:20 They think lots of other things could happen.
15:21 He could get injured.
15:23 If he's saying, I want 300 million dollars,
15:27 because I'm going to bring so much prestige to the team, when I break Barry Bond's record.
15:32 The Yankees say, You might and you might not.
15:36 We don't, we don't think .. as confident as you are, so therefore we're only going to pay you 250 million.
15:41 Susskind: But if you do break that record, we'll give you another fifty or something?
15:44 Bordone: That's what they ought to be doing, right?
15:45 So instead of fighting about it, what they ought to be doing is simply setting up an incentive scheme.
15:48 That's the contingency.
15:50 So there's, there's a shifting of the risk, based on a difference in the prediction about the future.
15:56 And one of the things that, you know, to bring it back to the Writers Guild, uh, strike ...
16:01 is that it's very clear that there's a lot of disputes about what's going to happen in the future.
16:08 And at least some of them, I think, can be ameliorated by the parties actually sharing, in truth what their differences in forecasts are.
16:18 And then building in a set of clauses that say, Hey, if the Guild's right about this, then they get more.
16:25 And if the producers are right about the fact that this advertising stream is, you know,  deminimalist and isn't going to result in lots and lots of money coming to the networks and producers, then..
16:35 Fine. Then they aren't going to earn anything.

",
"Susskind|Bordone|expectations|source|contingencies|impasse|Can you give an example of that|Alex Rodriguez|XXXX|Yankees|decade|confident|Barry Bond|They might hope it's going to happen|They think it's a great idea if it happens|It's really good for them|It's going to bring a lot of revenue in|Why? Because he's confident of his own abilities|They think lots of other things could happen|He could get injured|because I'm going to bring so much prestige to the team|We don't, we don't think .. as confident as you are, so therefore we're only going to pay you 250|incentive scheme|contingency|shifting|based|prediction|is that it's very clear that there's|disputes|ameliorated|forecasts|building in a set of clauses|Hey, if the Guild's right about this|And if the producers are right about the fact that this advertising stream is, you know,  deminimalist and isn't going to result in lots and lots of money coming to the networks and producers, then|Then they aren't going to earn anything" );

$sth->execute(
        "stujay-1",
        "Difficult places to negotiate",
        "03:12 Mintier: In the business environment, which country is the most difficult to negotiate in?
03:17 Uh, is it China? Is it Thai? Is it Vietnam? Is it Laos? Is it Burma?
03:21 StuJay: I was running a negotiation workshop in Shanghai.
03:27 And I tell you what, it's in the blood.
03:29 These Shanghainese, they're born with negotiation ..skills, you know. Everything is a negotiation, whether it is family, friends, business.
03:39 And, uh, for those guys, I feel sorry if people from a culture where it's a non-confrontational culture coming up against some people from Shanghai, or even Hong Kong, really good Hong Kong, uh, negotiators.
03:53 Mintier: Going to have dinner in a restaurant in Shanghai with Shanghaiese is, is really difficult, because they negotiate the menu.
03:39 StuJay: Yeh. Yeh. Everything is a negotiation. It's in the blood. And even Shanghai, you notice that Shanghai with Beijing. Beijing is more regal way, you know, it's a political city, where Shanghai is business.
04:14 And, so I think Shanghai needs a fantastic negotiators.

",
"Mintier|StuJay|Thai|Burma|Shanghainese|confrontational|Shanghai|Shanghaiese|regal way" );

$sth->execute(
        "stujay-2",
        "Poor negotiators",
        "04:18 Mintier: What about on the other end of the scale? Are there countries where negotiation is not a good skill that they maintain or have?
04:25 StuJay: There's always going to be negotiations, but how you do it.
04:28 So if you had somebody from Shanghai coming in and negotiating in Thailand, but the person, they're needing, the person in Thailand has the thing that they want,
04:38 If the Shanghainese comes and negotiates the way they do over there, then the Thai's just saying, Get out of my country.
04:46 So, it's all relative. In Thailand, negotiation is done quite differently.
04:52 Uh, now, the more international influences and a lot of Thai companies are training their staff up to be able to handle these international negotiations.
05:01 Um, but I think in any negotiation, one thing that I have learned is don't underestimate the power of silence.

",
"Mintier|StuJay|Shanghai|Thailand|Thai" );

$sth->execute(
        "hird-1",
        "Chinese-American Negotiations",
        "07:37 Yet, China is very, very different in terms of how they approach, um, business negotiations.
07:45 Uh, let's take an example.
07:47 If we take an American, if we say to an American,
07:50 What is a negotiation, 
07:52 Uh, they'll tell you that a negotiation is fundamentally a process to get a deal.
07:58 to, um, um, um, build value, hopefully.
08:03 And to sort of codify in a contract, or a written or a signed agreement.
08:09 The word 'tanpan' in Chinese does not mean negotiation.
08:16 In fact, there's no translation directly from Chinese that will come up, 'negotiation.'
08:23 It tends to come up as a 'discussion,' a 'dialogue.'
08:28 As someone described, it has a beginning, a middle, and a seemingly absence of an end.
08:38 And, so, one of the things that we need to understand is that the goal that we as an American pursue is not necessarily consistent with the goal that the Chinese might pursue.

",
"fundamentally|process|build value|codify|written|signed|tanpan|seemingly absence|pursue|consistent" );

$sth->execute(
        "dignen-1",
        "Dealing with \"No\"",
        "01:05 Dignen: And people find themselves increasingly under more and more pressure, with less and less time. 
01:11 And dealing with issues that they don't want to deal with, in a way that they also don't want to deal with it.
01:17 And I think it's increasingly important that, in English, non-native speakers are able to deal with \"No,\" when somebody is refusing to do something in their team.
01:27 And that when that moment escalates to conflict, they also have the skills in English to deal with that. 
01:34 So I think it, it's really about meeting a need which is strongly arising in the work context.

",
"Dignen|escalates|arising" );

$sth->execute(
        "dignen-2",
        "Handling conflict in English",
        "02:15 Interviewer: As teachers and trainers, what do you think we could do to help students improve in this area.
02:21 Dignen: I think in terms of problems for the non-native speaker,..
02:23 I think many non-native speakers face two kind of main problems: 
02:27 Firstly, some will come across as too direct in English when dealing with conflictual situations, simply because they don't have the softer, er, language and the range of language to moderate the conflict.
02:40 And others, because they don't have this language, simply drop out of the conflict, and decide to lose.
02:47 They, they have a win-lose situation.
02:50 So I think, very much, it's about giving people very clear guidelines, very practical tips on how to, to deal with these two scenarios, dealing with \"No,\" and conflict.

",
"Interviewer|Dignen|conflictual|moderate|guidelines|scenarios" );

$sth->execute(
        "dignen-3",
        "Cultural differences",
        "03:01 Interviewer: Is there an inter-cultural dimension to the issue of conflict?
03:04 Dignen: Absolutely. I mean, I think there are inter-cultural aspects to all of these social skills. And conflict is, is a particularly interesting one.
03:11 Because conflict is actually defined differently in different international contexts.
03:18 I do a lot of work in Germany, for example.
03:21 And many non-Germans working in Germany would describe many aspects of German communication style as quite conflictual.
03:29 But, in fact, many Germans would simply see their own communication style as quite pragmatic, as quite direct, as quite open, as quite honest.
03:38 So ... what some people are reading as conflictual is very often what people are just intending as honesty.
03:45 And then the way people deal with conflict of course across cultures is very different.
03:50 In Asian cultures, the stereotype of course is that people try to avoid conflict at every cost.
03:56 And even the word \"No,\" is sometimes not used, because that is seen, as itself, too conflictual.
04:03 In other business contexts, in Germany and the US, I think there is a certain enjoyment in fighting out the problem and raising the problem and coming to a solution.
04:13 So I think, it's very difficult to give trans-cultural guidelines.
04:16 I think the success factor is: Understand yourself, understand your own communication style, and adapt your conflict style to the cultural context.

",
"Interviewer|Dignen|dimension|aspects|conflictual|pragmatic|intending|stereotype|fighting out|guidelines|factor" );

$sth->execute(
        "lawncare-1",
        "The art of negotiation",
        "01:11 In this section, Keith shows us the art of negotiating with a customer.
01:14 As you watch this video, notice how he allows himself to be flexible with his billing procedure.
01:17 When he sees his customer is on a fixed income, and cannot make the monthly payments during the mowing season,
01:22 Keith suggests a payment plan that will spread it evenly across the entire year.
01:25 Let's watch him now, and see how he works his magic.

",
"Keith|video|flexible|billing procedure|fixed income|monthly payments|mowing season|payment plan|spread it evenly" );

$sth->execute(
        "lawncare-2",
        "Hundred dollar offer",
        "01:30 Keith: Okay, Mrs Jones, I was able to look at your grass, and I think I have come up with a pretty good estimate for you.
01:35 Mrs Jones: Oh, good.
01:36 Keith: Now you said on the phone this morning, that you wanted it cut about once every ten days?
01:41 Mrs Jones: I think so. That's a good time.
01:42 Keith: Okay.
01:42 Mrs Jones: ... a good amount of time.
01:47 Keith: Well, if it needs it cut more often, you can certainly talk to me and we can have it done more often.
01:53 Um, the estimate also covers running a string trimmer, and blowing off the porch and the patio.
01:57 Mrs Jones: Mm-hmm. Right.
01:58 Keith: And the estimate I have come up with is one hundred dollars per cut.

",
"Keith|Mrs Jones|estimate|string trimmer|blowing off|porch|patio" );

$sth->execute(
        "lawncare-3",
        "Offer rejected",
        "02:01 Mrs Jones: Oh. Mmh.
02:03 Keith: Does that sound like a lot?
02:05 Mrs Jones: Uh, it is actually.
02:06 We, my husband and I are on a fixed income and we just have to budget on money. We weren't planning on that much.
02:13 Keith: Well, I do understand that, but, you know, I am a professional company. I run commercial equipment. Your job will be look good year round and you'll never have to worry about if I'm going to show up or not. Would you be able to go with a hundred dollars?
02:28 Mrs Jones: I'm afraid not. In fact, we can't.. We can't even discuss. a hundred dollars.

",
"Keith|Mrs Jones|fixed income|commercial equipment" );

$sth->execute(
        "lawncare-4",
        "Offer renegotiated",
        "02:35 Keith: How much were you expecting to pay?
02:37 Mrs Jones: I was thinking, hoping, maybe seventy, seventy five dollars.
02:39 Keith: Oh, well that's quite a bit out of the estimate.
02:43: Uh, well let me say this: If I could get you to sign a one-year contract, I would also mulch the leaves in the fall.
02:51 And I could come down to eighty-five dollars per cut.
02:54 Does that sound better?
02:57 Mrs Jones: I think we could manage that.
02:58 Keith: Okay.

",
"Keith|Mrs Jones|mulch the leaves" );

$sth->execute(
        "greats-1",
        "Lying in negotiations",
        "09:00 Beasor: Interesting. 
09:01 Weiss: Mmh.
09:02 I, I, .. I say, You don't have to erm, You should never lie in a negotiation. Lying actually is, is wrong. And always is wrong.
09:10 However, you don't have to tell the truth.
09:14 I think of Jack Nicholson saying to Diane Keaton, \"I've never lied to you. I've always given you a version of the truth.\"
09:23 Weiss: Heh-heh-heh.
09:24 Beasor: And and and so I would teach my clients, that someone, if a supplier, for instance, were to say:
09:29 \"What did you think of our product?\"
09:32 you wouldn't say, \"Well, it's a fantastic product. I'm surprised you can make it so cheaply.\"
09:38 What you'd say is: \"Well, thank you for your product. We've benchtested it and it does fulfill our minimal criteria, as do other products that are on the shortlist and we would therefore look forward to a commercial negotiation with you, when we can discuss terms and conditions and, and your valued proposition.
09:55 Weiss: Mmh-mmh.
09:57 Beasor: So you're not actually lying to them. But you're giving them a version of the truth, which says, \"We have choice. We have power. And you've got to work for our business.\"

",
"Beasor|Weiss|Jack Nicholson|Diane Keaton|benchtested|minimal|criteria|shortlist|valued|proposition" );

$sth->execute(
        "greats-2",
        "Different understanding",
        "12:02 Beasor: I, I remember one deal where I, I had .. My guys were in a recess.
12:04 And, uh, they said to me, \"Well, look Tom, uh, we're in a hopeless position here. 
12:09 I think the best thing we can do is just to sort of give in gracefully. And and do the best we can, we can.\"
12:16 I said, \"Well, look. Let's have one more go before we complete the process and capitulate entirely.
12:22 Weiss: Mmh-mmh.
12:23 Beasor: So we went in. We went back in to have one more go.
12:27 What we didn't know is that the other party were in the other room suggesting that they were entirely weak and they should need to capitulate immediately.
12:38 Weiss: Hmm-hmm-hmm.
12:39 Beasor: So when we went back in and said, \"Well, look. I'm sorry the answer remains no,\" the other party said, \"Okay, then. We give in.\"
12:45 And I thought: XXXX So we're in one room showing, saying, \"We are weak and they are strong.\" And they're in the other room saying, \"We are weak and they are strong.\"
12:56 And it became a battle of who could concede first.

",
"Beasor|Weiss" );

$sth->execute(
        "service-1",
        "Customer service rep role",
        "00:22 I want to put you in the role of a customer service representative of a telephone company..
00:25 A difficult position to be in and a hard job to do.
00:30 Now here's the situation.
00:31 You work for Telephone-A-Rama, a very large company in the US.
00:35 You've been there for five years, and you're a very good customer service representative, by all accounts.
00:39 Telephone-A-Rama recently hired an outside firm to see where it was losing the most money,
00:45 because it was quite popular, but its profit margins were small, in comparison.

",
"representative|Telephone-A-Rama|accounts|outside|profit margins" );

$sth->execute(
        "service-2",
        "Reps 'quick' to give in to customer demands",
        "00:50 During the audit, the consulting firm found that the customer service reps were giving away a lot of free services and reducing payments to disgruntled customers to appease them.
01:00 While this is clearly necessary sometimes, the consulting group found from interviews with Telephone-A-Rama customer service reps...
01:06 that the reps were quick to go to this option and to give away far more than might be necessary.
01:11 So in that context, the company issued a memorandum to all customer service reps that if they continued to exhibit a record of giving away more than is necessary (which was not defined, by the way),
01:22 they would be let go.

",
"audit|consulting|disgruntled|appease|option|issued a memorandum|exhibit a record" );

$sth->execute(
        "service-3",
        "Reps told to take tough position",
        "01:24 Moving forward to the issue at hand,
01:26 a customer from Kalamazoo, Michigan called to complain about his service,
01:30 saying that it had been down all day yesterday.
01:33 And that the connection in the last week to ten days had been very staticky.
01:36 As a result, he demanded that he take off from his monthly bill a week's worth of cost...
01:41 as well as asking that all long-distance calls that he made during that period, totaling seventy-eight dollars, be subtracted.

",
"issue at hand|Kalamazoo, Michigan|staticky|long-distance|subtracted" );

$sth->execute(
        "service-4",
        "What rep has to do",
        "01:47 Now the issue here for you is first, to defuse the situation,
01:50 not to give in to this demand until you can investigate it further,
01:54 and even then, consider the question that he's posed and whether it is reasonable,
01:58 and still keep this person as a customer.

",
"defuse|posed" );

$sth->execute(
        "service-5",
        "How you would handle customer",
        "02:02 That's your challenge.
02:03 What would you say to them, and how would you frame the conversation.
02:07 Remember that the initial response will be most critical in setting the tone.
02:12 Please send your ideas to me at josh at negotiations dot com.
02:16 And I'll follow up next week with some ideas.

",
"frame|initial|critical|tone" );

$sth->execute(
        "office-1",
        "Negotiating with boss",
        "00:45 Interviewer: When you're talking about negotiating with your boss, you're not just talking about a raise, are you?
00:49 Corley: No, definitely not. One of the things that, that we recognize when we, when we look at relations between uh, boss and subordinate is that there are a lot of things throughout a normal work day,
01:00 that you actually negotiate for.

",
"Interviewer|Corley|look at relations between uh, boss and subordinate is that there are a lot of things throughout a normal" );

$sth->execute(
        "office-2",
        "Different negotiation scenarios",
"01:01 Whether it be uh, placement on the project,
01:05 It could be uh, funds or other resources for, for projects that you're doing,
01:10 all the way up to asking for a raise, asking for a promotion, uh, maybe even asking for a transfer out of that part of the organization.
01:18 So there's a lot of different scenarios that people find themselves in where they actually have to negotiate with their boss for something that they want.
01:30 And their boss may or may not want it as well.
01:31 And it's not always the easiest thing to do.

",
"placement on the project|funds or other resources for, for projects|promotion|transfer out of that part of the organization" );

$sth->execute(
        "office-3",
        "Huge power difference",
        "01:35 Interviewer: So why is it difficult to negotiate with your boss?
01:38 Corley: Well, I think the first reason that most people feel right away is..
01:42 Wow, this is a huge power difference.
01:45 Or, you know, this is the person who signs my check.
01:47 Or this is the person, you know, who can make my life even miserable or even enjoyable.
01:53 depending upon the decisions he or she makes.
01:55 This is the person who may or may not decide whether I get that promotion I'm hoping to get, you know, after the next performance review.

",
"Interviewer|Corley|check|miserable|enjoyable|depending|performance review" );

$sth->execute(
        "office-4",
        "Problem of power difference",
        "02:04 So, the first aspect is just this idea of, 
02:08 How can I negotiate with someone who has so much influence over my work,
02:14 who has the potential to change the way I work, when I work, how I work?
02:18 So, uh, often that's the, when I talk with folks who are interested in negotiating with their boss, or becoming better at negotiating with their boss, that's often the first thing I hear.
02:29 Is, how can I do this when he or she has so much more power than I do?

",
"aspect|influence|potential|folks|or becoming better|Problem of power difference
" );

$sth->execute(
        "office-5",
        "Having alternatives",
        "01:33 And so having some alternative ideas, having some other ways in which you can achieve your interests and hopefully your boss's interests ...
01:44 in addition to, you know, what you were originally bringing to the table.
01:48 That can be extremely helpful.
01:50 Whether it's, you know reacting to a boss saying no for the first time or dealing with their skepticism ...
01:57 If you have some alternatives, if you are open to alternatives that can be really helpful.

",
"table|skepticism" );

$sth->execute(
        "office-6",
        "Understanding your boss's and your styles",
        "02:32 And so not only do you have to have some understanding of where your boss is coming from ...
02:38 And how your boss prefers to handle situations like this ...
02:42 But you have to understand yourself as well.
02:44 If you're someone who is very competitive, seeks out confrontation, tackles things head-on, very little dancing around the issue ...
02:53 That's not going to work well with a boss, like I said, who tends to be more avoiding or more accommodating.

",
"confrontation|tackles|head-on|dancing|accommodating" );

$sth->execute(
        "office-7",
        "Giving up too early",
        "01:46 I think some of us decide to leave the table too soon when we're dealing with our boss.
01:51 And a lot of that has to do with slipping into more of an avoiding style in our negotiating.
01:58 We go in, we try to be collaborative, we try to look for that common ground ...
02:04 And at the first sign that things are not going to work ...
02:06 We decide to get out as quickly as we can.
02:09 Whereas our boss may just be warming up.

",
"slipping|common ground|Whereas" );

$sth->execute(
        "office-8",
        "Knowing how to give up",
        "01:38 And so even though you weren't able to get what you needed this time, end it in a positive way.
01:43 So that the next time you go to your boss and ask for something ...
01:46 they're already more likely at least to listen to you ...
01:50 because they said no last time and they're remembering that you handled it well ...
01:54 that you were professional about it ...
01:56 and that it didn't hurt your relationship with them.
01:59  That's going to go a long way to helping you out in the future.

",
"professional|relationship" );

$sth = $d->table_info('','','%');
my $tables = $sth->fetchall_hashref('TABLE_NAME');

for my $table ( qw/texts / )
{
	if ( ($connect_info)->[0] =~ m/SQLite/ )
	{
		print "$table: $tables->{$table}->{sqlite_sql}\n";
	}
	else {
		print "$table: $tables->{$table}->{'TABLE_NAME'}\n";
	}
}

#while ( my $id = <STDIN> )
#{
#       chop $id;
#       $sth->execute($id);
#       while (my @r = $sth->fetchrow_array)
#       {
#               $, = "\t";
#               print @r, "\n";
#       }
#       print "\n";
#}

$sth->finish;
$d->disconnect;
