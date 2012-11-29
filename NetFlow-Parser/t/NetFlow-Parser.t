# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl NetFlow-Parser.t'

use strict;
use warnings;
use Test::More;
use Test::Exception;
BEGIN { use_ok('NetFlow::Parser') };
BEGIN { require_ok('NetFlow::Parser') };

my @methods = qw ( new _read_header read_packet parse );
can_ok('NetFlow::Parser', @methods);

# TODO: test method new
# TODO: test method _read_header
# TODO: test method read_packet
# TODO: test method parse

done_testing();
