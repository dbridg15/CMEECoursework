#!/usr/bin/env python3

"""Script takes a csvfile containing 2 DNA sequence and returns the best
alignment
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# imports
import csv
import sys


# function that computes a score by returning the number of matches
# starting from given arbitrary startpoint

def calculate_score(s1, s2, l1, l2, startpoint):
    """Takes two DNA sequences, their lengths and a given starting point and
    calculates the number of matching base pairs"""

    # startpoint is the point at which we want to start

    matched = ""  # contains string for alignement
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            # if its matching the character
            if s1[i + startpoint] == s2[i]:
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # build some formatted output
    # print("." * startpoint + matched)
    # print("." * startpoint + s2)
    # print(s1)
    # print(score)
    # print("")

    return score


# function computes the highest alignment score by passing the sequences through
# calculate_score at every possible start point

def best_score(seq1, seq2):
    """Takes two DNA sequences and passes through calculate_score to return
    the best possible alignment and alignment score"""

    # assign the longest sequence s1, and the shortest to s2
    # l1 is the length of the longest, l2 that of the shortest

    l1 = len(seq1)
    l2 = len(seq2)
    if l1 >= l2:
        s1 = seq1
        s2 = seq2
    else:
        s1 = seq2
        s2 = seq1
        l1, l2 = l2, l1  # swap the two lengths

    my_best_align = None
    my_best_score = -1

    # for all possible staring points calculate score and if it is the best yet
    # replace exisiting my_best_score and my_best_align

    for i in range(l1):
        z = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score:
            my_best_align = "." * i + s2
            my_best_score = z

    return [my_best_align, s1, my_best_score]


# function takes csv file with two DNA sequences as input and passes though
# best_score, returning the best possible alignment and corrosponding score into
# output file align_results.txt, saved in this weeks Results folder
#'../Data/align_seq.csv'
def main(argv):
    """Takes a given csv file with two DNA seqences and passes through
    best_score to determine the best possible alignment"""

    filename = file_function(argv)

    with open(filename, 'r') as csvfile:
        csvread = csv.reader(csvfile)
        for entry in csvread:
            seq1 = entry[0]
            seq2 = entry[1]
    x = best_score(seq1, seq2)

    f = open('../Results/align_results.txt', 'w')
    f.write('Best Alignment: \n\n' + x[0] + '\n' + x[1] + '\n\n'
            + 'Alignment Score: ' + str(x[2]))
    f.close()
    print('Best Alignment: \n\n' + x[0] + '\n' + x[1] + '\n\n'
          + 'Alignment Score: ' + str(x[2]))



def file_function(argv):
    """Takes filename given else returns default"""
    if len(argv) > 1:
        print('Relative path given \n')
        return str(argv[1])
    else:
        print('Relative path not given, default usedn \n')
        return str('../Data/align_seq.csv')


if __name__ == '__main__':
    status = main(sys.argv)
    sys.exit(status)
