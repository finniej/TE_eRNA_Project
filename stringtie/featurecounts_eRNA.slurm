#!/bin/bash
#SBATCH --job-name=featurecounts_eRNA
#SBATCH --time=2:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --output=featurecounts_eRNA_%j.out
#SBATCH --error=featurecounts_eRNA_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ADDEMAIL@HERE.ca

# Load the Subread module 
module load subread/2.0.6

# Define directories and files
BAM_DIR="$HOME/scratch/TEtranscripts/alignments"
GTF="$HOME/scratch/eRNA_IDO/stringtie/filtered_merged.gtf"
OUT_FILE="$HOME/scratch/eRNA_IDO/eRNA_counts/featurecounts_eRNA_raw.txt"
LOG_FILE="$HOME/scratch/eRNA_IDO/stringtie/eRNA_analysislog.txt"

# Create output directory
mkdir -p "$(dirname "$OUT_FILE")"

# Log and run featureCounts
{
  echo "[$(date)] Starting featureCounts for eRNA"
  echo "GTF annotation: $GTF"
  echo "Output file: $OUT_FILE"
  echo "Input BAM files:"
  ls "$BAM_DIR"/*_Aligned.sortedByCoord.out.bam
  echo "-------------------------------------------"

  featureCounts \
  -a "$GTF" \
  -o "$OUT_FILE" \
  -t exon \
  -g gene_id \
  -p \
  -s 0 \
  --ignoreDup \
  -O \
  --fraction \
  -T 8 \
  "$BAM_DIR"/*_Aligned.sortedByCoord.out.bam



  echo "[$(date)] Finished featureCounts"
  echo "-------------------------------------------"
} | tee -a "$LOG_FILE"
