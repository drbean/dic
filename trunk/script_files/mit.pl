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
        "strang1",
        "Linear Algebra Lecture 1 Strang",
	"all",
        "Hi. This is the first lecture in MIT's course 18.06, linear algebra, and I'm Gilbert Strang. The text for the course is this book, Introduction to Linear Algebra.

And the course web page, which has got a lot of exercises from the past, MatLab codes, the syllabus for the course, is web.mit.edu/18.06.

And this is the first lecture, lecture one.

So, and later we'll give the web address for viewing these, videotapes. Okay, so what's in the first lecture? This is my plan.

The fundamental problem of linear algebra, which is to solve a system of linear equations.

So let's start with a case when we have some number of equations, say n equations and n unknowns.

So an equal number of equations and unknowns.

That's the normal, nice case.

And what I want to do is -- with examples, of course -- to describe, first, what I call the Row picture. That's the picture of one equation at a time. It's the picture you've seen before in two by two equations where lines meet.

So in a minute, you'll see lines meeting.

The second picture, I'll put a star beside that, because that's such an important one.

And maybe new to you is the picture -- a column at a time.

And those are the rows and columns of a matrix.

So the third -- the algebra way to look at the problem is the matrix form and using a matrix that I'll call A.

Okay, so can I do an example? The whole semester will be examples and then see what's going on with the example.

So, take an example. Two equations, two unknowns. So let me take 2x -y =0, let's say. And -x +2y=3.

Okay. let me -- I can even say right away -- what's the matrix, that is, what's the coefficient matrix? The matrix that involves these numbers -- a matrix is just a rectangular array of numbers. Here it's two rows and two columns, so 2 and -- minus 1 in the first row minus 1 and 2 in the second row, that's the matrix.

And the right-hand -- the, unknown -- well, we've got two unknowns. So we've got a vector, with two components, x and x, and we've got two right-hand sides that go into a vector 0 3.

I couldn't resist writing the matrix form, right -- even before the pictures. So I always will think of this as the matrix A, the matrix of coefficients, then there's a vector of unknowns.

Here we've only got two unknowns.

Later we'll have any number of unknowns.

And that vector of unknowns, well I'll often -- I'll make that x -- extra bold. A and the right-hand side is also a vector that I'll always call b.

So linear equations are A x equal b and the idea now is to solve this particular example and then step back to see the bigger picture. Okay, what's the picture for this example, the Row picture? Okay, so here comes the Row picture.

",
""
	],
	

	];

uptodatepopulate( 'Text', $texts );

my $questions = [
			[ qw/genre text id content answer/ ],

[ "all", "strang1", 1, "An equal number of equations and unknowns is the normal case.", "True" ],
[ "all", "strang1", 2, "Strang starts with examples and then sees what's involved with them.", "True" ],
[ "all", "strang1", 3, "A matrix is just a rectangular array of numbers.", "True" ],
[ "all", "strang1", 4, "Strang starts with the column picture.", "False" ],
[ "all", "strang1", 5, "The algebra way is the column picture.", "False" ],
[ "all", "strang1", 6, "The right hand side goes into the coefficient matrix.", "False" ],

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


This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

