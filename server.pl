#!/usr/bin/env perl

use strict;
use warnings;
use English qw( -no_match_vars );

use IO::Socket;
use NetFlow::Parser;
use Getopt::Long;
use SPM::Daemon qw( init_server_user log_die log_notice log_warn );
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
my $Database_File   = "/home/sean/projects/Perl-NetFlow-Collector/netflow2.db";
my $Database_Handle = create_database($Database_File);
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

# TODO: document this function
# Returns: DBI database handle
sub create_database {
    my $database_file = shift;
    if (!defined $database_file) {
        log_die("Cannot connect to undefined database");
    }

    if (-f $database_file) {
        my $database_handle = DBI->connect("dbi:SQLite:dbname=$database_file", "", "", { AutoCommit => 1, RaiseError => 1 } );
        if (!defined $database_handle) {
            log_die("Cannot connect to database $database_file: $DBI::errstr");
        }

        # Exit if headers table does not exist.
        if ( scalar(grep { $_ eq 'headers' } $database_handle->tables(undef, undef, 'headers', 'TABLE')) != 1) {
            log_die("Missing table 'headers' in database $database_file");
        }

        # Exit if flows table does not exist.
        if (scalar(grep { $_ eq 'flows' } $database_handle->tables(undef, undef, 'flows' , 'TABLE')) != 1) {
            log_die("Missing table 'flows' in database $database_file");
        }

        # Exit if view does not exist.
        if (scalar(grep { $_ eq 'headers_localtime' } $database_handle->tables(undef, undef, 'headers_localtime' , 'VIEW')) != 1) {
            log_die("Missing view 'fheaders_localtime' in database $database_file");
        }

        return $database_handle;
    }

    # Create Database Tables
    my $database_handle = DBI->connect("dbi:SQLite:dbname=$database_file", "", "", { AutoCommit => 1, RaiseError => 1 } );

    my $create_headers_table_sql = <<'END_SQL';
    -- Table for Netflow headers
    CREATE TABLE IF NOT EXISTS headers (
        header_id          INTEGER NOT NULL  PRIMARY KEY, -- Surrogate key
        version            INTEGER NOT NULL,              -- Netflow version number
        count              INTEGER NOT NULL,              -- Flows associated with header
        system_uptime      INTEGER NOT NULL,              -- Milliseconds since the flow export device booted
        unix_seconds       INTEGER NOT NULL,              -- Seconds since 0000 UTC 1970
        unix_nano_seconds  INTEGER NOT NULL,              -- Residual nanoseconds since 0000 UTC 1970
        flow_sequence      INTEGER NOT NULL,              -- Sequence counter of total flows seen
        engine_type        INTEGER NOT NULL,              -- Type of flow-switching engine
        engine_id          INTEGER NOT NULL,              -- Slot number of the flow-switching engine
        sampling_mode      INTEGER NOT NULL,              -- Sampling mode
        sampling_interval  INTEGER NOT NULL               -- Sampling interval
    )
END_SQL
    $database_handle->do($create_headers_table_sql);

    my $create_flows_table_sql = <<'END_SQL';
    -- Table for Netfow flows
    CREATE TABLE IF NOT EXISTS flows (
        flow_id                   INTEGER  NOT NULL  PRIMARY KEY,       -- Surrogate key
        source_ip_address         TEXT     NOT NULL,                    -- Source IP address
        destination_ip_address    TEXT     NOT NULL,                    -- Destination IP address
        next_hop_ip_address       TEXT     NOT NULL,                    -- IP address of next hop router
        snmp_input_index          INTEGER  NOT NULL,                    -- SNMP index of input interface
        snmp_output_index         INTEGER  NOT NULL,                    -- SNMP index of output interface
        packets                   INTEGER  NOT NULL,                    -- Packets in the flow
        bytes                     INTEGER  NOT NULL,                    -- Total number of Layer 3 bytes in the packets of the flow
        start_system_uptime       INTEGER  NOT NULL,                    -- System uptime at start of flow
        end_system_uptime         INTEGER  NOT NULL,                    -- System uptime at the time the last packet of the flow was receive
        source_port               INTEGER  NOT NULL,                    -- TCP/UDP source port number
        destination_port          INTEGER  NOT NULL,                    -- TCP/UDP destination port number
        tcp_flags                 INTEGER  NOT NULL,                    -- Cumulative OR of TCP flags
        ip_protocol               INTEGER  NOT NULL,                    -- IP protocol type (for example, TCP = 6; UDP = 17)
        type_of_service           INTEGER  NOT NULL,                    -- IP type of service (ToS)
        source_system_number      INTEGER  NOT NULL,                    -- Autonomous system number of the source, either origin or peer
        destination_system_number INTEGER  NOT NULL,                    -- Autonomous system number of the destination, either origin or pee
        source_mask               INTEGER  NOT NULL,                    -- Source address prefix mask bits
        destination_mask          INTEGER  NOT NULL,                    -- Destination address prefix mask bits
        header_id                 INTEGER  NOT NULL  REFERENCES headers -- Setup one to many relationship between flows and headers
    )
END_SQL
    $database_handle->do($create_flows_table_sql);

    # Create Database Views
    my $create_local_time_view_sql = <<'END_SQL';
    -- View for local time zone
    CREATE VIEW IF NOT EXISTS headers_localtime AS
    SELECT header_id,
           version,
           count,
           system_uptime,
           datetime(unix_seconds, 'unixepoch', 'localtime'),
           unix_nano_seconds,
           flow_sequence,
           engine_type,
           engine_id,
           sampling_mode,
           sampling_interval
    FROM headers
END_SQL
    $database_handle->do($create_local_time_view_sql);
    return $database_handle;
}

sub exit_handler {
    $Exit = 1;
}

