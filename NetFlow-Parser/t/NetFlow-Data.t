# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl NetFlow-Parser.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More;
use Test::Exception;
BEGIN { use_ok('NetFlow::Data') };
BEGIN { require_ok('NetFlow::Data') };

my @methods = qw( bytes dstaddr dstas dstport first last new nexthop packets
    protocol srcaddr srcas srcport tcpflags tos );

can_ok('NetFlow::Data', @methods);

my $data = reset_data();

new_ok('NetFlow::Data' => [ $data ]);

my $obj = NetFlow::Data->new( $data );
is($obj->bytes(), 5, 'bytes accessor');
is($obj->dstaddr(), '192.168.1.1', 'dstaddr accessor');
is($obj->dstas(), 1, 'dstas accessor');
is($obj->dstport(), 80, 'dstport accessor');
is($obj->first(), 1, 'first accessor');
is($obj->last(), 1, 'last accessor');
is($obj->nexthop(), '192.168.1.1', 'nexthop accessor');
is($obj->packets(), 1, 'packets accessor');
is($obj->protocol(), 1, 'protocol accessor');
is($obj->srcaddr(), '192.168.1.2', 'srcaddr accessor');
is($obj->srcas(), 1, 'srcas accessor');
is($obj->srcport(), 1099, 'srcport accessor');
is($obj->tcpflags(), 1, 'tcpflags accessor');
is($obj->tos(), 1, 'tos accessor');

# Test bytes.
$data->{bytes} = -1;
dies_ok { NetFlow::Data->new( $data ) }, 'constructor dies negative bytes';
$data->{bytes} = 0;
lives_ok { NetFlow::Data->new( $data ) }, 'constructor lives zero bytes';
$data->{bytes} = 1;
lives_ok { NetFlow::Data->new( $data ) }, 'constructor lives one byte';
$data->{bytes} = 4294967295;
lives_ok { NetFlow::Data->new( $data ) }, 'constructor lives 4294967295 bytes';
$data = reset_data();

# Test dstport
$data->{dstport} = -1;
dies_ok { NetFlow::Data->new( $data ) }, 'constructor dies -1 dstport';
$data->{dstport} = 65536;
dies_ok { NetFlow::Data->new( $data ) }, 'constructor dies 65536 dstport';
$data->{dstport} = 'a';
dies_ok { NetFlow::Data->new( $data ) }, 'constructor dies \'a\' dstport';
$data->{dstport} = 0;
lives_ok { NetFlow::Data->new( $data ) }, 'constructor lives 0 dstport';
$data->{dstport} = 1;
lives_ok { NetFlow::Data->new( $data ) }, 'constructor lives 1 dstport';
$data->{dstport} = 80;
lives_ok { NetFlow::Data->new( $data ) }, 'constructor lives 80 dstport';
$data->{dstport} = 65535;
lives_ok { NetFlow::Data->new( $data ) }, 'constructor lives 65535 dstport';

$data = reset_data();

# Test first
my @dies_data = qw( a 1.1 -1 4294967296);
for my $item (@dies_data) {
    $data->{first} = $item;
    dies_ok { NetFlow::Data->new( $data ) }, "constructor dies $item first";
}
$data = reset_data();

my @lives_data = qw( 0 1 4294967295);
for my $item (@lives_data) {
    $data->{first} = $item;
    lives_ok { NetFlow::Data->new( $data ) }, "constructor lives $item first";
}
$data = reset_data();

# Test last
for my $item (@dies_data) {
    $data->{last} = $item;
    dies_ok { NetFlow::Data->new( $data ) }, "constructor dies $item last";
}
$data = reset_data();

for my $item (@lives_data) {
    $data->{last} = $item;
    lives_ok { NetFlow::Data->new( $data ) }, "constructor lives $item last";
}
$data = reset_data();

# Test packets
for my $item (@dies_data) {
    $data->{packets} = $item;
    dies_ok { NetFlow::Data->new( $data ) }, "constructor dies $item packets";
}
$data = reset_data();

for my $item (@lives_data) {
    $data->{packets} = $item;
    lives_ok { NetFlow::Data->new( $data ) }, "constructor lives $item packets";
}
$data = reset_data();

# Test protocol
my @protocol_lives_data = 0..255;
for my $item (@protocol_lives_data) {
    $data->{protocol} = $item;
    lives_ok { NetFlow::Data->new( $data ) }, "constructor lives $item protocol";
}
$data = reset_data();

my @protocol_dies_data = ( -1, 256, 1.1, 'a' );
for my $item (@protocol_dies_data) {
    $data->{protocol} = $item;
    dies_ok { NetFlow::Data->new( $data ) }, "constructor dies $item protocol";
}
$data = reset_data();

# Test srcaddr, dstaddr, nexthop
my @invalid_ip_addresses = qw( z 1 1. 1.1 1.1. 1.1.1 1.1.1. 256.256.256.256 -1.-1.-1.-1 192.168.1.1111 );
for my $address (@invalid_ip_addresses) {
    $data->{dstaddr} = $address;
    dies_ok { NetFlow::Data->new( $data ) }, "constructor dies invalid dstaddr $address";
    $data = reset_data();
    $data->{srcaddr} = $address;
    dies_ok { NetFlow::Data->new( $data ) }, "constructor dies invalid srcaddr $address";
    $data = reset_data();
    $data->{nexthop} = $address;
    dies_ok { NetFlow::Data->new( $data ) }, "constructor dies invalid nexthop $address";
    $data = reset_data();
}
$data = reset_data();

my @valid_ip_addresses = qw( 0.0.0.0 255.255.255.255 );
for my $address (@valid_ip_addresses) {
    $data->{dstaddr} = $address;
    lives_ok { NetFlow::Data->new( $data ) }, "consturctor lives dstaddr $address";
    $data = reset_data();
    $data->{srcaddr} = $address;
    lives_ok { NetFlow::Data->new( $data ) }, "consturctor lives srcaddr $address";
    $data = reset_data();
    $data->{nexthop} = $address;
    lives_ok { NetFlow::Data->new( $data ) }, "consturctor lives nexthop $address";
    $data = reset_data();
}
$data = reset_data();

# Test srcport
$data->{srcport} = -1;
dies_ok { NetFlow::Data->new( $data ) }, 'constructor dies -1 srcport';
$data->{srcport} = 65536;
dies_ok { NetFlow::Data->new( $data ) }, 'constructor dies 65536 srcport';
$data->{srcport} = 'a';
dies_ok { NetFlow::Data->new( $data ) }, 'constructor dies \'a\' srcport';
$data->{srcport} = 0;
lives_ok { NetFlow::Data->new( $data ) }, 'constructor lives 0 srcport';
$data->{srcport} = 1;
lives_ok { NetFlow::Data->new( $data ) }, 'constructor lives 1 srcport';
$data->{srcport} = 80;
lives_ok { NetFlow::Data->new( $data ) }, 'constructor lives 80 srcport';
$data->{srcport} = 65535;
lives_ok { NetFlow::Data->new( $data ) }, 'constructor lives 65536 srcport';
$data = reset_data();

# Test tcpflags
my @tcpflags_lives_data =  ( 0..255 );
for my $number (@tcpflags_lives_data) {
    $data->{tcpflags} = $number;
    lives_ok { NetFlow::Data->new( $data ) }, "consturctor lives $number tcpflags";
}
$data = reset_data();

my @tcpflags_dies_data = qw( -1 256 a 1.1 );
for my $number (@tcpflags_dies_data) {
    $data->{tcpflags} = $number;
    dies_ok { NetFlow::Data->new( $data ) }, "constructor dies $number tcpflags";
}
$data = reset_data();

# Test tos
my @tos_lives_data =  ( 0..255 );
for my $number (@tos_lives_data) {
    $data->{tos} = $number;
    lives_ok { NetFlow::Data->new( $data ) }, "consturctor lives $number tos";
}
$data = reset_data();

my @tos_dies_data = qw( -1 256 a 1.1 );
for my $number (@tos_dies_data) {
    $data->{tos} = $number;
    dies_ok { NetFlow::Data->new( $data ) }, "constructor dies $number tos";
}
$data = reset_data();

# Test srcas
my @srcas_lives_data = qw( 0 1 65535 );
for my $number (@srcas_lives_data) {
    $data->{srcas} = $number;
    lives_ok { NetFlow::Data->new( $data ) }, "constructor lives $number srcas";
}
$data = reset_data();

my @srcas_dies_data = qw( -1 65536 a 1.1 );
for my $number (@srcas_dies_data) {
    $data->{srcas} = $number;
    dies_ok { NetFlow::Data->new( $data ) }, "constructor dies $number srcas";
}
$data = reset_data();

# Test dstas
my @dstas_lives_data = qw( 0 1 65535 );
for my $number (@dstas_lives_data) {
    $data->{dstas} = $number;
    lives_ok { NetFlow::Data->new( $data ) }, "constructor lives $number dstas";
}
$data = reset_data();

my @dstas_dies_data = qw( -1 65536 a 1.1 );
for my $number (@dstas_dies_data) {
    $data->{dstas} = $number;
    dies_ok { NetFlow::Data->new( $data ) }, "constructor dies $number dstas";
}
$data = reset_data();

#TODO: { };

done_testing();

sub reset_data {
    my $reset_data = {
    bytes    => 5,
    dstaddr  => '192.168.1.1',
    dstas    => 1,
    dstport  => 80,
    first    => 1,
    last     => 1,
    nexthop  => '192.168.1.1',
    packets  => 1,
    protocol => 1,
    srcaddr  => '192.168.1.2',
    srcport  => 1099,
    srcas    => 1,
    tcpflags => 1,
    tos      => 1 };
    return $reset_data;
}

