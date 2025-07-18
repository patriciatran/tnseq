# TnSeq

# Purpose
The purpose of the pipeline is to analyze TnSeq data. TnSeq data usually is in the form of single-end short reads. Overall the reads need to be trimmed and mapped onto a reference genome.
"TA" sites are identified across the whole reference genome. 
A series of steps are used to compile the number of reads mapped (count) onto TA sites accross the genome, and then narrowed down into segments of the genomes that are encoded by gene. 
Overall the final table is a table of Genes with the number of TA sites insertions across replicates.

# Input data
You will need single-end sequences, in the form of 
`{sample}_R1_001.fastq` per sample.

# File descriptions
this repository contains scripts to analyze TnSeq data on the UW-Madison Center for High Throughput Computing. It contains a series of paired `sh` and `submit` files, containing the commands to be run, and the resources needed to run the job, respectively.
Helpers scripts (`.sh`, `.py`) are available to set up the project structure or summarize all the data at the end.

## Scripts folders
- `set_up.sh`: a bash script that takes in as an argument your netID and a project name. Will create all the input and output folder structure needed for this pipeline.
-`01-cutadapt.sub`: cutadapt script that takes trim the adapter off of the FASTQ file. For example, `mysequenceADAPTERsomethingelse`, will keep mysequence only.
- `02-index_ref.sub`: Builds the genome index file for the reference genome, to prepare for mapping.
- `03-map-to-ref.sub`: Maps a sample to the reference genome.
- `04-sort-and-index-bam.sub`: Take the aligned reads, sorts and index the file.
- `05-find-TA.sub`: Find all instances of the "TA" in the reference genome.
    - `count-TA.py`: helper script
- `06-extract-insertion-sites.sub`: From the mapped file, get all the reads that overlap with "TA" in the reference genome.
- `07-count-insertions-per-TA-sites.sub`: Using the file in step 6, sum up how many reads (insertions) occur at each TA site.
- `08-gff-to-bed.sub`: Convert the GFF 
annotation file of the reference genome into a `bed` format file.
 - `gff-to-bed.py`: helper script
- `09-count-insertions-per-TA-sites-with-genes.sub`: Compiles the number of insertions (reads mapping to TA) among the genes (features) of the reference genome.
- `merge_files.sh`: Take all the files from step `09` for each sample and create 1 single table. Each column is a column.

# Example output file

The output of merge_files.sh should look like this: a file with at least 6 columns:
- Accession ID
- Start
- End
- Gene Name
- Something
- Orientation
- Followed by the number of samples analysed.

```
NC_000964.3	409	1750	dnaA	.	+	96	76	47	64	55	49
NC_000964.3	1938	3075	dnaN	.	+	7	11	13	6	4	9
NC_000964.3	3205	3421	rlbA	.	+	0	0	0	1	1	0
NC_000964.3	3436	4549	recF	.	+	6	5	8	4	10	4
NC_000964.3	4566	4812	remB	.	+	170	48	49	2	32	17
NC_000964.3	4866	6783	gyrB	.	+	33	53	34	15	24	27
NC_000964.3	6993	9459	gyrA	.	+	25	18	10	9	30	16
NC_000964.3	9809	11364	rrnO-16S	.	+	220	137	232	72	89	7

```

# Step by Step Instructions

> [!NOTE]
> Please make sure to have an account and a `staging` folder.

1. 
