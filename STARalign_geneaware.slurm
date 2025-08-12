#!/bin/bash
#SBATCH --job-name=TEtranscripts_align
#SBATCH --output=logs/star_final_align_%A_%a.out
#SBATCH --error=logs/star_final_align_%A_%a.err
#SBATCH --time=8:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ADDEMAIL@HERE.ca
#SBATCH --array=1-10

module load star/2.7.11b
module load samtools

THREADS=8

# Set directories
PROJECT_DIR=~/scratch/ADDDIRECTORY
cd "$PROJECT_DIR"

TRIMMED_DIR=$PROJECT_DIR/seqs
OUT_DIR=$PROJECT_DIR/final_alignments
LOG_FILE=$PROJECT_DIR/logs/analysis_log.txt
GENOME_DIR=$PROJECT_DIR/STAR_index
SAMPLE_PATH=$(sed -n "${SLURM_ARRAY_TASK_ID}p" samples.txt)
SAMPLE=$(basename "$SAMPLE_PATH")

echo "$(date): Starting STAR alignment on paired-end trimmed data" >> "$LOG_FILE                                                                                                             "

R1=${TRIMMED_DIR}/${SAMPLE}_R1_paired.fastq.gz
R2=${TRIMMED_DIR}/${SAMPLE}_R2_paired.fastq.gz

echo "$(date): Aligning sample ${SAMPLE}" >> "$LOG_FILE"

# Run STAR paired-end alignment
STAR --runThreadN $THREADS \
        --genomeDir "$GENOME_DIR" \
        --readFilesIn "$R1" "$R2" \
        --readFilesCommand zcat \
        --outFileNamePrefix ${OUT_DIR}/${SAMPLE}_ \
        --outSAMtype BAM SortedByCoordinate \
        --outSAMunmapped Within KeepPairs \
        --outFilterMultimapNmax 100 \
        --winAnchorMultimapNmax 100 \
        --outFilterMatchNminOverLread 0.3 \
        --outFilterMatchNmin 30 \
        --outFilterMismatchNmax 999 \
        --outFilterMismatchNoverReadLmax 0.04 \
        --outSAMstrandField intronMotif \
        --alignSJoverhangMin 8 \
        --alignSJDBoverhangMin 1 \
        --alignIntronMin 20 \
        --sjdbScore 1 \
        --alignIntronMax 1000000 \
        --alignMatesGapMax 1000000 \
        --outSAMattributes Standard \
        --outFilterType BySJout


# Index the output BAM file
BAM_FILE=${OUT_DIR}/${SAMPLE}_Aligned.sortedByCoord.out.bam
echo "$(date): Indexing BAM file ${BAM_FILE}" >> "$LOG_FILE"
samtools index "$BAM_FILE"

# Log completion of sample
echo "$(date): Finished alignment and indexing of ${SAMPLE}" >> "$LOG_FILE"
