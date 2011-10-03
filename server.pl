#!/usr/bin/env perl

use strict;
use warnings;

use IO::Socket;
use English;
use NetFlow::Parser;
use Sys::Syslog;

my $port_number = 1234;
my $sock = new IO::Socket::INET( LocalPort => $port_number, Proto => 'udp' )
    or die "socket: $EVAL_ERROR";
print "Waiting for UDP Packets on port $port_number\n";

my ($MAXLEN, $data);
# Maximum packet size for Netflow v5.
# 24 + (30 * 48) = 1464 bytes
# Header: 24 bytes
# Each Flow: 48 bytes (can be 1 to 30 flows per packet)
my $parser = NetFlow::Parser->new();
$MAXLEN = 1464;
while ($sock->recv($data, $MAXLEN)) {
    my ($port, $ip) = sockaddr_in($sock->peername);
    my $client = gethostbyaddr($ip, AF_INET);
    $parser->input($data);
    $parser->parse();
}
die "recv: $OS_ERROR";
