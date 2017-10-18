#!/usr/bin/env python3

"""some functions exemplifying the use of control statments
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'

# imports
import sys  # module to interface our program with the operating system


def even_or_odd(x=0):  # if not specified then x is 0

    """Find whether a number x is even or odd."""
    if x % 2 == 0:  # The conditional if
        return "%d is Even" % x
    return "%d is Odd!" % x


def largest_divisor_five(x=120):
    """Find the largest divisor of x among 2,3,4,5"""
    largest = 0
    if x % 5 == 0:
        largest = 5
    elif x % 4 == 0:
        largest = 4
    elif x % 3 == 0:
        largest = 3
    elif x % 2 == 0:
        largest = 2
    else:  # when all other conditions are not met
        return "No divisor found for %d" % x

    return "The largest divisor of %d is %d" % (x, largest)


def is_prime(x=70):
    """Find whether x is Prime"""
    for i in range(2, x):
        if x % i == 0:
            print("%d is not a prime %d is a divisor" % (x, i))

            return False
        print("%d is a Prime. Woo!!" % x)
        return True


def find_all_primes(x=22):
    """Find all the primes up to x"""
    allprimes = []
    for i in range(2, x+1):
        if is_prime(i):
            allprimes.append(i)
    print("There are %d primes between 2 and %d" % (len(allprimes), x))
    return allprimes


def main(argv):
    """Test and Print output of all  functions"""

    # sys.exit (keep this commented at the mo...)
    print(even_or_odd(22))
    print(even_or_odd(33))
    print(largest_divisor_five(120))
    print(largest_divisor_five(121))
    print(is_prime(60))
    print(is_prime(59))
    print(find_all_primes(100))
    return 0


if(__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
