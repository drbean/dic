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

tourism.pl - Set up dic db

=head1 SYNOPSIS

perl tourism.pl

=head1 DESCRIPTION

'CREATE TABLE texts (id text, description text, league $VARCHAR{15}, content text, unclozeables text, primary key (league id))'

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


my $connect_info = $modelmodule->config->{connect_info};
my $d = DBI->connect( @$connect_info );

my $tsth = $d->prepare("INSERT INTO texts (id, description, genre, content, unclozeables)
                                        VALUES  (?,?,'demo',?,?)");


my $qsth = $d->prepare("INSERT INTO questions (genre, text, id, content, answer)
                                        VALUES  ('demo',?,?,?,?)");

$tsth->execute(
        "pat-1",
        "Returning home",
        "A: Hi, Liz, I'm home.
B: Hi, Dick. How was your day?
A: Oh, the same as usual. Decent, I guess. Yours?
B: Good. Actually, you'll never guess who I ran into downtown.
A: Who?
B: Pat Marshall

",
"A|B|Liz|Dick|Decent|Pat Marshall
" );

$qsth->execute(
	'pat-1',
	1,
	'Who ran into Pat Marshall downtown?',
	'Liz'
);

$tsth->execute(
        "pat-2",
        "Pat and Norman's accident",
        "A: Really? Wow. It seems like years since we saw her. How's she been?
B: Not so good. She and Norman were in a car accident about a year ago.
B: Norman was in the hospital for a while, and he lost his job.
A: That's too bad. So how are they managing?

",
"A|B|Norman|Pat
" );

$qsth->execute(
	'pat-2',
	1,
	'Norman lost his job since he □□□ □□ □ □□□ □□□□□□□□.',
	'was in a car accident'
);

$tsth->execute(
        "pat-3",
        "How Pat's managing",
        "B: Not that well, apparently. Pat's working, and they're getting by, I guess, but things are pretty tough financially....
B: Remember when they lived next door and she took care of the kids when I got sick? She's the kind of person who's always there for you.
A: Yeah, she's a gem.

",
"A|B|financially|Pat
" );

$qsth->execute(
	'pat-3',
	1,
	'Who lived next door and is pretty kind?',
	'Pat'
);


$tsth->execute(
        "pat-4",
        "What kind of person Norman is",
        "B: Hey, why don't we invite them over for dinner. I really value Pat's friendship.
A: Yeah, I do too. I'm not thrilled about spending time with Norman, though.
B: Why not?
A: Well, you know. He's kind of pig-headed. He's the type that always has to be right.

",
"A|B|Pat|Norman|thrilled|pig-headed|Dick
" );

$qsth->execute(
	'pat-4',
	1,
	"Why don't Dick (and Liz?) value Norman's friendship?",
	'He always has to be right'
);


my $sth = $d->table_info('','','%');
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

$tsth->finish;
$qsth->finish;
$sth->finish;
$d->disconnect;
