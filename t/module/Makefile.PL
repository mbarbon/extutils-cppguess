#!/usr/bin/perl -w

use strict;
use ExtUtils::MakeMaker;

WriteMakefile
  ( NAME            => 'CppGuessTest',
    VERSION_FROM    => 'lib/CppGuessTest.pm',
    PL_FILES        => {},
    );
