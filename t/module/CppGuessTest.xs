#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <string>

typedef std::string std__string;

int silly_test( int value )
{
    return 2 * value + 1;
}

std::string useless_test( const std::string& a, const std::string& b )
{
    return a + b;
}

MODULE=CppGuessTest PACKAGE=CppGuessTest

PROTOTYPES: DISABLE

int
silly_test( int value )

std::string
useless_test( std::string a, std::string b )
