#!/bin/bash
#SBATCH --job-name=star_index
#SBATCH --output=../logs/star_index.out
#SBATCH --error=../logs/star_index.err
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=addemailhere@mail.ca

module load star/2.7.11b

PROJECT_DIR=~/ADDDIRECTORY
LOGFILE=$PROJECT_DIR/analysis_log.txt

cd $PROJECT_DIR/reference

# Log start
echo "$(date): Starting STAR genome index build." >> $LOGFILE

STAR --runThreadN 8 \
     --runMode genomeGenerate \
     --genomeDir ./ADDDIRECTORY \
     --genomeFastaFiles ADDREFERENCEGENOME \

# Log completion
echo "$(date): Completed STAR genome index build. Output dir: reference/STAR_index" >> $LOGFILE
