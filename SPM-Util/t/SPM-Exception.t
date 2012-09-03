# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl SPM-Exception.t'.

use Test::More;
use Test::Exception;
use SPM::Exception;
BEGIN { use_ok('SPM::Exception') };
BEGIN { require_ok('SPM::Exception') };

my $spm_exception                   = new_ok(SPM::Exception);
my $spm_exception_invalidinputundef = new_ok(SPM::Exception::InvalidInputUndef);
my $spm_exception_invalidinputreference = new_ok(SPM::Exception::InvalidInputReference);
TODO: {
    local $TODO = "still writing SPM::Exception sub classes";
}

done_testing();

