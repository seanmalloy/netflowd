package SPM::Util;

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
use English qw( -no_match_vars );
use SPM::X::BadValue;
require Exporter;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw( is_defined is_reference isnt_defined isnt_reference );
our $VERSION   = '0.01';

#############################################
# Usage      : is_defined(scalar)
# Purpose    : Test if a scalar is defined
# Returns    : True if scalar is defined
# Parameters : Scalar variable
# Throws     : SPM::X::BadValue if scalar input is undef
# Comments   : none
# See Also   : perldoc -f defined, perldoc -f undef
sub is_defined {
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
    return 1;
}

#############################################
# Usage      : is_reference(scalar)
# Purpose    : Checks if a scalar is a reference
# Returns    : true if scalar input is a reference
# Parameters : Scalar variable
# Throws     : SPM::X::BadValue if input is not a reference
# Comments   : none
# See Also   : perldoc -f ref
sub is_reference {
    my $parameter = shift;
    if (ref($parameter) eq '') {
        SPM::X::BadValue->throw({
            ident   => 'bad parameter',
            tags    => [ qw(reference) ],
            public  => 1,
            message => "invalid parameter %{given_value}s for %{given_for}s",
            given_value => ref($parameter) . ' reference',
            given_for   => 'reference test',
        });

    }
    return 1;
}

#############################################
# Usage      : isnt_defined(scalar)
# Purpose    : Tests if a scalar is undef
# Returns    : True if scalar is undef
# Parameters : Scalar variable
# Throws     : SPM::X::BadValue if scalar input is defined
# Comments   : none
# See Also   : perldoc -f defined, perldoc -f undef, SPM::Util::is_defined
sub isnt_defined {
    my $parameter = shift;
    if (! defined $parameter) {
        return 1;
    }
    SPM::X::BadValue->throw({
        ident   => 'bad parameter', 
        tags    => [ qw(defined) ], 
        public  => 1, 
        message => "invalid parameter %{given_value}s for %{given_for}s", 
        given_value => $parameter, 
        given_for   => 'isnt_defined()', 
    });
}

#############################################
# Usage      : isnt_reference(scalar)
# Purpose    : Checks if a scalar is not a reference
# Returns    : true if scalar input is not a reference
# Parameters : Scalar variable
# Throws     : SPM::X::BadValue if input is a reference
# Comments   : none
# See Also   : perldoc -f ref
sub isnt_reference {
    my $parameter = shift;
    if (ref($parameter) eq '') {
        return 1;
    }
    SPM::X::BadValue->throw({
        ident   => 'bad parameter',
        tags    => [ qw(reference) ],
        public  => 1,
        message => "invalid parameter %{given_value}s for %{given_for}s",
        given_value => $parameter,
        given_for   => 'isnt_reference()',
    });
}

1;

__END__
=head1 NAME

SPM::Util - Perl generic utility fucntions

=head1 SYNOPSIS

  use SPM::Util qw( is_defined is_reference isnt_defined isnt_reference );

=head1 DESCRIPTION

The SPM::Util module provides utility functions written by Sean Malloy

=head2 EXPORT

Nothing is exported by default from this module. All functions need to
be explicitly requested.

=head1 FUNCTIONS

=head2 is_defined(I<SCALAR>)

Takes a I<SCALAR> input. Returns true if I<SCALAR> is defined.
Throws SPM::X::BadValue if I<SCALAR> is undef.

=head2 is_reference(I<SCALAR>)

Takes a I<SCALAR> input. Returns true if I<SCALAR> is a
reference. Throws SPM::X::BadValue if I<SCALAR> is not
a reference.

=head2 isnt_defined(I<SCALAR>)

Takes a I<SCALAR> input. Returns true if I<SCALAR> is undef.
Throws SPM::X::BadValue if I<SCALAR> is defined.

=head2 isnt_reference(I<SCALAR>)

Takes a I<SCALAR> input. Returns true if I<SCALAR> is not
a reference. Throws SPM::X::BadValue if I<SCALAR> is a reference.

=head1 SEE ALSO

  perldoc -f undef
  perldoc -f ref

=head1 BUGS

No known bugs at this time.

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

