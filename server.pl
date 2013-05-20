#!/usr/bin/env perl

use strict;
use warnings;
use English qw( -no_match_vars );

use IO::Socket;
use NetFlow::Parser;
use Getopt::Long;
use SPM::Daemon qw( init_server_user log_die log_notice );
use DBI;

# Signal Handlers
$SIG{'INT'}  = 'exit_handler';
$SIG{'TERM'} = 'exit_handler';

# TODO: parse config file

my ($Port);
if (!defined $Port) {
    $Port = 1234;
}

my $Pid_File = '/var/run/server.pid';

init_server_user($Pid_File, 'sean', 'sean');

#my $Database_File = "/home/sean/projects/Perl-NetFlow-Collector/netflow.db";
my $Database_File = "/home/sean/projects/Perl-NetFlow-Collector/netflow2.db";
create_database($Database_File);
my $Database_Handle = DBI->connect("dbi:SQLite:dbname=$Database_File", "", "", { AutoCommit => 1, RaiseError => 1 } );
#create_db($Database_File);
my $Exit = 0;

my ($Maximum_Length, $data);
# Maximum packet size for Netflow v5.
# 24 + (30 * 48) = 1464 bytes
# Header: 24 bytes
# Each Flow: 48 bytes (can be 1 to 30 flows per packet)
my $parser = NetFlow::Parser->new();
$Maximum_Length = 1464;
my $Packet;

my $Header_Statement_Handle = $Database_Handle->prepare("INSERT INTO headers(version, count, system_uptime, unix_seconds, unix_nano_seconds, flow_sequence, engine_type, engine_id, sampling_mode, sampling_interval) VALUES (?,?,?,?,?,?,?,?,?,?)");
my $Flow_Statement_Handle   = $Database_Handle->prepare("INSERT INTO flows(source_ip_address, destination_ip_address, next_hop_ip_address, snmp_input_index, snmp_output_index, packets, bytes, start_system_uptime, end_system_uptime, source_port, destination_port, tcp_flags, ip_protocol, type_of_service, source_system_number, destination_system_number, source_mask, destination_mask, header_id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

my $Header_Primary_Key;
my $Sock;
MAIN:
while (!$Exit) {
    if (!defined $Sock) {
        $Sock = new IO::Socket::INET( LocalPort => $Port, Proto => 'udp' )
            or die "socket: $EVAL_ERROR";
        log_notice("listening on port $Port", "\n");
    }

    
    if (!$Sock->recv($data, $Maximum_Length)) {
        $Sock->close();
        undef $Sock;
        log_warn("UDP packet receive error: $OS_ERROR", "\n");
        next MAIN;
    }

    my ($port, $ip) = sockaddr_in($Sock->peername);
    my $client = gethostbyaddr($ip, AF_INET);
    $Packet = $parser->parse($data);
    log_notice("inserting into headers table", "\n");
    $Header_Statement_Handle->execute( $Packet->version(), $Packet->count(), $Packet->sys_uptime(), $Packet->unix_secs(), $Packet->unix_nsecs(), $Packet->flow_sequence(), $Packet->engine_type(), $Packet->engine_id, $Packet->sampling_mode, $Packet->sampling_interval() );
    $Header_Primary_Key = $Database_Handle->last_insert_id("", "", "", "");
    for my $flow (@{$Packet->flows()}) {
        log_notice("inserting into flows table", "\n");
        $Flow_Statement_Handle->execute( $flow->srcaddr(), $flow->dstaddr(), $flow->nexthop(), $flow->input(), $flow->output(), $flow->packets(), $flow->bytes(), $flow->first(), $flow->last(), $flow->srcport(), $flow->dstport(), $flow->tcpflags(), $flow->protocol(), $flow->tos(), $flow->srcas(), $flow->dstas(), $flow->srcmask(), $flow->dstmask(), $Header_Primary_Key );
    }
}
clean_up();
exit 0;

sub clean_up {
    log_notice("disconnecting from database $Database_File", "\n");
    $Database_Handle->disconnect;
}

# START
# TODO: create database if it does not exist
sub create_database {
    my $database_file = shift;
    # TODO: deal with undef db file
    if (-f $database_file) {
        return;
        # TODO: check for valid db(can we connect?)
    }

    # create database tables
    my $database_handle = DBI->connect("dbi:SQLite:dbname=$database_file", "", "", { AutoCommit => 1, RaiseError => 1 } );

    my $create_headers_table = "CREATE TABLE IF NOT EXISTS headers ( header_id INTEGER NOT NULL PRIMARY KEY, version INTEGER NOT NULL, count INTEGER NOT NULL, system_uptime INTEGER NOT NULL, unix_seconds INTEGER NOT NULL, unix_nano_seconds INTEGER NOT NULL, flow_sequence INTEGER NOT NULL, engine_type INTEGER NOT NULL, engine_id INTEGER NOT NULL, sampling_mode INTEGER NOT NULL, sampling_interval INTEGER  NOT NULL )";
    $database_handle->do($create_headers_table);

    my $create_flows_table = "CREATE TABLE IF NOT EXISTS flows ( flow_id INTEGER NOT NULL PRIMARY KEY, source_ip_address TEXT NOT NULL, destination_ip_address TEXT NOT NULL, next_hop_ip_address TEXT NOT NULL, snmp_input_index INTEGER NOT NULL, snmp_output_index INTEGER NOT NULL, packets INTEGER NOT NULL, bytes INTEGER NOT NULL, start_system_uptime INTEGER NOT NULL, end_system_uptime INTEGER NOT NULL, source_port INTEGER NOT NULL, destination_port INTEGER NOT NULL, tcp_flags INTEGER  NOT NULL, ip_protocol INTEGER NOT NULL, type_of_service INTEGER NOT NULL, source_system_number INTEGER NOT NULL, destination_system_number INTEGER NOT NULL, source_mask INTEGER NOT NULL, destination_mask INTEGER NOT NULL, header_id INTEGER NOT NULL REFERENCES headers)";
    $database_handle->do($create_flows_table);

    # create database views
    my $create_local_time_view = "CREATE VIEW IF NOT EXISTS headers_localtime AS SELECT header_id, version, count, system_uptime, datetime(unix_seconds, 'unixepoch', 'localtime'), unix_nano_seconds, flow_sequence, engine_type, engine_id, sampling_mode, sampling_interval FROM headers"; 
    $database_handle->do($create_local_time_view);

    $database_handle->disconnect;
    return;
}

sub exit_handler {
    $Exit = 1;
}

