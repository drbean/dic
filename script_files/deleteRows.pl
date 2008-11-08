#!/usr/bin/perl

=head1 NAME

deleteRows.pl - Emulate cli db tool, dbtool.pl with DB schema

=head1 SYNOPSIS

script_files/deleteRows.pl Player name Jack
95801001 Jack
95801007 Jack

=head1 DESCRIPTION

Deletes all rows from the table associated with the Player schema which have Jack in the name column.

=head1 AUTHOR

Dr Bean C<drbean @ an at sign cpan, dot, a dot, org>

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
my $model = "${name}::Schema";
my $modelfile = "$name/Model/DB.pm";
my $modelmodule = "${name}::Model::DB";
# require $modelfile;

my $connect_info = $modelmodule->config->{connect_info};
my $d = $model->connect( @$connect_info );
my $s = $d->resultset($ARGV[0])->search( { $ARGV[1] => $ARGV[2] } );
my $deletions = $s->count;
print "Deleting $deletions rows ...\n";
$s->delete_all;
