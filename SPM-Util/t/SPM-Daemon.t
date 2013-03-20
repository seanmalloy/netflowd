# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl SPM-Daemon.t'

use Test::More tests => 1;
use Test::Exception;
use SPM::Daemon;
BEGIN { use_ok('SPM::Daemon') };

