package SPM::Daemon;

use strict;
use warnings;
use English qw( -no_match_vars );

use POSIX qw(setsid WNOHANG);
use Carp 'croak', 'cluck';   # TODO: should expections be used instead?
use File::Basename;
use IO::File;
use Sys::Syslog qw(:DEFAULT setlogsock);
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( init_server_root init_server_user log_debug log_die log_notice log_warn );
our $VERSION   = '0.01';

use constant PIDPATH  => '/var/run';
use constant FACILITY => 'local0';
my ($Pid, $Pidfile);

sub _become_daemon {
    die "Can't fork" unless defined (my $child = fork);
    exit 0 if $child;  # parent dies
    setsid();          # become session leader
    open(STDIN,  "</dev/null");
    open(STDOUT, ">/dev/null");
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

sub _init_log {
    setlogsock('unix');
    my $basename = basename($PROGRAM_NAME);
    openlog($basename, 'pid', FACILITY);
    $SIG{__WARN__} = 'log_warn';    # send warn() messages to syslog
    $SIG{__DIE__}  = 'log_die';     # send die() messages to syslog
}

sub _getpidfilename {
    my $basename = basename($PROGRAM_NAME, '.pl');
    return PIDPATH . "/$basename.pid";
}

sub _msg {
    my $msg = join('', @_) || "Something's wrong";
    my ($pack, $filename, $line) = caller(1);
    $msg .= "$filename line $line\n" unless $msg =~ /\n$/;
    return $msg;
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
    return IO::File->new($file, O_WRONLY|O_CREAT|O_EXCL, 0644)
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
    if (!defined $Pidfile) {
        $Pidfile = _getpidfilename();
    }
    my $fh = _open_pid_file($Pidfile);
    _become_daemon();
    print $fh $PROCESS_ID;
    close $fh;
    _init_log();
    return $Pid = $PROCESS_ID;
}

sub init_server_user {
    if (!_running_as_root()) {
        die "must run as root!";
    }
    $Pidfile  = shift;
    my $user  = shift;
    my $group = shift;
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
    _init_log();
    _change_privilages($user, $group);
    return $Pid = $PROCESS_ID;
}

sub log_die {
    syslog('crit', _msg(@_));
    die @_;
}
sub log_debug  { syslog('debug',   _msg(@_)) }
sub log_notice { syslog('notice',  _msg(@_)) }
sub log_warn   { syslog('warning', _msg(@_)) }

END { 
    $EFFECTIVE_USER_ID = $REAL_USER_ID;     # regain root privilages
    if (defined $Pid && $Pid == $PID) {
        log_notice("removing pidfile $Pidfile", "\n");
        unlink $Pidfile;
    }
}

1;

__END__
=head1 NAME

SPM::Daemon - Functions For Perl Daemons

=head1 SYNOPSIS

  use SPM::Daemon qw( init_server log_debug log_die log_notice log_warn );

=head1 DESCRIPTION

The SPM::Daemon module contains functions to used for creating daemons.

=head2 EXPORT

Nothing is exported by default from this module. All functions need to
be explicitly requested.

=head1 FUNCTIONS

=head2 init_server_root(PIDFILE)

Do required work to become a daemon as root. Forks a new process, becomes the session leader, sets up syslog, clears environment variables,
clears umask, and changes directory to /.

=head2 init_server_user(PIDFILE, USER, GROUP)

Do required work to become a daemon as USER. Forks a new process, becomes the session leader, sets set syslog, clears environment variables,
clears umask, and changes directory to /. Drops root privilages runs as user USER and group GROUP.

=head2 log_debug

Log a debug message to syslog.

=head2 log_die

Log a critical message to syslog and die.

=head2 log_notice

Log a notice message to syslog.

=head2 log_warn

Log a warning message to syslog.

=head1 SEE ALSO

Sys::Syslog, fork(), setsid()

=head1 BUGS

No known bugs at this time.

=head1 AUTHOR

Sean Malloy, E<lt>spinelli85@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Sean Malloy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.

=cut

