use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'NetFlow::Parser',
    AUTHOR              => q{Sean Malloy <spinelli85@gmail.com>},
    VERSION_FROM        => 'lib/NetFlow/Parser.pm',
    ABSTRACT_FROM       => 'lib/NetFlow/Parser.pm',
    LICENSE             => 'bsd',
    PL_FILES            => {},
    PREREQ_PM => {
        'Moose'                        => 0,
        'Moose::Util::TypeConstraints' => 0,
        'SPM::Util::Num'               => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'SPM-Temp-*' },
);

