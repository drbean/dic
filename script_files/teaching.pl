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
        "time",
        "Tension between being perfect and being productive",
	"teaching",
	"1:23 Sure. I think if there's one thing, principle that guided my preparation for teaching, but also scholarship, as I'll explain later, is this tension between being perfect and being productive.

1:41 Um, you have to do great work, but it can't always be perfect. Especially, the first time. And I think that's especially true when you're preparing for teaching. Uh, given all the responsibilities a tenure-track faculty member has, starting a new job, uh, you know, the most important of which is getting his or her research or scholarly program up and going, and productive.

2:06 Uh, you can't spend all of your time preparing a course, or two courses, because you've got other things to do. And I think anybody who has the experiment, the experience of preparing a course knows that it can take all of your time, and more. So you just have to limit how much time you put into the preparation of a course the first time you teach it.

2:36 I think the thing to keep in mind is that you're going to be teaching the rest of your career. And you're probably going to be teaching a course multiple times. And so when you teach it the first time, it should be really good. But it doesn't have to be perfect.

",
"1:23|1:41|2:06|2:36|scholarship|tenure-track faculty member|research or scholarly program|multiple"
	],
	
	];

uptodatepopulate( 'Text', $texts );

my $questions = [
			[ qw/genre text id content answer/ ],

[ "teaching", "time", 1, "Preparing to teach can take too much time", "True" ],
[ "teaching", "time", 2, "The first course you teach shouldn't be perfect.", "True" ],
[ "teaching", "time", 3, "Teachers have to do other things as well as teach.", "True" ],
[ "teaching", "time", 4, "All a teacher's courses should be perfect, even a first course.", "False" ],
[ "teaching", "time", 5, "A teacher has other responsibilities as well as teaching, but he or she can also teach a perfect course.", "False" ],
[ "teaching", "time", 6, "You can't think about making your course better after the first time.", "False" ],

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

