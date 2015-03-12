#!/usr/bin/perl 

# Created: 西元2011年02月24日 09時44分23秒
# Last Edit: 2014 12月 08, 18時55分09秒
# $Id$

=head1 NAME

update_players.pl - New players into database

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

use strict;
use warnings;
use FindBin qw/$Bin/;

=head1 SYNOPSIS

perl script_files/update_players -l FLA0030


=cut

=head1 DESCRIPTION

does 'INSERT INTO players, members (id, name, password, league) VALUES (?, ?, ?)' for newplayers.


=cut

use Grades;
use lib "$Bin/../../dic/lib/";
use Dic;  
use Dic::Model::DB;

my $script = Grades::Script->new_with_options;
my $id = $script->league;
my $league = League->new( id => $id );

my $c = Dic::Model::DB->config->{connect_info};
my $s = Dic::Schema->connect( $c );                                           

my $p = $s->resultset('Player');
my $m = $league->members;
my @p = map { {
    id => $_->{id}, name => $_->{Chinese}, password => $_->{password} } } @$m;
$p->find_or_create( $_ ) for @p;
my $ms = $s->resultset('Member');                                              
my @m = map { { player => $_->{id}, league => $id } } @$m;
$ms->find_or_create( $_ ) for @m;

=head1 AUTHOR

Dr Bean C<< <drbean at cpan, then a dot, (.), and org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2011 Dr Bean, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

# End of update_players.pl

# vim: set ts=8 sts=4 sw=4 noet:
