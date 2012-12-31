use strict;
use warnings;
use Test::More;
use Test::Exception;
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

# TODO: new_ok();
# TODO: read only methods should die when using as setters (all methods except flows)
# TODO: read/write methods should not die when using as setters (only flows method)
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

