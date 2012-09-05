package NetFlow::Data;

use 5.010001;
use strict;
use warnings;
our $VERSION = '0.01';

# Only works with NetFlow V5.

# Constructor
# input: none
sub new {
    my $class = shift;
    my $self = {
        srcaddr   => undef, # Source IP address
        dstaddr   => undef, # Destination IP address
        nexthop   => undef, # IP address of next hop router
        input     => undef, # SNMP index of input interface
        output    => undef, # SNMP index of output inferface
        packets   => undef, # Number of packets in the flow
        bytes     => undef, # Number of bytes in the flow
        first     => undef, # Uptime at start of flow
        last      => undef, # Uptime at end of flow
        srcport   => undef, # source port
        dstport   => undef, # destination port
        pad1      => undef, # filler
        tcp_flags => undef, # Cumulative OR of TCP flags
        protocol  => undef, # IP protocol type (for example, TCP = 6; UDP = 17)
        tos       => undef, # IP type of service (ToS)
        src_as    => undef, # Autonomous system number of the source, either origin or peer
        dst_as    => undef, # Autonomous system number of the destination, either origin or peer
        src_mask  => undef, # Source address prefix mask bits
        dst_mask  => undef, # Destination address prefix mask bits
        pad2      => undef, # filler
    };
    bless $self, $class;
    return $self;
}


sub srcaddr {
    
}

sub dstaddr {

}

sub nexthop {

}

sub packets {
    
}

sub bytes {

}

sub first {

}

sub last {

}

sub srcport {

}

sub dstport {
    
}

sub tcp_flags {
    
}

sub protocol {

}

sub tos {
    
}

sub src_as {

}

sub dst_as {

}

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
