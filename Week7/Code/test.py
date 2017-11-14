import os
# import sys
# import subprocess


for dirname, dirnames, filenames in os.walk('../../../'):
    # print all subdirectories first.
    for subdirname in dirnames:
        if subdirname.startswith('C'):
            print(subdirname)

    # print all filenames.
    for filename in filenames:
        if filename.startswith('C'):
            print(filename)
