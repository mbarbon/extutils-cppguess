package ExtUtils::CppGuess;

use strict;
use warnings;

=head1 NAME

ExtUtils::CppGuess - guess C++ compiler and flags

=cut

our $VERSION = '0.01';

sub new {
    my( $class ) = @_;
    my $self = bless {}, $class;

    return $self;
}

sub guess_compiler {
    my( $self ) = @_;
    return $self->{guess} if $self->{guess};

    $self->{guess} = { compiler => 'g++',
                       linker   => 'g++',
                       };

    return $self->{guess};
}

sub makemaker_options {
    my( $self ) = @_;
    my $g = $self->guess_compiler || die;

    return ( CC => $g->{compiler}, LD => $g->{linker} );
}

sub module_build_options {
    my( $self ) = @_;
    my $g = $self->guess_compiler || die;

    return ( config => { cc => $g->{compiler}, ld => $g->{linker} } );
}

1;
