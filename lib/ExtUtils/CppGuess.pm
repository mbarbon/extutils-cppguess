package ExtUtils::CppGuess;

use strict;
use warnings;

=head1 NAME

ExtUtils::CppGuess - guess C++ compiler and flags

=cut

use Config;
use File::Basename qw();

our $VERSION = '0.01';

sub new {
    my( $class ) = @_;
    my $self = bless {}, $class;

    return $self;
}

sub guess_compiler {
    my( $self ) = @_;
    return $self->{guess} if $self->{guess};

    if( $^O =~ /^mswin/i ) {
        _guess_win32( $self );
    } else {
        _guess_unix( $self );
    }
}

sub makemaker_options {
    my( $self ) = @_;
    my $g = $self->guess_compiler || die;

    return ( CCFLAGS      => $self->{guess}{extra_cflags},
             dynamic_lib  => { OTHERLDFLAGS => $self->{guess}{extra_lflags} },
             );
}

sub module_build_options {
    my( $self ) = @_;
    my $g = $self->guess_compiler || die;

    return ( extra_compiler_flags => $self->{guess}{extra_cflags},
             extra_linker_flags   => $self->{guess}{extra_lflags},
             );
}

sub _guess_win32 {
    my( $self ) = @_;
    my $c_compiler = $Config{cc};

    if( _cc_is_gcc( $c_compiler ) ) {
        $self->{guess} = { extra_cflags => ' -xc++ ',
                           extra_lflags => ' -lstdc++ ',
                           };
    } elsif( _cc_is_msvc( $c_compiler ) ) {
        $self->{guess} = { extra_cflags => ' -TP -EHsc ',
                           extra_lflags => ' msvcprt.lib ',
                           };
    } else {
        die "Unable to determine a C++ compiler for '$c_compiler'";
    }
}

sub _guess_unix {
    my( $self ) = @_;
    my $c_compiler = $Config{cc};

    if( !_cc_is_gcc( $c_compiler ) ) {
        die "Unable to determine a C++ compiler for '$c_compiler'";
    }

    $self->{guess} = { extra_cflags => ' -xc++ ',
                       extra_lflags => ' -lstdc++ ',
                       };
}

# from Alien::wxWidgets::Utility

my $quotes = $^O =~ /MSWin32/ ? '"' : "'";

sub _capture {
    qx!$^X -e ${quotes}open STDERR, q[>&STDOUT]; exec \@ARGV${quotes} -- $_[0]!;
}

sub _cc_is_msvc {
    my( $cc ) = @_;

    return $^O =~ /MSWin32/ and File::Basename::basename( $cc ) =~ /^cl/i;
}

sub _cc_is_gcc {
    my( $cc ) = @_;

    return    scalar( _capture( "$cc --version" ) =~ m/g(cc|\+\+)/i ) # 3.x
           || scalar( _capture( "$cc" ) =~ m/gcc/i );          # 2.95
}

1;
