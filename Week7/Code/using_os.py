#!/usr/bin/env python3

"""Script to find all files and subdirectories beggining with C or c in the home
directory
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# imports
import subprocess


# Get the user's home directory.
home = subprocess.os.path.expanduser("~")


################################################################################
# files and directories starting with C
################################################################################

# Create an empty list to store the results.
FilesDirsStartingWithC = []

for dirname, dirnames, filenames in subprocess.os.walk(home):
    # print all subdirectories first.
    for subdirname in dirnames:
        if subdirname.startswith('C'):  # if it starts with C add it to list
            FilesDirsStartingWithC.append(subdirname)

    # print all filenames.
    for filename in filenames:
        if filename.startswith('C'):
            FilesDirsStartingWithC.append(filename)

# print number of files/directories found!
print("All Files and Directories starting with C: \n",
      len(FilesDirsStartingWithC), "files and directories found \n")
# print(*FilesDirsStartingWithC, sep = '\n')
print("\n")


################################################################################
# files and directories starting with C or c
################################################################################

FilesDirsStartingWithCc = []


for dirname, dirnames, filenames in subprocess.os.walk(home):
    # print all subdirectories first.
    for subdirname in dirnames:
        if subdirname.startswith(('C', 'c')):
            FilesDirsStartingWithCc.append(subdirname)

    # print all filenames.
    for filename in filenames:
        if filename.startswith(('C', 'c')):
            FilesDirsStartingWithCc.append(filename)

print("All files and Directories Starting with C or c: \n",
      len(FilesDirsStartingWithCc), "files and directories found \n")
# print(*FilesDirsStartingWithCc, sep = '\n')
print("\n")

################################################################################
# directories starting with C or c
################################################################################

DirsStartingWithCc = []


for dirname, dirnames, filenames in subprocess.os.walk(home):
    # print all subdirectories first.
    for subdirname in dirnames:
        if subdirname.startswith(('C', 'c')):
            DirsStartingWithCc.append(subdirname)

print("All Directories starting with C: \n",
      len(DirsStartingWithCc), "Directories found \n")
# print(*DirsStartingWithCc, sep = '\n')
