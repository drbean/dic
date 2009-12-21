use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'dic' }
BEGIN { use_ok 'dic::Controller::Library::Login' }

ok( request('/library/login')->is_success, 'Request should succeed' );


