package NetFlow::Parser;

use 5.010001;
use Moose;
use SPM::Util::Num qw(bin2dec bin2dottedquad);
use NetFlow::Data;
our $VERSION = '0.01';

use Moose::Util::TypeConstraints;

subtype 'NetflowVersion'
    => as 'Int'
    => where { $_ eq 5 }
    => message { "Only support Netflow version 5" };

subtype 'FlowCount'
    => as 'UnsignedInt'
    => where { $_ < 31 }
    => message { "Invalid flow count($_). Must be between 0 and 30" };

subtype 'BinaryString'
    => as 'Str',
    => where { $_ =~ /^[0-1]+$/ }
    => message { "($_) is not a string of 0's and 1's" };

subtype 'UnsignedInt6Bit'
    => as 'UnsignedInt',
    => where { $_ < 64 }
    => message { "Number ($_) is not less than 64" };

subtype 'UnsignedInt2Bit'
    => as 'UnsignedInt',
    => where { $_ < 4 }
    => message { "Number ($_) is not less than 4" };

no Moose::Util::TypeConstraints;

has 'raw_data'          => (isa => 'Any',              is => 'rw', required => 0); # Raw binary Netflow packet
has 'raw_flows'         => (isa => 'BinaryString',     is => 'rw', required => 0); # String of 0's and 1's representing Netflow flows (no header)
has 'version'           => (isa => 'NetflowVersion',   is => 'rw', required => 0); # Netflow version number (only support version 5)
has 'count'             => (isa => 'FlowCount',        is => 'rw', required => 0); # number of flows in the packet
has 'sys_uptime'        => (isa => 'UnsignedInt32Bit', is => 'rw', required => 0); # milliseconds since the export device booted
has 'unix_secs'         => (isa => 'UnsignedInt32Bit', is => 'rw', required => 0); # seconds since Unix epoch
has 'unix_nsecs'        => (isa => 'UnsignedInt32Bit', is => 'rw', required => 0); # residual nanoseconds since Unix epoch
has 'flow_sequence'     => (isa => 'UnsignedInt32Bit', is => 'rw', required => 0); # sequence counter of total flows seen
has 'engine_type'       => (isa => 'UnsignedInt8Bit',  is => 'rw', required => 0); # type of flow-switching engine
has 'engine_id'         => (isa => 'UnsignedInt8Bit',  is => 'rw', required => 0); # slot number of the flow-switching engine
has 'sampling_mode'     => (isa => 'UnsignedInt2Bit',  is => 'rw', required => 0); # two bit sampling mode
has 'sampling_interval' => (isa => 'UnsignedInt6Bit',  is => 'rw', required => 0); # TODO: this should be 14 bits, according to the Cisco Netflow docs
has 'debug'             => (isa => 'UnsignedInt', is => 'rw', required => 1, default => 0); # set to > 0 enable debug, set to 0 turn off debug

sub read_packet {
    my $self   = shift;
    my $packet = shift;
    $self->raw_data($packet);
    $self->_read_header();
}

# returns: List of NetFlow::Data objects.
sub parse {
    my $self = shift;
    if ($self->debug()) {
        warn "##### Start Parse #####";
    }

    my $offset = 0;
    my $flow;
    my $flow_string;
    my @flows;
    for (1..$self->count()) {
        $flow_string = substr($self->raw_flows(), $offset, 384); # 384 = number of bits in a flow record
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
        $flow = NetFlow::Data->new(
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
    return @flows;
}

# START
# TODO: according to Netflow docs
# the sample interval should be 14 bits
sub _read_header {
    my $self = shift;
    my ($version,       $count,             $sysuptime,   $unix_secs,
        $unix_nsecs,    $flow_sequence,     $engine_type, $engine_id,
        $sampling_mode, $sampling_interval, $flows) =
            unpack('n1n1N1N1N1N1B8B8B2B6B*', $self->raw_data()); # TODO - does this work on little and big endian?

    if ($self->debug()) {
        warn "##### Start Parse Header #####";
        warn "Version: $version";
        warn "Count: $count";
        warn "Sysuptime: $sysuptime";
        warn "Unix_Secs: $unix_secs";
        warn "Unix NSencs: $unix_nsecs";
        warn "Flow Seq: $flow_sequence";
        warn "Engine Type: $engine_type";
        warn "Engine ID: $engine_id";
        warn "Sampling Mode: $sampling_mode";
        warn "Sampleing Interval: $sampling_interval";
        warn "Raw Flow Data Length(bits): " . length($flows);
        warn "##### End Parse Header #####";
    }

    # Validate length of all flow records. Each flow
    # record should be 384 bits.
    if ( length $flows ne (384 * $count) ) {
        die "parse error: invalid flow record length";  # TODO: throw different exception 
    }

    $self->version($version);
    $self->count($count);
    $self->sys_uptime($sysuptime);
    $self->unix_secs($unix_secs);
    $self->unix_nsecs($unix_nsecs);
    $self->flow_sequence($flow_sequence);
    $self->engine_type(bin2dec($engine_type));
    $self->engine_id(bin2dec($engine_id));
    $self->sampling_mode(bin2dec($sampling_mode));
    $self->sampling_interval(bin2dec($sampling_interval));
    $self->raw_flows($flows);
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
Returns Netflow data as NetFlow::Data objects. This module
is meant to be used with NetFlow::Data.

=head1 METHODS

=head2 debug

Turn debug on or off. Set to 0 to turn off debug. Set to > 1 to
turn on debug. By default debug is off.

=head2 new

Returns a new NetFlow::Parser object.

TODO: document constructor arguements. Both optional and required.

=head2 parse

Parse binary Netflow data that has already been read with the
read_packet() method. Returns a list of NetFlow::Data objects.

=head2 read_packet

Read in a binary Netflow version 5 packet.

=head1 SEE ALSO

Read the documentation for the Perl modules
NetFlow::Data and Moose.

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

