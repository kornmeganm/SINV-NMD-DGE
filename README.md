SINV-NMD-DGE: Transcriptomic Analysis of UPF1 in SINV Infection
This repository contains the bioinformatics pipeline and analysis scripts for investigating global gene expression changes during Sindbis Virus (SINV) infection, specifically focused on the role of UPF1.

Project Background
UPF1 is a central helicase in the Nonsense-Mediated mRNA Decay (NMD) pathway. In this study, we utilize a dTAG (degron) system to acutely degrade UPF1 to investigate its function during viral pathogenesis. Our findings indicate that UPF1 acts as a proviral factor; this analysis seeks to identify the host genetic pathways contributing to this phenotype.

Repository Structure
FASTQC_Fastp/: Contains scripts and results for raw read quality control and trimming.

R_Scripts/: Core analysis scripts using DESeq2 for differential gene expression (DGE).

Slurm_Scripts/: Batch scripts for high-performance computing (HPC) environments to handle alignment and quantification.

Metadata/: Sample sheets defining experimental conditions (Mock vs. SINV, +/- dTAG).

Analysis Workflow
1. Pre-processing
Raw sequencing reads are processed for quality control using FastQC and trimmed for adapters/low-quality bases using cutadapt.

See: FASTQC_Fastp/fastp.sh

2. Alignment & Quantification
Reads are mapped to the host genome (and SINV genome) using HISAT2 via the Slurm scripts provided in Slurm_Scripts/. Genes are quantified using featureCounts. 

3. Differential Gene Expression (DGE)
We utilize DESeq2 in R to perform statistical comparisons between:

Infection Status: SINV-infected vs. Mock-infected.

UPF1 Status: Control vs. dTAG-induced UPF1 degradation.

Interaction Effects: Identifying genes that respond differently to infection when UPF1 is absent.

Key Findings to Look For
The analysis in this repo specifically looks for:

Stability changes in known NMD targets during UPF1 degradation.

Correlation between host transcriptional shifts and viral titer reduction upon UPF1 degradation.

Setup & Requirements
To run the R analyses, you will need the following Bioconductor packages:

R
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install(c("DESeq2", "EnhancedVolcano", "clusterProfiler", "pheatmap"))
