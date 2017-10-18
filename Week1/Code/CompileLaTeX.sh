#!/bin/bash
# Author: David Bridgwood dmb2417@ic.ac.uk
# Script: CompileLaTeX.sh
# Desc: Compile LaTeX script to pdf and cleanup temporary files
# Arguments: none
# Date: Oct 2017


pdflatex -output-directory ../Results $1.tex
pdflatex -output-directory ../Results $1.tex
bibtex $1
pdflatex -output-directory ../Results $1.tex
pdflatex -output-directory ../Results $1.tex
evince ../Results/$1.pdf &

##cleanup
rm -f ../Results/*~
rm -f ../Results/*.aux
rm -f ../Results/*.dvi
rm -f ../Results/*.log
rm -f ../Results/*.nav
rm -f ../Results/*.out
rm -f ../Results/*.snm
rm -f ../Results/$1.bbl
rm -f ../Results/$1.bib
rm -f ../Results/$1.blg
rm -f ../Results/*.toc
