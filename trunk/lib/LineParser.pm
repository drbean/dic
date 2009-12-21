package LineParser;  # assumes Some/Module.pm

# Last Edit: 2008 Apr 02, 09:10:45 PM
# $Id: /mi/svndic/trunk/lib/LineParser.pm 1397 2008-04-05T04:15:24.532792Z greg  $

use strict;
use warnings;

use Parse::RecDescent;
use Word;
use Newline;

=head1 NAME

LineParser -  Base class for Parsers

=head1 SYNOPSIS

See L<Cloze>

=head1 DESCRIPTION

Provides some common accessors

=cut

=head2 parse

Creates the object. Should be implemented by the sub-class.

=cut

sub parse
{
	die "This was supposed to be defined by the __PACKAGE__ subclass."
}

=head2 cloze

Get the cloze from the parse object

=cut

sub cloze {
    my $self = shift;
    my $cloze = shift;
    if ( defined $cloze ) { $self->{clozeline} = $cloze; }
    elsif ( $self->{clozeline} ) { return $self->{clozeline}; }
}


=head2 dictionary

Get a dictionary from the parse object

=cut

sub dictionary {
    my $self = shift;
    my $dictionary = shift;
    if ( defined $dictionary ) { $self->{dictionary} = $dictionary; }
    elsif ( $self->{dictionary} ) { return $self->{dictionary}; }
}


1;  # don’t forget to return a true value from the file
