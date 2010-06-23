package t::lib::TestUtils;

use strict;

use ExtUtils::Manifest qw(manicopy maniread);
use File::Path qw(rmtree);
use File::Spec::Functions qw(rel2abs);
use Cwd qw(cwd);
use Fatal qw(chdir);
use Config qw();

require Exporter; *import = \&Exporter::import;

our @EXPORT = qw(prepare_test build_makemaker build_module_build);

sub prepare_test {
    my( $source, $destination ) = @_;
    my $cwd = cwd();

    $destination = rel2abs( $destination );
    rmtree( $destination );
    chdir( $source );
    manicopy( maniread(), $destination );
    chdir( $cwd );
}

sub build_module_build {
    my( $path ) = @_;
    my $cwd = cwd();
    chdir $path;

    my $build_pl = `perl Build.PL 2>&1`;
    my $build_pl_ok = $?;

    if( $build_pl_ok != 0 ) {
        chdir( $cwd );
        return ( 0, $build_pl, undef, undef );
    }

    my $build = `$^X Build 2>&1`;
    my $build_ok = $?;

    if( $build_ok != 0 ) {
        chdir( $cwd );
        return ( 0, $build_pl, $build, undef );
    }

    my $build_test = `$^X Build test 2>&1`;
    my $build_test_ok = $?;

    if( $build_test_ok != 0 ) {
        chdir( $cwd );
        return ( 0, $build_pl, $build, $build_test );
    } else {
        chdir( $cwd );
        return ( 1, $build_pl, $build, $build_test );
    }
}

sub build_makemaker {
    my( $path ) = @_;
    my $cwd = cwd();
    chdir $path;

    my $makefile_pl = `$^X Makefile.PL 2>&1`;
    my $makefile_pl_ok = $?;

    if( $makefile_pl_ok != 0 ) {
        chdir( $cwd );
        return ( 0, $makefile_pl, undef, undef );
    }

    my $make = `$Config::Config{make} 2>&1`;
    my $make_ok = $?;

    if( $make_ok != 0 ) {
        chdir( $cwd );
        return ( 0, $makefile_pl, $make, undef );
    }

    my $make_test = `$Config::Config{make} test 2>&1`;
    my $make_test_ok = $?;

    if( $make_test_ok != 0 ) {
        chdir( $cwd );
        return ( 0, $makefile_pl, $make, $make_test );
    } else {
        chdir( $cwd );
        return ( 1, $makefile_pl, $make, $make_test );
    }
}

1;
