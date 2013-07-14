# Test for SPM::Util module.

use Test::More tests => 56;
use Test::Exception;
use SPM::Util qw( is_defined is_reference isnt_defined isnt_reference );
BEGIN { use_ok('SPM::Util') };

# Tests for SPM::Util::is_defined function
is(is_defined('1'),  1, 'SPM::Util::is_defined 1 as string returns true');
is(is_defined('10'), 1, 'SPM::Util::is_defined 10 as string returns true');
is(is_defined('a'),  1, 'SPM::Util::is_defined "a" as string returns true');
is(is_defined('ab'), 1, 'SPM::Util::is_defined "ab" as string returns true');
is(is_defined(''),   1, 'SPM::Util::is_defined empty string returns true');
is(is_defined(0),    1, 'SPM::Util::is_defined 0 returns true');
is(is_defined(1),    1, 'SPM::Util::is_defined 1 returns true');
is(is_defined(-1),   1, 'SPM::Util::is_defined -1 returns true');
is(is_defined(10),   1, 'SPM::Util::is_defined 10 returns true');
is(is_defined([]),   1, 'SPM::Util::is_defined array reference returns true');
is(is_defined({}),   1, 'SPM::Util::is_defined hash reference returns true');
throws_ok { is_defined(undef) } "SPM::X::BadValue", 'SPM::Util::is_defined undef throws exception';
throws_ok { is_defined() } "SPM::X::BadValue", 'SPM::Util::is_defined no parameters throws exception';

# Tests for SPM::Util::is_reference function.
our $foo;
is(is_reference(*foo{SCALAR}),   1, 'SPM::Util::is_reference scalar reference returns true');
is(is_reference(*ARGV{ARRAY}),   1, 'SPM::Util::is_reference array reference returns true');
is(is_reference(*ENV{HASH}),     1, 'SPM::Util::is_reference hash reference returns true');
is(is_reference(sub {}),         1, 'SPM::Util::is_reference code reference returns true');
throws_ok { is_reference(undef) } "SPM::X::BadValue", 'SPM::Util::is_reference undef throws excpetion';
throws_ok { is_reference(1)     } "SPM::X::BadValue", 'SPM::Util::is_reference 1 throws excpetion';
throws_ok { is_reference(-1)    } "SPM::X::BadValue", 'SPM::Util::is_reference -1 throws excpetion';
throws_ok { is_reference(0)     } "SPM::X::BadValue", 'SPM::Util::is_reference 0 throws excpetion';
throws_ok { is_reference(10)    } "SPM::X::BadValue", 'SPM::Util::is_reference 10 throws excpetion';
throws_ok { is_reference('1')   } "SPM::X::BadValue", 'SPM::Util::is_reference 1 as string throws excpetion';
throws_ok { is_reference('10')  } "SPM::X::BadValue", 'SPM::Util::is_reference 10 as string throws excpetion';
throws_ok { is_reference('a')   } "SPM::X::BadValue", 'SPM::Util::is_reference single character string throws excpetion';
throws_ok { is_reference('ab')  } "SPM::X::BadValue", 'SPM::Util::is_reference two character string throws excpetion';
throws_ok { is_reference('')    } "SPM::X::BadValue", 'SPM::Util::is_reference empty string throws excpetion';
throws_ok { is_reference()      } "SPM::X::BadValue", 'SPM::Util::is_reference no parameters throws excpetion';

# Tests for SPM::Util::isnt_defined function
is(isnt_defined(undef),  1, 'SPM::Util::isnt_defined undef returns true');
is(isnt_defined(),       1, 'SPM::Util::isnt_defined no parameters returns true');
throws_ok { isnt_defined('1')  } "SPM::X::BadValue", 'SPM::Util::isnt_defined 1 as string throws exception';
throws_ok { isnt_defined('10') } "SPM::X::BadValue", 'SPM::Util::isnt_defined 10 as string throws exception';
throws_ok { isnt_defined('a')  } "SPM::X::BadValue", 'SPM::Util::isnt_defined "a" as string throws exception';
throws_ok { isnt_defined('ab') } "SPM::X::BadValue", 'SPM::Util::isnt_defined "ab" as string throws exception';
throws_ok { isnt_defined('')   } "SPM::X::BadValue", 'SPM::Util::isnt_defined empty throws exception';
throws_ok { isnt_defined(0)    } "SPM::X::BadValue", 'SPM::Util::isnt_defined 0 throws exception';
throws_ok { isnt_defined(1)    } "SPM::X::BadValue", 'SPM::Util::isnt_defined 1 throws exception';
throws_ok { isnt_defined(-1)   } "SPM::X::BadValue", 'SPM::Util::isnt_defined -1 throws exception';
throws_ok { isnt_defined(10)   } "SPM::X::BadValue", 'SPM::Util::isnt_defined 10 throws exception';
throws_ok { isnt_defined([])   } "SPM::X::BadValue", 'SPM::Util::isnt_defined array reference throws exception';
throws_ok { isnt_defined({})   } "SPM::X::BadValue", 'SPM::Util::isnt_defined hash reference throws exception';

# START
# Tests for SPM::Util::isnt_reference function.
is(isnt_reference(undef), 1, 'SPM::Util::isnt_reference undef returns true');
is(isnt_reference(1),     1, 'SPM::Util::isnt_reference 1 returns true');
is(isnt_reference(-1),    1, 'SPM::Util::isnt_reference -1 returns true');
is(isnt_reference(0),     1, 'SPM::Util::isnt_reference 0 returns true');
is(isnt_reference('1'),   1, 'SPM::Util::isnt_reference 1 as string  returns true');
is(isnt_reference('10'),  1, 'SPM::Util::isnt_reference 10 as string  returns true');
is(isnt_reference('a'),   1, 'SPM::Util::isnt_reference single character string returns true');
is(isnt_reference('ab'),  1, 'SPM::Util::isnt_reference two character string returns true');
is(isnt_reference(''),    1, 'SPM::Util::isnt_reference empty string returns true');
is(isnt_reference(),      1, 'SPM::Util::isnt_reference no parameters returns true');
throws_ok { isnt_reference(*foo{SCALAR}) } "SPM::X::BadValue", 'SPM::Util::isnt_reference scalar reference throws exception';
throws_ok { isnt_reference(*ARGV{ARRAY}) } "SPM::X::BadValue", 'SPM::Util::isnt_reference array reference throws exception';
throws_ok { isnt_reference(*ENV{HASH})   } "SPM::X::BadValue", 'SPM::Util::isnt_reference hash reference throws exception';
throws_ok { isnt_reference(sub {})       } "SPM::X::BadValue", 'SPM::Util::isnt_reference reference reference throws exception';

