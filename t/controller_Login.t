use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Dic' }
BEGIN { use_ok 'Dic::Controller::Login' }

ok( request('/login')->is_success, 'Request should succeed' );


