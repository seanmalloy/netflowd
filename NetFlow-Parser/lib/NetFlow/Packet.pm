package NetFlow::Packet;

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

use 5.016_001;
use Moose;
use NetFlow::Flow;

our $VERSION = '0.01';

# Only works with Netflow V5.

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

# Note: According to Cisco Netflow docs the sample interval should be 14 bits. The
# OpenBSD if_pflow.h file sets sampling mode and sampling interval to 8 bit total. Need
# to read appropriate RFC to find the "correct" length of the sampling interval field.

has 'count'             => (isa => 'FlowCount',               is => 'ro', required => 1); # number of flows in the packet
has 'engine_id'         => (isa => 'UnsignedInt8Bit',         is => 'ro', required => 1); # slot number of the flow-switching engine
has 'engine_type'       => (isa => 'UnsignedInt8Bit',         is => 'ro', required => 1); # type of flow-switching engine
has 'flow_sequence'     => (isa => 'UnsignedInt32Bit',        is => 'ro', required => 1); # sequence counter of total flows seen
has 'flows'             => (isa => 'ArrayRef[NetFlow::Flow]', is => 'ro', required => 1); # ArrayRef of NetFlow::Flows
has 'sampling_interval' => (isa => 'UnsignedInt6Bit',         is => 'ro', required => 1); # six bit sampling interval
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
               count             => $count,
               engine_id         => $engine_id,
               engine_type       => $engine_type,
               flows             => [ NetFlow::Flow->new() ],
               flow_sequence     => $flow_sequence,
               sampling_interval => $sampling_interval,
               sampling_mode     => $sampling_mode,
               sys_uptime        => $sys_uptime,
               unix_secs         => $unix_secs,
               unix_nsecs        => $unix_nsecs,
               version           => $version,
             );

  # access packet header data
  print $packet->count(), "\n";
  print $packet->engine_id(), "\n";
  print $packet->engine_type(), "\n";
  print $packet->flow_sequence(), "\n";
  print $packet->sampling_interval(), "\n";
  print $packet->sampling_mode(), "\n";
  print $packet->sys_uptime(), "\n";
  print $packet->unix_secs(), "\n";
  print $packet->unix_nsecs(), "\n";
  print $packet->version(), "\n";

  # access flow data (see NetFlow::Flow)
  for my $flow (@{$packet->flows()}) {
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
  }

=head1 DESCRIPTION

Object oriented module for storing and accessing Netflow version
5 flow packets. Only provides a constructor and accessor methods. This
module is meant to be used with NetFlow::Flow and NetFlow::Parser.

=head1 METHODS
version

=head2 count

Returns the number fo flows in the packet.

=head2 engine_id

Returns the slot number of the flow switching engine.

=head2 engine_type

Returns the type of flow switching engine.

=head2 flows

Returns an array reference of NetFlow::Flow objects.

=head2 flow_sequence

Returns the sequcne counter of total flows seen.

=head2 new

Returns a new NetFlow::Packet object. The parameters count, engine_id, engine_type, flows,
flow_sequence, sampling_interval, sampling_mode, sys_uptime, unix_nsecs, unix_secs, and 
version are all required.

=head2 sampling_interval

Returns the sampling interval.

=head2 sampling_mode

Returns the sampling mode.

=head2 sys_uptime

Returns the number of milliseconds since the export device booted.

=head2 unix_nsecs

Returns the residual nanoseconds since the Unix epoch.

=head2 unix_secs

Returns in the numbers of seconds since the Unix epoch.

=head2 version

Returns the Netflow version number.

=head1 SEE ALSO

Read the documentation for Perl modules
NetFlow::Flow and NetFlow::Parser.

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
