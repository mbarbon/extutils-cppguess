#!/usr/bin/perl -w

use strict;
use Test::More tests => 1;
use t::lib::TestUtils;

my $separator = ( '=' x 40 . "\n" );

prepare_test( 't/module', 't/makemaker' );
my( $ok, $configure, $build, $test ) = build_makemaker( 't/makemaker' );

ok( $ok, 'build with ExtUtils::MakeMaker' );
if( !$ok ) {
    diag( "Makefile.PL output\n", $separator, $configure, $separator );
    diag( "make output\n",        $separator, $build, $separator ) if $build;
    diag( "make test output\n",   $separator, $test, $separator ) if $test;
}
