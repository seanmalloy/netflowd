# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl SPM-Util.t'

use Test::More tests => 44;
use Test::Exception;
use SPM::Util::Num qw( bin2dec bin2dottedquad dec2bin);
BEGIN { use_ok('SPM::Util::Num') };
BEGIN { require_ok('SPM::Util::Num') };

# Tests for SPM::Util::Num::bin2dec function.
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
throws_ok { bin2dec('2') } "SPM::Exception", 'invalid input, 2';
throws_ok { bin2dec('a') } "SPM::Exception", 'invalid input, a';
throws_ok { bin2dec('1a') } "SPM::Exception", 'invalid input, 1a';
throws_ok { bin2dec({}) } "SPM::Exception", 'invalid input, hash ref';
throws_ok { bin2dec([]) } "SPM::Exception", 'invalid input, array ref';
throws_ok { bin2dec(undef) } "SPM::Exception", 'invalid input, undef';
throws_ok { bin2dec() } "SPM::Exception", 'invalid input, empty call';

# Tests for SPM::Util::Num::bin2dottedquad function.
is(bin2dottedquad('00000000000000000000000000000000'), '0.0.0.0', 'convert to 0.0.0.0');
is(bin2dottedquad('11111111111111111111111111111111'), '255.255.255.255', 'convert to 255.255.255.255');
is(bin2dottedquad('11000000101010000000000100000001'), '192.168.1.1', 'convert to 192.168.1.1');
throws_ok { bin2dottedquad(undef) } "SPM::Exception", 'invalid input, undef';
throws_ok { bin2dottedquad() } "SPM::Exception", 'empty call';
throws_ok { bin2dottedquad('') } "SPM::Exception", 'invalid input, empty string';
throws_ok { bin2dottedquad('1') } "SPM::Exception", 'invalid input, 1 bit';
throws_ok { bin2dottedquad('1111111111111111111111111111111') } "SPM::Exception", 'invalid input, 31 bits';
throws_ok { bin2dottedquad('111111111111111111111111111111111') } "SPM::Exception", 'invalid input, 33 bits';
throws_ok { bin2dottedquad({}) } "SPM::Exception", 'invalid input, hash ref';
throws_ok { bin2dottedquad([]) } "SPM::Exception", 'invalid input, array ref';
throws_ok { bin2dottedquad('2') } "SPM::Exception", 'invalid input, 2';
throws_ok { bin2dottedquad('a') } "SPM::Exception", 'invalid input, a';
throws_ok { bin2dottedquad('1a') } "SPM::Exception", 'invalid input, 1a';

# Tests for SPM::Util::Num::dec2bin function.
is(dec2bin('7'), '111', 'convert 7(string) to binary');
is(dec2bin(7), '111', 'convert 7 to binary');
is(dec2bin(0), '0', 'convert 0 to binary');
is(dec2bin(1), '1', 'convert 1 to binary');
is(dec2bin(255), '11111111', 'convert 255 to binary');
throws_ok { dec2bin({}) } "SPM::Exception", 'invalid input, hash ref';
throws_ok { dec2bin([]) } "SPM::Exception", 'invalid input, array ref';
throws_ok { dec2bin() } "SPM::Exception", 'empty call';
throws_ok { dec2bin(undef) } "SPM::Exception", 'invalid input, undef';
throws_ok { dec2bin('a') } "SPM::Exception", 'invalid input, a';
throws_ok { dec2bin('1a') } "SPM::Exception", 'invalid input, 1a';


