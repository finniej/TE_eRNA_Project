#!/bin/bash
#SBATCH --job-name=star_align
#SBATCH --output=../logs/star_align_%j.out
#SBATCH --error=../logs/star_align_%j.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ADDEMAIL@HERE.ca

module load star/2.7.11b
module load samtools/1.17

THREADS=8

# Set directories
TRIMMED_DIR=../trimmed_data
OUT_DIR=../alignments/trimmed
LOG_FILE=../logs/analysis_log.txt
GENOME_DIR=../reference/STAR_index

echo "$(date): Starting STAR alignment on paired-end trimmed data" >> "$LOG_FILE"

# Loop through all R1 paired files
for R1 in ${TRIMMED_DIR}/*_R1_paired.fastq.gz
do
    # Derive sample base name (removes _R1_paired.fastq.gz)
    SAMPLE=$(basename "$R1" _R1_paired.fastq.gz)
    R2=${TRIMMED_DIR}/${SAMPLE}_R2_paired.fastq.gz

    # Log which sample is being processed
    echo "$(date): Aligning sample ${SAMPLE}" >> "$LOG_FILE"

    # Run STAR paired-end alignment
    STAR --runThreadN $THREADS \
         --genomeDir "$GENOME_DIR" \
         --readFilesIn "$R1" "$R2" \
         --readFilesCommand zcat \
         --outFileNamePrefix ${OUT_DIR}/${SAMPLE}_ \
         --outSAMtype BAM SortedByCoordinate \
         --outSAMunmapped Within \
         --outFilterMultimapNmax 100 \
         --winAnchorMultimapNmax 200 \
         --outFilterMatchNminOverLread 0.3 \
         --outFilterMatchNmin 30

    # Index the output BAM file
    BAM_FILE=${OUT_DIR}/${SAMPLE}_Aligned.sortedByCoord.out.bam
    echo "$(date): Indexing BAM file ${BAM_FILE}" >> "$LOG_FILE"
    samtools index "$BAM_FILE"

    # Log completion of sample
    echo "$(date): Finished alignment and indexing of ${SAMPLE}" >> "$LOG_FILE"

done

# Log end of alignment step
echo "$(date): Completed all STAR alignments and indexing" >> "$LOG_FILE"
[jmfinnie@gra-login1 scratch]$
