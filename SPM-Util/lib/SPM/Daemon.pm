package SPM::Daemon;

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

use POSIX qw(setsid WNOHANG);
use Carp 'croak', 'cluck';   # TODO: should expections be used instead?
use File::Basename;
use IO::File;
use SPM::Syslog qw( close_syslog init_syslog log_info );
require Exporter;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw( init_server_root init_server_user );
our $VERSION   = '0.01';

use constant PIDPATH  => '/var/run';
use constant FACILITY => 'local0';
my ($Pid, $Pidfile);

sub _become_daemon {
    die "Can't fork" unless defined (my $child = fork);
    exit 0 if $child;  # parent dies
    setsid();          # become session leader
    open(STDIN,  '<', '/dev/null');
    open(STDOUT, '>', '/dev/null');
    open(STDERR, ">&STDOUT");
    chdir '/';      # change working directory
    umask(0);       # forget file mode creation mask
    $ENV{PATH}  = '/bin:/sbin:/usr/bin:/usr/sbin';
    $SIG{CHLD}  = '_reap_child';
    return $PROCESS_ID;
}

sub _change_privilages {
    my $user  = shift;
    my $group = shift;
    my $uid   = getpwnam($user) or die "Can't get uid for $user\n";
    my $gid   = getgrnam($group) or die "Can't get gid for $group\n";
    $EFFECTIVE_GROUP_ID = "$gid $gid";
    $REAL_GROUP_ID      = $gid;
    $EFFECTIVE_USER_ID  = $uid;    # change the effective UID (but the the real UID)
}

sub _getpidfilename {
    my $basename = basename($PROGRAM_NAME, '.pl');
    return PIDPATH . "/$basename.pid";
}

sub _open_pid_file {
    my $file = shift;
    if (-e $file) {     # oops. pid file already exists
        my $fh = IO::File->new($file) || return;
        $Pid = <$fh>;
        croak "Server already running with PID $Pid" if kill 0 => $Pid;
        cluck "Removing PID file for defunct server process $Pid.\n";
        croak "Can't unlink PID file $file" unless -w $file && unlink $file;
    }
    return IO::File->new($file, O_WRONLY|O_CREAT|O_EXCL, oct(644))
        or die "Can't create $file: $OS_ERROR\n";
}

sub _reap_child {
    do { } while waitpid(-1, WNOHANG) > 0;
}

# Return true is running as root.
# Retrun false if not running as root.
sub _running_as_root {
    return(!$REAL_USER_ID);
}

sub init_server_root {
    if (!_running_as_root()) {
        die "must run as root!";
    }
    $Pidfile  = shift;
    my $syslog_mask = shift;
    if (!defined $Pidfile) {
        $Pidfile = _getpidfilename();
    }
    my $fh = _open_pid_file($Pidfile);
    _become_daemon();
    print $fh $PROCESS_ID;
    close $fh;

    if (! defined $syslog_mask) {
        $syslog_mask = 'info';
    }
    init_syslog($syslog_mask);
    return $Pid = $PROCESS_ID;
}

sub init_server_user {
    if (!_running_as_root()) {
        die "must run as root!";
    }
    $Pidfile        = shift;
    my $user        = shift;
    my $group       = shift;
    my $syslog_mask = shift;
    if (!defined $user && !defined $group) {
        die "cannot drop privilages, missing user or group parameter!";
    }
    if (!defined $Pidfile) {
        $Pidfile = _getpidfilename();
    }
    my $fh = _open_pid_file($Pidfile);
    _become_daemon();
    print $fh $PROCESS_ID;
    close $fh;

    if (! defined $syslog_mask) {
        $syslog_mask = 'info';
    }
    init_syslog($syslog_mask);
    _change_privilages($user, $group);
    return $Pid = $PROCESS_ID;
}

END { 
    $EFFECTIVE_USER_ID = $REAL_USER_ID;     # regain root privilages
    if (defined $Pid && $Pid == $PID) {
        log_info("removing pidfile $Pidfile", "\n");
        unlink $Pidfile;
        close_syslog();
    }
}

1;

__END__
=head1 NAME

SPM::Daemon - Functions For Perl Daemons

=head1 SYNOPSIS

  use SPM::Daemon qw( init_server_root init_server_user );

=head1 DESCRIPTION

The SPM::Daemon module contains functions used for creating daemons.

=head2 EXPORT

Nothing is exported by default from this module. All functions need to
be explicitly requested.

=head1 FUNCTIONS

=head2 init_server_root(PIDFILE, MASK)

Do required work to become a daemon as root. Forks a new process, becomes the session leader, sets up syslog, clears environment variables,
clears umask, and changes directory to /. Sets syslog mask to I<MASK>. Valid syslog masks are 'debug', 'info', 'warning', 'err', and 'crit'.
The I<MASK> parameter is optional. Default syslog I<MASK> is 'info'.

=head2 init_server_user(PIDFILE, USER, GROUP, MASK)

Do required work to become a daemon as I<USER>. Forks a new process, becomes the session leader, sets up syslog, clears environment variables,
clears umask, and changes directory to /. Drops root privilages runs as user I<USER> and group I<GROUP>. Sets syslog mask to I<MASK>. Valid syslog masks
are 'debug', 'info', 'warning', 'err', and 'crit'. The I<MASK> parameter is optional. Default syslog mask is 'info'.

=head1 SEE ALSO

SPM::Syslog, fork(), setsid()

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

