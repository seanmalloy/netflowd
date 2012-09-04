# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl SPM-Exception.t'.

use Test::More;
use Test::Exception;
use SPM::Exception;
BEGIN { use_ok('SPM::Exception') };
BEGIN { require_ok('SPM::Exception') };

my $spm_exception                       = new_ok(SPM::Exception);
my $spm_exception_invalidinputundef     = new_ok(SPM::Exception::InvalidInputUndef);
my $spm_exception_invalidinputreference = new_ok(SPM::Exception::InvalidInputReference);
my $spm_exception_outofrange            = new_ok(SPM::Exception::OutOfRange);
throws_ok { SPM::Exception->throw } 'SPM::Exception', 'test SPM::Exception->throw';
throws_ok { SPM::Exception::InvalidInputUndef->throw } 'SPM::Exception::InvalidInputUndef', 'test SPM::Exception::InvalidInputUndef->throw';
throws_ok { SPM::Exception::InvalidInputReference->throw } 'SPM::Exception::InvalidInputReference', 'test SPM::Exception::InvalidInputReference->throw';
throws_ok { SPM::Exception::OutOfRange->throw } 'SPM::Exception::OutOfRange', 'test SPM::Exception::OutOfRange->throw';
TODO: {
    local $TODO = "still writing SPM::Exception sub classes";
}

done_testing();

