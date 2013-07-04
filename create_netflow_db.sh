#!/bin/bash

# Create Netflow SQLite database.

MY_DB_FILE="$1"
if [ -z "$MY_DB_FILE" ]; then
    MY_DB_FILE="netflow.db"
fi

sqlite3 $MY_DB_FILE << EOF

-- Table for Netflow headers
CREATE TABLE IF NOT EXISTS headers (
    header_id          INTEGER  NOT NULL  PRIMARY KEY, -- Surrogate key
    version            INTEGER  NOT NULL,              -- Netflow version number
    count              INTEGER  NOT NULL,              -- Flows associated with header
    system_uptime      INTEGER  NOT NULL,              -- Milliseconds since the flow export device booted
    unix_seconds       INTEGER  NOT NULL,              -- Seconds since 0000 UTC 1970
    unix_nano_seconds  INTEGER  NOT NULL,              -- Residual nanoseconds since 0000 UTC 1970
    flow_sequence      INTEGER  NOT NULL,              -- Sequence counter of total flows seen
    engine_type        INTEGER  NOT NULL,              -- Type of flow-switching engine
    engine_id          INTEGER  NOT NULL,              -- Slot number of the flow-switching engine
    sampling_mode      INTEGER  NOT NULL,              -- Sampling mode
    sampling_interval  INTEGER  NOT NULL               -- Sampling interval
);

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
    end_system_uptime         INTEGER  NOT NULL,                    -- System uptime at the time the last packet of the flow was received
    source_port               INTEGER  NOT NULL,                    -- TCP/UDP source port number
    destination_port          INTEGER  NOT NULL,                    -- TCP/UDP destination port number
    tcp_flags                 INTEGER  NOT NULL,                    -- Cumulative OR of TCP flags
    ip_protocol               INTEGER  NOT NULL,                    -- IP protocol type (for example, TCP = 6; UDP = 17)
    type_of_service           INTEGER  NOT NULL,                    -- IP type of service (ToS)
    source_system_number      INTEGER  NOT NULL,                    -- Autonomous system number of the source, either origin or peer
    destination_system_number INTEGER  NOT NULL,                    -- Autonomous system number of the destination, either origin or peer
    source_mask               INTEGER  NOT NULL,                    -- Source address prefix mask bits
    destination_mask          INTEGER  NOT NULL,                    -- Destination address prefix mask bits
    header_id                 INTEGER  NOT NULL  REFERENCES headers -- Setup one to many relationship between flows and headers
);

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
FROM headers;
EOF

