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
        "tate",
        "Ed Tate's three speaking tips",
	"speaking",
	"OO:30 Griffin: I suppose this is a stupid question, but ..
00:32 What is, like if you had to say, the three most important things that public speaking, uh, public speakers should do to, to excel?
00:41 Tate: Well, I think there are several mistakes that .. I focus on business presenters .. and what I see in a business environment are several things.
00:48 Number one, they focus on their, their computers and their content.
They don't spend enough time focusing on connecting with their audiences.
And, I think that's probably the biggest mistake.
So that's one of the things we talked about here today.
I think it's both. It's both content and connection.
And I think presenters need to think about how they're going to .. their material relates to the audience.
01:09 I also need .. I think that people need to be a little bit more mindful of there's different types of learning styles.
There's some people who like to listen to things. There's some people who like to watch, and there's some people who like to do.
And if you saw my presentation today, you'd see that I incorporate all three modalities.
So that's something else to focus on, not so much on your expertise, but focus on how people will get your message.
01:32 And what I try to do, as opposed to speak, like the traditional speaker, I try to create a memorable experience that people talk about.
",
"00:30|00:32|00:41|00:48|01:09|01:32|Tate|Griffin|incorporate|modalities"
	],
	
	];

uptodatepopulate( 'Text', $texts );

my $questions = [
			[ qw/genre text id content answer/ ],

[ "speaking", "tate", 1, "Tate says to focus on the audience as much as on the subject.", "True" ],
[ "speaking", "tate", 2, "Tate says speakers need to be mindful of different things people focus on.", "True" ],
[ "speaking", "tate", 3, "Tate says presenters need to focus on what the audience thinks, not what the speaker says.", "True" ],
[ "speaking", "tate", 4, "Tate thinks speakers don't spend enough time focusing on their computers and content.", "False" ],
[ "speaking", "tate", 5, "Tate says speakers think too much about different learning styles.", "False" ],
[ "speaking", "tate", 6, "Tate says speakers need to be more mindful of their speaking style and their expertise as speakers.", "False" ],

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

