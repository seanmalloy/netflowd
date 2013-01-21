use strict;
use warnings;
use Test::More;
use Test::Exception;
BEGIN { use_ok('NetFlow::Parser') };

my $Module = "NetFlow::Parser";

# Module can run these methods.
can_ok($Module, 'new');
can_ok($Module, 'debug');
can_ok($Module, 'parse');

# Test consturctor with valid input.
new_ok($Module => [ ]);
my $Parser = $Module->new();
isa_ok($Parser, $Module);

# TODO: test method new
# TODO: test method _read_header
# TODO: test method parse

done_testing();
