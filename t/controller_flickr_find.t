#!/usr/bin/perl

package main;

use strict;
use warnings;

use List::Util qw/sum min max/;
use List::MoreUtils qw/all/;
use IO::All;
use IO::Handle;
use Pod::Usage;

use lib 'lib';
use Flickr;

run () unless caller;

sub run {
	my $script = Script->new_with_options( tags => "shizu" );
	pod2usage(1) if $script->help;
	pod2usage(-exitstatus => 0, -verbose => 2) if $script->man;
	my $tag = $script->tags;
	my $total  = 5;
	my $api = Flickr::API->new({key =>
		'ea697995b421c0532215e4a2cbadbe1e',
		secret => 'ab2024b750a9d1f2' });
	my $r = $api->execute_method('flickr.photos.search',
		{ tags => $tag, per_page => $total, api_key =>
			'ea697995b421c0532215e4a2cbadbe1e' });
	if ( $r->{error_code} ) {
		print $r->{error_message};
		return;
	}
	my @newurls;
	for my $n ( 0 .. $total-1 ) {
		my $photo = $r->{tree}->{children}->[1]->
			{children}->[2*$n+1]->{attributes};
		unless ( defined $photo->{title} ) {
			print "No picture";
			return;
		}
		my %row;
		$row{title} = $photo->{title};
		$row{id} = undef;
		$row{word} = $tag;
		$row{url} = 'http://farm' . $photo->{farm} .
			'.static.flickr.com/'.  $photo->
			{server} .  '/'.  $photo->{id} . '_' .
			$photo->{secret} . '_t.jpg';
		push @newurls, \%row;
	}
	local $, = " ";
	local $\="\n";
	print $_->{url}, $_->{title} for @newurls;
		
}


__END__

=head1 NAME

flickr_find - Find tagged pics on Flickr

=head1 SYNOPSIS

grades -l m/j

=head1 OPTIONS

=over 8

=item B<--man> A man page

=item B<--help> This help message

=item B<--league> The league to which the report belongs, a path from the present working directory to the directory in which league.yaml exists.

=back

=head1 DESCRIPTION

B<grades> totals scores that students have earned for classwork, homework and exams. It adds the total beans (divided by 5) to homework, midterm and final scores and outputs the grade so far.

Beans (ie, classwork) are in classwork.yaml. Homework is in $hw/cumulative.yaml. (Use B<hwtotal> to write this.) Exam scores are in $exams/g.yaml. $hw, $exams are in ./league.yaml.

=cut
