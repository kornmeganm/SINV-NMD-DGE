#!/bin/bash
#SBATCH -J pipeline
#SBATCH --error=pipeline_%a_%j.err
#SBATCH -N 1 -n 8 -t 20:00:00 --mem=80G
#SBATCH --array=0-23

PARAMS=(1A 1B 1C 1D 1E 1F 1G 1H 2A 2B 2C 2D 2E 2F 2G 2H 3A 3B 3C 3D 3E 3F 3G 3H)
sample=${PARAMS[$SLURM_ARRAY_TASK_ID]}

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate /groups/as6282_gp/mmk2265/tools/conda/envs/align

inputdir="/groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/trimmed"
hg38_index="/groups/as6282_gp/mmk2265/tools/genomes/Homo_sapiens/UCSC/hg38/Sequence/hg38/genome"
gtf="/groups/as6282_gp/mmk2265/tools/annotations/Homo_sapiens.GRCh38.115.gtf.gz"
shared_output="/groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/aligned"
local_output="/localscratch/mmk2265/align"
countsdir="/groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/counts"
mkdir -p "$local_output" "$countsdir" "$shared_output"

echo "Processing $sample..."

# 1. Human alignment
hisat2 -x "$hg38_index" -1 "$inputdir/${sample}_R1_trimmed.fastq.gz" -2 "$inputdir/${sample}_R2_trimmed.fastq.gz" --un-conc "$local_output/${sample}_unaligned.fastq" --threads 8 --rna-strandness RF -S "$local_output/${sample}_hg38.sam"

# 2. IMMEDIATE featureCounts on fresh SAM
cd /localscratch/mmk2265/align

featureCounts -T 8 -p -s 2 -t exon -g gene_id -a "$gtf" -o "$countsdir/counts.txt" "${sample}_hg38.sam"


# 4. CLEANUP (frees ~70GB per sample!)
rm "$local_output/${sample}_hg38.sam" "$local_output/${sample}_unaligned.*.fastq"


