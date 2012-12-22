use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'NetFlow::Parser',
    AUTHOR              => q{Sean Malloy <spinelli85@gmail.com>},
    VERSION_FROM        => 'lib/NetFlow/Parser.pm',
    ABSTRACT_FROM       => 'lib/NetFlow/Parser.pm',
    'LICENSE'           => 'bsd',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'SPM-Temp-*' },
);

