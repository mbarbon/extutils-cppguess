#!/usr/bin/perl -w

use strict;
use Test::More tests => 1;

use ExtUtils::Manifest qw(manicopy maniread);
use File::Path qw(rmtree);

my $separator = ( '=' x 40 . "\n" );

rmtree 't/module_build';
chdir 't/module' or die;
manicopy( maniread(), '../module_build' );
chdir '../module_build' or die;

my $build_pl = `perl Build.PL 2>&1`;
my $build_pl_ok = $?;

if( $build_pl_ok != 0 ) {
    ok( 0, 'configuration failed' );
    diag( "Build.PL output\n",   $separator, $build_pl, $separator );

    exit 1;
}

my $build = `./Build 2>&1`;
my $build_ok = $?;

if( $build_ok != 0 ) {
    ok( 0, 'build failed' );
    diag( "Build.PL output\n",   $separator, $build_pl, $separator );
    diag( "Build output\n",      $separator, $build, $separator );

    exit 1;
}

my $build_test = `./Build test 2>&1`;
my $build_test_ok = $?;

if( $build_test_ok != 0 ) {
    ok( 0, 'test failed' );
    diag( "Build.PL output\n",   $separator, $build_pl, $separator );
    diag( "Build output\n",      $separator, $build, $separator );
    diag( "Build test output\n", $separator, $build_test, $separator );
} else {
    ok( 1, 'full success' );
}
