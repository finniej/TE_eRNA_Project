#!/bin/bash
#SBATCH --job-name=stringtie_eRNA
#SBATCH --time=4:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=4
#SBATCH --output=stringtie_eRNA_%A_%a.out
#SBATCH --error=stringtie_eRNA_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ADDEMAIL@HERE.ca
#SBATCH --array=0-9

module load stringtie/2.2.3

# Directories
BAM_DIR="$HOME/scratch/TEtranscripts/alignments"
OUT_DIR="$HOME/scratch/eRNA_IDO/stringtie/eRNA_quant"
FILTERED_GTF="$HOME/scratch/eRNA_IDO/stringtie/filtered_merged.gtf"
LOG_FILE="$HOME/scratch/eRNA_IDO/stringtie/eRNA_analysislog.txt"

mkdir -p "$OUT_DIR"

# Get BAM files
cd "$BAM_DIR"
BAM_FILES=(*_Aligned.sortedByCoord.out.bam)
BAM_FILE="${BAM_FILES[$SLURM_ARRAY_TASK_ID]}"
SAMPLE=$(basename "$BAM_FILE" _Aligned.sortedByCoord.out.bam)

{
  echo "[$(date)] Starting eRNA quantification for $SAMPLE"

  stringtie "$BAM_FILE" \
    -o "$OUT_DIR/${SAMPLE}_eRNA.gtf" \
    -p 4 \
    -G "$FILTERED_GTF" \
    -e -B \
    -A "$OUT_DIR/${SAMPLE}_eRNA_abund.tab"

  echo "[$(date)] Finished eRNA quantification for $SAMPLE"
  echo "-------------------------------------------"
} | tee -a "$LOG_FILE"
