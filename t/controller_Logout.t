use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Dic' }
BEGIN { use_ok 'Dic::Controller::Logout' }

ok( request('/logout')->is_success, 'Request should succeed' );


