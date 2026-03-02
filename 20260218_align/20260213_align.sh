#!/bin/bash
# 
#SBATCH -J hisat3n                # Job name           # Name of stdout output file (%j expands to jobId)
#SBATCH --error=hisat3n_%j.err              # Name of sterr output file (%j expands to jobId)
#SBATCH -N 1            # Total number of nodes requested
#SBATCH -n 5           # Total number of cpu requested
#SBATCH -t 18:00:00              # Run time (hh:mm:ss) - 11 hours 55 mins
#SBATCH --mem=60000 # memory in MB i.e. 20GB (fastx is not memory intensive)
#SBATCH --array=0-21
PARAMS=(1C  1D  1E  1F  1G  1H  2A  2B  2C  2D  2E  2F  2G  2H  3A  3B  3C  3D  3E  3F  3G  3H)

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate /groups/as6282_gp/mmk2265/tools/conda/envs/hisat-3n

#create job information
inputdir="/groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/trimmed"

# Shared output directory (visible everywhere)
shared_output="/groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/aligned"
mkdir -p "$shared_output"

# Process on localscratch (fast temp storage)
local_output="/localscratch/mmk2265/aligned"
mkdir -p "$local_output"

# 1. Human alignment (HISAT-3N)
hisat2 -x /groups/as6282_gp/mmk2265/tools/genomes/Homo_sapiens/UCSC/hg38/Sequence/hg38/genome -1 "$inputdir/${PARAMS[$SLURM_ARRAY_TASK_ID]}_R1_trimmed.fastq.gz" -2 "$inputdir/${PARAMS[$SLURM_ARRAY_TASK_ID]}_R2_trimmed.fastq.gz" -S "$local_output/${PARAMS[$SLURM_ARRAY_TASK_ID]}_hg38.sam" --un-conc "$local_output/${PARAMS[$SLURM_ARRAY_TASK_ID]}_unaligned.fastq" --threads 5 --rna-strandness RF

hisat2 -x /groups/as6282_gp/mmk2265/tools/genomes/SINV/SINV_AR339 -1 "$local_output/${PARAMS[$SLURM_ARRAY_TASK_ID]}_unaligned.1.fastq" -2 "$local_output/${PARAMS[$SLURM_ARRAY_TASK_ID]}_unaligned.2.fastq" -S "$local_output/${PARAMS[$SLURM_ARRAY_TASK_ID]}_SINV.sam" --threads 5 --rna-strandness RF

cp "$local_output/${PARAMS[$SLURM_ARRAY_TASK_ID]}_SINV.sam" "$shared_output/"
rm "${PARAMS[$SLURM_ARRAY_TASK_ID]}_*.fastq"


