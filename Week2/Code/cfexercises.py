#! /usr/bin/env python3

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

"""Set of functions to print certain numbers of 'hello'
   and a number of foo functions"""

import sys

# How many times will 'hello' be printed


# 1) prints y-x hellos
def hello_in_range(x=3, y=17):
    """print x-y hellos"""
    for i in range(x, y):
        print('hello')
    return ''


# 2) prints hello for each instance where x is divisable by 3
def hello_divisable3(x=12):
    """print hello x divided by 3 times """

    for j in range(x):
        if j % 3 == 0:
            print('hello')
    return ''


# 3) print hello each time x leaves remainder 3 when divided by 5 or 4
def hello_remainder3(x=13):
    """print hello each time x leaves remainder 3 when divided by 5 or 4"""

    for j in range(x):
        if j % 5 == 3:
            print('hello')
        elif j % 4 == 3:
            print('hello')
    return ''


# 4) print hello for each multiple of 3 up to x
def hello_multiple3(x=15):
    """ print hello for each multiple of 3 up to x"""

    z = 0
    while z != x:
        print('hello')
        z = z + 3
    return ''


#  5) print 0 hellos if x < 18, 1 hello if 18 =< x > 31 and 9 hello if x > 31
def weired_hellos(x=12):
    """print 1 hellos if x < 18, 1 hello if 18 =< x > 31, 9 if x > 31"""
    z = 12
    while z < x:
        if z == 31:
            for k in range(7):
                print('hello')
        elif z == 18:
            print('hello')
        z = z + 1
    return ''


# foo -- returns x to the power of 0.5
def foo(x):
    """returns x to the power of 0.5"""
    return x ** 0.5


# foo2 -- returns the larger of x and y
def foo2(x, y):
    """return the  larger of x and y"""
    if x > y:
        return x
    return y


# foo3 if x > y then swap, if y > z then swap
def foo3(x, y, z):
    """if x > y then swap, if y > z then swap"""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]


# foo4 return factorial of x
def foo4(x):
    """return factorial of x"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result


# foo5 another way of returning the factorial of x
# This is a recursive function, meaning that the function calls itself!!
def foo5(x):
    """return the factorial of x, recursive function"""
    if x == 1:
        return 1
    return x * foo5(x - 1)

# def main... and print


def main(argv):
    print(hello_in_range())
    print(hello_divisable3())
    print(hello_remainder3())
    print(hello_multiple3())
    print(weired_hellos())
    print(foo(5))
    print(foo2(15, 22))
    print(foo3(5, 3, 6))
    print(foo4(7))
    print(foo5(9))


if(__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
