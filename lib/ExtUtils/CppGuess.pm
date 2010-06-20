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

1;
