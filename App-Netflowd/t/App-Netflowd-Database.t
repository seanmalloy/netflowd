# Tests for App::Netflowd::Database

use Test::More tests => 1;
use Test::Exception;
use App::Netflowd::Database qw( create_netflowd_database verify_netflowd_database );
BEGIN { use_ok('App::Netflowd::Database') };

