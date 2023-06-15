#!/bin/bash -l

# nf-core rnaseq pipeline
# star-rsem
# grch37

#$ -S /bin/bash
#$ -l h_rt=48:00:00
#$ -l mem=10G
#$ -l tmpfs=10G
#$ -pe smp 1
#$ -wd /home/rebmism/Scratch/logfiles/single-job

cd $HOME/Scratch/logfiles/nf

shopt -s expand_aliases

module load blic-modules
module load nfcore/rnaseq/3.10.1

echo [$(date)] Start nf-core rnaseq pipeline .....
nfcore_rnaseq --input '/home/rebmism/Scratch/nextflow_req/arneo-pwb_sample_sheet_1.csv' --outdir $OUTPATH --multiqc_title 'arneo_pwb' --genome GRCh37 --aligner 'star_rsem' -resume
echo [$(date)] 

