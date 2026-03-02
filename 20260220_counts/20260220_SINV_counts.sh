#!/bin/bash
#SBATCH -J pipeline
#SBATCH --error=pipeline_%a_%j.err
#SBATCH -N 1 -n 8 -t 20:00:00 --mem=80G
#SBATCH --array=0-23

PARAMS=(1A 1B 1C 1D 1E 1F 1G 1H 2A 2B 2C 2D 2E 2F 2G 2H 3A 3B 3C 3D 3E 3F 3G 3H)
sample=${PARAMS[$SLURM_ARRAY_TASK_ID]}

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate /groups/as6282_gp/mmk2265/tools/conda/envs/align

inputdir="/groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/aligned"
gtf="/groups/as6282_gp/mmk2265/tools/annotations/SINV_J0236_1.gtf"
countsdir="/groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/counts"

echo "Processing $sample..."


# 2. IMMEDIATE featureCounts on fresh SAM
cd "$inputdir"

featureCounts -T 8 -p -s 2 -t exon -g gene_id -a "$gtf" -o "$countsdir/${sample}_SINV_counts.txt" "${sample}_SINV.sam"


