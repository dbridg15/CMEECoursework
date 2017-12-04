#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb

module load anaconda3/personal
module load intel-suite

echo "Running fw1316-HPC.R..."
R --vanilla < $WORK/dmb2417_HPC.R
mv dmb2417_cluster_run_* $WORK
echo "Run complete."
#EOF
