use strict;
use warnings;
use Test::More;

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

eval "require Test::Distribution";
plan skip_all => "Test::Distribution required" if $@;
Test::Distribution->import();
