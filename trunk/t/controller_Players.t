use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'dic' }
BEGIN { use_ok 'dic::Controller::Players' }

ok( request('/players')->is_success, 'Request should succeed' );


