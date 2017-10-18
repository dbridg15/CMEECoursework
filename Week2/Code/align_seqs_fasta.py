#!/usr/bin/env python3

"""I dont understand the if __name__=='__main__' bit!!!!
Author: David Bridgwood"""

__author__ = 'David Bridgwood (dmb2417@ic.ac.uk)'
__version__ = '0.0.1'


# imports
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

def main(argv):
    """Takes 2 fasta files containing DNA sequences as input and returns the
    best possible alignment and score"""

    files = file_function(argv)
    file1 = files[0]
    file2 = files[1]

    # Open the file strip off \n characters and add each line but the first
    # to the sequence
    with open(file1, 'r') as seq1_raw:
        meta1 = ''
        seq1 = ''

        line = seq1_raw.readline()
        while line:
            line = line.rstrip()
            if '>' in line:
                meta1 = line
            else:
                seq1 = seq1 + line
            line = seq1_raw.readline()

    with open(file2, 'r') as seq2_raw:
        meta2 = ''
        seq2 = ''

        line = seq2_raw.readline()
        while line:
            line = line.rstrip()
            if '>' in line:
                meta2 = line
            else:
                seq2 = seq2 + line
            line = seq2_raw.readline()

    best = best_score(seq1, seq2)

    with open('../Results/align_fasta_results.txt', 'w') as f:
        f.write('Best Alignment: \n\n' + best[0] + '\n' + best[1] + '\n\n'
                + 'Alignment Score: ' + str(best[2]))

#    print(meta1 + '\n' + meta2)
#    print('Best Alignment: \n\n' + best[0] + '\n' + best[1] + '\n\n'
#          + 'Alignment Score: ' + str(best[2]))


def file_function(argv):
    """Takes filenames given unless none are in which case returns defaults"""
    if len(argv) == 3:
        print("Relative paths given \n")
        return (str(argv[1]), str(argv[2]))
    elif len(argv) == 2:
        print("Only one file given, Please provide two fasta files")
        sys.exit(0)
    else:
        print("No files given. Defaults used")
        return ('../../Week1/Data/fasta/407228326.fasta',
                '../../Week1/Data/fasta/407228412.fasta')


if __name__ == '__main__':
    status = main(sys.argv)
    sys.exit(status)
