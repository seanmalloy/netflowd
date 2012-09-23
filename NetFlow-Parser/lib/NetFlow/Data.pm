package NetFlow::Data;

#use 5.010001;
use Moose;

our $VERSION = '0.01';

# Only works with NetFlow V5.

use Moose::Util::TypeConstraints;

subtype 'Natural'
    => as 'Int'
    => where { $_ > 0 };

subtype 'PortNumber'
    => as 'Natural'
    => where { $_ < 65536 }
    => message { "This number ($_) is not less than 65536" };

no Moose::Util::TypeConstraints;

# Constructor
# input: none
#sub new {
#    my $class = shift;
#    my $self = {
#        srcaddr  => undef, # Source IP address
#        dstaddr  => undef, # Destination IP address
#        nexthop  => undef, # IP address of next hop router
#        input    => undef, # SNMP index of input interface
#        output   => undef, # SNMP index of output inferface
#        packets  => undef, # Number of packets in the flow
#        bytes    => undef, # Number of bytes in the flow
#        first    => undef, # Uptime at start of flow
#        last     => undef, # Uptime at end of flow
#        srcport  => undef, # source port
#        dstport  => undef, # destination port
#        tcpflags => undef, # Cumulative OR of TCP flags
#        protocol => undef, # IP protocol type (for example, TCP = 6; UDP = 17)
#        tos      => undef, # IP type of service (ToS)
#        srcas    => undef, # Autonomous system number of the source, either origin or peer
#        dstas    => undef, # Autonomous system number of the destination, either origin or peer
#    };
#    bless $self, $class;
#    return $self;
#}
#

has 'bytes'    => (isa => 'Int', is => 'ro', required => 1);
has 'dstaddr'  => (isa => 'Str', is => 'ro', required => 1);
has 'dstport'  => (isa => 'PortNumber', is => 'ro', required => 1);
has 'first'    => (isa => 'Int', is => 'ro', required => 1);
has 'last'     => (isa => 'Int', is => 'ro', required => 1);
has 'packets'  => (isa => 'Int', is => 'ro', required => 1);
has 'protocol' => (isa => 'Natural', is => 'ro', required => 1);
has 'srcaddr'  => (isa => 'Str', is => 'ro', required => 1);
has 'srcport'  => (isa => 'PortNumber', is => 'ro', required => 1);
has 'nexthop'  => (isa => 'Str', is => 'ro', required => 1);
has 'tcpflags' => (isa => 'Str', is => 'ro', required => 1);   # TODO: figure out data type
has 'tos'      => (isa => 'Str', is => 'ro', required => 1);   # TODO: figure out data type
has 'srcas'    => (isa => 'Str', is => 'ro', required => 1);   # TODO: figure out data type
has 'dstas'    => (isa => 'Str', is => 'ro', required => 1);   # TODO: figure out data type

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
