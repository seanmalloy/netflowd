# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl SPM-Util.t'

use Test::More tests => 18;
use Test::Exception;
use SPM::Util::Num qw( bin2dec );
BEGIN { use_ok('SPM::Util::Num') };
BEGIN { require_ok('SPM::Util::Num') };

is(bin2dec('0'), 0, 'convert 0');
is(bin2dec('1'), 1, 'convert 1');
is(bin2dec('10'), 2, 'convert 2');
is(bin2dec('11'), 3, 'convert 3');
is(bin2dec('01'), 1, 'leading zero convert 1');
is(bin2dec('010'), 2, 'leading zero convert 2');
is(bin2dec('011'), 3, 'leading zero convert 3');
is(bin2dec('001'), 1, 'multiple leading zero convert 1');
is(bin2dec('0010'), 2, 'multiple leading zero convert 2');
is(bin2dec('0011'), 3, 'multiple leading zero convert 3');
is(bin2dec(undef), 0, 'convert undef to zero');
is(bin2dec(), 0, 'convert no input');

# Test exception code.
throws_ok { bin2dec('2') } "SPM::Exception", 'invalid input, 2';
throws_ok { bin2dec('a') } "SPM::Exception", 'invalid input, a';
throws_ok { bin2dec(my $ref = {}) } "SPM::Exception", 'invalid input, hash ref';
throws_ok { bin2dec(my $ref = []) } "SPM::Exception", 'invalid input, array ref';

