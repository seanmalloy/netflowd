package SPM::Util::Num;

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

use 5.16.1;
use strict;
use warnings;
use SPM::Util qw( is_defined isnt_reference );
use SPM::X::BadValue;
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( bin2dec bin2dottedquad dec2bin);
our $VERSION   = '0.01';

# Convert a number from binary to decimal.
sub bin2dec {
    my $num = shift;
    is_defined($num);
    isnt_reference($num);
    
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
    is_defined($ipv4);
    isnt_reference($ipv4);

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
    is_defined($num);
    isnt_reference($num);

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

1;

__END__
=head1 NAME

SPM::Util::Num - Perl number utility

=head1 SYNOPSIS

  use SPM::Util::Num qw( bin2dec bin2dottedquad dec2bin );

=head1 DESCRIPTION

The SPM::Util::Num module contains functions to manipulate numbers.

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

