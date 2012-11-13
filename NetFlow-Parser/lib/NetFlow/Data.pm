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

NetFlow::Data - Perl extension for blah blah blah

=head1 SYNOPSIS

  use NetFlow::Data;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for NetFlow::Data, created by h2xs. It looks like the
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
