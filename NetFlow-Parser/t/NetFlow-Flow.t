use strict;
use warnings;
use Test::More tests => 1498;
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

# Test constructor with valid bytes values
$Flow_Data = reset_data();
for my $bytes (0, 1, 4294967295) {
    $Flow_Data->{bytes} = $bytes;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with bytes parameter equal to $bytes";
}

# Test constructor with valid dstport values
$Flow_Data = reset_data();
for my $dstport (0, 1, 80, 65535) {
    $Flow_Data->{dstport} = $dstport;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with dstport parameter equal to $dstport";
}

# Test constructor with valid first values
$Flow_Data = reset_data();
for my $first (0, 1, 4294967295) {
    $Flow_Data->{first} = $first;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with first parameter equal to $first";
}

# Test constructor with valid last values
$Flow_Data = reset_data();
for my $last (0, 1, 4294967295) {
    $Flow_Data->{last} = $last;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with last parameter equal to $last";
}

# Test constructor with valid packets values
$Flow_Data = reset_data();
for my $packets (0, 1, 4294967295) {
    $Flow_Data->{packets} = $packets;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with packets parameter equal to $packets";
}

# Test constructor with valid protocol values
$Flow_Data = reset_data();
for my $protocol (0..255) {
    $Flow_Data->{protocol} = $protocol;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with protocol parameter equal to $protocol";
}

# Test constructor with valid dstaddr values
$Flow_Data = reset_data();
for my $dstaddr ('0.0.0.0', '255.255.255.255' ) {
    $Flow_Data->{dstaddr} = $dstaddr;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with dstaddr equal to $dstaddr";
}

# Test constructor with valid srcaddr values
$Flow_Data = reset_data();
for my $srcaddr ('0.0.0.0', '255.255.255.255' ) {
    $Flow_Data->{srcaddr} = $srcaddr;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with srcaddr equal to $srcaddr";
}

# Test constructor with valid nexthop values
$Flow_Data = reset_data();
for my $nexthop ('0.0.0.0', '255.255.255.255' ) {
    $Flow_Data->{nexthop} = $nexthop;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with nexthop equal to $nexthop";
}

# Test constructor with valid srcport values
$Flow_Data = reset_data();
for my $srcport (0, 1, 80, 65535) {
    $Flow_Data->{srcport} = $srcport;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with srcport equal to $srcport";
}

# Test constructor with valid tcpflags values
$Flow_Data = reset_data();
for my $tcpflags (0..255) {
    $Flow_Data->{tcpflags} = $tcpflags;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with tcpflows equal to $tcpflags";
}

# Test constructor with valid tos values
$Flow_Data = reset_data();
for my $tos (0..255) {
    $Flow_Data->{tos} = $tos;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with tos equal to $tos";
}

# Test constructor with valid srcas values
$Flow_Data = reset_data();
for my $srcas (0, 1, 65535) {
    $Flow_Data->{srcas} = $srcas;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with srcas equal to $srcas";
}

# Test constructor with valid dstas values
$Flow_Data = reset_data();
my @dstas_lives_data = qw( 0 1 65535 );
for my $dstas (0, 1, 65535) {
    $Flow_Data->{dstas} = $dstas;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with dstas equal to $dstas";
}

# Test constructor with valid srcmask values
$Flow_Data = reset_data();
for my $srcmask (0..255) {
    $Flow_Data->{srcmask} = $srcmask;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with srcmask equal to $srcmask";
}

# Test constructor with valid dstmask values
$Flow_Data = reset_data();
for my $dstmask (0..255) {
    $Flow_Data->{dstmask} = $dstmask;
    lives_ok { $Module->new ( $Flow_Data ) } "NetFlow::Flow->new lives with dstmaks equal to $dstmask";
}

# Test constructor with valid input values
$Flow_Data = reset_data();
for my $input (0, 1, 65535) {
    $Flow_Data->{input} = $input;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with input equal to $input";
}

# Test constructor with valid output values
$Flow_Data = reset_data();
for my $output (0, 1, 65535) {
    $Flow_Data->{output} = $output;
    lives_ok { $Module->new( $Flow_Data ) } "NetFlow::Flow->new lives with output equal to $output";
}

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
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 'a',   srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numberic srcport parameter 
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => -1,    srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative srcport parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 65536, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 65536 srcport parameter 
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => -1,  tos => 1, };|NetFlow::Flow->new() dies with negative tcpflags parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1.1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 tcpflags parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 'a', tos => 1, };|NetFlow::Flow->new() dies with non-numeric tcpflags parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 256, tos => 1, };|NetFlow::Flow->new() dies with 256 tcpflags parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => -1, };|NetFlow::Flow->new() dies with negative tos parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1.1, };|NetFlow::Flow->new() dies with 1.1 tos parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 'a', };|NetFlow::Flow->new() dies with non-numeric tos parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 256, };|NetFlow::Flow->new() dies with 256 tos parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => -1,    tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative srcas parmater
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1.1,   tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 srcas parmater
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 'a',   tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numeric srcas parmater
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 65536, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 65536 srcas parmater
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => -1,    dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative dstas parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1.1,   dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 dstas parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 'a',   dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numberic dstas parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 65536, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 65536 dstas parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => -1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative srcmask parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1.1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 srcmask parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 'a', srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numeric srcmask parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 256, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 256 srcmask parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => -1,  dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative dstmask parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 'a', dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numeric dstmask parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1.1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 dstmask parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 256, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 256 dstmask parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 'a',   last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numeric input parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1.1,   last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 input parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => -1,    last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative input parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 65536, last => 1, nexthop => '192.168.1.1', output => 1, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 65536 input parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 'a',   packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with non-numeric output parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 1.1,   packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 1.1 output parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => -1,    packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with negative output parameter
$Test_Parameters = { bytes => 5, dstaddr => '192.168.1.1', dstas => 1, dstmask => 1, dstport => 80, first => 1, input => 1, last => 1, nexthop => '192.168.1.1', output => 65536, packets => 1, protocol => 1, srcaddr => '192.168.1.2', srcmask => 1, srcport => 1099, srcas => 1, tcpflags => 1, tos => 1, };|NetFlow::Flow->new() dies with 65536 output parameter
