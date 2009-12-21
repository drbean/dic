use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'dic' }
BEGIN { use_ok 'dic::Controller::Leagues' }

ok( request('/leagues')->is_success, 'Request should succeed' );


