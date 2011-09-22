#!/usr/bin/perl

use strict;
use warnings;
use Text::Template;
use Email::Send;
use YAML qw/LoadFile/;

my $sender = Email::Send->new({ mailer => 'SMTP' });
$sender->mailer_args([ 
	   Host     => 'email.nuu.edu.tw', # defaults to localhost
	   username => 'greg',
	   password => '1949',
]);

my $tmpl = Text::Template->new( TYPE => 'FILE', SOURCE => 'flier1.tmpl' );
my $datahash = { address => 'greg@nuu.edu.tw' };
my $message = $tmpl->fill_in( hash => $datahash );

$sender->send( $message );

my @leagues = qw/MIA0009 BMA0076 BMA0077/;
for my $league ( @leagues ) {
	my $yaml = LoadFile "../records/982$league/league.yaml";
	my $members = $yaml->{member};
	my @ids = map { $_->{id} } @$members;
	for my $id ( @ids ) {
		my $datahash = { address => "$id\@smail.nuu.edu.tw" };
		my $message = $tmpl->fill_in( hash => $datahash );
$DB::single=1;
		$sender->send( $message );
	}
}


