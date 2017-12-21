#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb

# load the required modules (anaconda has R)
module load anaconda3/personal
module load intel-suite

# print that the run has started
echo "Running dmb2417_xHPC.R..."
# run the R script
R --vanilla < $WORK/dmb2417_HPC.R
# move the results back to $WORK directory
mv dmb2417_cluster_run_* $WORK
# print that job is complete
echo "Run complete."
#The end
