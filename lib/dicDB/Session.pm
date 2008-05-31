package dicDB::Session;

use base qw/DBIx::Class/;

# Load required DBIC stuff
__PACKAGE__->load_components(qw/PK::Auto Core/);
# Set the table name
__PACKAGE__->table('sessions');
# Set columns in table
__PACKAGE__->add_columns(qw/id session_data expires/);
# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/id/);

=head1 NAME

dicDB::Session - A model object to store session data with Catalyst;:Plugin::Session::Store::DBIC instead of FastMmap or File

=head1 DESCRIPTION

This is an object that represents a row in the 'sessions' table.

=cut

1;
