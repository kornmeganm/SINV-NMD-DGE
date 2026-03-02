#!/bin/bash
# 
#SBATCH -J featureCounts                # Job name
#SBATCH -o featureCounts_%j.out           # Name of stdout output file (%j expands to jobId)
#SBATCH --error=featureCounts_%j.err              # Name of sterr output file (%j expands to jobId)
#SBATCH -N 1            # Total number of nodes requested
#SBATCH -n 5           # Total number of cpu requested
#SBATCH -t 18:00:00              # Run time (hh:mm:ss) - 11 hours 55 mins
#SBATCH --mem=60000 # memory in MB i.e. 20GB (fastx is not memory intensive)
#SBATCH --array=0-1
PARAMS=(1A  1B)

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate /groups/as6282_gp/mmk2265/tools/conda/envs/featureCounts

#create job information
inputdir="/groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/aligned"
gtf="/groups/as6282_gp/mmk2265/tools/annotations/Homo_sapiens.GRCh38.115.gtf.gz"

# Shared output directory (visible everywhere)
shared_output="/groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/counts"
mkdir -p "$shared_output"

# Process on localscratch (fast temp storage)
local_output="/localscratch/mmk2265/counts"
mkdir -p "$local_output"
# 1. Human counts
featureCounts -T 5 -p -s 2 -t exon -g gene_id -a "$gtf" -o "$local_output/counts.txt" "$inputdir"/*_hg38.sam

cp "$local_output/counts.txt" "$shared_output/"

