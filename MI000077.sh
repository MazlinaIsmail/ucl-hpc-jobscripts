#!/bin/bash -l

# STAR-Arriba

#$ -l h_rt=12:00:00
#$ -l mem=100G
#$ -l tmpfs=100G
#$ -pe smp 8
#$ -wd /home/rebmism/Scratch/logfiles/array-job

cd $TMPDIR
source $HOME/additional/dependencies.source

OUTDIR=$HOME/Scratch/output/$JOB_NAME
mkdir -p $OUTDIR

NUMBER=$SGE_TASK_ID
R1=$(sed -n ${NUMBER}p $PARAMFILE | awk '{print $2}')
R2=${R1/_1P/_2P}
FILENAME=${R1##*/}
LABEL=${FILENAME%%\.*}

$STARv2_7_8a \
--runThreadN 8 \
--genomeDir $HOME/Scratch/output/MI000076_1/STAR_index_GRCh37_GENCODE19 --genomeLoad NoSharedMemory \
--readFilesIn $R1 $R2 \
--readFilesCommand zcat --outStd BAM_Unsorted --outSAMtype BAM Unsorted --outSAMunmapped Within --outBAMcompression 0 --outFilterMultimapNmax 50  \
--peOverlapNbasesMin 10 --alignSplicedMateMapLminOverLmate 0.5 --alignSJstitchMismatchNmax 5 -1 5 5 --chimSegmentMin 10 --chimOutType WithinBAM HardClip \
--chimJunctionOverhangMin 10 --chimScoreDropMax 30 --chimScoreJunctionNonGTAG 0 --chimScoreSeparation 1 --chimSegmentReadGapMax 3 --chimMultimapNmax 50 |
$ARRIBA \
-x /dev/stdin \
-o $OUTDIR/$LABEL.fusions.tsv \
-O $OUTDIR/$LABEL.fusions.discarded.tsv \
-a $HOME/Scratch/output/MI000076_1/GRCh37.fa \
-g $HOME/Scratch/output/MI000076_1/GENCODE19.gtf \
-f blacklist,known_fusions

