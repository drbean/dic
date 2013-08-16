package dic::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

use Catalyst;
# use dic;

# my $name = dic->config->{database};
my $name = "dic021";

__PACKAGE__->config(
    schema_class => 'dic::Schema',

    connect_info => {
        dsn => "dbi:Pg:dbname=$name",
        user => '',
        password => '',
    }
);


=head1 NAME

dic::Model::DB - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<dic>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<dic::Schema>

=head1 AUTHOR

Dr Bean

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
