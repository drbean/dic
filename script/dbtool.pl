#!/usr/bin/perl

use strict;
use warnings;

use DBI;

=head1 NAME

dbtool.pl - Emulate cli db tool

=head1 SYNOPSIS

./dbtool scores player
95801001

=head1 DESCRIPTION

SELECT * FROM $ARGV[0] WHERE $ARGV[1] = ?

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


my $d = DBI->connect('dbi:SQLite:db/tourism','','');
my $s = $d->prepare("select * from $ARGV[0] where $ARGV[1] = ?");
while ( my $id = <STDIN> )
{
	chop $id;
	$s->execute($id);
	while (my @r = $s->fetchrow_array)
	{
		$, = "\t";
		print @r, "\n";
	}
	print "\n";
}
$s->finish;
$d->disconnect;
