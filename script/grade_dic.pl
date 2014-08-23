#!/usr/bin/perl 

# Created: 10/21/2011 02:37:36 PM
# Last Edit: 2014  8月 23, 15時14分24秒
# $Id$

=head1 NAME

grade_dic.pl - Grade only dic letters written

=head1 VERSION

Version 0.01

=cut

use strict;
use warnings;
# use lib qw( /var/www/cgi-bin/target/lib );
use lib qw( lib );

use YAML qw/LoadFile Dump/;
use List::Util qw/min/;

=head1 SYNOPSIS

perl script_files/grade_dic.pl -l GL00016 -x rueda -o 20 -t 85 > ../001/GL00016/homework/5.yaml

=cut

use Grades;

my $script = Grades::Script->new_with_options;
my $leagueid = $script->league;
# ( my $id = $leagueid ) =~ s/^([[:alpha:]]+[[:digit:]]+).*$/$1/;
my $id = $leagueid;
my $exercise = $script->exercise;
my $two = $script->two;
my $one = $script->one;

my $l = League->new( id => $id );
my $g = Grades->new({ league => $l }); 
my $m = $l->members;
my %m = map { $_->{id} => $_ } @$m;

use Dic;
use Dic::Schema;
use Dic::Model::DB;

=head1 DESCRIPTION

Above 20 percent, grade of hwMax/2. Above 85 percent of the letters, a (perfect) grade of hwMax. No roles. Uses play table, rather than words. If no -o or -t (one and two) options, then correct/total percent of hwMax.

=cut

my $connect_info = Dic::Model::DB->config->{connect_info};
my $d = Dic::Schema->connect( $connect_info );
my $genre = $d->resultset('Leaguegenre')->find({league=>$leagueid})->genre;
my $members = $d->resultset('Member')->search({ league => $leagueid });
my $play = $d->resultset('Play')->search({ exercise => $exercise });
my $quiz = $d->resultset('Quiz')->search({ exercise => $exercise });
my $words = $d->resultset('Word')->search({ exercise => $exercise,
		genre => $genre });

my ($p, $gr);
for my $player ( keys %m ) {
    my $wordplay = $play->search({ player => $player, league => $leagueid });
    my ($correct, $total) = (0) x 2;
    while ( my $word = $wordplay->next ) {
	my $id = $word->blank;
	my $letters = $wordplay->find({ blank => $id });
	my $answered;
	if ( $letters ) {
	    $answered = $letters->correct;
	    $correct += $answered;
	    if ( my $assigned_word = $words->find({id => $id}) ) {
		$total += length $assigned_word->clozed;
	    }
	    else {
		$total += $answered;
		warn "No assigned word for player ${player}'s blank $id. Adding $answered correct to both $correct correct and $total total.";
	    }
	}
    }
    $p->{$player}->{letters} = $correct;
    $p->{$player}->{percent} = $total? sprintf('%.0f', 100*$correct/$total): 0;
    my $hwMax = $g->hwMax;
    if ( defined $one and defined $two ) {
	$gr->{$player} = min ($hwMax,
	    $p->{$player}->{percent} >= $two? $hwMax:
		$p->{$player}->{percent} > $one? $hwMax/2: 0 );
    }
    else {
    $gr->{$player} = min ( $hwMax, $hwMax * $p->{$player}->{percent} / 100 );
    }
}

print Dump { exercise => $exercise, grade => $gr, points => $p,
				cutpoints => { one => $one, two => $two } };

=head1 AUTHOR

Dr Bean C<< <drbean at cpan, then a dot, (.), and org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2011 Dr Bean, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

# End of grade_dic.pl

# vim: set ts=8 sts=4 sw=4 noet:
