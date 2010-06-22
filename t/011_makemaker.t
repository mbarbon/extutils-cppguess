#!/usr/bin/perl -w

use strict;
use Test::More tests => 1;

use ExtUtils::Manifest qw(manicopy maniread);
use File::Path qw(rmtree);
use Config;

my $separator = ( '=' x 40 . "\n" );

rmtree 't/makemaker';
chdir 't/module' or die;
manicopy( maniread(), '../makemaker' );
chdir '../makemaker' or die;

my $makefile_pl = `$^X Makefile.PL 2>&1`;
my $makefile_pl_ok = $?;

if( $makefile_pl_ok != 0 ) {
    ok( 0, 'configuration failed' );
    diag( "perl Makefile.PL output\n", $separator, $makefile_pl, $separator );

    exit 1;
}

my $make = `$Config{make} 2>&1`;
my $make_ok = $?;

if( $make_ok != 0 ) {
    ok( 0, 'build failed' );
    diag( "Makefile.PL output\n", $separator, $makefile_pl, $separator );
    diag( "make output\n",        $separator, $make, $separator );

    exit 1;
}

my $make_test = `$Config{make} test 2>&1`;
my $make_test_ok = $?;

if( $make_test_ok != 0 ) {
    ok( 0, 'test failed' );
    diag( "perl Makefile.PL output\n", $separator, $makefile_pl, $separator );
    diag( "make output\n",             $separator, $make, $separator );
    diag( "make test output\n",        $separator, $make_test, $separator );
} else {
    ok( 1, 'full success' );
}
