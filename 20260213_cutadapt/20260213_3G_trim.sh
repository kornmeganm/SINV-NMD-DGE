#!/bin/bash
# 
#SBATCH -J cutadapt                # Job name
#SBATCH -o cutadapt_%j.out           # Name of stdout output file (%j expands to jobId)
#SBATCH --error=cutadapt_%j.err              # Name of sterr output file (%j expands to jobId)
#SBATCH -N 1            # Total number of nodes requested
#SBATCH -n 5           # Total number of cpu requested
#SBATCH -t 09:55:00              # Run time (hh:mm:ss) - 11 hours 55 mins
#SBATCH --mem=30000 # memory in MB i.e. 20GB (fastx is not memory intensive)
#SBATCH --array=0
PARAMS=(3G)

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate /groups/as6282_gp/mmk2265/tools/conda/envs/cutadapt

echo "cutadapt at: $(which cutadapt)"

#create job information
inputdir="/groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq"
adapterR1="AGATCGGAAGAGC"  #NextNEB_Adapter_R1
adapterR2="AGATCGGAAGAGC"  #NextNEB_Adapter_R2

# Shared output directory (visible everywhere)
shared_output="/groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/trimmed"
mkdir -p "$shared_output"

# Process on localscratch (fast temp storage)
local_output="/localscratch/mmk2265/trimmed"
mkdir -p "$local_output"


cutadapt -j 5 -a $adapterR1 -A $adapterR2 -q 10 -m 16 -o $local_output/${PARAMS[$SLURM_ARRAY_TASK_ID]}_R1_trimmed.fastq.gz -p $local_output/${PARAMS[$SLURM_ARRAY_TASK_ID]}_R2_trimmed.fastq.gz $inputdir/${PARAMS[$SLURM_ARRAY_TASK_ID]}_R1_001.fastq.gz $inputdir/${PARAMS[$SLURM_ARRAY_TASK_ID]}_R2_001.fastq.gz > $local_output/${PARAMS[$SLURM_ARRAY_TASK_ID]}_cutadapt.log

cp "$local_output/${PARAMS[$SLURM_ARRAY_TASK_ID]}"* "$shared_output/"
