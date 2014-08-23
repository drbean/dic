#!/usr/bin/perl 

# Created: 西元2010年11月30日 09時59分46秒
# Last Edit: 2014  8月 23, 15時12分02秒
# $Id$

=head1 NAME

delete_exercise.pl - Delete exercise from database

=cut

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";

use Dic;
use Dic::Model::DB;
my $connect_info = Dic::Model::DB->config->{connect_info};
my $schema = Dic::Schema->connect( $connect_info );

=head1 SYNOPSIS

perl script_files/delete_exercise exId1 exId2 ..

=cut

sub run {
    my @exIds = @ARGV;
    for my $exId ( @exIds ) {
	my $exs = $schema->resultset('Exercise')->search( { id=>$exId } );
	while ( my $ex = $exs->next ) {
	    my $genre = $ex->genre;
	    # my $dictionary = $ex->dictionary;
	    my $words = $ex->words;
	    my %entries;
	    #while (my $word = $words->next)
	    #{
	    #        my $token = $word->published;
	    #        my $entry = $dictionary->find({ word => $token });
	    #        if ( $entry )
	    #        {
	    #    	    my $count = $entry->count;
	    #    	    $entry->update( {count => --$count} );
	    #        }
	    #}
	    $ex->questions->delete_all;
	    $ex->delete;
	}
    }
}

run unless caller;


=head1 DESCRIPTION

Delete an exercise. Delete of Text, Questions and Questionwords done here too.

=cut

=head1 AUTHOR

Dr Bean C<< <drbean at cpan, then a dot, (.), and org> >>

=cut

=head1 COPYRIGHT & LICENSE

Copyright 2010 Dr Bean, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

# End of create_exercise.pl

# vim: set ts=8 sts=4 sw=4 noet:


