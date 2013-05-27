use strict;
use warnings;
use Test::More;
use English qw(-no_match_vars);

if ( not $ENV{RELEASE_TESTING} ) {
    my $msg = 'Author test.  Set $ENV{RELEASE_TESTING} to a true value to run.';
    plan( skip_all => $msg );
}

eval "require Test::Perl::Critic";
plan skip_all => "Test::Perl::Critic required" if $EVAL_ERROR;

Test::Perl::Critic::all_critic_ok();

