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
        "uniqlo-1",
        "Uniqlo's marketing mix",
	"business",
	"Uniqlo is a Japanese clothing brand. It started as a small suit maker in 1963 and is now one of the biggest Japanese clothing companies.

Uniqlo's name has always been connected to the Japanese music scene. Its customers are young and fashionable.

Uniqlo has developed a unique marketing mix. It has the right combination of product, price, promotion and place.

If a clothes company wants to be successful, it needs to have the right marketing mix. Every company has a different marketing mix of product, price, promotion and place.

The product is what Uniqlo sells. The price is how much the customer pays. Promotion is what Uniqlo does to keep Uniqlo in customers' minds. Place is where and how the customer buys Uniqlo clothes.

The company has to make the right decisions about all of product, price, promotion and place to make the most money. And decisions about each of these things affects decisions about the other things.

",
"Uniqlo|Japanese"
	],
	
	];

uptodatepopulate( 'Text', $texts );

my $questions = [
			[ qw/genre text id content answer/ ],

[ "business", "uniqlo", 1, "Uniqlo's marketing mix is successful.", "True" ],
[ "business", "uniqlo-1", 2, "Uniqlo's decisions about price affect its decisions about promotion.", "True" ],
[ "business", "uniqlo-1", 3, "If Uniqlo decides to sell different clothes, it needs to mind what customers want to pay.", "True" ],
[ "business", "uniqlo-1", 4, "Uniqlo is a young Japanese music maker.", "False" ],
[ "business", "uniqlo-1", 5, "Uniqlo has the same marketing mix as other different companies.", "False" ],
[ "business", "uniqlo-1", 6, "Uniqlo does not make decisions about the combination of product, price, promotion and place in its marketing mix.", "False" ],

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

script_files/justright.pl - Set up dic db

=head1 SYNOPSIS

perl script_files/justright.pl

=head1 DESCRIPTION

'CREATE TABLE texts (id text, description text, genre text, content text, unclozeables text, primary key (id))'

=head1 AUTHOR

Dr Bean C<drbean at, yes, at (@) cpan, a dot, yes a dot, ie (.) org>

=head1 COPYRIGHT


This library is free software, you scan redistribute it and/or modify
it under the same terms as Perl itself.

=cut

