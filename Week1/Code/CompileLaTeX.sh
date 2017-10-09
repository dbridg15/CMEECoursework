#!/bin/bash
# Author: David Bridgwood dmb2417@ic.ac.uk
# Script: CompileLaTeX.sh
# Desc: Compile LaTeX script to pdf and cleanup temporary files
# Arguments: none
# Date: Oct 2017


pdflatex $1.tex
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
evince $1.pdf &

##cleanup
rm*~
rm *.aux
rm *.dvi
rm *.log
rm *.nav
rm *.out
rm *.snm
rm $1.bbl
rm $1.bib
rm $1.blg
re *.toc






