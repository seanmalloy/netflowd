package NetFlow::Data;

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
has 'dstaddr'  => (isa => 'IPAddress',        is => 'ro', required => 1); # destination IP address
has 'dstport'  => (isa => 'UnsignedInt16Bit', is => 'ro', required => 1); # destination TCP/UDP port
has 'first'    => (isa => 'UnsignedInt32Bit', is => 'ro', required => 1); # sysuptime in milliseconds at start of flow
has 'last'     => (isa => 'UnsignedInt32Bit', is => 'ro', required => 1); # sysuptime in milliseconds at end of flow
has 'packets'  => (isa => 'UnsignedInt32Bit', is => 'ro', required => 1); # total number of packets in the flow
has 'protocol' => (isa => 'UnsignedInt8Bit',  is => 'ro', required => 1); # IP protocol type
has 'srcaddr'  => (isa => 'IPAddress',        is => 'ro', required => 1); # source IP address
has 'srcport'  => (isa => 'UnsignedInt16Bit', is => 'ro', required => 1); # source TCP/UDP port
has 'nexthop'  => (isa => 'IPAddress',        is => 'ro', required => 1); # IP address of next hop router
has 'tcpflags' => (isa => 'UnsignedInt8Bit',  is => 'ro', required => 1); # Cumulative OR of tcp flags
has 'tos'      => (isa => 'UnsignedInt8Bit',  is => 'ro', required => 1); # IP type of service
has 'srcas'    => (isa => 'UnsignedInt16Bit', is => 'ro', required => 1); # AS number of source
has 'dstas'    => (isa => 'UnsignedInt16Bit', is => 'ro', required => 1); # AS number of destination

__PACKAGE__->meta->make_immutable;

1;

__END__
=head1 NAME

NetFlow::Data - Perl extension for Netflow version 5 flow data

=head1 SYNOPSIS

  use NetFlow::Data;

  # create object
  my $flow = NetFlow::Data->new(
               srcaddr  => $srcaddr,
               dstaddr  => $dstaddr,
               nexthop  => $nexthop,
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
             );
  # print total bytes in flow
  print $flow->bytes(), "\n";

=head1 DESCRIPTION

Object oriented module for storing and accessing Netflow version
5 data. Only provides a constructor and accessor methods. This module
is meant to be used with NetFlow::Parser.

=head1 METHODS

=head2 bytes

Returns the total number of bytes contained.

head2 dstaddr

Returns the destination IP addresss.

=head2 dstas

TODO: blah

=head2 dstport

Returns the destionation TCP/UDP port number.

=head2 first

TODO: blah

=head2 last

TODO: blah

=head2 new

TODO: constructor

=head2 nexthop

Returns the IP address of the next hop router.

=head2 packets

Returns the total number of packets.

=head2 protocol

TODO: blah

=head2 srcaddr

Returns the source IP addresss.

=head2 srcas

TODO: blah

=head2 srcport

Returns the source TCP/UDP port number.

=head2 tcpflags

TODO: blah

=head2 tos

TODO: blah

=head1 SEE ALSO

NetFlow::Parser
Moose

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
