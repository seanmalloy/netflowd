package SPM::Util::Num;

use 5.010001;
use strict;
use warnings;
use SPM::X::BadValue;
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( bin2dec bin2dottedquad dec2bin);
our $VERSION   = '0.01';

# Convert a number from binary to decimal.
sub bin2dec {
    my $num = shift;
    _check_undef($num);
    _check_reference($num);
    
    # Only binary number are valid input.
    if ($num !~ /^[0-1]+$/) {
        SPM::X::BadValue->throw({
            ident   => 'bad binary number',
            tags    => [ qw(number) ],
            public  => 1,
            message => "invalid number %{given_value}s for %{given_for}s",
            given_value => $num,
            given_for   => 'binary to decimal conversion',
        });
    }
    
    # Strip leading zeroes.
    $num =~ s/^0+([0-1].?)/$1/;

    return unpack("N", pack("B32", substr("0" x 32 . $num, -32)));
}

# Convert a 32 bit IPv4 address to dotted quad notation.
sub bin2dottedquad {
    my $ipv4 = shift;
    _check_undef($ipv4);
    _check_reference($ipv4);

    # Only binary number are valid input.
    if ($ipv4 !~ /^[0-1]+$/) {
        SPM::X::BadValue->throw({
            ident   => 'bad binary number',
            tags    => [ qw(number) ],
            public  => 1,
            message => "invalid number %{given_value}s for %{given_for}s",
            given_value => $ipv4,
            given_for   => 'binary to ip address conversion',
        });
    }

    if (length($ipv4) != 32) {
        SPM::X::BadValue->throw({
            ident   => 'bad binary number',
            tags    => [ qw(number) ],
            public  => 1,
            message => "binary number %{given_value}s for %{given_for}s is not 32 bits",
            given_value => $ipv4,
            given_for   => 'binary to ip address conversion',
        });

    }
    my ($part1, $part2, $part3, $part4) = unpack "A8A8A8A8", $ipv4;
    return(bin2dec($part1) . '.' . bin2dec($part2) . '.' . bin2dec($part3) .
        '.' . bin2dec($part4));
}

# Convert a number from decimal to binary.
sub dec2bin {
    my $num = shift;
    _check_undef($num);
    _check_reference($num);

    # Only numbers are valid input.
    if ($num !~ /^\d+$/) {
        SPM::X::BadValue->throw({
            ident   => 'bad number',
            tags    => [ qw(number) ],
            public  => 1,
            message => "invalid number %{given_value}s for %{given_for}s",
            given_value => $num,
            given_for   => 'decimal to binary conversion',
        });

    }
    return(sprintf("%b", $num));
}

sub _check_reference {
    my $parameter = shift;
    if (ref($parameter) ne '') {
        SPM::X::BadValue->throw({
            ident   => 'bad parameter',
            tags    => [ qw(reference) ],
            public  => 1,
            message => "invalid parameter %{given_value}s for %{given_for}s",
            given_value => ref($parameter) . ' reference',
            given_for   => 'reference test',
        });

    }
    return $parameter;
}

sub _check_undef {
    my $parameter = shift;
    if (!defined $parameter) {
        SPM::X::BadValue->throw({
            ident   => 'bad parameter',
            tags    => [ qw(undef) ],
            public  => 1,
            message => "invalid parameter %{given_value}s for %{given_for}s",
            given_value => 'undef',
            given_for   => 'undef test',
        });
    }
    return $parameter;
}

1;

__END__
=head1 NAME

SPM::Util::Num - Perl number utility

=head1 SYNOPSIS

  use SPM::Util::Num qw( bin2dec bin2dottedquad dec2bin );

=head1 DESCRIPTION

The SPM::Util::Num modules contains functions to manipulate numbers.

=head2 EXPORT

Nothing is exported by default from this module. All functions need to
be explicitly requested.

=head1 FUNCTIONS

=head2 bin2dec

Convert a binary number to decimal.

=head2 bin2dottedquad

Convert a 32-bit binary number to IPv4 dotted quad notation(i.e. 192.168.1.1).

=head2 dec2bin

Convert a decimal number to binary

=head1 SEE ALSO

None.

=head1 BUGS

The parameter to the bin2dec and bin2dottedquad functions
must be a string if it has leading zeroes.

=head1 AUTHOR

Sean Malloy, E<lt>spinelli85@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Sean Malloy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.

=cut

