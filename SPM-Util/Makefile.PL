use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'SPM::Util::Num',
    AUTHOR              => q{Sean Malloy <spinelli85@gmail.com>},
    VERSION_FROM        => 'lib/SPM/Util/Num.pm',
    ABSTRACT_FROM       => 'lib/SPM/Util/Num.pm',
    LICENSE             => 'bsd',
    PL_FILES            => {},
    PREREQ_PM => {
        'Moose'        => 0,
        'Throwable::X' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'SPM-Temp-*' },
);

