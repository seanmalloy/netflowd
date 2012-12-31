package NetFlow::Packet;

#use 5.010001;
use Moose;

our $VERSION = '0.01';

# Only works with NetFlow V5.

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

# TODO: should flows be ro OR rw?
# TODO: should there be methods to add/remove flows?

has 'count'             => (isa => 'FlowCount',               is => 'ro', required => 1); # number of flows in the packet
has 'engine_id'         => (isa => 'UnsignedInt8Bit',         is => 'ro', required => 1); # slot number of the flow-switching engine
has 'engine_type'       => (isa => 'UnsignedInt8Bit',         is => 'ro', required => 1); # type of flow-switching engine
has 'flow_sequence'     => (isa => 'UnsignedInt32Bit',        is => 'ro', required => 1); # sequence counter of total flows seen
has 'flows'             => (isa => 'ArrayRef[NetFlow::Flow]', is => 'rw', required => 0); # ArrayRef of NetFlow::Flows
has 'sampling_interval' => (isa => 'UnsignedInt6Bit',         is => 'ro', required => 1); # TODO: this should be 14 bits, according to the Cisco Netflow docs
has 'sampling_mode'     => (isa => 'UnsignedInt2Bit',         is => 'ro', required => 1); # two bit sampling mode
has 'sys_uptime'        => (isa => 'UnsignedInt32Bit',        is => 'ro', required => 1); # milliseconds since the export device booted
has 'unix_nsecs'        => (isa => 'UnsignedInt32Bit',        is => 'ro', required => 1); # residual nanoseconds since Unix epoch
has 'unix_secs'         => (isa => 'UnsignedInt32Bit',        is => 'ro', required => 1); # seconds since Unix epoch
has 'version'           => (isa => 'NetflowVersion',          is => 'ro', required => 1); # Netflow version number (only support version 5)

__PACKAGE__->meta->make_immutable;

1;

__END__
=head1 NAME

NetFlow::Packet - Perl extension for a Netflow version 5 packet

=head1 SYNOPSIS

  use NetFlow::Packet;

  # create object
  my $packet = NetFlow::Packet->new(
               version           => $version,
               count             => $count,
               sys_uptime        => $sys_uptime,
               unix_secs         => $unix_secs,
               unix_nsecs        => $unix_nsecs,
               flow_sequence     => $flow_sequence,
               engine_type       => $engine_type,
               engine_id         => $engine_id,
               sampling_mode     => $sampling_mode,
               sampling_interval => $sampling_interval,
               flows             => [],
             );
  # print version from Netflow header
  print $packet->version(), "\n";

=head1 DESCRIPTION

Object oriented module for storing and accessing Netflow version
5 flow packets. Only provides a constructor and accessor methods. This
module is meant to be used with NetFlow::Flow and NetFlow::Parser.

=head1 METHODS
version

=head2 count

TODO

=head2 engine_id

TODO

=head2 engine_type

TODO

=head2 flows

TODO

=head2 flow_sequence

TODO

=head2 new

Returns a new NetFlow::Packet object. The parameters bytes, dstaddr, dstas, dstmask, dstport,
first, input, last, nexthop, output, packets, protocol, tcpflags, tos, srcaddr, srcas, srcmask,
and srcport are all required.

=head2 sampling_interval

TODO

=head2 sampling_mode

TODO

=head2 sys_uptime

TODO

=head2 unix_nsecs

TODO

=head2 unix_secs

TODO

=head2 version

TOOD

=head1 SEE ALSO

Read the documentation for the Perl modules
NetFlow::Flow, NetFlow::Parser, and Moose.

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
