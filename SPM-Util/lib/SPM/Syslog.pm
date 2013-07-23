package SPM::Syslog;

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
use File::Basename;
use Sys::Syslog qw(:standard :macros);
use Carp 'croak',  'cluck';   # TODO: should expections be used instead?
require Exporter;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw( close_syslog init_syslog log_debug log_die log_error log_info log_warn );
our $VERSION   = '0.01';

sub close_syslog {
    log_info("Closing syslog connection", "\n");
    closelog();
}

sub init_syslog {
    my $log_mask = shift;

    my $basename = basename($PROGRAM_NAME);
    openlog($basename, 'ndelay,pid', LOG_LOCAL0);

    if (!defined $log_mask) {
        $log_mask = 'info';
    }
    
    if ($log_mask eq 'debug') {
        setlogmask(LOG_UPTO(LOG_DEBUG));
    } elsif ($log_mask eq 'info') {
        setlogmask(LOG_UPTO(LOG_INFO));
    } elsif ($log_mask eq 'warning') {
        setlogmask(LOG_UPTO(LOG_WARNING));
    } elsif ($log_mask eq 'err') {
        setlogmask(LOG_UPTO(LOG_ERR));
    } elsif ($log_mask eq 'crit') {
        setlogmask(LOG_UPTO(LOG_CRIT));
    } else {
        # Unknown log mask, bail out
        closelog();
        croak "Invalid log mask $log_mask"
    }
    
    $SIG{__WARN__} = 'log_warn';    # send warn() messages to syslog
    $SIG{__DIE__}  = 'log_die';     # send die() messages to syslog
}

sub log_debug  { syslog(LOG_DEBUG,   _msg(@_));         }
sub log_die    { syslog(LOG_CRIT,    _msg(@_)); close_syslog(); die @_; }
sub log_error  { syslog(LOG_ERR,     _msg(@_));         }
sub log_info   { syslog(LOG_INFO,    _msg(@_));         }
sub log_warn   { syslog(LOG_WARNING, _msg(@_));         }

sub _msg {
    my $msg = join('', @_) || "Something's wrong ";
    my ($pack, $filename, $line) = caller(1);
    $msg .= "$filename line $line\n" unless $msg =~ /\n$/;
    return $msg;
}

1;

__END__
=head1 NAME

SPM::Syslog - Perl Syslog Functions

=head1 SYNOPSIS

  use SPM::Syslog qw( close_syslog init_syslog log_debug log_die log_error log_info log_warn );

  init_syslog();
  log_debug("debug message for syslog", "\n");
  
  log_die("critical message for syslog, "\n");

  close_syslog();

=head1 DESCRIPTION

The SPM::Syslog module contains wrapper functions for the Sys::Syslog module.

=head2 EXPORT

Nothing is exported by default from this module. All functions need to
be explicitly requested.

=head1 FUNCTIONS

=head2 close_syslog()

Wrapper for Sys::Syslog::closelog(). Logs an info
message to syslog before closing the syslog connection.

=head2 init_syslog(I<MASK>)

Wrapper for Sys::Syslog::openlog(). Sets facility to LOG_LOCAL0.
Sets options to "ndelay,pid". Sets ident to the programs name. Sets
signal handlers $SIG{__WARN__} and $SIG{__DIE__} to log_warn() and log_die()
respectively. Only messages up to log mask I<MASK> will be logged. Possible
values for I<MASK> are 'debug', 'info', 'warning', 'err', and 'crit'. Default
I<MASK> is 'info' if I<MASK> parameter is not passed.

=head2 log_debug

Log a debug message to syslog.

=head2 log_die

Log a critical message to syslog and die.

=head2 log_error

Log an error message to syslog.

=head2 log_info

Log an info message to syslog.

=head2 log_warn

Log a warning message to syslog.

=head1 SEE ALSO

Sys::Syslog

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

