package dic;

use strict;
use warnings;

use Catalyst::Runtime '5.70';

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root 
#                 directory

use Catalyst qw/
    -Debug 
    ConfigLoader 
    Static::Simple
    
    StackTrace

    Authentication
    Authorization::Roles
            
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    /;

    # Authorization::ACL

#BEGIN { my @plugins = qw/ConfigLoader Static::Simple 
#                   Authentication
#                   Authentication::Credential::Password
#		   Authorization::Roles
#                   Session
#                   Session::State::Cookie
#			/;
#		   # Authentication::Store::DBIC
#	if ( $^O eq 'linux' ) { push @plugins, 'Session::Store::FastMmap'; }
#	# else { push @plugins, 'Session::Store::DBIC'; }
#	require Catalyst; Catalyst->import(@plugins);
#}

our $VERSION = '0.02';

# Configure the application. 
#
# Note that settings in dic.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with a external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( name => 'dic' );

# Start the application
__PACKAGE__->setup;

## Authorization::ACL Rules
#__PACKAGE__->deny_access_unless(
#        "/books/form_create",
#        [qw/admin/],
#    );
#__PACKAGE__->deny_access_unless(
#        "/books/form_create_do",
#        [qw/admin/],
#    );
#__PACKAGE__->deny_access_unless(
#        "/books/delete",
#        [qw/user admin/],
#    );




=head1 NAME

dic - Catalyst based application

=head1 SYNOPSIS

    script/dic_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<dic::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
