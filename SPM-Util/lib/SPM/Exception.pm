package SPM::Exception;

use 5.010001;
use strict;
use warnings;
use Exception::Class::Base;

our @ISA = qw(Exception::Class::Base);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

our $VERSION = '0.01';

# Methods to subclass.
#
# isa
# fields
# alias
# description 
# throw
# caught
# error
# trace->as_string
# euid
# egid
# uid
# gid
# pid
# time
# rethrow
# new

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

SPM::Exception - Perl extension for blah blah blah

=head1 SYNOPSIS

  use SPM::Util::Num;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for SPM::Util, created by h2xs. It looks like the
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
