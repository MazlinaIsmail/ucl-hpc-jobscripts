#!/bin/bash -l

#$ -l h_rt=20:00:00
#$ -l mem=50G
#$ -l tmpfs=300G
#$ -pe smp 6

module load singularity-env

cd $TMPDIR
source $HOME/additional/dependencies.source
OUTPATH=$HOME/Scratch/output/$JOB_NAME
mkdir -p $OUTPATH

# parse param file to get variable
NUMBER=$SGE_TASK_ID
DIRNAME=$(sed -n ${NUMBER}p $PARAMFILE | awk '{print $2}')

$TIME --verbose singularity run --app preProcess $PCFSELECT_PREPROCESS -i $DIRNAME -o $OUTPATH -t $TMPDIR -n 10

