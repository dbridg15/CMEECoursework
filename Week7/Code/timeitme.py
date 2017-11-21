#!/usr/bin/env python

# run in python 2 as python 3 has no difference between range and xrange

""" illustrating difference between range and xrange must be run in python2
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# imports
import time
import timeit

################################################################################
# range vs xrange
################################################################################


def a_not_useful_function():
    """function using range"""
    y = 0
    for i in range(100000):
        y = y + i
    return 0


def a_less_useless_function():
    """function using xrange"""
    y = 0
    for i in xrange(100000):
        y = y + i
    return 0


# one approach is to time it like this
start = time.time()
a_not_useful_function()
print "a_not_useful_function takes %f s to run." % (time.time() - start)

start = time.time()
a_less_useless_function()
print "a_less_useless_function takes %f s to run." % (time.time() - start)

# But the time taken changes every time it's run!!!
# could do the following in ipython!

#   %timeit a_not_useful_function()
#   10000000 loops, best of 3: 26.1 ns per loop

#   %timeit a_less_useless_function()
#   10000000 loops, best of 3: 26.1 ns per loop

# still looking not right!!!


################################################################################
# for loops vs list comps
################################################################################

my_list = range(1000)


def my_squares_loop(x):
    """function using loops"""
    out = []
    for i in x:
        out.append(i**2)
    return out


def my_squares_lc(x):
    """function using list compreshensions"""
    out = [i ** 2 for i in x]
    return out


#   %timeit my_squares_loop(my_list)
#   10000 loops, best of 3: 125 us per loop

#   %timeit my_squares_loop(my_list)
#   10000 loops, best of 3: 125 us per loop


################################################################################
# for loops vs join method
################################################################################

import string

my_letters = list(string.ascii_lowercase)


def my_join_loop(l):
    """join function using loops"""
    out = ''
    for letter in l:
        out += letter
    return out


def my_join_method(l):
    """join function"""
    out = ''.join(l)
    return out


#   %timeit my_squares_loop(my_list)
#   10000 loops, best of 3: 125 us per loop

#   %timeit my_join_method(my_letters)
#   1000000 loops, best of 3: 577 ns per loop


################################################################################
# oh no!!!
################################################################################


def getting_silly_pi():
    """silly function 1"""
    y = 0
    for i in xrange(100000):
        y = y + i
    return 0


def getting_silly_pii():
    """silly function 2"""
    y = 0
    for i in xrange(100000):
        y += i
    return 0


#   %timeit getting_silly_pi()
#   100 loops, best of 3: 3.63 ms per loop

#   %timeit getting_silly_pii()
#   100 loops, best of 3: 3.72 ms per loop
