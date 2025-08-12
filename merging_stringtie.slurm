#!/bin/bash
#SBATCH --job-name=stringtie_merge
#SBATCH --time=2:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --output=stringtie_merge.out
#SBATCH --error=stringtie_merge.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ADDEMAIL@HERE.ca

module load stringtie/2.2.3

MERGE_LIST="$HOME/scratch/eRNA_IDO/stringtie/mergelist.txt"
OUTPUT="$HOME/scratch/eRNA_IDO/stringtie/merged_transcripts.gtf"
REF_GTF="$HOME/scratch/TEtranscripts/Mus_musculus.GRCm39.114.gtf"

stringtie --merge \
  -G "$REF_GTF" \
  -o "$OUTPUT" \
  "$MERGE_LIST"
