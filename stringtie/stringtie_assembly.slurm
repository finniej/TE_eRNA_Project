#!/bin/bash
#SBATCH --job-name=stringtie
#SBATCH --time=4:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=4
#SBATCH --output=stringtie_%A_%a.out
#SBATCH --error=stringtie_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ADDEMAIL@HERE.ca
#SBATCH --array=0-9

module load stringtie/2.2.3

# Define directories
BAM_DIR="$HOME/scratch/TEtranscripts/alignments"
OUT_DIR="$HOME/scratch/eRNA_IDO/stringtie/output"
GTF_REF="$HOME/scratch/TEtranscripts/Mus_musculus.GRCm39.114.gtf"
LOG_FILE="$HOME/scratch/eRNA_IDO/stringtie/eRNA_analysislog.txt"

mkdir -p "$OUT_DIR"

# Get list of BAM files
cd "$BAM_DIR"
BAM_FILES=(*_Aligned.sortedByCoord.out.bam)
BAM_FILE="${BAM_FILES[$SLURM_ARRAY_TASK_ID]}"
SAMPLE=$(basename "$BAM_FILE" _Aligned.sortedByCoord.out.bam)


# Log and run
{
  echo "[$(date)] Starting StringTie for $SAMPLE"

  stringtie "$BAM_FILE" \
    -o "$OUT_DIR/${SAMPLE}.gtf" \
    -p 4 \
    -G "$GTF_REF" \
    -f 0.05 \
    -c 1.5 \
    -t \
    -m 100 \
    --rf \
    -v

  echo "[$(date)] Finished $SAMPLE"
  echo "-------------------------------------------"
} | tee -a "$LOG_FILE"
