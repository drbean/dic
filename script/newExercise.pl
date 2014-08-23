#!/usr/bin/perl

=head1 NAME

script_files/newExercise.pl - Do updating db, creating new exercise

=head1 SYNOPSIS

./script_files/newExercise.pl textname

=head1 DESCRIPTION

Create exercise with same name as textname, using create method of Dic::Controller::Exercises

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
my $textId = $ARGV[0];
my $text = $c->model('DB::Text')->find({id=>$textId}) or die "$textId text?";
my $genre = $text->genre;
$c->stash->{text} = $text;
$c->stash->{genre} = $genre;

require "$name/Controller/Exercises.pm";
"${name}::Controller::Exercises"->clozecreate($c, $textId, 'Ctest', $textId);
"${name}::Controller::Exercises"->questioncreate($c, $textId, 'Ctest', $textId);
