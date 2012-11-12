package NetFlow::Parser;

use 5.010001;
use Moose;
use SPM::Util::Num qw(bin2dec bin2dottedquad);
use NetFlow::Data;
our $VERSION = '0.01';

# Only works with NetFlow V5.
# Example Usage of Public Interface:
#    ->new();
#    ->read_packet($netflow_packet);
#    ->parse();

# Example Usage:
#
# my $nf_parser = NetFlow::Parser->new();
# $nf_parser->read_packet($packet);
# my @flows = $nf_parser->parse();


has 'raw_data'          => (isa => 'Any', is => 'rw', required => 0); # TODO: default value?, isa?, this is the entire raw packet
has 'raw_flows'         => (isa => 'Any', is => 'rw', required => 0); # TODO: isa?, this is the string version of all flows
has 'version'           => (isa => 'Int', is => 'rw', required => 0); # TODO: isa?
has 'count'             => (isa => 'Int', is => 'rw', required => 0); # TODO: isa?
has 'sys_uptime'        => (isa => 'Any', is => 'rw', required => 0); # TODO: isa? milliseconds since device was booted
has 'unix_secs'         => (isa => 'Any', is => 'rw', required => 0); # TODO: isa?
has 'unix_nsecs'        => (isa => 'Any', is => 'rw', required => 0); # TODO: isa?
has 'flow_sequence'     => (isa => 'Any', is => 'rw', required => 0); # TODO: isa?
has 'engine_type'       => (isa => 'Any', is => 'rw', required => 0); # TODO: isa?
has 'engine_id'         => (isa => 'Any', is => 'rw', required => 0); # TODO: isa?
has 'sampling_mode'     => (isa => 'Any', is => 'rw', required => 0); # TODO: isa?
has 'sampling_interval' => (isa => 'Any', is => 'rw', required => 0); # TODO: isa?

#sub new {
#    my $class = shift;
#    my $self  = { raw_data          => undef, # Raw NetFlow binary packet
#
#                  # Fields from NetFlow v5 packet header.
#                  version           => undef, # NetFlow export format version number
#                  count             => undef, # Number of flows exported in this packet
#                  sys_uptime        => undef, # Current time in milliseconds since the export device booted
#                  unix_secs         => undef, # Current count of seconds since 0000 UTC 1970
#                  unix_nsecs        => undef, # Residual nanoseconds since 0000 UTC 1970
#                  flow_sequence     => undef, # Sequence counter of total flows seen
#                  engine_type       => undef, # Type of flow-switching engine
#                  engine_id         => undef, # Slot number of the flow-switching engine
#                  sampling_mode     => undef, # Sampling Mode
#                  sampling_interval => undef, # Sampling Interval
#    };
#    bless $self, $class;
#    return $self;
#}

sub read_packet {
    my $self   = shift;
    my $packet = shift;
    $self->raw_data($packet);
    $self->_read_header();
}

# START: finish the parse method.
# returns: List of NetFlow::Data objects.
sub parse {
    #warn "################### START parse";
    my $self = shift;

    # TODO: where should this code go?
    # validate length of all flows. each flow record is 384 bits.
    if ( length($self->raw_flows()) ne (384 * $self->count()) ) {
        die "parse: invalid flow record length";
    }

    my $offset = 0;
    my $flow;
    my $flow_string;
    my @flows;
    for (1..$self->count()) {
        $flow_string = substr($self->raw_flows(), $offset, 384); # 384 = number of bits in a flow record
        warn "Length of Flow Data: " . length($flow_string);
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
        $pad2 = bin2dec($pad2);
        $flow = NetFlow::Data->new(
            srcaddr  => $srcaddr,
            dstaddr  => $dstaddr,
            nexthop  => $nexthop,
            #$input,
            #$output,
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
            #$src_mask,
            #$dst_mask,
        );
        push @flows, $flow;
        #print "\n";
        #warn "Source Addr: $srcaddr";
        #warn "Dest Addr:   $dstaddr";
        #warn "Next Hop:    $nexthop";
        #warn "Input:       $input";
        #warn "Output:      $output";
        #warn "Dpkts:       $dpkts";
        #warn "Octects:     $doctets";
        #warn "First:       $first";
        #warn "Last:        $last";
        #warn "Source Port: $srcport";
        #warn "Dest Port:   $dstport";
        #warn "Pad1:        $pad1";
        #warn "TCP Flags:   $tcp_flags";
        #warn "Protocol:    $prot";
        #warn "TOS:         $tos";
        #warn "Source AS:   $src_as";
        #warn "Dest AS:     $dst_as";
        #warn "Source mask: $src_mask";
        #warn "Dest mask:   $dst_mask";
        #warn "Pad2:        $pad2";
        #print "\n";
        $offset += 384;
    }
    #warn "############################### end parse";
    return @flows;
}

sub _read_header {
    # TODO: unpack, handle network byte order(big endian vs. little endian)
    my $self = shift;
    my ($version,       $count,             $sysuptime,   $unix_secs,
        $unix_nsecs,    $flow_sequence,     $engine_type, $engine_id,
        $sampling_mode, $sampling_interval, $flows) =
    #unpack('n1n1N1N1N1N1H2H2B2B14B*', $self->{raw_packet}); # TODO - does it work on little and big endian machines?
            unpack('n1n1N1N1N1N1H2H2B2B6B*', $self->raw_data()); # TODO - why does this work

    #warn "Version: $version";
    #warn "Count: $count";
    #warn "Sysuptime: $sysuptime";
    #warn "Unix_Secs: $unix_secs";
    #warn "Unix NSencs: $unix_nsecs";
    #warn "Flow Seq: $flow_sequence";
    #warn "Engine Type: $engine_type";
    #warn "Engine ID: $engine_id";
    #warn "Sampling Mode: $sampling_mode";
    #warn "Sampleing Interval: $sampling_interval";
    #warn "Raw Flow Data Length(bits): " . length($flows);

    $self->version($version);
    $self->count($count);
    $self->sys_uptime($sysuptime);
    $self->unix_secs($unix_secs);
    $self->unix_nsecs($unix_nsecs);
    $self->flow_sequence($flow_sequence);
    $self->engine_type(hex $engine_type);
    $self->engine_id(hex $engine_id);
    $self->sampling_mode(bin2dec($sampling_mode));
    $self->sampling_interval(bin2dec($sampling_interval));
    $self->raw_flows($flows);
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=head1 NAME

NetFlow::Parser - Perl extension for blah blah blah

=head1 SYNOPSIS

  use NetFlow::Parser;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for NetFlow::Parser, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Sean Malloy, E<lt>sean@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Sean Malloy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
