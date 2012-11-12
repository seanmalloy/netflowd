package SPM::Util::Num;

use 5.010001;
use strict;
use warnings;
use SPM::Exception;
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
        SPM::Exception::OutOfRange->throw;
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
        SPM::Exception::OutOfRange->throw;
    }

    if (length($ipv4) != 32) {
        SPM::Exception::OutOfRange->throw;
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
        SPM::Exception::OutOfRange->throw;
    }
    return(sprintf("%b", $num));
}

sub _check_reference {
    my $parameter = shift;
    if (ref($parameter) ne '') {
        SPM::Exception::InvalidInputReference->throw;
    }
    return $parameter;
}

sub _check_undef {
    my $parameter = shift;
    if (!defined $parameter) {
        SPM::Exception::InvalidInputUndef->throw;
    }
    return $parameter;
}

1;
__END__
# TODO: document the fact that input with leading zeroes must be a string, not a number.

=head1 NAME

SPM::Util::Num - Perl number utility

=head1 SYNOPSIS

  use SPM::Util::Num qw( bic2dec );

=head1 DESCRIPTION

The SPM::Util::Num modules contains various function to manipulate number.

=head2 EXPORT

Nothing is exported by default from this module. All functions need to
be explicitly requested.

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

=head1 AUTHOR

Sean Malloy, E<lt>spinelli85@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Sean Malloy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
