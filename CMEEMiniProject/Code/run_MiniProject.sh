#!/bin/bash

# Author:      David Bridgwood dmb2417@ic.ac.uk
# Script:      run_MiniProject.sh
# Description: runs CMEE MiniProject

###############################################################################
# run miniproject
###############################################################################

echo ""
echo "###############################################################################"
echo "# 01_sort_data.py"
echo "###############################################################################"
echo ""
python3 01_sort_data.py ../Data/GrowthRespPhotoData_new.csv

echo ""
echo "###############################################################################"
echo "# 02_NLLS.py"
echo "###############################################################################"
echo ""
python3 02_NLLS.py 3 25

echo ""
echo "###############################################################################"
echo "# 03_plots.R"
echo "###############################################################################"
echo ""
Rscript 03_plots.R 50

echo ""
echo "###############################################################################"
echo "# 04_figures.R"
echo "###############################################################################"
echo ""
Rscript 04_figures.R

echo ""
echo "###############################################################################"
echo "# compiling pdf of writeup"
echo "###############################################################################"
echo ""

pdflatex -quiet writeup.tex
bibtex writeup
pdflatex -quiet writeup.tex
pdflatex -quiet writeup.tex

mv writeup.pdf ../Results/

# delete all the rubbish
rm -f *~
rm -f *.aux
rm -f *.blg
rm -f *.log
rm -f *.nav
rm -f *.out
rm -f *.snm
rm -f *.toc
rm -f *.vrb
rm -f *.bbl
rm -f *.dvi
rm -f *.lot
rm -f *.lof

echo ""
echo "###############################################################################"
echo "# Its Finally Over!!"
echo "###############################################################################"
echo ""
