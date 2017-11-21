#!/usr/bin/env python

# run in python 2 as python 3 has no difference between range and xrange

""" illustrating profiling must be run in python2!
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


def a_useless_function(x):
    """a useless function"""
    y = 0
    # 8 zeros
    for i in xrange(100000000):  # changed to xrange! (python2 only!)
        y = y + i
    return 0


def another_useless_function(x):  # Doesnt Work!!!
    """another useless function"""
    y = 0
    z = 0
    while z <= 100000000:
        y = y + x
        z += 1
    return 0


def a_less_useless_function(x):
    """a less useless function"""
    y = 0
    # five zeros
    for i in xrange(100000):  # changed to xrange! (python2 only)
        y = y + i
    return 0


def some_function(x):
    """run the other functions"""
    print(x)
    a_useless_function(x)
    another_useless_function(x)
    a_less_useless_function(x)
    return 0


some_function(1000)
