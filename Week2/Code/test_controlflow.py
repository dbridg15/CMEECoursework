#! /usr/bin/python3

"""Testing Docstrings using the even_or_odd function"""
__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# docstrings are considered part of the running code (normal comments are
# stripped). Hence, you can access your docstrings at runtime

# imports
import sys  # module to interface our program with the operating system
import doctest


def even_or_odd(x=0):  # if not specified then x is 0
    """Find whether a number x is even or odd.

    >>> even_or_odd(10)
    '10 is Even!'

    >>> even_or_odd(5)
    '5 is Odd!'

    whenever a float is provided, then the closest integer is used:
    >>> even_or_odd(3.2)
    '3 is Odd!'

    in case of negative numbers, the positive is taken:
    >>> even_or_odd(-2)
    '-2 is Even!'

    """
    # Define function to be tested
    x = int(x)

    if x % 2 == 0:  # The conditional if
        return "%d is Even!" % x
    return "%d is Odd!" % x


doctest.testmod()  # To run the embedded tests
