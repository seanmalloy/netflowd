# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl NetFlow-Parser.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More;
BEGIN { use_ok('NetFlow::Data') };
BEGIN { require_ok('NetFlow::Data') };

my @methods = qw(bytes dstaddr dstas dstport first last new nexthop packets
    protocol srcaddr srcas srcport tcpflags tos );

can_ok('NetFlow::Data', @methods);

my $data = {
    bytes    => 5,
    dstaddr  => '192.168.1.1',
    dstas    => 'test',
    dstport  => 80,
    first    => 1,
    last     => 1,
    nexthop  => '192.168.1.1',
    packets  => 1,
    protocol => 1,
    srcaddr  => '192.168.1.2',
    srcport  => 1099,
    srcas    => 'test',
    tcpflags => 'test',
    tos      => 'test' };

new_ok('NetFlow::Data' => [ $data ]);

my $obj = NetFlow::Data->new( $data );
is($obj->bytes(), 5, 'bytes accessor');
is($obj->dstaddr(), '192.168.1.1', 'dstaddr accessor');
is($obj->dstas(), 'test', 'dstas accessor');
is($obj->dstport(), 80, 'dstport accessor');
is($obj->first(), 1, 'first accessor');
is($obj->last(), 1, 'last accessor');
is($obj->nexthop(), '192.168.1.1', 'nexthop accessor');
is($obj->packets(), 1, 'packets accessor');
is($obj->protocol(), 1, 'protocol accessor');
is($obj->srcaddr(), '192.168.1.2', 'srcaddr accessor');
is($obj->srcas(), 'test', 'srcas accessor');
is($obj->srcport(), 1099, 'srcport accessor');
is($obj->tcpflags(), 'test', 'tcpflags accessor');
is($obj->tos(), 'test', 'tos accessor');


TODO: { };

done_testing();

