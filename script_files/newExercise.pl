#!/usr/bin/perl

=head1 NAME

script_files/newExercise.pl - Do updating db, creating new exercise

=head1 SYNOPSIS

./script_files/newExercise.pl rent1

=head1 DESCRIPTION

Dumps tables known by DB schema

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use warnings;
use lib 'lib';

use Config::General;

my @MyAppConf = glob( '*.conf' );
die "Which of @MyAppConf is the configuration file?"
			unless @MyAppConf == 1;
my %config = Config::General->new($MyAppConf[0])->getall;
my $name = $config{name};
require $name . ".pm";
# require "$name/Schema.pm"; $name->import;

my $c = $name->prepare;
my ($league, $genre, $text) = @ARGV[0..2];
$c->session->{exercise} = $league;
$c->stash->{genre} = $genre;
$c->stash->{text} = $c->model('DB::Text')->find({id=>$text});

require "$name/Controller/Exercises.pm";
"${name}::Controller::Exercises"->clozecreate($c, $text, 'Ctest', $text);
"${name}::Controller::Exercises"->questioncreate($c, $text, 'Ctest', $text);

sleep;
