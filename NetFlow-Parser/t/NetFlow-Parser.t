use strict;
use warnings;
use Test::More;
use Test::Exception;
BEGIN { use_ok('NetFlow::Parser') };

my @methods = qw ( new _read_header read_packet parse );
can_ok('NetFlow::Parser', @methods);

# TODO: test method new
# TODO: test method _read_header
# TODO: test method read_packet
# TODO: test method parse

done_testing();
