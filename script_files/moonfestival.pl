#!perl

use strict;
use warnings;
use lib 'lib';

use DBI;
use Config::General;

use Cwd;

( my $MyAppDir = getcwd ) =~ s|^.+/([^/]+)$|$1|;
my $app = lc $MyAppDir;
my %config = Config::General->new("$app.conf")->getall;
my $name = $config{name};
require $name . ".pm";
my $model = "${name}::Schema";
my $modelfile = "$name/Model/DB.pm";
my $modelmodule = "${name}::Model::DB";
# require $modelfile;

=head1 NAME

studentlife.pl - Set up dic db

=head1 SYNOPSIS

perl studentlife.pl

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
                                        VALUES  (?,?,'access',?,?)");

$sth->execute(
        "date",
        "15th Day of the 8th Month",
        "00:00 Last night was the fifteenth day of the eighth month in the Lunar Calendar.
00:05 Obviously, this was .. it was the sixth day of the tenth month in the regular calendar. It was October the sixth last night.
00:12 Now what does it mean? The fifteenth day of the eighth month of the Lunar Calendar.
00:15 It's the Moon Festival. Doh!
00:17 Anyway, uh, I just er...
00:19 I don't know if you guys know this, but the fifteenth day of every month in the Lunar Calendar is the day when the moon is at its fullest for that month.
00:28 Now, the eighth month of every year in the Lunar Calendar happens to be er ..
00:33 I mean the fifteenth day of the eighth month of the Lunar Calendar happens to be the day when the moon will be at its roundest, at its fullest, for the whole year.
00:43 So that's why um, people celebrate the Moon Festival.
00:46 Well at least the Chinese do anyway.
00:47 I think the Japanese do too.

",
"Doh|er" );

$sth->execute(
        "background",
        "Shang[3]yUe[4]",
        "00:00 Um, so, what does this mean?
00:02 Anyway, in Taiwan, people usually celebrate the Moon Festival by having barbecues.
00:07 Now a long time ago, like, you know, in the past, ancient times, whatever,
00:11 Um, people will celebrate, like, the Moon Festival by shang[3]yUe[4]
00:16 That means enjoying the moon, all right?
00:18 Shang[3] means enjoying and moon is, like, yUe[4].
00:21 So, shang[3]yUe[4].
00:23 So, you sit under in the moon and like, drink, like little tiny shot glasses of wine.
00:27 You know, like, whatever,
00:28 You've seen those old Chinese paintings.
00:29 They drink, like, little shot glasses of rice wine, or whatever and.
00:33 And so, yeh, 
00:34 And they talk poetry, and all that what-not.
00:37 And like, after a while, there was, like, you know, eating moon cakes.
00:40 And that's another story for another time. The moon cakes.
00:43 There's like something, you know, intriguing.
00:46 Well, not really intriguing.
00:47 But there is, like, this funny back story to it.
00:49 But I'll talk about it some other time.
00:51 So, anyway, then people, you know, eat moon cakes until now.
00:55 But in Taiwan, a special, like, celebration thing is the barbecue.
00:59 People like ..

",
"shang|yUe|Shang|shot glasses|intriguing|back story" );

$sth->execute(
        "barbecue",
        "Barbecue",
        "00:00 But in Taiwan, a special, like, celebration thing is the barbecue.
00:04 People, like, ...
00:06 Okay, what I mean barbecue, I actually mean, like grilling.
00:09 Because they don't really cook the food for a long time, and cover it.
00:12 They just put the meat over the grill thing.
00:16 The metal grill plate thing.
00:17 And then, like, grill, grill, grill, for, like, a few minutes.
00:21 Like, a couple of minutes.
00:22 And then take it out.
00:23 And most of the meat are, like, on skewers.
00:25 You know, not like hamburger meat, or like lamb chops.
00:28 But like little, like, sausages, like Chinese sausages.
00:32 Uh, I don't know if you guys have seen Chinese sausages.
00:35 But, anyway, they're like fat little fellows.
00:37 And, you know, like,
00:38 Uh and then, what else do people grill here during Moon Festival.
00:42 Um, also like little things called kim[1]bu[3]lai[4].
00:45 I think it's some kind of fish paste that was, like, um.
00:48 I mean, it was, like, made into a solid form from fish paste, whatever.
00:53 Anyway, they just, like, grill these little things,
00:55 that usu, usu, usually, like, stuff that you see in the night market.
00:58 Just little things.
00:59 Or, like green peppers, or, um,
01:02 Or perhaps mushrooms, and sausages, and little bits of meat.
01:06 Um, stuff on skewers.
01:07 Just simple stuff.

",
"metal|plate|skewers|lamb chops|kim|bu|lai|solid" );

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
