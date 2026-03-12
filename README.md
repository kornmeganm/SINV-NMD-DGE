SINV-NMD-DGE: Transcriptomic Analysis of UPF1 in SINV Infection
This repository contains the bioinformatics pipeline and analysis scripts for investigating global gene expression changes during Sindbis Virus (SINV) infection, specifically focused on the role of UPF1.

Project Background
UPF1 is a central helicase in the Nonsense-Mediated mRNA Decay (NMD) pathway. In this study, we utilize a dTAG (degron) system to acutely degrade UPF1 to investigate its function during viral pathogenesis. Our findings indicate that UPF1 acts as a proviral factor; this analysis seeks to identify the host genetic pathways contributing to this phenotype.

Repository Structure
The analysis is organized chronologically. Each directory contains the specific shell/R scripts used, along with the resulting log files and output data.

20260106_fastqc/: Initial quality control of raw sequencing reads.

20260213_cutadapt/: Adapter trimming and filtering of low-quality reads.

20260218_align/: Mapping reads to the host and SINV genomes.

20260220_counts/: Generation of the gene-level count matrix.

Analysis Workflow
1. Pre-processing
Raw sequencing reads are processed for quality control using FastQC and trimmed for adapters/low-quality bases using cutadapt.

See: 20260106_fastqc/20260106_fastqc.sh and 20260213_cutadapt/20260107_trim.sh

2. Alignment & Quantification
Reads are mapped to the host genome (and SINV genome) using HISAT2. Genes are quantified using featureCounts.

See: 20260218_align/20260219_align_count.sh and 20260218_align/20260218_SINV_align.sh and 20260220_SINV_counts.sh

Key Findings to Look For
The analysis in this repo specifically looks for:

Stability changes in known NMD targets during UPF1 degradation.

Correlation between host transcriptional shifts and viral titer reduction upon UPF1 degradation.

