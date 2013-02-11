package SPM::X::BadValue;
use Moose;
 
with qw(Throwable::X);
 
use Throwable::X -all; # to get the Payload helper

our $VERSION = 0.01;
 
sub x_tags { qw(value) }
 
# What bad value were we given?
has given_value => (
  is => 'ro',
  required => 1,
  traits   => [ Payload ],
);
 
# What was the value supposed to be used for?
has given_for => (
  is  => 'ro',
  isa => 'Str',
  traits => [ Payload ],
);

__PACKAGE__->meta->make_immutable;
1;

__END__
=head1 NAME

SPM::X::BadValue - Perl extension for thowing a BadValue Exception

=head1 SYNOPSIS

  use SPM::X::BadValue;

  SPM::X::BadValue->throw({
    ident   => 'bad filename',
    tags    => [ qw(value) ],
    public  => 1,
    message => "invalid value %{given_value}s for %{given_for}s",
    given_value => $filename,
    given_for   => 'filename',
  });

=head1 DESCRIPTION

Thow a BadValue exception.

=head1 METHODS

=head2 throw

Throws an exception.

=head2 x_tags

List of tags this modules has.

=head1 SEE ALSO

Read the documentation for Perl module Throwable::X.

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

