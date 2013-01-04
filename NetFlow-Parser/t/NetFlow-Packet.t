use strict;
use warnings;
use Test::More;
use Test::Exception;
use NetFlow::Flow;
BEGIN { use_ok('NetFlow::Packet') };

my $module = "NetFlow::Packet";
can_ok($module, 'count');
can_ok($module, 'flow_sequence');
can_ok($module, 'flows');
can_ok($module, 'engine_id');
can_ok($module, 'engine_type');
can_ok($module, 'new');
can_ok($module, 'sampling_interval');
can_ok($module, 'sampling_mode');
can_ok($module, 'sys_uptime');
can_ok($module, 'unix_nsecs');
can_ok($module, 'unix_secs');
can_ok($module, 'version');

my $packet_data = reset_data();

# Test consturctor.
new_ok($module => [ $packet_data ]);
my $packet = $module->new($packet_data);
isa_ok($packet, $module);

# Read only methods die when using as setters.
dies_ok { $packet->count(0)             } 'NetFlow::Packet->count dies as setter method';
dies_ok { $packet->flow_sequence(0)     } 'NetFlow::Packet->flow_sequence dies as setter method';
dies_ok { $packet->engine_id(0)         } 'NetFlow::Packet->engine_id dies as setter method';
dies_ok { $packet->engine_type(0)       } 'NetFlow::Packet->engine_type dies as setter method';
dies_ok { $packet->sampling_interval(0) } 'NetFlow::Packet->sampling_interval dies as setter method';
dies_ok { $packet->sampling_mode(0)     } 'NetFlow::Packet->sampling_mode dies as setter method';
dies_ok { $packet->sys_uptime(0)        } 'NetFlow::Packet->sys_uptime dies as setter method';
dies_ok { $packet->unix_nsecs(0)        } 'NetFlow::Packet->unix_nsecs dies as setter method';
dies_ok { $packet->unix_secs(0)         } 'NetFlow::Packet->unix_secs dies as setter method';
dies_ok { $packet->version(0)           } 'NetFlow::Packet->version dies as setter method';

# Accessor methods live.
lives_ok { $packet->count()             } 'NetFlow::Packet->count accessor lives';
lives_ok { $packet->flow_sequence()     } 'NetFlow::Packet->flow_sequence accessor lives';
lives_ok { $packet->engine_id()         } 'NetFlow::Packet->engine_id accessor lives';
lives_ok { $packet->engine_type()       } 'NetFlow::Packet->engine_type accessor lives';
lives_ok { $packet->sampling_interval() } 'NetFlow::Packet->sampling_interval accessor lives';
lives_ok { $packet->sampling_mode()     } 'NetFlow::Packet->sampling_mode accessor lives';
lives_ok { $packet->sys_uptime()        } 'NetFlow::Packet->sys_uptime accessor lives';
lives_ok { $packet->unix_nsecs()        } 'NetFlow::Packet->unix_nsecs accessor lives';
lives_ok { $packet->unix_secs()         } 'NetFlow::Packet->unix_secs accessor lives';
lives_ok { $packet->version()           } 'NetFlow::Packet->version accessor lives';
lives_ok { $packet->flows()             } 'NetFlow::Packet->flows accessor lives';

# TODO: Accessor methods return correct value.
is ( $packet->count(),             1,          'NetFlow::Packet->count accessor returns correct value'             );
is ( $packet->flow_sequence(),     37,         'NetFlow::Packet->flow_sequence accessor returns correct value'     );
is ( $packet->engine_id(),         0,          'NetFlow::Packet->engine_id accessor returns correct value'         );
is ( $packet->engine_type(),       0,          'NetFlow::Packet->engine_type accessor returns correct value'       );
is ( $packet->sampling_interval(), 1 ,         'NetFlow::Packet->sampling_interval accessor returns correct value' );
is ( $packet->sampling_mode(),     2,          'NetFlow::Packet->sampling_mode accessor returns correct value'     );
is ( $packet->sys_uptime(),        1000,       'NetFlow::Packet->sys_uptime accessor returns correct value'        );
is ( $packet->unix_nsecs(),        1,          'NetFlow::Packet->unix_nsecs accessor returns correct value'        );
is ( $packet->unix_secs(),         1357183150, 'NetFlow::Packet->unix_secs accessor returns correct value'         );
is ( $packet->version(),           5,          'NetFlow::Packet->version accessor returns correct value'           );
# is ( $packet->flows()             );    # TODO

# TODO: read/write methods should live when using as setters (only flows method)
# TODO: constructor should die whith invalid input
#     version
#     count
#     sys_uptime
#     unix_secs
#     unix_nsecs
#     flow_sequence
#     engine_type
#     engine_id
#     sampling_mode
#     sampling_interval
#     flows
# TODO: constructor should live with valid input
# TODO: set number of tests

done_testing();

sub reset_data {
    my $flow_data = { bytes    => 5,
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
    my $flow = NetFlow::Flow->new($flow_data);
    my $flows = [ $flow ];
    my $data = { 'count'             => 1,
                 'engine_id'         => 0,
                 'engine_type'       => 0,
                 'flow_sequence'     => 37,
                 'flows'             => $flows,
                 'sampling_interval' => 1, # TODO: this should be 14 bits, according to the Cisco Netflow docs
                 'sampling_mode'     => 2,
                 'sys_uptime'        => 1000,
                 'unix_nsecs'        => 1,
                 'unix_secs'         => 1357183150,
                 'version'           => 5,
               };
    return $data;
}

