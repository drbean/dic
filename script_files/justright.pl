#!perl

use strict;
use warnings;
use lib 'lib';

use Config::General;

use Cwd;

BEGIN {
	( my $MyAppDir = getcwd ) =~ s|^.+/([^/]+)$|$1|;
	my $app = lc $MyAppDir;
	my %config = Config::General->new("$app.conf")->getall;
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
        "destinations",
        "Orlando or Seattle?",
	"JUST RIGHT",
        "Sonia: So which is better, then, Fran? Orlando or Seattle?
Fran: Orlando, definitely. It's more relaxing, and it's cheaper! And it's got lovely beaches.
Sonia: But we always go to the beach. I'd rather do something different this year. Something more interesting. Like a city. Like Seattle.
Fran: There's a problem, then, Sonia.
Sonia: Oh, What's that?
Fran: Because I like beaches. Well, I like beaches better than cities, anyway. And Orlando is sunnier too. And it always rains in Seattle, you know, Sonia.
Sonia: No, it doesn't. And anyway, rain or no rain, there's more to do in Seattle.
Fran: Like what? Museums and things like that? I'd rather stay here in New York!Sonia: Okay then. You go to the beach and I'll go to Seattle. How's that?
Fran: Oh, all right. You win. This time. But no museums and no walking around in the rain!


",
"Sonia|Fran|Orlando|Seattle"
	],
	[
        "smiths",
        "Jo Smith and Joe Smith",
	"JUST RIGHT",
        "Just Right Elementary Student's Book. American Edition, by Carol Lethaby, Ana Acevedo and Jeremy Harmer. Copyright Marshall Cavendish, Limited, 2007.

Track 1:

1.  My name is Jo Smith. I'm a dentist. I'm from Argentina. I have one brother, Alberto. He and his wife Patty have one son, Paco. My husband, Peter, is English. We have two sons, Freddy, twelve, and Ricky, eight, and a baby daughter, Monica, eighteen months old.

2. I'm Joe Smith and I'm thirty-eight. I'm an architect. My father is from Scotland and my mother is from Jamaica, in the Caribbean. I'm American. I'm an only child. My wife, Sandra, is a teacher. We have two daughters: Alice, twelve and Neisha, six. We also have a son, Barry, fourteen months old. We live in California.

",
"Carol|Lethaby|Ana|Acevedo|Jeremy|Harmer|Smith|Argentina|Alberto|Patty|Paco|Peter|Freddy|Ricky|Monica|Jamaica|Caribbean|Sandra|Alice|Neisha|Barry|California|Marshall|Cavendish|"
	]
	];

$schema->populate( 'Text', $texts );

=head1 NAME

script_files/justright.pl - Set up dic db

=head1 SYNOPSIS

perl script_files/justright.pl

=head1 DESCRIPTION

'CREATE TABLE texts (id text, description text, genre text, content text, unclozeables text, primary key (id))'

=head1 AUTHOR

Dr Bean C<drbean at, yes, at (@) cpan, a dot, yes a dot, ie (.) org>

=head1 COPYRIGHT


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

