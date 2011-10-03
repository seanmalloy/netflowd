# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl SPM-Exception.t'.

use Test::More tests => 3;
use SPM::Exception;
BEGIN { use_ok('SPM::Exception') };
BEGIN { require_ok('SPM::Exception') };

my $object = SPM::Exception->new();
isa_ok($object, 'SPM::Exception');


