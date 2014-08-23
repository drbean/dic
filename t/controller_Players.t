use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Dic' }
BEGIN { use_ok 'Dic::Controller::Players' }

ok( request('/players')->is_success, 'Request should succeed' );


