package NetFlow::Parser;

use 5.010001;
use strict;
use warnings;
use SPM::Util::Num qw(bin2dec);
use NetFlow::Data;
our $VERSION = '0.01';

# Only works with NetFlow V5.
# Example Usage:
#    ->new();
#    ->input($netflow_packet);
#    ->parse();

# Constructor
# input: none
sub new {
    my $class = shift;
    my $self  = { flows_remaining   => undef, # Number of flows that can still be parsed
                  raw_packet        => undef, # Raw NetFlow binary packet

                  # Fields from NetFlow v5 packet header.
                  version           => undef, # NetFlow export format version number
                  count             => undef, # Number of flows exported in this packet
                  sys_uptime        => undef, # Current time in milliseconds since the export device booted
                  unix_secs         => undef, # Current count of seconds since 0000 UTC 1970
                  unix_nsecs        => undef, # Residual nanoseconds since 0000 UTC 1970
                  flow_sequence     => undef, # Sequence counter of total flows seen
                  engine_type       => undef, # Type of flow-switching engine
                  engine_id         => undef, # Slot number of the flow-switching engine
                  sampling_mode     => undef, # Sampling Mode
                  sampling_interval => undef, # Sampling Interval
    };
    bless $self, $class;
    return $self;
}

# input: binary NetFlow packet(header and flow records).
sub input {
    my $self = shift;
    $self->{raw_packet} = shift;
    $self->_read_header();
}

# START: finish the parse method.
# returns: NetFlow::Data object. undef when there are no more
# flows to parse.
sub parse {
    my $self = shift;
    if ($self->{flows_remaining} == 0) {
        warn("no flows remaining");
        return undef;
    }
    warn("Flows: " . $self->{raw_packet});
    return;

    # TODO: Below code needs work.
    #my $offset = 0;    
    #for (1..$self->{count}) {
    #    #my $flow = substr($self->{raw_packet}, $offset, 96); # 96 = number of nybles in a flow record.
    #    my ($srcaddr, $dstaddr, $nexthop,  $input,    $output, $dpkts,     $doctets,
    #        $first,    $last,    $srcport,  $dstport,  $pad1,   $tcp_flags, $prot, $tos,
    #        $src_as,  $dst_as,  $src_mask, $dst_mask, $pad2) =
    #        unpack('A8A8A8A4A4A8A8A8A8A4A4A2A2A2A2A4A4A2A2A4', $flow);
    #    print "Source Addr: $srcaddr\n";
    #    print "Dest Addr: $dstaddr\n";
    #    print "Next Hop: $nexthop\n";
    #    print "Input: $input\n";
    #    print "Output: $output\n";
    #    print "Dpkts: $dpkts\n";
    #    print "Octects: $doctets\n";
    #    print "First: $first\n";
    #    print "Last: $last\n";
    #    print "Source Port: $srcport\n";
    #    print "Dest Port: $dstport\n";
    #    print "Pad1: $pad1\n";
    #    print "TCP Flags: $tcp_flags\n";
    #    print "Prot: $prot\n";
    #    print "TOS: $tos\n";
    #    print "Source AS: $src_as\n";
    #    print "Dest AS: $dst_as\n";
    #    print "Source mask: $src_mask\n";
    #    print "Dest mask: $dst_mask\n";
    #    print "Pad2: $pad2\n";
    #    print "\n";
    #    $offset += 96;
    #}
}

# input: none
# returns: number of flows that can still be parsed.
sub remaining {
    my $self = shift;
    return $self->{flows_remaining};
}

sub _read_header {
    # TODO: unpack, handle network byte order(big endian vs. little endian)
    my $self = shift;
    my ($version, $count, $sysuptime, $unix_secs, $unix_nsecs, $flow_sequence, $engine_type, $engine_id, $sampling_mode, $sampling_interval, $flows) =
        unpack('n1n1N1N1N1N1H2H2B2B14B*', $self->{raw_packet}); # TODO - does it work on little and big endian machines?
    $self->{version}           = $version;
    $self->{count}             = $count;
    $self->{sys_uptime}        = $sysuptime;
    $self->{unix_secs}         = $unix_secs;
    $self->{unix_nsecs}        = $unix_nsecs;
    $self->{flow_sequence}     = $flow_sequence;
    $self->{engine_type}       = hex $engine_type;
    $self->{engine_id}         = hex $engine_id;
    $self->{sampling_mode}     = bin2dec($sampling_mode);
    $self->{sampling_interval} = bin2dec($sampling_interval);
    $self->{raw_packet}        = $flows;
    $self->{flows_remaining}   = $self->{count};
}

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
