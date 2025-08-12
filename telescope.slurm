#!/bin/bash
#SBATCH --job-name=telescope_all
#SBATCH --output=output/telescope_all_%j.out
#SBATCH --error=output/telescope_all_%j.err
#SBATCH --time=18:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ADDEMAIL@HERE.ca

# Load necessary modules
module load python/3.7.9

# Activate the Python virtual environment
# This script is designed for use with custom Telescope implementation found at https://github.com/finniej/telescope_noconda
source telescope-env-py39/bin/activate

echo "virtual env established" >> output/log.txt

# Loop through all BAM files in parent directory
for bamfile in ../archive/*.bam; do
    # Get base name without path or extension
    sample=$(basename "$bamfile" .bam)

    echo "Processing $sample" >> output/log.txt

    mkdir -p "output/telescope_${sample}"

    # Run Telescope
    telescope assign "$bamfile" ../annotations_mm39_locusID.gtf \
        --outdir "output/telescope_${sample}" \
        --attribute transcript_id

    echo "$sample completed" >> output/log.txt
done

# Deactivate the environment (optional)
deactivate
