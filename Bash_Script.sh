#!/bin/bash

# Initialize SECONDS to track time
SECONDS=0

# Change working directory to ~/singlecell (if needed)
cd ~/singlecell/understandingfastq || exit

#This has been downloaded directly in terminal through conda so commented out-required reference genome and RSeQC for the alignment and indentifying strandedness
wget https://ftp.ensembl.org/pub/release-113/gtf/homo_sapiens/Homo_sapiens.GRCh38.113.gtf.gz                  
gunzip Homo_sapiens.GRCh38.113.gtf

#Downlaod sra, convert to fastq file with compression and unzip it- It has already been downaloaded hence commenting the script
prefetch SRR087416
fastq-dump --split-files --gzip SRR087416.sra
gunzip SRR087416.fastq.gz

# Run Fastqc on the fastq file and output results in the same directory
fastqc SRR087416/SRR087416.fastq -o SRR087416/
echo "fastqc ran successfully"

# Running multiqc and output result in the same directory
multiqc SRR087416/ -o SRR087416/
echo "multiqc ran successfully" 

#Run trimmoamtic with trailing reads of quality greater than 15: after review of fastqc and multiqc report
trimmomatic SE -threads 4 SRR087416/SRR087416.fastq SRR087416/trimmed/trimmed.fastq TRAILING:15 -phred33  
echo "Trimmomatic Run Successfully"

#Fastqc and multiqc report of trimmed report, to compare fastqc report of before and after trimming
fastqc SRR087416/trimmed/trimmed.fastq -o SRR087416/trimmed/
multiqc SRR087416/trimmed -o SRR087416/trimmed/
echo "fastqc and multiqc on trimmed fastq file ran successfully"

#Run alignment first  if strand information is not known- if known then directly apply the strandedness information in the alignment
hisat2 -x HISAT2/grch38/genome -U SRR087416/trimmed/trimmed.fastq | samtools sort -o HISAT2/trimmed.bam
echo "Initial alignment without strand information successfull"

#convert gtf to bed file to use RSeQC for checking strandedness
gtf2bed < Homo_sapiens.GRCh38.113.gtf > Homo_sapiens.GRCh38.113.bed

#Identifying the strand using RSeQC if information about library preparation is not available
Strandedness=$(infer_experiment.py -i HISAT2/trimmed.bam -r HISAT2/Homo_sapiens.GRCh38.113.bed)
echo "Stradedness: $Strandedness"

#Run alignment with knowledge of strandness from RSeQc
hisat2 --rna-strandness FR -x HISAT2/grch38/genome -U SRR087416/trimmed/trimmed.fastq | samtools sort -o HISAT2/Stran_trimmed.bam
echo "Final alignment ran successfully"

#Run feature counts to get the feature counts and the summary
featureCounts -S 1 -a HISAT2/Homo_sapiens.GRCh38.113.gtf -o Counts/featurecounts.txt HISAT2/Stran_trimmed.bam
echo "Feature count extraction ran succesfully"

# Calculate elapsed time and display it in minutes and seconds
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
