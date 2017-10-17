#!/usr/bin/env python3

"""Python script demonstrating the difference between global
and local variables
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# Lets try this!

_a_global = 10


def a_function():
    """Function defining _a_global and _a_local
    _a_global is only 5 within the function"""
    _a_global = 5  # inside the function _a_global is now 5 however
                   # this is unchanged outside of the function
    _a_local = 4
    print("Inside the function, the value is ", _a_global)
    print("Inside the function, the value is ", _a_local)
    return None


a_function()
print("Outside the function, the value is ", _a_global)


# Now trying this...

_a_global = 10


def a_function():
    """Function defining _a_global and _a_local
    _a_global is changed outside the function as well"""
    global _a_global
    _a_global = 5
    _a_local = 4
    print("Inside the funciton, the value is ", _a_global)
    print("Inside the funciton, the value is ", _a_local)
    return None


a_function()
print("Outside the function, the value is", _a_global)
