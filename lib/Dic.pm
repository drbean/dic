package dic;

# $Id$

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
    Session::Store::DBIC
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

our $VERSION = '0.04';

# Configure the application. 
#
# Note that settings in dic.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with a external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( name => 'dic' );
__PACKAGE__->config( disable_component_resolution_regex_fallback => 1 );

__PACKAGE__->config->{'Plugin::Authentication'} = {
	default_realm => 'dbic',
        dbic => {
            credential => {
                class => 'Password',
                # This is the name of the field in the users table with the
                # password stored in it
                password_field => 'password',
                # We are using an unencrypted password for now
                password_type => 'clear'
	    },
            store => {
                # Use DBIC to retrieve username, password & role information
                class => 'DBIx::Class',
                # This is the model object created by Catalyst::Model::DBIC
                # from your schema (you created 'MyApp::Schema::User' but as
                # the Catalyst startup debug messages show, it was loaded as
                # 'MyApp::Model::DB::Users').
                # NOTE: Omit 'MyApp::Model' here just as you would when using
                # '$c->model("DB::Users)'
                user_class => 'DB::Player',
                # This is the name of the field in your 'users' table that
                # contains the user's name
                id_field => 'id',
		role_relation => 'getrole',
		role_field => 'id'
	    }
    }
};

__PACKAGE__->config->{'Plugin::Session'} = {
                dbic_class      => 'DB::Session',
                expires => 3600
};


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
