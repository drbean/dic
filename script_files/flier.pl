#!/usr/bin/perl

use strict;
use warnings;
use Text::Template;
use Net::SMTP::TLS;
use YAML qw/LoadFile/;

my $sender = Net::SMTP::TLS->new(
	   'mail.nuu.edu.tw', # defaults to localhost
	   Hello => 'sac.nuu.edu.tw',
	   User => 'greg',
	   Password => '',
);
$sender->mail('drbean@sac.nuu.edu.tw');

my $tmpl = Text::Template->new( TYPE => 'FILE', SOURCE => 'flier1.tmpl' );

my @leagues = qw/BMA0059 MIA0013 FIA0034/;

for my $league ( @leagues ) {
	for my $drbean ( qw/greg@nuu.edu.tw drbean@freeshell.org/ ) {
		my $datahash = { league => $league, address => $drbean };
		my $message = $tmpl->fill_in( hash => $datahash );
		$sender->to($drbean);
		$sender->data;
		$sender->datasend($message);
		$sender->dataend;
		$sender->quit;
	}
	my $yaml = LoadFile "../../002/$league/league.yaml";
	my $members = $yaml->{member};
	my @ids = map { $_->{id} } @$members;
	for my $id ( @ids ) {
		my $datahash = { league => $league, address => "$id\@smail.nuu.edu.tw"};
		my $message = $tmpl->fill_in( hash => $datahash );
$DB::single=1;
		$sender->to("$id\@smail.nuu.edu.tw");
		$sender->data;
		$sender->datasend($message);
		$sender->dataend;
		$sender->quit;
		$sender->send( $message );
	}
}


