use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    #NAME              => 'SPM::Util::Num',
    NAME              => 'SPM::Util',
    VERSION_FROM      => 'lib/SPM/Util/Num.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/SPM/Util/Num.pm', # retrieve abstract from module
       AUTHOR         => 'Sean Malloy <spinelli85@gmail.com@>') : ()),
);
