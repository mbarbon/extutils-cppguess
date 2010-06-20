#!/usr/bin/perl -w

use strict;
use Module::Build;

my $build = Module::Build->new
  ( module_name   => 'ExtUtils::CppGuess',
    license       => 'perl',
    requires      => { },
    );

$build->create_build_script;
