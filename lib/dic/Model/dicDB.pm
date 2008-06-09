package dic::Model::dicDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';
use Catalyst;
use dic;

my $name = dic->config->{database};
my $db = dic->path_to( 'db', $name );

my $connect_info;
if ( $^O eq 'linux' ) { $connect_info = [ "dbi:SQLite:$db", '', '', ]; }

elsif ( $^O eq 'MSWin32' ) {
	$connect_info = [ "dbi:ODBC:Driver={SQL Server};Server=LocalServer;Network=DBMSSOCN;Address=127.0.0.1;Database=$name" ];
	# $connect_info = [ "dbi:ODBC:DSN=dictation" ];
}

__PACKAGE__->config(
    schema_class => 'dicDB',
    connect_info => $connect_info,
);

=head1 NAME

dic::Model::dicDB - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<dic>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<dicDB>

=head1 AUTHOR

Dr Bean,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
