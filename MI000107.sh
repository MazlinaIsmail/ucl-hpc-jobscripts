#!/bin/bash -l

# nf-core rnaseq pipeline
# default: star-salmon
# genome grch37

#$ -S /bin/bash
#$ -l h_rt=48:00:00
#$ -l mem=10G
#$ -l tmpfs=10G
#$ -pe smp 1
#$ -wd /home/rebmism/Scratch/logfiles/single-job

shopt -s expand_aliases

# load source file to point to genome v38
# currently not working
# source $HOME/additional/dependencies_nfcore_rnaseq.source
module load blic-modules
module load nfcore/rnaseq/3.10.1

echo [$(date)] Start nf-core rnaseq pipeline .....
nfcore_rnaseq --input '/home/rebmism/Scratch/nextflow_req/arneo-pwb_sample_sheet.csv' --outdir $OUTPATH --multiqc_title 'arneo_pwb' --genome GRCh37 -resume
echo [$(date)] 

