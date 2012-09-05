# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl NetFlow-Parser.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;
BEGIN { use_ok('NetFlow::Data') };
BEGIN { require_ok('NetFlow::Data') };

can_ok('NetFlow::Data', qw(new srcaddr dstaddr nexthop packets bytes first last srcport dstport tcp_flags protocol tos src_as dst_as ));
new_ok('NetFlow::Data');

#my $data = NetFlow::Data->new();

#srcaddr   => undef, # Source IP address
#dstaddr   => undef, # Destination IP address
#nexthop   => undef, # IP address of next hop router
#packets   => undef, # Number of packets in the flow
#bytes     => undef, # Number of bytes in the flow
#first     => undef, # Uptime at start of flow
#last      => undef, # Uptime at end of flow
#srcport   => undef, # source port
#dstport   => undef, # destination port
#tcp_flags => undef, # Cumulative OR of TCP flags
#protocol  => undef, # IP protocol type (for example, TCP = 6; UDP = 17)
#tos       => undef, # IP type of service (ToS)
#src_as    => undef, # Autonomous system number of the source, either origin or peer
#dst_as    => undef, # Autonomous system number of the destination, either origin or peer

done_testing();

