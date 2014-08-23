use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Dic' }
BEGIN { use_ok 'Dic::Controller::Leagues' }

ok( request('/leagues')->is_success, 'Request should succeed' );


