#!/usr/bin/perl

=head1 NAME

dumpTables.pl - Emulate cli db tool, dbtool.pl with DB schema

=head1 SYNOPSIS

./dumpTables.pl players
95801001 Tom
95801002 Jack

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
my $model = "${name}::Schema";
my $modelfile = "$name/Model/DB.pm";
my $modelmodule = "${name}::Model::DB";
# require $modelfile;

my $connect_info = $modelmodule->config->{connect_info};
my $d = $model->connect( @$connect_info );
my $s = $d->resultset($ARGV[0]);
my @columns = $s->result_source->columns;
$, = "\t";
print @columns, "\n=============================================\n";
while ( my $r = $s->next )
{
	my @r;
	foreach my $column ( @columns )
	{
		my $value = $r->$column;
		if ( ref $value ) { push @r, $value->get_column('id'); }
		else {
			if (defined $value) { push @r, $value; }
			else { push @r, 'NULL'; }
		}
	}
	print @r, "\n";
}
