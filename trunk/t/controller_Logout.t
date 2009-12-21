use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'dic' }
BEGIN { use_ok 'dic::Controller::Logout' }

ok( request('/logout')->is_success, 'Request should succeed' );


