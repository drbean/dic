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
        "eden-1",
        "Eden",
        "Dennis Miller: The first student I talked with was Eden Hartwell, of Mt Upton, New York. She's a forensics major. Let's jump right into the conversation.
Miller: Favorite food.
Eden: My mom's spaghetti.
Miller: How does she make that if that's your absolute favorite food?
Eden: She just makes it with sauce.
Miller: Yeh?
Eden: Yeh. (laughs)

",
"Dennis Miller|Miller|forensics|Eden|Hartwell|Upton|spaghetti|sauce" );

$sth->execute(
        "eden-2",
        "The color pink",
        "Miller: And your favorite color?
Eden: Pink.
Miller: Okay. You're not wearing any pink. Ha-ha-ha!
Eden: Ha-ha-ha!
Miller: Okay, pink sneakers.
Eden: Yup.
Miller: Okay? You got it.
Eden: Ha-ha-ha!
Miller: And you said before when you were talking that uh, your whole
room is, is done in pink.
Eden: Yeh. Mmh-hmm.
Miller: Does your roommate like pink too?
Eden: I think she likes it, but she doesn't have any pink.
Miller: She also didn't have any choice.
Eden: Right. (laughs)
Miller: Ha! Ha! Ha!
Eden: My half of the room is pink, and hers is whatever color she wants it to be. I don't know. Ha-ha.
Miller: I see you guys worked that out beforehand.
Eden: Yeh.

",
"Miller|Eden|sneakers" );

$sth->execute(
        "eden-3",
        "Getting to know roommate",
        "Miller: Now you were telling me that you got to know your roommate through uh, email during the summer, which struck me as a really good way to do things. Did you contact her, or she contacted you?
Eden: Actually, during orientation, we had a time, where we just sat with a group of people and talked to them, and then we chose our roommate. So we exchanged emails, and screen names, and everything like that, then. So we had the few months before we came, to get to know each other.
Miller: Again, that strikes me as a really good way to do things. How did you get to know each other? Did you ask each other what you like?
Eden: Yeh. We just asked each other what your hobbies were, or sleep habits and things like that. Things that you would ask people that you were going to live with.
Miller: So when you guys got together during the first days of school, you had pretty much a lot of those things out of the way.
Eden: Yeh.
Miller: Okay, you like this and you don't like this. 
Eden: Mmh-hmm. Yeh. So it was really easy to move in with them.

",
"Miller|Eden|orientation|screen names" );

$sth->execute(
        "eden-4",
        "Music and hobbies",
        "Miller: Your favorite band.
Eden: Coheed and Cambria. Mmh-hmm. I just, I really like their music. And my boyfriend introduced them to me and I've been hooked ever since.
Miller: And I need to ask about your favorite movie?
Eden: The Nightmare Before Christmas.
Miller: Your hobbies.
Eden: My hobbies. I've danced for fourteen years. Everything, ballet, tap,
jazz. And I did a lot of acting in school. And I have horses. So I ride
horseback. And I do a lot of like, crafting. I knit and sew, and crochet.
Miller: How do you fit all that stuff in.
Eden: I don't know. (laughs)
Miller: Ha-ha-ha!

",
"Miller|Eden|Coheed and Cambria|hooked|Nightmare|crafting|knit|sew|crochet" );

$sth->execute(
        "eden-5",
        "Saying goodbye",
        "Miller: The first day that you came here, that your mother brought you
here.
Eden: Yeh.
Miller: And she drove away, and you were on your own. What, what were your
feelings, right at that point?
Eden: The whole situation wasn't as hard for me, because I'd been an exchange
student last year. So I had already gone through having to be alone and
without my parents. So I guess it wasn't as hard as it could have been. But I
did get sad when my mom drove away, and she tapped on her brakes. Because she
always did that to say goodbye when she left me at the baby sitter. So that
was kind of heart-touching. (laughs)
Miller: Yeh.

",
"Miller|Eden|exchange|tapped" );

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
