#!/usr/bin/perl

=head1 NAME

script_files/newExercise.pl - Do updating db, creating new exercise

=head1 SYNOPSIS

./script_files/newExercise.pl leaguename genrename textname

=head1 DESCRIPTION

Create exercise with same name as textname, using create method of dic::Controller::Exercises

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use warnings;
use lib 'lib';
use File::Spec;
use Cwd;

use Config::General;

my $dir = ( File::Spec->splitpath(getcwd) )[-1];
my @MyAppConf = glob( '*.conf' );
die "Which of @MyAppConf is the configuration file in $dir?"
			unless @MyAppConf == 1;
my %config = Config::General->new($MyAppConf[0])->getall;
my $name = $config{name};
require $name . ".pm";

my $c = $name->prepare;
my $league = $dir;
my $genre = $c->model('DB::League')->find({id=>$league})->genre->genre;
my $text = $ARGV[0];
$c->session->{exercise} = $league;
$c->stash->{genre} = $genre;
$c->stash->{text} = $c->model('DB::Text')->find({id=>$text});

require "$name/Controller/Exercises.pm";
"${name}::Controller::Exercises"->clozecreate($c, $text, 'Ctest', $text);
"${name}::Controller::Exercises"->questioncreate($c, $text, 'Ctest', $text);
