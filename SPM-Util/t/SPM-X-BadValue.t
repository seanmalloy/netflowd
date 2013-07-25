# Tests for SPM::X::BadValue

use Test::More tests => 4;
use Test::Exception;
use SPM::X::BadValue;
BEGIN { use_ok('SPM::X::BadValue') };

my $Module = "SPM::X::BadValue";

can_ok($Module, 'throw');
can_ok($Module, 'x_tags');

throws_ok {
    SPM::X::BadValue->throw({
        ident       => 'bad parameter', 
        tags        => [ qw(example) ], 
        public      => 1, 
        message     => "invalid parameter %{given_value}s for %{given_for}s", 
        given_value => 'example', 
        given_for   => 'example', 
    }) 
} "SPM::X::BadValue", 'SPM::X::BadValue throws exception';

