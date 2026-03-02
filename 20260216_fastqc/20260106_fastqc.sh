#!/bin/bash
# 
#SBATCH -J fastq_raw                # Job name
#SBATCH -o fastq_raw.%j.out           # Name of stdout output file (%j expands to jobId)
#SBATCH --error=fastq_raw.%j.err              # Name of sterr output file (%j expands to jobId)
#SBATCH -N 1            # Total number of nodes requested
#SBATCH -n 1           # Total number of cpu requested
#SBATCH -t 00:35:00              # Run time (hh:mm:ss) - 11 hours 55 mins
#SBATCH --mem=30000 # memory in MB i.e. 20GB (fastx is not memory intensive)
#SBATCH --array=0-10
PARAMS=(1H 2A 2B 2C 2D 2E 2F 2G 2H 3A 3G)

#create job information
outputdir="/localscratch/mmk2265/20260216_fastqc_raw"
mkdir -p "$outputdir"


shared_output="/groups/as6282_gp/mmk2265/20260216_fastqc/results"
mkdir -p "$shared_output"

module load conda
CONDA_BASE=$(conda info --base)
source "$CONDA_BASE/etc/profile.d/conda.sh"
conda activate js-env
#cd into tool directory
cd /groups/as6282_gp/mmk2265/tools/fastqc-0.12.1

#run command
./fastqc -t 4 /groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/${PARAMS[$SLURM_ARRAY_TASK_ID]}_R1_001.fastq.gz /groups/as6282_gp/data_bkup/mmk2265/20251208_SINV_RNAseq/${PARAMS[$SLURM_ARRAY_TASK_ID]}_R2_001.fastq.gz -o $outputdir
cp "$outputdir/${PARAMS[$SLURM_ARRAY_TASK_ID]}"* "$shared_output/" 
