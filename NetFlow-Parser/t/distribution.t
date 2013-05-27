use strict;
use warnings;
use English qw(-no_match_vars);
use Test::More;

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

eval "require Test::Distribution";
plan skip_all => "Test::Distribution required" if $EVAL_ERROR;
Test::Distribution->import();
