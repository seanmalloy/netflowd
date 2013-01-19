use strict;
use warnings;
#use Test::More tests => 1480;
use Test::More;
use Test::Exception;
BEGIN { use_ok('NetFlow::Flow') };

my $Module = "NetFlow::Flow";

# Module can run these methods.
can_ok($Module, 'bytes');
can_ok($Module, 'dstas');
can_ok($Module, 'dstaddr');
can_ok($Module, 'dstmask');
can_ok($Module, 'dstport');
can_ok($Module, 'first');
can_ok($Module, 'input');
can_ok($Module, 'last');
can_ok($Module, 'new');
can_ok($Module, 'output');
can_ok($Module, 'packets');
can_ok($Module, 'protocol');
can_ok($Module, 'srcaddr');
can_ok($Module, 'srcmask');
can_ok($Module, 'srcport');
can_ok($Module, 'nexthop');
can_ok($Module, 'tcpflags');
can_ok($Module, 'tos');
can_ok($Module, 'srcas');

my $Flow_Data = reset_data();

# Test constructor with valid input.
new_ok($Module => [ $Flow_Data ]);
my $Flow = $Module->new($Flow_Data);
isa_ok($Flow, $Module);

# Read only methods die when used as setters.
dies_ok { $Flow->bytes(1)    } "NetFlow::Flow->bytes dies as setter method";
dies_ok { $Flow->dstaddr(1)  } "NetFlow::Flow->dstaddr dies as setter method";
dies_ok { $Flow->dstas(1)    } "NetFlow::Flow->dstas dies as setter method";
dies_ok { $Flow->dstmask(1)  } "NetFlow::Flow->dstmask dies as setter method";
dies_ok { $Flow->dstport(1)  } "NetFlow::Flow->dstport dies as setter method";
dies_ok { $Flow->first(1)    } "NetFlow::Flow->first dies as setter method";
dies_ok { $Flow->input(1)    } "NetFlow::Flow->input dies as setter method";
dies_ok { $Flow->last(1)     } "NetFlow::Flow->last dies as setter method";
dies_ok { $Flow->nexthop(1)  } "NetFlow::Flow->nexthop dies as setter method";
dies_ok { $Flow->output(1)   } "NetFlow::Flow->output dies as setter method";
dies_ok { $Flow->packets(1)  } "NetFlow::Flow->packets dies as setter method";
dies_ok { $Flow->protocol(1) } "NetFlow::Flow->protocol dies as setter method";
dies_ok { $Flow->srcaddr(1)  } "NetFlow::Flow->srcaddr dies as setter method";
dies_ok { $Flow->srcas(1)    } "NetFlow::Flow->srcas dies as setter method";
dies_ok { $Flow->srcmask(1)  } "NetFlow::Flow->srcmask dies as setter method";
dies_ok { $Flow->srcport(1)  } "NetFlow::Flow->srcport dies as setter method";
dies_ok { $Flow->tcpflags(1) } "NetFlow::Flow->tcpflags dies as setter method";
dies_ok { $Flow->tos(1)      } "NetFlow::Flow->tos dies as setter method";

# Accessor methods live.
lives_ok { $Flow->bytes()    } 'NetFlow::Flow->bytes accessor lives';
lives_ok { $Flow->dstaddr()  } 'NetFlow::Flow->dstaddr accessor lives';
lives_ok { $Flow->dstas()    } 'NetFlow::Flow->dstas accessor lives';
lives_ok { $Flow->dstas()    } 'NetFlow::Flow->destas accessor lives';
lives_ok { $Flow->dstmask()  } 'NetFlow::Flow->dstmask accessor lives';
lives_ok { $Flow->dstport()  } 'NetFlow::Flow->dstport accessor lives';
lives_ok { $Flow->first()    } 'NetFlow::Flow->first accessor lives';
lives_ok { $Flow->input()    } 'NetFlow::Flow->input accessor lives';
lives_ok { $Flow->last()     } 'NetFlow::Flow->last accessor lives';
lives_ok { $Flow->nexthop()  } 'NetFlow::Flow->nexthop accessor lives';
lives_ok { $Flow->output()   } 'NetFlow::Flow->output accessor lives';
lives_ok { $Flow->packets()  } 'NetFlow::Flow->packets accessor lives';
lives_ok { $Flow->protocol() } 'NetFlow::Flow->protocol accessor lives';
lives_ok { $Flow->srcaddr()  } 'NetFlow::Flow->srcaddr accessor lives';
lives_ok { $Flow->srcas()    } 'NetFlow::Flow->srcas accessor lives';
lives_ok { $Flow->srcmask()  } 'NetFlow::Flow->srcmask accessor lives';
lives_ok { $Flow->srcport()  } 'NetFlow::Flow->srcport accessor lives';
lives_ok { $Flow->tcpflags() } 'NetFlow::Flow->tcpflags accessor lives';
lives_ok { $Flow->tos()      } 'NetFlow::Flow->tos accessor lives';

# Accessor methods return correct value.
cmp_ok ( $Flow->bytes(),    '==', 5,    'NetFlow::Flow->bytes accessor retuns correct value'    );
cmp_ok ( $Flow->dstas(),    '==', 1,    'NetFlow::Flow->dstas accessor retuns correct value'    );
cmp_ok ( $Flow->dstmask(),  '==', 1,    'NetFlow::Flow->dstmask accessor retuns correct value'  );
cmp_ok ( $Flow->dstport(),  '==', 80,   'NetFlow::Flow->dstport accessor retuns correct value'  );
cmp_ok ( $Flow->first(),    '==', 1,    'NetFlow::Flow->first accessor retuns correct value'    );
cmp_ok ( $Flow->input(),    '==', 1,    'NetFlow::Flow->input accessor retuns correct value'    );
cmp_ok ( $Flow->last(),     '==', 1,    'NetFlow::Flow->last accessor retuns correct value'     );
cmp_ok ( $Flow->output(),   '==', 1,    'NetFlow::Flow->output accessor retuns correct value'   );
cmp_ok ( $Flow->packets(),  '==', 1,    'NetFlow::Flow->packets accessor retuns correct value'  );
cmp_ok ( $Flow->protocol(), '==', 1,    'NetFlow::Flow->protocol accessor retuns correct value' );
cmp_ok ( $Flow->srcas(),    '==', 1,    'NetFlow::Flow->srcas accessor retuns correct value'    );
cmp_ok ( $Flow->srcmask(),  '==', 1,    'NetFlow::Flow->srcmask accessor retuns correct value'  );
cmp_ok ( $Flow->srcport(),  '==', 1099, 'NetFlow::Flow->srcport accessor retuns correct value'  );
cmp_ok ( $Flow->tcpflags(), '==', 1,    'NetFlow::Flow->tcpflags accessor retuns correct value' );
cmp_ok ( $Flow->tos(),      '==', 1,    'NetFlow::Flow->tos accessor retuns correct value'      );
is ( $Flow->dstaddr(), '192.168.1.1', 'NetFlow::Flow->dstaddr accessor retuns correct value' );
is ( $Flow->nexthop(), '192.168.1.1', 'NetFlow::Flow->nexthop accessor retuns correct value' );
is ( $Flow->srcaddr(), '192.168.1.2', 'NetFlow::Flow->srcaddr accessor retuns correct value' );

# Test constructor with invalid parmateters
my ($Code, $Test_Description);
my $Test_Parameters;
LINE:
while (my $line = <DATA>) {
    chomp $line;
    if ($line =~ /^#/) {
        next LINE;
    }
    ($Code, $Test_Description) = split /\|/, $line; 
    eval $Code;
    dies_ok { NetFlow::Flow->new($Test_Parameters) } $Test_Description;
}

# START
#$Flow_Data->{srcport} = -1;
#dies_ok { $Module->new( $Flow_Data ) } 'constructor dies -1 srcport';
#$Flow_Data->{srcport} = 65536;
#dies_ok { $Module->new( $Flow_Data ) } 'constructor dies 65536 srcport';
#$Flow_Data->{srcport} = 'a';
#dies_ok { $Module->new( $Flow_Data ) } 'constructor dies \'a\' srcport';

#my @tcpflags_dies_data = qw( -1 256 a 1.1 );
#for my $number (@tcpflags_dies_data) {
#    $Flow_Data->{tcpflags} = $number;
#    dies_ok { $Module->new( $Flow_Data ) } "constructor dies $number tcpflags";
#}

#my @tos_dies_data = qw( -1 256 a 1.1 );
#for my $number (@tos_dies_data) {
#    $Flow_Data->{tos} = $number;
#    dies_ok { $Module->new( $Flow_Data ) } "constructor dies $number tos";
#}

#my @srcas_dies_data = qw( -1 65536 a 1.1 );
#for my $number (@srcas_dies_data) {
#    $Flow_Data->{srcas} = $number;
#    dies_ok { $Module->new( $Flow_Data ) } "constructor dies $number srcas";
#}

#my @dstas_dies_data = qw( -1 65536 a 1.1 );
#for my $number (@dstas_dies_data) {
#    $Flow_Data->{dstas} = $number;
#    dies_ok { $Module->new( $Flow_Data ) } "constructor dies $number dstas";
#}

#my @srcmask_dies_data = qw(-1 a 256 1.1);
#for my $number (@srcmask_dies_data) {
#    $Flow_Data->{srcmask} = $number;
#    dies_ok { $Module->new( $Flow_Data) } "constructor dies $number srcmask";
#}

#my @dstmask_dies_data = qw ( -1 a 256 1.1);
#for my $number (@dstmask_dies_data) {
#    $Flow_Data->{dstmask} = $number;
#    dies_ok { $Module->new( $Flow_Data ) } "constructor dies $number dstmask";
#}

#my @input_dies_data = qw( a 1.1 -1 65536 );
#for my $number (@input_dies_data) {
#    $Flow_Data->{input} = $number;
#    dies_ok { $Module->new( $Flow_Data ) } "constructor dies $number input";
#}

#my @output_dies_data = qw( a 1.1 -1 65536 );
#for my $number (@output_dies_data) {
#    $Flow_Data->{output} = $number;
#    dies_ok { $Module->new( $Flow_Data ) } "constructor dies $number output";
#}

# Test bytes.
$Flow_Data->{bytes} = 0;
lives_ok { $Module->new( $Flow_Data ) } 'constructor lives zero bytes';
$Flow_Data->{bytes} = 1;
lives_ok { $Module->new( $Flow_Data ) } 'constructor lives one byte';
$Flow_Data->{bytes} = 4294967295;
lives_ok { $Module->new( $Flow_Data ) } 'constructor lives 4294967295 bytes';
$Flow_Data = reset_data();

# Test dstport
$Flow_Data->{dstport} = 0;
lives_ok { $Module->new( $Flow_Data ) } 'constructor lives 0 dstport';
$Flow_Data->{dstport} = 1;
lives_ok { $Module->new( $Flow_Data ) } 'constructor lives 1 dstport';
$Flow_Data->{dstport} = 80;
lives_ok { $Module->new( $Flow_Data ) } 'constructor lives 80 dstport';
$Flow_Data->{dstport} = 65535;
lives_ok { $Module->new( $Flow_Data ) } 'constructor lives 65535 dstport';

# Test first
$Flow_Data = reset_data();
my @lives_data = qw( 0 1 4294967295);
for my $item (@lives_data) {
    $Flow_Data->{first} = $item;
    lives_ok { $Module->new( $Flow_Data ) } "constructor lives $item first";
}

# Test last
$Flow_Data = reset_data();
for my $item (@lives_data) {
    $Flow_Data->{last} = $item;
    lives_ok { $Module->new( $Flow_Data ) } "constructor lives $item last";
}

# Test packets
$Flow_Data = reset_data();
for my $item (@lives_data) {
    $Flow_Data->{packets} = $item;
    lives_ok { $Module->new( $Flow_Data ) } "constructor lives $item packets";
}

# Test protocol
$Flow_Data = reset_data();
my @protocol_lives_data = 0..255;
for my $item (@protocol_lives_data) {
    $Flow_Data->{protocol} = $item;
    lives_ok { $Module->new( $Flow_Data ) } "constructor lives $item protocol";
}

# Test srcaddr, dstaddr, nexthop
$Flow_Data = reset_data();
my @valid_ip_addresses = qw( 0.0.0.0 255.255.255.255 );
for my $address (@valid_ip_addresses) {
    $Flow_Data->{dstaddr} = $address;
    lives_ok { $Module->new( $Flow_Data ) } "consturctor lives dstaddr $address";
    $Flow_Data = reset_data();
    $Flow_Data->{srcaddr} = $address;
    lives_ok { $Module->new( $Flow_Data ) } "consturctor lives srcaddr $address";
    $Flow_Data = reset_data();
    $Flow_Data->{nexthop} = $address;
    lives_ok { $Module->new( $Flow_Data ) } "consturctor lives nexthop $address";
    $Flow_Data = reset_data();
}

# Test srcport
$Flow_Data->{srcport} = 0;
lives_ok { $Module->new( $Flow_Data ) } 'constructor lives 0 srcport';
$Flow_Data->{srcport} = 1;
lives_ok { $Module->new( $Flow_Data ) } 'constructor lives 1 srcport';
$Flow_Data->{srcport} = 80;
lives_ok { $Module->new( $Flow_Data ) } 'constructor lives 80 srcport';
$Flow_Data->{srcport} = 65535;
lives_ok { $Module->new( $Flow_Data ) } 'constructor lives 65536 srcport';

# Test tcpflags
$Flow_Data = reset_data();
my @tcpflags_lives_data =  ( 0..255 );
for my $number (@tcpflags_lives_data) {
    $Flow_Data->{tcpflags} = $number;
    lives_ok { $Module->new( $Flow_Data ) } "consturctor lives $number tcpflags";
}

# Test tos
$Flow_Data = reset_data();
my @tos_lives_data =  ( 0..255 );
for my $number (@tos_lives_data) {
    $Flow_Data->{tos} = $number;
    lives_ok { $Module->new( $Flow_Data ) } "consturctor lives $number tos";
}

# Test srcas
$Flow_Data = reset_data();
my @srcas_lives_data = qw( 0 1 65535 );
for my $number (@srcas_lives_data) {
    $Flow_Data->{srcas} = $number;
    lives_ok { $Module->new( $Flow_Data ) } "constructor lives $number srcas";
}

# Test dstas
$Flow_Data = reset_data();
my @dstas_lives_data = qw( 0 1 65535 );
for my $number (@dstas_lives_data) {
    $Flow_Data->{dstas} = $number;
    lives_ok { $Module->new( $Flow_Data ) } "constructor lives $number dstas";
}

# Test srcmask
$Flow_Data = reset_data();
for my $number (0..255) {
    $Flow_Data->{srcmask} = $number;
    lives_ok { $Module->new( $Flow_Data ) } "consturctor lives $number srcmask";
}

# Test dstmask
$Flow_Data = reset_data();
for my $number (0..255) {
    $Flow_Data->{dstmask} = $number;
    lives_ok { $Module->new ( $Flow_Data ) } "constructor lives $number dstmask";
}

# Test input
$Flow_Data = reset_data();
my @input_lives_data = qw( 0 1 65535);
for my $number (@input_lives_data) {
    $Flow_Data->{input} = $number;
    lives_ok { $Module->new( $Flow_Data ) } "constructor lives $number input";
}

# Test output
$Flow_Data = reset_data();
my @output_lives_data = qw( 0 1 65535);
for my $number (@output_lives_data) {
    $Flow_Data->{output} = $number;
    lives_ok { $Module->new( $Flow_Data ) } "constructor lives $number output";
}
$Flow_Data = reset_data();

done_testing();

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

__DATA__
#$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with ...
$Test_Parameters = { dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing bytes parameter
$Test_Parameters = { bytes => 5, dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing dstaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing dstas parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing dstmask parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing dstport parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing first parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing input parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing last parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing nexthop parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing output parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing packets parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing protocol parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing srcaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing srcmask parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing srcport parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies missing srcas parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tos => 1, };|NetFlow::Flow->new() dies missing tcpflags parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, };|NetFlow::Flow->new() dies missing tos parameter
$Test_Parameters = { bytes => -1, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative bytes parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => -1, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with with negative dstport parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 65536, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 65536 dstport parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 'a', first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numberic dstport parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 'a', input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numberic first parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1.1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 first parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => -1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative first parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 4294967296, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 4294967296 first parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 'a', nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numeric last parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1.1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 last parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => -1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative last parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 4294967296, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 4294967296 last parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 'a', protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numeric packets parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1.1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 packets parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => -1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative packets parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 4294967296, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 4294967296 packets parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => -1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative protocol parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 256, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 256 protocol parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1.1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 protocol parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 'a', srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numeric protocol parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => 'z', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numeric nexthop parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1 nexthop parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '1.', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1. nexthop parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 nexthop parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '1.1.', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1. nexthop parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '1.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1.1 nexthop parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '1.1.1.', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1.1. nexthop parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '256.256.256.256', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 256.256.256.256 nexthop parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '-1.-1.-1.-1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with -1.-1.-1.-1 nexthop parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1111', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 192.168.1.1111 nexthop parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => 'z', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numeric srcaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '1', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1 srcaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '1.', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1. srcaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '1.1', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 srcaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '1.1.', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1. srcaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '1.1.1', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1.1 srcaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '1.1.1.', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1.1. srcaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '256.256.256.256', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 256.256.256.256 srcaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '-1.-1.-1.-1', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with -1.-1.-1.-1 srcaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.1111', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 192.168.1.1111 srcaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => 'z', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numeric dstaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1 dstaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '1.', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1. dstaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 dstaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '1.1.', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1. dstaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '1.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1.1 dstaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '1.1.1.', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1.1. dstaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '256.256.256.256', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 256.256.256.256 dstaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '-1.-1.-1.-1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with -1.-1.-1.-1 dstaddr parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1111', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 192.168.1.1111 dstaddr parameter
