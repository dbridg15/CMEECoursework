""" This is blah blah"""

# Use the subprocess.os module to get a list of fules and directories
# in your ubuntu home directory

# Hint: look in subprocess.os and/or subprocess.os.path and/or
# subprocess.os.walk for helpful functions

import subprocess
import os

#################################
# ~Get a list of files and
# ~directories in your home/ that start with an uppercase 'C'

# Type your code here:

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# Create a list to store the results.
FilesDirsStartingWithC = []


for dirname, dirnames, filenames in os.walk(home):
    # print all subdirectories first.
    for subdirname in dirnames:
        if subdirname.startswith('C'):
            FilesDirsStartingWithC.append(subdirname)

    # print all filenames.
    for filename in filenames:
        if filename.startswith('C'):
            FilesDirsStartingWithC.append(filename)

# print(FilesDirsStartingWithC)

# Use a for loop to walk through the home directory.
# for (dir, subdir, files) in subprocess.os.walk(home):

#################################
# Get files and directories in your home/ that start with either an
# upper or lower case 'C'

# Type your code here:

FilesDirsStartingWithCc = []


for dirname, dirnames, filenames in os.walk(home):
    # print all subdirectories first.
    for subdirname in dirnames:
        if subdirname.startswith(('C', 'c')):
            FilesDirsStartingWithCc.append(subdirname)

    # print all filenames.
    for filename in filenames:
        if filename.startswith(('C', 'c')):
            FilesDirsStartingWithCc.append(filename)

# print(FilesDirsStartingWithCc)


#################################
# Get only directories in your home/ that start with either an upper or
# ~lower case 'C'

# Type your code here:
DirsStartingWithCc = []


for dirname, dirnames, filenames in os.walk(home):
    # print all subdirectories first.
    for subdirname in dirnames:
        if subdirname.startswith(('C', 'c')):
            DirsStartingWithCc.append(subdirname)

print(DirsStartingWithCc)
