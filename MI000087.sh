#!/bin/bash -l

#$ -l h_rt=20:00:00
#$ -l mem=10G
#$ -l tmpfs=30G
#$ -pe smp 10

cd $TMPDIR

module load singularity-env
export SINGULARITY_BINDPATH=/scratch/scratch/rebmism
export SINGULARITY_TMPDIR=$TMPDIR
export SINGULARITY_CACHEDIR=$TMPDIR
export SINGULARITY_LOCALCACHEDIR=$TMPDIR
export SINGULARITY_CLEANENV=1
source $HOME/additional/dependencies.source

# parse param file to get variable
NUMBER=$SGE_TASK_ID
PATIENT_ID=$(sed -n ${NUMBER}p $PARAMFILE | awk '{ print $2 }')

OUTPATH=$HOME/Scratch/output/$JOB_NAME/$PATIENT_ID
mkdir -p $OUTPATH

GERMLINE_ID=$(grep $PATIENT_ID".*germline" $SAMPLE_LST | awk '{ print $1 }')
TUMOUR_ID=$(grep $PATIENT_ID".*tumour" $SAMPLE_LST | awk '{ print $1 }')
# get path of input files
GL_PATH=$(find $PREPROCESS_OUTDIR -name $GERMLINE_ID"*bam")
T_PATH=$(find $PREPROCESS_OUTDIR -name $TUMOUR_ID"*bam")
# create temp file for sample info
LINE1="Patient\tTumour\tNormal\n"
LINE2="$PATIENT_ID\t$T_PATH\t$GL_PATH\n"
echo -e $LINE1$LINE2 >>$TMPDIR/sample_info.tsv

echo Start pcf-select for $PATIENT_ID at $(date)
$TIME --verbose singularity run --app PCFS $PCFSELECT_V3 -s $TMPDIR/sample_info.tsv -o $OUTPATH -t $TMPDIR -n 10 
echo Finish at $(date)


