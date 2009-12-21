#!perl

=head1 NAME

script_files/allscores.pl - Dump scores of players in all dic leagues below this dir

=head1 SYNOPSIS

script_files/scores.pl

 In dic dir:
 FLA0018		eden-1	eden-2	Total
 ============================================
 N9461736	80	155	235	
 N9461738	106	219	325	
 
=head1 DESCRIPTION

Changes dir to subdir of form (?dic|access|[A-Z]+\d+) and runs script_files/scores.pl

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use warnings;

my @dirs = glob( '*' );
foreach my $dir ( @dirs )
{
	next unless $dir =~ m/^(?:dic|access|[A-Z]+\d+)$/;
	chdir $dir;
	system('perl script_files/scores.pl');
	die "scores.pl died in $dir: $?" if $?;
	chdir "..";
}
