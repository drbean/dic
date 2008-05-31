#!/usr/bin/perl

=head1 NAME

dicDB.pl - Emulate cli db tool, dbtool.pl with dicDB schema

=head1 SYNOPSIS

./dicDB.pl players
95801001 Tom
95801002 Jack

=head1 DESCRIPTION

Dumps tables known by dicDB schema

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use warnings;
use lib 'lib';

use YAML qw/LoadFile/;

my $yaml = (glob '*.yml')[0];
my $app = LoadFile $yaml;
my $name = $app->{name};
require $name . ".pm";
my $model = $name . "DB";
my $modelfile = $name . "/Model/" . $name . "DB.pm";
my $modelmodule = $name . "::Model::" . $name . "DB";
# (my $modelmodule = $modelfile) =~ $name . "::Model::" . $name . "DB";
require $modelfile;

my $connect_info = $modelmodule->config->{connect_info};
my $d = $model->connect( @$connect_info );
my $s = $d->resultset($ARGV[0])->search( { $ARGV[1] => $ARGV[2] } );
my $deletions = $s->count;
print "Deleting $deletions rows ...\n";
$s->delete;
