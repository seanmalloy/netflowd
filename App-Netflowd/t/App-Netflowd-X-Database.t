# Tests for App::Netflowd::X::Database

use Test::More tests => 4;
use Test::Exception;
use App::Netflowd::X::Database;
BEGIN { use_ok('App::Netflowd::X::Database') };

my $Module = "App::Netflowd::X::Database";

can_ok($Module, 'throw');
can_ok($Module, 'x_tags');

throws_ok {
    App::Netflowd::X::Database->throw({
        ident       => 'database connection', 
        tags        => [ qw(database connection) ], 
        public      => 1, 
        message     => "cannot connect to database %{given_value}: %{given_for}", 
        given_value => 'example', 
        given_for   => 'example error', 
    }) 
} "App::Netflowd::X::Database", 'Netflowd::X::Database throws exception';

