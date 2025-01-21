# FASTQ-to-FeatureCounts-Pipeline


This repository provides a streamlined pipeline for RNA-Seq analysis, starting with the download of FASTQ files from the NCBI Sequence Read Archive (SRA), and culminating in the extraction of a feature count matrix. The pipeline involves several key steps that ensure quality control, data processing, and alignment before counting the features.
The data consist of mRNA Sequencing of Alzheimer's disease, Human whole brain. The study involves Whole transcriptome sequencing revealing gene expression and splicing differences in brain regions affected by Alzheimer's disease. 
SRA Source: https://www.ncbi.nlm.nih.gov/sra/?term=SRR087416

**Tools Required:**

**FastQC:** A tool to check the quality of FASTQ files, identifying issues like adapter sequences, GC content, and read lengths.

**MultiQC:** A tool to aggregate results from multiple FastQC reports into a single report for better overview and comparison.

**Trimmomatic:** A tool for trimming low-quality bases and adapter sequences from reads.

**HISAT2:** A fast and sensitive alignment tool for mapping RNA-Seq reads to a reference genome, supporting strand-specific alignments.

**Samtools:** A suite of programs for manipulating high-throughput sequencing data, such as sorting and converting BAM files.

**RSeQC:** A tool to analyze RNA-Seq data, including strand specificity.

**featureCounts:** A tool to count the number of reads mapped to each genomic feature (e.g., exons or genes).

**SRA-Toolkit:** A tool to fetch the fastq file from the SRA accession number

**Bedops:** A tool required to convert .gtf file to .bed file to run RSeQC identifying the strand specificity 




**Process Pipeline:**

**1. Download FASTQ Files from SRA**
The first step in the pipeline is to retrieve RNA-Seq data in FASTQ format from the NCBI SRA. This data is typically in SRA format and must be converted to FASTQ for further processing. The relevant SRA identifier (e.g., SRR087416) is used to download the data.

**2. Quality Control with FastQC**
After downloading the FASTQ file, it is important to assess its quality to identify potential issues, such as poor base quality or adapter contamination. FastQC is used to perform quality control on the raw reads, providing a detailed report on the quality of the data.

**3. Aggregating Reports with MultiQC**
Once FastQC reports are generated for each FASTQ file, MultiQC is used to aggregate these reports into a single comprehensive summary. This overview allows for easy identification of potential issues across multiple files.

**4. Trimming Low-Quality Reads with Trimmomatic**
Trimming removes low-quality bases and adapter sequences from the reads. This step ensures that the reads used in downstream analysis are of high quality. The trimming process is performed based on a defined quality threshold (e.g., trimming reads with quality scores below a certain value).

**5. Post-Trimming Quality Control**
After trimming the reads, it is crucial to re-assess their quality. FastQC is run again on the trimmed data to ensure that the trimming process has improved the overall quality of the reads. MultiQC is used again to aggregate the trimmed data's quality control reports.

**6. Initial Alignment (Without Strand Information)**
The trimmed reads are aligned to a reference genome (e.g., GRCh38) using an alignment tool. This step maps the reads to the genome, and the result is stored in a BAM file. At this stage, strand-specific information is not considered (if unknown), providing a baseline alignment.

**7. Strand-Specific Information Identification (If Unknown)**
If the library's strand-specificity is not known, it can be inferred using an additional tool like RSeQC. This tool analyzes the alignment data and helps determine whether the reads come from the sense or antisense strand of the genome.

**8. Final Alignment (With Strand Information)**
Once strand-specific information is determined, the alignment is rerun, this time accounting for strand-specificity. This ensures that the RNA-Seq data is aligned correctly according to its biological context.

**9. Feature Counting with featureCounts**
After aligning the reads to the reference genome, the next step is to count the number of reads that map to each gene or feature (e.g., exons). This is achieved using the featureCounts tool, which generates a count matrix of feature occurrences based on the alignment data.

**10. Output the Feature Count Matrix**
The final output is a feature count matrix that contains the number of reads mapped to each gene or feature. This matrix can be used for downstream analysis, such as differential expression analysis, to compare gene expression across different conditions or samples.

**11. Track Time:**
The script tracks and reports the total time taken for the entire process in minutes and seconds.

**How to Use This Repository:** 
Clone the repository to your local machine. Ensure that the required R packages are installed. Run the analysis script to reproduce the results.

**Future Improvements:** 
Explore upstream and downstream analysis.

**Conclusion:**
By following this pipeline, you will be able to generate RNA-Seq feature counts starting from raw FASTQ data and obtain an overview of the sequencing quality, alignment results, and gene expression.
