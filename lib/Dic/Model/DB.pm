package Dic::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

use Catalyst;
# use Dic;

# my $name = dic->config->{database};
my $name = "dic032";

__PACKAGE__->config(
    schema_class => 'Dic::Schema',

    connect_info => {
        dsn => "dbi:Pg:dbname=$name",
        user => '',
        password => '',
    }
);


=head1 NAME

Dic::Model::DB - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<Dic>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Dic::Schema>

=head1 AUTHOR

Dr Bean

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
