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
	[ qw(id description genre target content unclozeables) ],

	[
        "uniqlo-1",
        "Uniqlo's marketing mix",
	"business",
	"all",
	"Uniqlo is a Japanese clothing brand. It started as a small suit maker in 1963 and is now one of the biggest Japanese clothing companies.

Uniqlo's name has always been connected to the Japanese music scene. Its customers are young and fashionable.

Uniqlo has developed a unique marketing mix. It has the right combination of product, price, promotion and place.

If a clothes company wants to be successful, it needs to have the right marketing mix. Every company has a different marketing mix of product, price, promotion and place.

The product is what Uniqlo sells. The price is how much the customer pays. Promotion is what Uniqlo does to keep Uniqlo in customers' minds. Place is where and how the customer buys Uniqlo clothes.

The company has to make the right decisions about all of product, price, promotion and place to make the most money. And decisions about each of these things affects decisions about the other things.

",
"Uniqlo|Japanese"
	],
	
	[
        "uniqlo-2",
        "Uniqlo's product strategy",
	"business",
	"A",
	"Uniqlo has to design clothes and see if customers like them. But, it also has to know what clothes will be popular in the next six months, in spring or fall, and produce those kind of clothes.

In the fashion industry, clothes are only fashionable for a short time. Uniqlo has to change the style of its clothes all the time.

New styles are developed for the spring and fall season. But when one style of clothes is becoming popular, small changes are continually made in the style to keep it popular.

If these continual small changes are not made, the style can quickly lose popularity.

",
"Uniqlo"
	],
	
	[
        "uniqlo-2",
        "Uniqlo's pricing policy",
	"business",
	"B",
	"Uniqlo has to decide who is going to buy its clothes and decide how much they are willing to pay. It also has to decide how much it costs to produce its clothes. It has to choose a price which covers these costs.

Uniqlo products are medium-priced. People are willing to pay a little more for them because it shows they are successful in their lives.

It is not a low-priced brand. The clothes of people who buy low-priced brands show those people want value for the price they pay.

It is not a high-priced brand. People who buy a high-priced brand will buy it, even if it is cheaper, or even if it is more expensive. People who buy high-priced brands want clothes which are different or have the latest styles.

",
"Uniqlo"
	],
	
	[
        "uniqlo-2",
        "Uniqlo's place strategy",
	"business",
	"C",
	"Place is where Uniqlo products may be bought and also the ways the clothes are delivered or distributed to these places.

Uniqlo controls very carefully the places where its clothes may be bought. It has its own stores, and it has places in department stores, where the customer feels they are in a special Uniqlo store.

It wants to create an environment where the customer has a unique Uniqlo experience. If people can buy Uniqlo clothes anywhere, they don't have that special Uniqlo experience.

And people will think the Uniqlo brand is less fashionable if they can buy Uniqlo clothes anywhere.

",
"Uniqlo|delivered|distributed"
	],
	
	[
        "uniqlo-2",
        "Uniqlo's promotion activities",
	"business",
	"D",
	"The purpose of promotion is to get customers. Promotion includes advertising in magazines or on TV, and mailing of catalogs and newsletters to customers. It also includes getting famous people to wear Uniqlo clothes, the way Michael Jordan endorsed Nike shoes.

Japanese rappers Scha Dara Parr wear Uniqlo clothes. They are paid by Uniqlo to endorse the brand.

Other forms of promotion include discounts, give-away competitions, and participation in public events.

Promotion also includes the style of its public image, that is, the look of Uniqlo stores, Uniqlo displays, Uniqlo packaging and the Uniqlo logo 

All these things have an effect on sales of Uniqlo clothes.

",
"Uniqlo|catalogs|newsletters|Michael Jordan|Nike|Scha Dara Parr|logo"
	],
	
	];

uptodatepopulate( 'Text', $texts );

my $questions = [
			[ qw/genre text id target content answer/ ],

[ "business", "uniqlo-1", 1, "all", "Uniqlo's marketing mix is successful.", "True" ],
[ "business", "uniqlo-1", 2, "all", "Uniqlo's decisions about price affect its decisions about promotion.", "True" ],
[ "business", "uniqlo-1", 3, "all", "If Uniqlo decides to sell different clothes, it needs to mind what customers want to pay.", "True" ],
[ "business", "uniqlo-1", 4, "all", "Uniqlo is a young Japanese music maker.", "False" ],
[ "business", "uniqlo-1", 5, "all", "Uniqlo has the same marketing mix as other different companies.", "False" ],
[ "business", "uniqlo-1", 6, "all", "Uniqlo does not make decisions about the combination of product, price, promotion and place in its marketing mix.", "False" ],

[ "business", "uniqlo-2", 1, "A", "If Uniqlo can see what styles will be popular in the next season, it knows if customers will like its clothes or not.", "True" ],
[ "business", "uniqlo-2", 2, "A", "Uniqlo does not have to continue to develop changes to a style if it is becoming popular.", "False" ],
[ "business", "uniqlo-2", 3, "B", "Uniqlo customers will pay more for their clothes because they want to show they are successful", "True" ],
[ "business", "uniqlo-2", 4, "B", "Uniqlo is a low-priced brand, because people who buy it want value for money.", "False" ],
[ "business", "uniqlo-2", 5, "C", "Uniqlo controls the experience customers have by creating a unique experience in its own stores.", "True" ],
[ "business", "uniqlo-2", 6, "C", "People can buy Uniqlo clothes anywhere.", "False" ],
[ "business", "uniqlo-2", 7, "D", "Uniqlo promotes its clothes by advertising and stylizing its public image.", "True" ],
[ "business", "uniqlo-2", 8, "D", "Michael Jordan promotes Uniqlo clothes.", "False" ],

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

