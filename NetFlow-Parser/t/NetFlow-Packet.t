use strict;
use warnings;
use Test::More tests => 151;
use Test::Exception;
use Test::MockObject;
use NetFlow::Flow;
BEGIN { use_ok('NetFlow::Packet') };

my $Module = "NetFlow::Packet";

# Module can run these methods.
can_ok($Module, 'count');
can_ok($Module, 'flow_sequence');
can_ok($Module, 'flows');
can_ok($Module, 'engine_id');
can_ok($Module, 'engine_type');
can_ok($Module, 'new');
can_ok($Module, 'sampling_interval');
can_ok($Module, 'sampling_mode');
can_ok($Module, 'sys_uptime');
can_ok($Module, 'unix_nsecs');
can_ok($Module, 'unix_secs');
can_ok($Module, 'version');

my $Packet_Data = reset_data();

# Test consturctor with valid input.
new_ok($Module => [ $Packet_Data ]);
my $Packet = $Module->new($Packet_Data);
isa_ok($Packet, $Module);

# Read only methods die when used as setters.
dies_ok { $Packet->count(0)             } 'NetFlow::Packet->count dies as setter method';
dies_ok { $Packet->flow_sequence(0)     } 'NetFlow::Packet->flow_sequence dies as setter method';
dies_ok { $Packet->engine_id(0)         } 'NetFlow::Packet->engine_id dies as setter method';
dies_ok { $Packet->engine_type(0)       } 'NetFlow::Packet->engine_type dies as setter method';
dies_ok { $Packet->sampling_interval(0) } 'NetFlow::Packet->sampling_interval dies as setter method';
dies_ok { $Packet->sampling_mode(0)     } 'NetFlow::Packet->sampling_mode dies as setter method';
dies_ok { $Packet->sys_uptime(0)        } 'NetFlow::Packet->sys_uptime dies as setter method';
dies_ok { $Packet->unix_nsecs(0)        } 'NetFlow::Packet->unix_nsecs dies as setter method';
dies_ok { $Packet->unix_secs(0)         } 'NetFlow::Packet->unix_secs dies as setter method';
dies_ok { $Packet->version(0)           } 'NetFlow::Packet->version dies as setter method';
dies_ok { $Packet->flows(0)             } 'NetFlow::Packet->flows dies as setter method';

# Accessor methods live.
lives_ok { $Packet->count()             } 'NetFlow::Packet->count accessor lives';
lives_ok { $Packet->flow_sequence()     } 'NetFlow::Packet->flow_sequence accessor lives';
lives_ok { $Packet->engine_id()         } 'NetFlow::Packet->engine_id accessor lives';
lives_ok { $Packet->engine_type()       } 'NetFlow::Packet->engine_type accessor lives';
lives_ok { $Packet->sampling_interval() } 'NetFlow::Packet->sampling_interval accessor lives';
lives_ok { $Packet->sampling_mode()     } 'NetFlow::Packet->sampling_mode accessor lives';
lives_ok { $Packet->sys_uptime()        } 'NetFlow::Packet->sys_uptime accessor lives';
lives_ok { $Packet->unix_nsecs()        } 'NetFlow::Packet->unix_nsecs accessor lives';
lives_ok { $Packet->unix_secs()         } 'NetFlow::Packet->unix_secs accessor lives';
lives_ok { $Packet->version()           } 'NetFlow::Packet->version accessor lives';
lives_ok { $Packet->flows()             } 'NetFlow::Packet->flows accessor lives';

# Accessor methods return correct value.
cmp_ok ( $Packet->count(),             '==', 1,          'NetFlow::Packet->count accessor returns correct value'             );
cmp_ok ( $Packet->flow_sequence(),     '==', 37,         'NetFlow::Packet->flow_sequence accessor returns correct value'     );
cmp_ok ( $Packet->engine_id(),         '==', 0,          'NetFlow::Packet->engine_id accessor returns correct value'         );
cmp_ok ( $Packet->engine_type(),       '==', 0,          'NetFlow::Packet->engine_type accessor returns correct value'       );
cmp_ok ( $Packet->sampling_interval(), '==', 1,          'NetFlow::Packet->sampling_interval accessor returns correct value' );
cmp_ok ( $Packet->sampling_mode(),     '==', 2,          'NetFlow::Packet->sampling_mode accessor returns correct value'     );
cmp_ok ( $Packet->sys_uptime(),        '==', 1000,       'NetFlow::Packet->sys_uptime accessor returns correct value'        );
cmp_ok ( $Packet->unix_nsecs(),        '==', 1,          'NetFlow::Packet->unix_nsecs accessor returns correct value'        );
cmp_ok ( $Packet->unix_secs(),         '==', 1357183150, 'NetFlow::Packet->unix_secs accessor returns correct value'         );
cmp_ok ( $Packet->version(),           '==', 5,          'NetFlow::Packet->version accessor returns correct value'           );

# Test flows accessor method.
my $flows = $Packet->flows();
isa_ok ($flows, 'ARRAY');
is_deeply ( $flows, $Packet_Data->{flows}, 'NetFlow::Packet->flows accessor returns correct value' );
for my $flow (@{$flows}) {
    isa_ok($flow, 'NetFlow::Flow');
}

# Test constructor with invalid parmateters
my $Mock_Flow = Test::MockObject->new();
$Mock_Flow->set_isa('NetFlow::Flow');
my $Flows = [ $Mock_Flow ];
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
    dies_ok { NetFlow::Packet->new($Test_Parameters) } $Test_Description;
}

# Test constructor with valid count values
$Packet_Data = reset_data();
for my $count (0..30) {
    $Packet_Data->{count} = $count;
    lives_ok { NetFlow::Packet->new($Packet_Data) } "NetFlow::Packet->new lives with count parameter equal to $count";
}

# Test constructor with valid engine_id values
$Packet_Data = reset_data();
for my $engine_id (0, 1, 254, 255) {
    $Packet_Data->{engine_id} = $engine_id;
    lives_ok { NetFlow::Packet->new($Packet_Data) } "NetFlow::Packet->new lives with engine_id parameter equal to $engine_id";
}

# Test constructor with valid engine_type values
$Packet_Data = reset_data();
for my $engine_type (0, 1, 254, 255) {
    $Packet_Data->{engine_type} = $engine_type;
    lives_ok { NetFlow::Packet->new($Packet_Data) } "NetFlow::Packet->new lives with engine_type parameter equal to $engine_type";
}

# Test constructor with valid flow_sequence values
$Packet_Data = reset_data();
for my $flow_sequence (0, 1, 4294967294, 4294967295) {
    $Packet_Data->{flow_sequence} = $flow_sequence;
    lives_ok { NetFlow::Packet->new($Packet_Data) } "NetFlow::Packet->new lives with flow_sequnce parameter equal to $flow_sequence";
}

# Test consturctor with valid flows values
$Packet_Data = reset_data();
my @Valid_Flows = ( [], [ ($Mock_Flow, $Mock_Flow) ], [ ($Mock_Flow, $Mock_Flow, $Mock_Flow) ] );
for my $flows (@Valid_Flows) {
    $Packet_Data->{flows} = $flows;
    lives_ok { NetFlow::Packet->new($Packet_Data) } "NetFlow::Packet->new lives with with flows parameter values";
}

# Test constructor with valid sampling_interval values
$Packet_Data = reset_data();
for my $sampling_interval (0, 1, 62, 63) {
    $Packet_Data->{sampling_interval} = $sampling_interval;
    lives_ok { NetFlow::Packet->new($Packet_Data) } "NetFlow::Packet->new lives with sampling_interval parameter equal to $sampling_interval";
}

# Test constructor with valid sampling_mode values
$Packet_Data = reset_data();
for my $sampling_mode (0, 1, 2, 3) {
    $Packet_Data->{sampling_mode} = $sampling_mode;
    lives_ok { NetFlow::Packet->new($Packet_Data) } "NetFlow::Packet->new lives with sampling_mode parameter equal to $sampling_mode";
}

# Test construcotr with valid sys_uptime values
$Packet_Data = reset_data();
for my $sys_uptime (0, 1, 4294967294, 4294967295) {
    $Packet_Data->{sys_uptime} = $sys_uptime;
    lives_ok { NetFlow::Packet->new($Packet_Data) } "NetFlow::Packet->new lives with sys_uptime parameter equal to $sys_uptime";
}

# Test constructor with valid unix_nsecs values
$Packet_Data = reset_data();
for my $unix_nsecs (0, 1, 4294967294, 4294967295) {
    $Packet_Data->{unix_nsecs} = $unix_nsecs;
    lives_ok { NetFlow::Packet->new($Packet_Data) } "NetFlow::Packet->new lives with unix_nsecs parameter equal to $unix_nsecs";
}

# Test constructor with valid unix_secs values
$Packet_Data = reset_data();
for my $unix_secs (0, 1, 4294967294, 4294967295) {
    $Packet_Data->{unix_secs} = $unix_secs;
    lives_ok { NetFlow::Packet->new($Packet_Data) } "NetFlow::Packet->new lives with unix_secs parameter equal to $unix_secs";
}

# Do not need to test construcor with valid version values. Only valid version is 5.

sub reset_data {
    my $mock_flow_obj = Test::MockObject->new();
    $mock_flow_obj->set_isa('NetFlow::Flow');
    my $flows = [ $mock_flow_obj ];
    my $data = { 'count'             => 1,
                 'engine_id'         => 0,
                 'engine_type'       => 0,
                 'flow_sequence'     => 37,
                 'flows'             => $flows,
                 'sampling_interval' => 1,
                 'sampling_mode'     => 2,
                 'sys_uptime'        => 1000,
                 'unix_nsecs'        => 1,
                 'unix_secs'         => 1357183150,
                 'version'           => 5,
               };
    return $data;
}
__DATA__
# Consturctor dies with missing parmaters
$Test_Parameters = { engine_id => 0, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new() dies missing count parameter
$Test_Parameters = { count => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new() dies missing engine_id parameter
$Test_Parameters = { count => 1, engine_id => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new() dies missing engine_type parameter
$Test_Parameters = { count => 1, engine_id => 0, engine_type => 0, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new() dies missing flow_sequence parameter
$Test_Parameters = { count => 1, engine_id => 0, engine_type => 0, flow_sequence => 37, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new() dies missing flows parameter
$Test_Parameters = { count => 1, engine_id => 0, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new() dies missing sampling_interval parameter
$Test_Parameters = { count => 1, engine_id => 0, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new() dies missing sampling_mode parameter
$Test_Parameters = { count => 1, engine_id => 0, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new() dies missing sys_uptime parameter
$Test_Parameters = { count => 1, engine_id => 0, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new() dies missing unix_nsecs parameter
$Test_Parameters = { count => 1, engine_id => 0, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, version => 5 };|NetFlow::Packet->new() dies missing unix_secs parameter
$Test_Parameters = { count => 1, engine_id => 0, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150 };|NetFlow::Packet->new() dies missing version parameter
# Constructor dies with invalid values
$Test_Parameters = { count => -1, engine_id => 0, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, count parameter is -1
$Test_Parameters = { count => 31, engine_id => 0, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, count parameter is 31
$Test_Parameters = { count => 1, engine_id => -1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, engine_id parameter is -1
$Test_Parameters = { count => 1, engine_id => 256, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, engine_id parameter is 256
$Test_Parameters = { count => 1, engine_id => 1, engine_type => -1, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, engine_type parameter is 256
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 256, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, engine_type parameter is 256
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => -1, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, flow_sequcnce parameter is -1
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 4294967296, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, flow_sequence parameter is 4294967296
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => -1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, sampling_interval parameter is -1
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 64, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, sampling_interval parameter is 64
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => -1, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, sampling_mode parameter is -1
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 4, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, sampling_mode parameter is 4
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => -1, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, sys_uptime parameter is -1
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 4294967296, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, sys_uptime parameter is 4294967296
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => -1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, unix_nsecs parameter is -1
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 4294967296, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, unix_nsecs parameter is 4294967296
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => -1, version => 5 };|NetFlow::Packet->new dies, unix_secs parameter is -1
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 4294967296, version => 5 };|NetFlow::Packet->new dies, unix_secs parameter is 4294967296
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 4 };|NetFlow::Packet->new dies, version parameter is 4
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => $Flows, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 6 };|NetFlow::Packet->new dies, version parameter is 6
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => 0, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, flows is numeric
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => 'string', sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, flows is string
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => {}, sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, flows is empty hash reference
$Test_Parameters = { count => 1, engine_id => 1, engine_type => 0, flow_sequence => 37, flows => [ qw (string) ], sampling_interval => 1, sampling_mode => 2, sys_uptime => 1000, unix_nsecs => 1, unix_secs => 1357183150, version => 5 };|NetFlow::Packet->new dies, flows is empty array reference of strings
