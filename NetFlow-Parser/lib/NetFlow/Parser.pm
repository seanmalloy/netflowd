package NetFlow::Parser;

use 5.010001;
use Moose;
use SPM::Util::Num qw(bin2dec bin2dottedquad);
use NetFlow::Packet;
use NetFlow::Flow;
our $VERSION = '0.01';

has 'debug' => (isa => 'Int', is => 'rw', required => 0); # Set to non-zero to enable debugging

# returns: NetFlow::Packet object.
sub parse {
    my $self   = shift;
    my $packet = shift;
    my %header = $self->_read_header($packet);
    if ($self->debug()) {
        warn "##### Start Parse #####";
    }

    my $offset = 0;
    my $flow;
    my $flow_string;
    my @flows;
    for (1..$header{count}) {
        $flow_string = substr($header{flow_data}, $offset, 384); # 384 = number of bits in a flow record
        if ($self->debug()) {
            warn "Length of Flow Record in Bits: " . length($flow_string);
        }
        my ($srcaddr, $dstaddr, $nexthop,  $input,    $output, $dpkts,     $doctets,
            $first,    $last,    $srcport,  $dstport,  $pad1,   $tcp_flags, $prot, $tos,
            $src_as,  $dst_as,  $src_mask, $dst_mask, $pad2) =
                unpack('A32A32A32A16A16A32A32A32A32A16A16A8A8A8A8A16A16A8A8A16', $flow_string);
        # Convert Data
        $srcaddr   = bin2dottedquad($srcaddr);
        $dstaddr   = bin2dottedquad($dstaddr);
        $nexthop   = bin2dottedquad($nexthop);
        $input     = bin2dec($input);
        $output    = bin2dec($output);
        $dpkts     = bin2dec($dpkts);
        $doctets   = bin2dec($doctets);
        $first     = bin2dec($first);
        $last      = bin2dec($last);
        $srcport   = bin2dec($srcport);
        $dstport   = bin2dec($dstport);
        $pad1      = bin2dec($pad1);
        $tcp_flags = bin2dec($tcp_flags);
        $prot      = bin2dec($prot);
        $tos       = bin2dec($tos);
        $src_as    = bin2dec($src_as);
        $dst_as    = bin2dec($dst_as);
        $src_mask  = bin2dec($src_mask);
        $dst_mask  = bin2dec($dst_mask);
        $pad2      = bin2dec($pad2);
        $flow = NetFlow::Flow->new(
            srcaddr  => $srcaddr,
            dstaddr  => $dstaddr,
            nexthop  => $nexthop,
            input    => $input,
            output   => $output,
            packets  => $dpkts,
            bytes    => $doctets,
            first    => $first,
            last     => $last,
            srcport  => $srcport,
            dstport  => $dstport,
            tcpflags => $tcp_flags,
            protocol => $prot,
            tos      => $tos,
            srcas    => $src_as,
            dstas    => $dst_as,
            srcmask  => $src_mask,
            dstmask  => $dst_mask,
        );
        push @flows, $flow;
        if ($self->debug()) {
            print "\n";
            warn "Source Addr: $srcaddr";
            warn "Dest Addr:   $dstaddr";
            warn "Next Hop:    $nexthop";
            warn "Input:       $input";
            warn "Output:      $output";
            warn "Dpkts:       $dpkts";
            warn "Octects:     $doctets";
            warn "First:       $first";
            warn "Last:        $last";
            warn "Source Port: $srcport";
            warn "Dest Port:   $dstport";
            warn "Pad1:        $pad1";
            warn "TCP Flags:   $tcp_flags";
            warn "Protocol:    $prot";
            warn "TOS:         $tos";
            warn "Source AS:   $src_as";
            warn "Dest AS:     $dst_as";
            warn "Source mask: $src_mask";
            warn "Dest mask:   $dst_mask";
            warn "Pad2:        $pad2";
            print "\n";
        }
        $offset += 384;
    }
    if ($self->debug()) {
        warn "##### End Parse #####";
    }
    return NetFlow::Packet->new(
        version           => $header{version},
        count             => $header{count},
        sys_uptime        => $header{sys_uptime},
        unix_secs         => $header{unix_secs},
        unix_nsecs        => $header{unix_nsecs},
        flow_sequence     => $header{flow_sequence},
        engine_type       => $header{engine_type},
        engine_id         => $header{engine_id},
        sampling_mode     => $header{sampling_mode},
        sampling_interval => $header{sampling_interval},
        flows             => [ @flows ],
    );
}

# START
# Note: According to Cisco Netflow docs the sample interval should be 14 bits. The
# OpenBSD if_pflow.h file sets sampling mode and sampling interval to 8 bit total. Need
# to read appropriate RFC fro find the "correct" length of the sampling interval field.
sub _read_header {
    my $self       = shift;
    my $raw_packet = shift;
    my ($version,       $count,             $sys_uptime,  $unix_secs,
        $unix_nsecs,    $flow_sequence,     $engine_type, $engine_id,
        $sampling_mode, $sampling_interval, $flow_data) =
            unpack('n1n1N1N1N1N1B8B8B2B6B*', $raw_packet); # TODO - does this work on little and big endian?

    if ($self->debug()) {
        warn "##### Start Parse Header #####";
        warn "Version: $version";
        warn "Count: $count";
        warn "Sysuptime: $sys_uptime";
        warn "Unix_Secs: $unix_secs";
        warn "Unix NSencs: $unix_nsecs";
        warn "Flow Seq: $flow_sequence";
        warn "Engine Type: $engine_type";
        warn "Engine ID: $engine_id";
        warn "Sampling Mode: $sampling_mode";
        warn "Sampleing Interval: $sampling_interval";
        warn "Raw Flow Data Length(bits): " . length($flow_data);
        warn "##### End Parse Header #####";
    }

    # Validate length of all flow records. Each flow
    # record should be 384 bits.
    if ( length $flow_data != (384 * $count) ) {
        die "parse error: invalid flow record length";  # TODO: throw different exception 
    }

    # Only support Netflow version 5
    if ($version != 5) {
        die "Unknown Netflow version: $version. only supports Netflow version 5"; # TODO: throw different exception
    }
    
    $engine_type       = bin2dec($engine_type);
    $engine_id         = bin2dec($engine_id);
    $sampling_mode     = bin2dec($sampling_mode);
    $sampling_interval = bin2dec($sampling_interval);
    my %header = ( version           => $version,
                   count             => $count,
                   sys_uptime        => $sys_uptime,
                   unix_secs         => $unix_secs,
                   unix_nsecs        => $unix_nsecs,
                   flow_sequence     => $flow_sequence,
                   engine_type       => $engine_type,
                   engine_id         => $engine_id,
                   sampling_mode     => $sampling_mode,
                   sampling_interval => $sampling_interval,
                   flow_data         => $flow_data,
                 );
    return %header;
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=head1 NAME

NetFlow::Parser - Perl extension for Parsing Netflow version 5 data

=head1 SYNOPSIS

    use NetFlow::Parser;
    my $nf_parser = NetFlow::Parser->new();
    $nf_parser->read_packet($packet);
    my @flows = $nf_parser->parse();

=head1 DESCRIPTION

Object oriented module for parsing Netflow version 5 data.
Returns Netflow data as NetFlow::Flow objects. This module
is meant to be used with NetFlow::Flow and NetFlow::Packet.

=head1 METHODS

=head2 debug

Turn debug on or off. Set to 0 to turn off debug. Set to > 1 to
turn on debug. By default debug is off.

=head2 new

Returns a new NetFlow::Parser object.

TODO: document constructor arguements. Both optional and required.

=head2 parse

Parse binary Netflow data that has already been read with the
read_packet() method. Returns a list of NetFlow::Flow objects.

=head2 read_packet

Read in a binary Netflow version 5 packet.

=head1 SEE ALSO

Read the documentation for the Perl modules
NetFlow::Flow, NetFlow::Packet, and Moose.

=head1 BUGS

No known bugs at this time.

=head1 AUTHOR

Sean Malloy, E<lt>spinelli85@gmail.com@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Sean Malloy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.

=cut

