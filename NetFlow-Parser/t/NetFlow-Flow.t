use strict;
use warnings;
use Test::More tests => 1457;
use Test::Exception;
BEGIN { use_ok('NetFlow::Flow') };

my $module = "NetFlow::Flow";

# Module can run these methods.
can_ok($module, 'bytes');
can_ok($module, 'dstas');
can_ok($module, 'dstaddr');
can_ok($module, 'dstmask');
can_ok($module, 'dstport');
can_ok($module, 'first');
can_ok($module, 'input');
can_ok($module, 'last');
can_ok($module, 'new');
can_ok($module, 'output');
can_ok($module, 'packets');
can_ok($module, 'protocol');
can_ok($module, 'srcaddr');
can_ok($module, 'srcmask');
can_ok($module, 'srcport');
can_ok($module, 'nexthop');
can_ok($module, 'tcpflags');
can_ok($module, 'tos');
can_ok($module, 'srcas');

my $data = reset_data();

# Test constructor with valid input.
new_ok($module => [ $data ]);
my $obj = $module->new( $data );
isa_ok($obj, 'NetFlow::Flow');

# Read only methods die when used as setters.
dies_ok { $obj->bytes(1)    } "NetFlow::Flow->bytes dies as setter method";
dies_ok { $obj->dstas(1)    } "NetFlow::Flow->dstas dies as setter method";
dies_ok { $obj->dstaddr(1)  } "NetFlow::Flow->dstaddr dies as setter method";
dies_ok { $obj->dstmask(1)  } "NetFlow::Flow->dstmask dies as setter method";
dies_ok { $obj->dstport(1)  } "NetFlow::Flow->dstport dies as setter method";
dies_ok { $obj->first(1)    } "NetFlow::Flow->first dies as setter method";
dies_ok { $obj->input(1)    } "NetFlow::Flow->input dies as setter method";
dies_ok { $obj->last(1)     } "NetFlow::Flow->last dies as setter method";
dies_ok { $obj->output(1)   } "NetFlow::Flow->output dies as setter method";
dies_ok { $obj->packets(1)  } "NetFlow::Flow->packets dies as setter method";
dies_ok { $obj->protocol(1) } "NetFlow::Flow->protocol dies as setter method";
dies_ok { $obj->srcaddr(1)  } "NetFlow::Flow->srcaddr dies as setter method";
dies_ok { $obj->srcmask(1)  } "NetFlow::Flow->srcmask dies as setter method";
dies_ok { $obj->srcport(1)  } "NetFlow::Flow->srcport dies as setter method";
dies_ok { $obj->nexthop(1)  } "NetFlow::Flow->nexthop dies as setter method";
dies_ok { $obj->tcpflags(1) } "NetFlow::Flow->tcpflags dies as setter method";
dies_ok { $obj->tos(1)      } "NetFlow::Flow->tos dies as setter method";
dies_ok { $obj->srcas(1)    } "NetFlow::Flow->srcas dies as setter method";

# Accessor methods return correct value.
cmp_ok ( $obj->bytes(),    '==', 5,    'NetFlow::Flow->bytes accessor retuns correct value'    );
cmp_ok ( $obj->dstas(),    '==', 1,    'NetFlow::Flow->dstas accessor retuns correct value'    );
cmp_ok ( $obj->dstport(),  '==', 80,   'NetFlow::Flow->dstport accessor retuns correct value'  );
cmp_ok ( $obj->first(),    '==', 1,    'NetFlow::Flow->first accessor retuns correct value'    );
cmp_ok ( $obj->last(),     '==', 1,    'NetFlow::Flow->last accessor retuns correct value'     );
cmp_ok ( $obj->packets(),  '==', 1,    'NetFlow::Flow->packets accessor retuns correct value'  );
cmp_ok ( $obj->protocol(), '==', 1,    'NetFlow::Flow->protocol accessor retuns correct value' );
cmp_ok ( $obj->srcas(),    '==', 1,    'NetFlow::Flow->srcas accessor retuns correct value'    );
cmp_ok ( $obj->srcport(),  '==', 1099, 'NetFlow::Flow->srcport accessor retuns correct value'  );
cmp_ok ( $obj->tcpflags(), '==', 1,    'NetFlow::Flow->tcpflags accessor retuns correct value' );
cmp_ok ( $obj->tos(),      '==', 1,    'NetFlow::Flow->tos accessor retuns correct value'      );
is ( $obj->dstaddr(), '192.168.1.1', 'NetFlow::Flow->dstaddr accessor retuns correct value' );
is ( $obj->nexthop(), '192.168.1.1', 'NetFlow::Flow->nexthop accessor retuns correct value' );
is ( $obj->srcaddr(), '192.168.1.2', 'NetFlow::Flow->srcaddr accessor retuns correct value' );

# Test bytes.
$data->{bytes} = -1;
dies_ok { $module->new( $data ) } 'constructor dies negative bytes';
$data->{bytes} = 0;
lives_ok { $module->new( $data ) } 'constructor lives zero bytes';
$data->{bytes} = 1;
lives_ok { $module->new( $data ) } 'constructor lives one byte';
$data->{bytes} = 4294967295;
lives_ok { $module->new( $data ) } 'constructor lives 4294967295 bytes';
$data = reset_data();

# Test dstport
$data->{dstport} = -1;
dies_ok { $module->new( $data ) } 'constructor dies -1 dstport';
$data->{dstport} = 65536;
dies_ok { $module->new( $data ) } 'constructor dies 65536 dstport';
$data->{dstport} = 'a';
dies_ok { $module->new( $data ) } 'constructor dies \'a\' dstport';
$data->{dstport} = 0;
lives_ok { $module->new( $data ) } 'constructor lives 0 dstport';
$data->{dstport} = 1;
lives_ok { $module->new( $data ) } 'constructor lives 1 dstport';
$data->{dstport} = 80;
lives_ok { $module->new( $data ) } 'constructor lives 80 dstport';
$data->{dstport} = 65535;
lives_ok { $module->new( $data ) } 'constructor lives 65535 dstport';

$data = reset_data();

# Test first
my @dies_data = qw( a 1.1 -1 4294967296);
for my $item (@dies_data) {
    $data->{first} = $item;
    dies_ok { $module->new( $data ) } "constructor dies $item first";
}
$data = reset_data();

my @lives_data = qw( 0 1 4294967295);
for my $item (@lives_data) {
    $data->{first} = $item;
    lives_ok { $module->new( $data ) } "constructor lives $item first";
}
$data = reset_data();

# Test last
for my $item (@dies_data) {
    $data->{last} = $item;
    dies_ok { $module->new( $data ) } "constructor dies $item last";
}
$data = reset_data();

for my $item (@lives_data) {
    $data->{last} = $item;
    lives_ok { $module->new( $data ) } "constructor lives $item last";
}
$data = reset_data();

# Test packets
for my $item (@dies_data) {
    $data->{packets} = $item;
    dies_ok { $module->new( $data ) } "constructor dies $item packets";
}
$data = reset_data();

for my $item (@lives_data) {
    $data->{packets} = $item;
    lives_ok { $module->new( $data ) } "constructor lives $item packets";
}
$data = reset_data();

# Test protocol
my @protocol_lives_data = 0..255;
for my $item (@protocol_lives_data) {
    $data->{protocol} = $item;
    lives_ok { $module->new( $data ) } "constructor lives $item protocol";
}
$data = reset_data();

my @protocol_dies_data = ( -1, 256, 1.1, 'a' );
for my $item (@protocol_dies_data) {
    $data->{protocol} = $item;
    dies_ok { $module->new( $data ) } "constructor dies $item protocol";
}
$data = reset_data();

# Test srcaddr, dstaddr, nexthop
my @invalid_ip_addresses = qw( z 1 1. 1.1 1.1. 1.1.1 1.1.1. 256.256.256.256 -1.-1.-1.-1 192.168.1.1111 );
for my $address (@invalid_ip_addresses) {
    $data->{dstaddr} = $address;
    dies_ok { $module->new( $data ) } "constructor dies invalid dstaddr $address";
    $data = reset_data();
    $data->{srcaddr} = $address;
    dies_ok { $module->new( $data ) } "constructor dies invalid srcaddr $address";
    $data = reset_data();
    $data->{nexthop} = $address;
    dies_ok { $module->new( $data ) } "constructor dies invalid nexthop $address";
    $data = reset_data();
}
$data = reset_data();

my @valid_ip_addresses = qw( 0.0.0.0 255.255.255.255 );
for my $address (@valid_ip_addresses) {
    $data->{dstaddr} = $address;
    lives_ok { $module->new( $data ) } "consturctor lives dstaddr $address";
    $data = reset_data();
    $data->{srcaddr} = $address;
    lives_ok { $module->new( $data ) } "consturctor lives srcaddr $address";
    $data = reset_data();
    $data->{nexthop} = $address;
    lives_ok { $module->new( $data ) } "consturctor lives nexthop $address";
    $data = reset_data();
}
$data = reset_data();

# Test srcport
$data->{srcport} = -1;
dies_ok { $module->new( $data ) } 'constructor dies -1 srcport';
$data->{srcport} = 65536;
dies_ok { $module->new( $data ) } 'constructor dies 65536 srcport';
$data->{srcport} = 'a';
dies_ok { $module->new( $data ) } 'constructor dies \'a\' srcport';
$data->{srcport} = 0;
lives_ok { $module->new( $data ) } 'constructor lives 0 srcport';
$data->{srcport} = 1;
lives_ok { $module->new( $data ) } 'constructor lives 1 srcport';
$data->{srcport} = 80;
lives_ok { $module->new( $data ) } 'constructor lives 80 srcport';
$data->{srcport} = 65535;
lives_ok { $module->new( $data ) } 'constructor lives 65536 srcport';
$data = reset_data();

# Test tcpflags
my @tcpflags_lives_data =  ( 0..255 );
for my $number (@tcpflags_lives_data) {
    $data->{tcpflags} = $number;
    lives_ok { $module->new( $data ) } "consturctor lives $number tcpflags";
}
$data = reset_data();

my @tcpflags_dies_data = qw( -1 256 a 1.1 );
for my $number (@tcpflags_dies_data) {
    $data->{tcpflags} = $number;
    dies_ok { $module->new( $data ) } "constructor dies $number tcpflags";
}
$data = reset_data();

# Test tos
my @tos_lives_data =  ( 0..255 );
for my $number (@tos_lives_data) {
    $data->{tos} = $number;
    lives_ok { $module->new( $data ) } "consturctor lives $number tos";
}
$data = reset_data();

my @tos_dies_data = qw( -1 256 a 1.1 );
for my $number (@tos_dies_data) {
    $data->{tos} = $number;
    dies_ok { $module->new( $data ) } "constructor dies $number tos";
}
$data = reset_data();

# Test srcas
my @srcas_lives_data = qw( 0 1 65535 );
for my $number (@srcas_lives_data) {
    $data->{srcas} = $number;
    lives_ok { $module->new( $data ) } "constructor lives $number srcas";
}
$data = reset_data();

my @srcas_dies_data = qw( -1 65536 a 1.1 );
for my $number (@srcas_dies_data) {
    $data->{srcas} = $number;
    dies_ok { $module->new( $data ) } "constructor dies $number srcas";
}
$data = reset_data();

# Test dstas
my @dstas_lives_data = qw( 0 1 65535 );
for my $number (@dstas_lives_data) {
    $data->{dstas} = $number;
    lives_ok { $module->new( $data ) } "constructor lives $number dstas";
}
$data = reset_data();

my @dstas_dies_data = qw( -1 65536 a 1.1 );
for my $number (@dstas_dies_data) {
    $data->{dstas} = $number;
    dies_ok { $module->new( $data ) } "constructor dies $number dstas";
}
$data = reset_data();

# Test srcmask
my @srcmask_dies_data = qw(-1 a 256 1.1);
for my $number (@srcmask_dies_data) {
    $data->{srcmask} = $number;
    dies_ok { $module->new( $data) } "constructor dies $number srcmask";
}
$data = reset_data();

for my $number (0..255) {
    $data->{srcmask} = $number;
    lives_ok { $module->new( $data ) } "consturctor lives $number srcmask";
}
$data = reset_data();

# Test dstmask
my @dstmask_dies_data = qw ( -1 a 256 1.1);
for my $number (@dstmask_dies_data) {
    $data->{dstmask} = $number;
    dies_ok { $module->new( $data ) } "constructor dies $number dstmask";
}
$data = reset_data();

for my $number (0..255) {
    $data->{dstmask} = $number;
    lives_ok { $module->new ( $data ) } "constructor lives $number dstmask";
}
$data = reset_data();

# Test input
my @input_dies_data = qw( a 1.1 -1 65536 );
for my $number (@input_dies_data) {
    $data->{input} = $number;
    dies_ok { $module->new( $data ) } "constructor dies $number input";
}
$data = reset_data();

my @input_lives_data = qw( 0 1 65535);
for my $number (@input_lives_data) {
    $data->{input} = $number;
    lives_ok { $module->new( $data ) } "constructor lives $number input";
}
$data = reset_data();

# Test output
my @output_dies_data = qw( a 1.1 -1 65536 );
for my $number (@output_dies_data) {
    $data->{output} = $number;
    dies_ok { $module->new( $data ) } "constructor dies $number output";
}
$data = reset_data();

my @output_lives_data = qw( 0 1 65535);
for my $number (@output_lives_data) {
    $data->{output} = $number;
    lives_ok { $module->new( $data ) } "constructor lives $number output";
}
$data = reset_data();

sub reset_data {
    my $reset_data = { bytes    => 5,
                       dstaddr  => '192.168.1.1',
                       dstas    => 1,
                       dstmask  => 1,
                       dstport  => 80,
                       first    => 1,
                       input    => 1,
                       last     => 1,
                       nexthop  => '192.168.1.1',
                       output   => 1,
                       packets  => 1,
                       protocol => 1,
                       srcaddr  => '192.168.1.2',
                       srcmask  => 1,
                       srcport  => 1099,
                       srcas    => 1,
                       tcpflags => 1,
                       tos      => 1,
                     };
    return $reset_data;
}

