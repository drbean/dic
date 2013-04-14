#!/usr/bin/perl

=head1 NAME

loadYAMLid.pl -- Load a number of text with questions from a YAML file

=head1 SYNOPSIS

loadYAMLid.pl data/business.yaml careercandidate

=head1 DESCRIPTION

Cut and paste from YAML into texts, questions, percent tables 

But be careful with targets.

In order:
  - id
  - description
  - genre
  - target
  - content
  - unclozeables
  - percent # new


=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use warnings;
use lib 'lib';
use Scalar::Util qw/looks_like_number/;

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

use YAML qw/LoadFile DumpFile/;
use IO::All;
my $textfile = shift @ARGV;
my ($text, $question) = LoadFile $textfile;
my $genre_field = 2;
my $target_field = 3;
my $percent_field = 6;
my $t = $d->resultset('Text');
my $q = $d->resultset('Question');
my $p = $d->resultset('Percent');
my $g = $d->resultset('Leaguegenre');
my $j = $d->resultset('Jigsawrole');
my @ids = @ARGV;
for my $id ( @ids ) {
	my (@text, @qn, @percent, @jigsawrole);
	push @text, $text->[0];
	my ($percent, $target);
	if ( $text[0]->[$percent_field] and $text[0]->[$percent_field]
									eq 'percent' ) {
		$percent = delete $text[0]->[$percent_field];
		push @percent, [qw/text target value/];
	}
	for my $text ( grep { $_->[0] eq $id } @$text ) {
		push @text, $text;
		if ( defined $percent ) {
			$percent = delete $text[-1]->[$percent_field];
			$target = $text->[$target_field];
			push @percent, [$id, $target, $percent];
		}
		if ( $text[-1]->[$target_field] eq "all" ) {
			my @genre = $g->search({ genre => $text[-1]->[$genre_field] });
			for my $genre ( @genre ) {
				my $league = $genre->getleague;
				my $id = $league->id;
				my $members = $league->members;
				while ( my $member = $members->next ) {
					push @jigsawrole, { league => $id,
						player => $member->player->id, role => "all" };
				}
			}
		}
	}
	push @qn, $question->[0];
	push @qn, grep { $_->[1] eq $id } @$question;
	$t->populate(\@text);
	$q->populate(\@qn);
	$p->populate(\@percent) if defined $percent;
	$j->find_or_create( $_ ) for @jigsawrole;
	warn "$id text missing" unless @text > 1;
}


