#!/usr/bin/env python3

""" example regular expression in python
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# imports
import re


################################################################################
# regualr expressions
################################################################################

my_string = "a given string"

# find a space in the string
match = re.search(r'\s', my_string)

print(match)
# this should print something like
# <_sre.SRE_Match object at 0x93ecdd30>

# now we can see what has matched
print(match.group())

match = re.search(r's\w*', my_string)
# this should return "string"
print(match.group())


# NOW AN EXAMPLE OF NO MATCH:
# find a digit in the string
match = re.search(r'\d', my_string)

# this should print "None"
print(match)
# Further Example
#

my_string = 'an example'
match = re.search(r'\w*\s', my_string)

if match:
    print('found a match:', match.group())
else:
    print('did not find a match')


################################################################################
# to know if a pattern was matched we can use if
################################################################################

MyStr = 'an example'

match = re.search(r'\w*\s', MyStr)

if match:
    print('Found a match!:', match.group())
else:
    print('did not find a match')


################################################################################
# more regular expressions
################################################################################

match = re.search(r'\d', "it takes 2 to tango")
print(match.group())  # print 2

match = re.search(r'\s\w*\s', 'once upon a time')
print(match.group())  # ' upon '

match = re.search(r'\s\w{1,3}\s', 'once upon a time')
print(match.group())  # ' a '

match = re.search(r'\s\w*$', 'once upon a time')
print(match.group())  # ' time'

match = re.search(r'\w*\s\d.*\d', 'take 2 grams of H2O')
print(match.group())  # 'take 2 grams of H2'

match = re.search(r'^\w*.*\s', 'once upon a time')
print(match.group())  # 'once upon a '
# NOTE THAT *, +, and { } are all "greedy":
# They repeat the previous regex token as many times as possible
# As a result, they may match more text than you want

# To make it non-greedy, use ?:
match = re.search(r'^\w*.*?\s', 'once upon a time')
print(match.group())  # 'once '

# To further illustrate greediness, let's try matching an HTML tag:
match = re.search(r'<.+>', 'This is a <EM>first</EM> test')
print(match.group())  # '<EM>first</EM>'
# But we didn't want this: we wanted just <EM>
# It's because + is greedy!

# Instead, we can make + "lazy"!
match = re.search(r'<.+?>', 'This is a <EM>first</EM> test')
print(match.group())  # '<EM>'

# OK, moving on from greed and laziness
match = re.search(r'\d*\.?\d*', '1432.75+60.22i')  # note "\" before "."
print(match.group())  # '1432.75'

match = re.search(r'\d*\.?\d*', '1432+60.22i')
print(match.group())  # '1432'

match = re.search(r'[AGTC]+', 'the sequence ATTCGT')
print(match.group())  # 'ATTCGT'

re.search(r'\s+[A-Z]{1}\w+\s\w+',
          'The bird-shit frog''s name is Theloderma asper').group()
# ' Theloderma asper'
# NOTE THAT I DIRECTLY RETURNED THE RESULT BY APPENDING .group()
