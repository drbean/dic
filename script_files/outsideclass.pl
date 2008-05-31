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

my $database;
if ($^O eq 'linux') { my $database = $app->{database}; }
elsif ($^O eq 'MSWin32') { my $database = $name; }

=head1 NAME

outside.pl - Set up dic db

=head1 SYNOPSIS

perl outside.pl

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

my $sth = $d->prepare("INSERT INTO texts (id, description, content, unclozeables)
                                        VALUES  (?,?,?,?)");


$sth->execute(
        "melbourne-1",
        "From Federation Square to Degraves St",
        "From Federation Square to Degraves St

01:42 Call in at the Melbourne Visitors Center at Federation Square.
01:45 And ask at the desk for a copy of their Melbourne Walks, Walk Number 4.
01:50 This small brochure is free.
01:52 It will provide you with a route map and information on some of the best laneway and arcade experiences still remaining in the city.
01:58 So let's explore the best parts together.
02:01 The parts you will simply not want to miss.
02:03 Standing outside the Melbourne Visitors Center in Federation Square, ...
02:07 cross St Kilda Road to the corner of St Kilda Road and Flinders Street, and Flinders Street Station.
02:14 Here, by the steps to the station under the clocks, a traditional Melbourne meeting point, ...
02:19 cross Flinders Street to Young and Jackson's Hotel, the pub on the corner, and turn left down Flinders.
02:25 It's a short walk from here down Flinders Street, before we turn right into narrow Degraves Street.

",
"Federation Square|Degraves|Melbourne|brochure|laneway|arcade|St Kilda|Flinders|Young and Jackson's|From Federation Square to Degraves St
" );

$sth->execute(
        "melbourne-2",
        "Melbourne Clothes Store",
        "Melbourne Clothes Store

05:11 Greg Lawrence: And directly across the road from Smitten Kitten is the retro clothing store, Speed Boy Girl.
05:17 With the most amazing collection of vintage street wear.
05:20 Tops, tees, hats, boots and accessories,
05:23 It's different, funky and very reasonably priced for the quality it carries.
05:27 Chynthia, can you tell me a little about the concept for Speed Boy Girl?
05:31 Chynthia: Well, we have a collection of vintage and new clothes, for both boys and girls.
05:37 We have um.. All our vintage stuff comes from Europe,
05:42 so it's all kind of, um...
05:44 We've got cowboy boots.
05:45 We've got eighties boots.
05:46 All in A-one condition.
05:48 And we've also got, you know, Australian clothes.
05:50 We've got stuff from China. We've got a mixture.
05:54 A.. Our.. the basic concept is to incorporate all styles...
05:58 All the things that we like, no matter what era.
06:00 Greg: Is it street wear for young people mainly?
06:03 Or, do you get different age groups coming in?
06:06 Chynthia: Yeh! Pretty much for young, young people.
06:09 It's kind of a ..
06:10 But it's eclectic. It's a mixture of stuff.
06:12 So you .. everyone can find something.
06:14 Yesterday I sold a, a one of our vintage belts to a 75-year-old lady.
06:20 So we, we, Actually, it's not just for young..
06:22 We cross a lot of um, boundaries.
06:25 It's just.. It's all a bit of everything.
06:26 And if you like it, you know.
06:29 Greg: What's the vibe like in Degraves Street and the laneways around it?
06:32 Chynthia: Oh, it's fantastic.
06:33 The city, look, um, I, you know, I was born and .. born here and grew up in the city and around, around.. close by.
06:39 And the city lately, in the last three or four years has really had a change again.
06:44 'Cause it went quiet for a while and everyone, everyone was sort of doing things outside.
06:48 It's come back in the city, and all the laneways and ...
06:52 And I just think the city's got a lot of action.
06:54 And it's great to be around here.
06:56 Greg Lawrence: You're listening to Destinations Secrets by Talk-n-Tours, the podcast that's your door to unique destination insider experiences.
07:05 I'm Greg Lawrence and right now we're walking down narrow Degraves Street in Melbourne, Australia.

",
"Greg Lawrence|Smitten Kitten|retro|Speed Boy Girl|amazing|collection|vintage|accessories|reasonably|carries|Chynthia|concept|Europe|concept|incorporate|era|eclectic|boundaries|vibe|Degraves|laneways|Destinations Secrets|Talk-n-Tours|podcast|unique destination insider experiences|Melbourne Clothes Store
" );

$sth->execute(
        "feb17",
        "Returning to Taiwan",
        "Returning to Taiwan

00:00 And on uh, February 17, that's a Sunday,
00:04 Uh, it's about two weeks ago now, 
00:07 I came back to Taiwan.
00:11 I took the train from Horyuji,
00:13 to the airport,
00:14 which cost me, uh, 1,350 yen.
00:22 And, uh, then I took the, uh, bus from Taoyuan International Airport,
00:35 to Hsinchu,
00:40 which cost me about uh...
00:44 What was it now?
00:45 What was it now?
00:47 Uh, it was about.. 120 NT.
00:54 And that's my journey, my trip, to Japan.

",
"Horyuji|International|Returning to Taiwan
" );

$sth->execute(
        "singapore-3",
        "Talking to Drum Players",
        "Talking to Drum Players

08:08 Okay, let's go and see. (He grabs his podcast bag and he's going to go ask these guys.)
08:14 These guys run around on these trucks.
08:18 And what they do is they just beat the drums.
08:20 They're very, very popular here.
08:21 We've had them running up and down our house.
08:24 So let's just go ask them if we can understand a little bit more about what they're doing and why they do it.
08:36 Excuse me! Hello. Can you tell me what you're doing?
08:38 What, Why are you, Why are you on the trucks, uh?
08:41 Come on!
08:43 Hello. What's your name? What's your name?
08:45 Boy: Elvin.
08:46 Holden: Where are you from?
08:47 Boy: Singapore.
08:49 Holden: Okay. Whereabouts?
08:50 Boy: Huh?
08:51 Holden: Whereabouts?
08:52 Boy: What?
08:53 Holden: Whereabouts in Singapore?
08:54 Boy: Oh.

",
"podcast|Boy|Elvin|Holden|Talking to Drum Players
" );

$sth->execute(
        "strike-3",
        "An Example",
        "An Example

10:05 Susskind: Right. It's, it sounds like it's about being tough on the issues, rather than on the people.
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
11::00 You know, it turns out, that if you work here, actually,
11:04 lunches are free three days a week.
11:07 The idea here is...
11:09 It doesn't mean that you wouldn't rather get more money than less.
11:11 Of course you would.
11:14 But the reason why you are stuck on a certain amount has to do with some other interests.
11:17 that I may be able to provide for you at a rate that's cheaper than just paying you the money.
11:25 Susskind: And I guess it sounds like, something about the collaborative way of approaching negotiations fosters the collection of interests more readily than the adversarial model where you're much more guarded, much more ...
11:34 You're engaged in posturing. And.. And you want to look fierce, without saying why you want what you're saying you want.

",
"Susskind|Bordone|housing opportunities|And I guess it sounds like, something about the collaborative way of approaching negotiations fosters the collection of interests more readily than the adversarial model where you're much more guarded, much more ...|You're engaged in posturing. And.. And you want to look fierce, without saying why you want what you're saying you want.|An Example
" );

$sth->execute(
        "strike-4",
        "Network-Guild Conflict",
        "Network-Guild Conflict

03:00 Bordone: Uh, so what they're trying to do is leverage a third party, um, to gain sympathy.
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
"Susskind|Bordone|leverage a third party|gain sympathy|increase the pain|Internally|network|guild|shared|mediators|productive|engage|rancor or bitterness|less dominant|Network-Guild Conflict
" );

$sth = $d->table_info('','','%');
my $tables = $sth->fetchall_hashref('TABLE_NAME');

for my $table ( qw/texts / )
{
        print "$table: $tables->{$table}->{sqlite_sql}\n";
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
