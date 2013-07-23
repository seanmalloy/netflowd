package App::Netflowd::Database;

# Copyright (c) 2013 Sean Malloy. All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#    - Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    - Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# ABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

use 5.16.1;
use strict;
use warnings;
use SPM::Util qw( is_defined isnt_reference );
use SPM::X::BadValue;
use SPM::Syslog qw( log_info );
require Exporter;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw( connect_netflowd_database create_netflowd_database verify_netflowd_database );
our $VERSION   = '0.01';

#############################################
# Usage      : connect_netflowd_database('/path/to/db/file.db')
# Purpose    : Creates SQLite database for netflowd(if necessary),
#              verifies correctness of database, and connects to it
# Returns    : DBI database handle
# Parameters : Path to database file
# Throws     : Various exceptions
# Comments   : none
# See Also   : DBI, DBD::SQLite
sub connect_netflowd_database {
    my $database_file = shift;
    is_defined($database_file);
    isnt_reference($database_file);

    if (! -f $database_file) {
        _create_netflowd_database($database_file);  # TODO: check for failure
    } else {
        log_info("connecting to existing database $database_file", "\n");
    }
    verify_netflowd_database($database_file);  # TODO: check for failure
    my $database_handle = DBI->connect("dbi:SQLite:dbname=$database_file", "", "", { AutoCommit => 1, RaiseError => 1 } );

    # TODO: should be exception
    if (!defined $database_handle) {
        log_die("cannot connect to database $database_file: $DBI::errstr");
    }
    return $database_handle;
}

#############################################
# Usage      : create_netflowd_database('/path/to/db/file.db')
# Purpose    : creates SQLite database for netflowd
# Returns    : True if successful
# Parameters : Path to database file
# Throws     : Various exceptions
# Comments   : Does nothing if database file already exists
# See Also   : DBI, DBD::SQLite
sub create_netflowd_database {
    my $database_file = shift;
    is_defined($database_file);
    isnt_reference($database_file);

    if (! -e $database_file) {
        log_info("Creating new database $database_file", "\n");
        # Create database
        my $database_handle = DBI->connect("dbi:SQLite:dbname=$database_file", "", "", { AutoCommit => 1, RaiseError => 1 } );

        # TODO: should be exception
        if (!defined $database_handle) {
            #log_die("cannot connect to database $database_file: $DBI::errstr");
            return;
        }

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
        $database_handle->disconnect;
    }

    # Database file already exists. Do nothing.
    return 1;
}

#############################################
# Usage      : verify_netflowd_database('/path/to/db/file.db')
# Purpose    : verify correctness of Netflowd SQLite database
# Returns    : True if successful. Undef or empty list on failute (TODO: update when code uses exceptions)
# Parameters : Path to database file
# Throws     : Various exceptions
# Comments   : none
# See Also   : DBI, DBD::SQLite
sub verify_netflowd_database {
    my $database_file = shift;
    my $return_value  = 1;
    is_defined($database_file);
    isnt_reference($database_file);

    if (! -f $database_file) {
        # TODO: should be excpetion
        return;
    } else {
        my $database_handle = DBI->connect("dbi:SQLite:dbname=$database_file", "", "", { AutoCommit => 1, RaiseError => 1 } );

        # TODO: should be excpetion
        if (!defined $database_handle) {
            #log_die("cannot connect to database $database_file: $DBI::errstr");
            return;
        }

        # TODO: should be excpetion
        # Check for headers table
        if (scalar($database_handle->tables(undef, undef, 'headers', 'TABLE')) != 1) {
            $return_value = 0;
        }

        # TODO: should be excpetion
        # Check for flows table
        if (scalar($database_handle->tables(undef, undef, 'flows' , 'TABLE')) != 1) {
            $return_value = 0;
        }

        # TODO: should be excpetion
        # Check for headers_localtime view
        if (scalar($database_handle->tables(undef, undef, 'headers_localtime' , 'VIEW')) != 1) {
            $return_value = 0;
        }

        # TODO: check version information
        # TODO: check column type in each table and view
        $database_handle->disconnect;
    }
    
    if ($return_value == 0) {
        return;
    }
    return 1;
}

1;

__END__
=head1 NAME

App::Netflowd::Database - Perl extension for working with Netflowd databases

=head1 SYNOPSIS

    use App::Netflowd::Database qw( connect_netflowd_database create_netflowd_database verify_netflowd_database );
    my $db_file = '/path/to/db/file.db';
    create_netflowd_database($db_file);
    verify_netflowd_database($db_file;

    # OR
    
    connect_netflowd_database($db_file);

=head1 DESCRIPTION

Contains helper functions for connecting to, creating, and verifying a netflowd database.

=head1 FUNCTIONS

=head2 connect_netflowd_database(I<FILE>)

Create SQLite netflowd database I<FILE> if it does not
already exist. Verifies connrectness of netflowd database
I<FILE>. Returns a DBD connection to the database.

=head2 create_netflowd_database(I<FILE>)

Creates SQLite netflowd database I<FILE>. Does nothing
if I<FILE> already exists.

=head2 verify_netflowd_database(I<FILE>)

Verify correctness of tables, views, and data in a netflowd SQLite
database.

=head1 SEE ALSO

  netflowd
  DBI
  DBD::SQLite

=head1 BUGS

No known bugs at this time.

=head1 AUTHOR

Sean Malloy, E<lt>spinelli85@gmail.com@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2013 Sean Malloy. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

   - Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   - Redistributions in binary form must reproduce the above
     copyright notice, this list of conditions and the following
     disclaimer in the documentation and/or other materials provided
     with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
ABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

=cut

