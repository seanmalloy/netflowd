package NetFlow::Flow;

#use 5.010001;
use Moose;

our $VERSION = '0.01';

# Only works with NetFlow V5.

use Moose::Util::TypeConstraints;

subtype 'UnsignedInt'
    => as 'Int'
    => where { $_ > -1 }
    => message { "Number ($_) is not greater than -1" };

subtype 'UnsignedInt32Bit'
    => as 'UnsignedInt'
    => where { $_ < 4294967296 }
    => message { "Number ($_) is not less than 4294967296" };

subtype 'UnsignedInt16Bit'
    => as 'UnsignedInt'
    => where { $_ < 65536 }
    => message { "Number ($_) is not less than 65536" };

subtype 'UnsignedInt8Bit'
    => as 'UnsignedInt'
    => where { $_ < 256 }
    => message { "Number ($_) is not less than 256" };

subtype 'UnsignedInt4Bit'
    => as 'UnsignedInt'
    => where { $_ < 16 }
    => message { "Number ($_) is not less than 16" };

subtype 'IPAddress'
    => as 'Str'
    => where { $_ =~ /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/ }
    => message { "String ($_) is not a valid IP address" };

no Moose::Util::TypeConstraints;

has 'bytes'    => (isa => 'UnsignedInt32Bit', is => 'ro', required => 1); # total number of layer 3 bytes in the flow
has 'dstas'    => (isa => 'UnsignedInt16Bit', is => 'ro', required => 1); # AS number of destination
has 'dstaddr'  => (isa => 'IPAddress',        is => 'ro', required => 1); # destination IP address
has 'dstmask'  => (isa => 'UnsignedInt8Bit',  is => 'ro', required => 1); # destination address prefix mask bits
has 'dstport'  => (isa => 'UnsignedInt16Bit', is => 'ro', required => 1); # destination TCP/UDP port
has 'first'    => (isa => 'UnsignedInt32Bit', is => 'ro', required => 1); # sysuptime in milliseconds at start of flow
has 'input'    => (isa => 'UnsignedInt16Bit', is => 'ro', required => 1); # SNMP index of input interface
has 'last'     => (isa => 'UnsignedInt32Bit', is => 'ro', required => 1); # sysuptime in milliseconds at end of flow
has 'output'   => (isa => 'UnsignedInt16Bit', is => 'ro', required => 1); # SNMP index of output interface
has 'packets'  => (isa => 'UnsignedInt32Bit', is => 'ro', required => 1); # total number of packets in the flow
has 'protocol' => (isa => 'UnsignedInt8Bit',  is => 'ro', required => 1); # IP protocol type
has 'srcaddr'  => (isa => 'IPAddress',        is => 'ro', required => 1); # source IP address
has 'srcmask'  => (isa => 'UnsignedInt8Bit',  is => 'ro', required => 1); # source address prefix mask bits
has 'srcport'  => (isa => 'UnsignedInt16Bit', is => 'ro', required => 1); # source TCP/UDP port
has 'nexthop'  => (isa => 'IPAddress',        is => 'ro', required => 1); # IP address of next hop router
has 'tcpflags' => (isa => 'UnsignedInt8Bit',  is => 'ro', required => 1); # Cumulative OR of tcp flags
has 'tos'      => (isa => 'UnsignedInt8Bit',  is => 'ro', required => 1); # IP type of service
has 'srcas'    => (isa => 'UnsignedInt16Bit', is => 'ro', required => 1); # AS number of source

__PACKAGE__->meta->make_immutable;

1;

__END__
=head1 NAME

NetFlow::Flow - Perl extension for Netflow version 5 flow data

=head1 SYNOPSIS

  use NetFlow::Flow;

  # create object
  my $flow = NetFlow::Flow->new(
               bytes    => $doctets,
               dstaddr  => $dstaddr,
               dstas    => $dst_as,
               dstmask  => $dst_mask,
               dstport  => $dstport,
               first    => $first,
               input    => $input,
               last     => $last,
               nexthop  => $nexthop,
               output   => $output,
               packets  => $dpkts,
               protocol => $prot,
               srcaddr  => $srcaddr,
               srcas    => $src_as,
               srcmask  => $src_mask,
               srcport  => $srcport,
               tcpflags => $tcp_flags,
               tos      => $tos,
             );

  # access data from object
  print $flow->bytes(), "\n";
  print $flow->dstaddr(), "\n";
  print $flow->dstas(), "\n";
  print $flow->dstmask(), "\n";
  print $flow->dstport(), "\n";
  print $flow->first(), "\n";
  print $flow->input(), "\n";
  print $flow->last(), "\n";
  print $flow->nexthop(), "\n";
  print $flow->output(), "\n";
  print $flow->packets(), "\n";
  print $flow->protocol(), "\n";
  print $flow->srcaddr(), "\n";
  print $flow->srcas(), "\n";
  print $flow->srcmask(), "\n";
  print $flow->srcport(), "\n";
  print $flow->tcpflags(), "\n";
  print $flow->tos(), "\n";

=head1 DESCRIPTION

Object oriented module for storing and accessing Netflow version
5 flow data. Only provides a constructor and accessor methods. This
module is meant to be used with NetFlow::Packet and NetFlow::Parser.

=head1 METHODS

=head2 bytes

Returns the total number of bytes in the flow.

=head2 dstaddr

Returns the destination IPv4 addresss in dotted quad notation.

=head2 dstas

Returns the autonomous system number of the destination.

=head2 dstmask

Returns the destination address prefix mask bits. For example
returns 24 for 192.168.1.0/24.

=head2 dstport

Returns the destination TCP/UDP port number.

=head2 first

Returns the system up time in milliseconds at the start of the flow.

=head2 input

Returns the SNMP index of the input interface.

=head2 last

Returns the system up time in milliseconds when the last packet of the flow was received.

=head2 new

Returns a new NetFlow::Flow object. The parameters bytes, dstaddr, dstas, dstmask, dstport,
first, input, last, nexthop, output, packets, protocol, tcpflags, tos, srcaddr, srcas, srcmask,
and srcport are all required.

=head2 nexthop

Returns the IPv4 address of the next hop router in dotted quad notation.

=head2 output

Returns the SNMP index of the output interface.

=head2 packets

Returns the total number of packets in the flow.

=head2 protocol

Returns the IP protocol type. For example returns 6 for TCP and 17 for UDP.

=head2 srcaddr

Returns the source IPv4 addresss in dotted quad notation.

=head2 srcas

Returns the autonomous system number of the source.

=head2 srcmask

Returns the source address prefix mask bits. For example
returns 24 for 192.168.1.0/24.

=head2 srcport

Returns the source TCP/UDP port number.

=head2 tcpflags

Returns the cumulative OR of the TCP flags.

=head2 tos

Returns the IP type of service.

=head1 SEE ALSO

Read the documentation for Perl modules
NetFlow::Packet and NetFlow::Parser.

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
