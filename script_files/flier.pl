#!/usr/bin/perl

use strict;
use warnings;
use Text::Template;
use Email::Send;
use YAML qw/LoadFile/;

my $sender = Email::Send->new({ mailer => 'Sendmail' });
$sender->mailer_args([ 
	   Host     => 'mail.nuu.edu.tw', # defaults to localhost
	   username => 'greg',
	   password => '',
]);

my $tmpl = Text::Template->new( TYPE => 'FILE', SOURCE => 'flier1.tmpl' );

my @leagues = qw/FIA0034/;

for my $league ( @leagues ) {
	for my $drbean ( qw/greg@nuu.edu.tw drbean@freeshell.org/ ) {
		my $datahash = { league => $league, address => $drbean };
		my $message = $tmpl->fill_in( hash => $datahash );
		$sender->send( $message );
	}
	my $yaml = LoadFile "../../012/$league/league.yaml";
	my $members = $yaml->{member};
	my @ids = map { $_->{id} } @$members;
	for my $id ( @ids ) {
		my $datahash = { league => $league, address => "$id\@smail.nuu.edu.tw"};
		my $message = $tmpl->fill_in( hash => $datahash );
$DB::single=1;
		$sender->send( $message );
	}
}


