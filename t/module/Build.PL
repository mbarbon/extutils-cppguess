#!/usr/bin/perl -w

use strict;
use Module::Build;

my $build = Module::Build->new
  ( module_name     => 'CppGuessTest',
    abstarct        => 'a test module',
    license         => 'perl',
    xs_files        => { 'CppGuessTest.xs' => 'lib/CppGuessTest.xs' },
    );
$build->create_build_script;
