#!perl

use strict;
use warnings;
use lib 'lib';

use Config::General;

BEGIN {
	my @MyAppConf = glob( '*.conf' );
	die "Which of @MyAppConf is the configuration file?"
				unless @MyAppConf == 1;
	my %config = Config::General->new($MyAppConf[0])->getall;
	$::name = $config{name};
	require "$::name.pm"; $::name->import;
	require "$::name/Schema.pm"; $::name->import;
}

no strict qw/subs refs/;
my $connect_info = "${::name}::Model::DB"->config->{connect_info};
# my $connect_info = [ 'dbi:SQLite:db/demo','','' ];
my $schema = "${::name}::Schema"->connect( @$connect_info );
use strict;

my $texts = [
	[ qw(id description genre content unclozeables) ],
	[
        "nyc",
        "New York City multiculturalism",
	"intercultural",
        "BBC: Let's return now to Leonard Lopate at WNYC.

Lopate: And you know, Madelika, the ... just our daily experience, uh, is a revelation when you think about diversity. My haircutter is from Morocco. My building superintendent is from Albania. My cab driver last night was from the Cote d'Ivoire.

And, uh, we have uh, a call to Shan Con. Shan, uh, what's it like being a hyphenated American in New York?

Shan, are you there?

Shan: Hi, yeh. Uh, actually I'm half Pakistani, half Irish. which is a combination I think you can only find in New York City.

Lopate: And what is your experience in New York? Why would you call New York the most diverse city in the world?

Shan: Well, you know, just where I am, where I live in Brooklyn, on my block, we have a Ukrainian-run laundromat, a Korean-run Tex-Mex restaurant, and a pizzeria owned and operated by a Latino family.

I mean, if I need a dose of diversity, all I need to do is open my bedroom window, and the smell just wafts right in.


",
"BBC|Leonard|Lopate|Madelika|Morocco|Albania|Cote d'Ivoire|Shan|Con|Pakistani|Irish|Brooklyn|Ukrainian|Korean|Tex-Mex|pizzeria|Latino|dose|wafts"
	],
	];
	
uptodatepopulate( 'Text', $texts );

my $questions = [
			[ qw/genre text id content answer/ ],

[ "intercultural", "nyc", 1, "Shan Con likes being in New York, one of the most diverse cities in the world.", "True" ],
[ "intercultural", "nyc", 2, "Shan Con is from New York City, but he is half-Pakistani, half-Irish.", "True" ],
[ "intercultural", "nyc", 3, "Lopate's haircutter, building superintendent and cab driver are all not from New York.", "True" ],
[ "intercultural", "nyc", 4, "Lopate is a hyphenated American and Shan Con is not a hyphenated American.", "False" ],
[ "intercultural", "nyc", 5, "On the block in Brooklyn where Shan Con lives, there is a laundromat run by Moroccans.", "False" ],
[ "intercultural", "nyc", 6, "The smell in Shan Con's bedroom is bad, because of the Ukrainian, Korean and Latino combination.", "False" ],

	];

uptodatepopulate( 'Question', $questions );

sub uptodatepopulate
{
	my $class = $schema->resultset(shift);
	my $entries = shift;
	my $columns = shift @$entries;
	foreach my $row ( @$entries )
	{
		my %hash;
		@hash{@$columns} = @$row;
		$class->update_or_create(\%hash);
	}
}


=head1 NAME

studentlife.pl - Set up dic db

=head1 SYNOPSIS

perl studentlife.pl

=head1 DESCRIPTION

'CREATE TABLE texts (id text, description text, genre text, content text, unclozeables text, primary key (id))'

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
