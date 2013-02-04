#!/usr/bin/env perl

use strict;
use warnings;
use English qw( -no_match_vars );

use IO::Socket;
use NetFlow::Parser;
use Getopt::Long;
use Sys::Syslog;
use DBI;

$SIG{'INT'} = 'INT_handler';
my ($Port_Number);

if (!defined $Port_Number) {
    $Port_Number = 1234;
}

my $Database_File   = "netflow.db";
my $Database_Handle = DBI->connect("dbi:SQLite:dbname=$Database_File", "", "", { AutoCommit => 1, RaiseError => 1 } );

my $sock = new IO::Socket::INET( LocalPort => $Port_Number, Proto => 'udp' )
    or die "socket: $EVAL_ERROR";
print "Waiting for UDP Packets on port $Port_Number\n";

my ($MAXLEN, $data);
# Maximum packet size for Netflow v5.
# 24 + (30 * 48) = 1464 bytes
# Header: 24 bytes
# Each Flow: 48 bytes (can be 1 to 30 flows per packet)
my $parser = NetFlow::Parser->new();
$MAXLEN = 1464;
my $Packet;

my $Header_Statement_Handle = $Database_Handle->prepare("INSERT INTO headers(version, count, system_uptime, unix_seconds, unix_nano_seconds, flow_sequence, engine_type, engine_id, sampling_mode, sampling_interval) VALUES (?,?,?,?,?,?,?,?,?,?)");
my $Flow_Statement_Handle   = $Database_Handle->prepare("INSERT INTO flows(source_ip_address, destination_ip_address, next_hop_ip_address, snmp_input_index, snmp_output_index, packets, bytes, start_system_uptime, end_system_uptime, source_port, destination_port, tcp_flags, ip_protocol, type_of_service, source_system_number, destination_system_number, source_mask, destination_mask, header_id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

my $Header_Primary_Key;
while ($sock->recv($data, $MAXLEN)) {
    my ($port, $ip) = sockaddr_in($sock->peername);
    my $client = gethostbyaddr($ip, AF_INET);
    $Packet = $parser->parse($data);
    print "Inserting into headers table\n";
    $Header_Statement_Handle->execute( $Packet->version(), $Packet->count(), $Packet->sys_uptime(), $Packet->unix_secs(), $Packet->unix_nsecs(), $Packet->flow_sequence(), $Packet->engine_type(), $Packet->engine_id, $Packet->sampling_mode, $Packet->sampling_interval() );
    $Header_Primary_Key = $Database_Handle->last_insert_id("", "", "", "");
    for my $flow (@{$Packet->flows()}) {
        print "Inserting into flows table\n";
        $Flow_Statement_Handle->execute( $flow->srcaddr(), $flow->dstaddr(), $flow->nexthop(), $flow->input(), $flow->output(), $flow->packets(), $flow->bytes(), $flow->first(), $flow->last(), $flow->srcport(), $flow->dstport(), $flow->tcpflags(), $flow->protocol(), $flow->tos(), $flow->srcas(), $flow->dstas(), $flow->srcmask(), $flow->dstmask(), $Header_Primary_Key );
    }
}
die "recv: $OS_ERROR";

sub INT_handler {
    $Database_Handle->disconnect;
    print "Exiting\n";
    exit 0;
}

