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

This repository contains scripts to analyze TnSeq data on the UW-Madison Center for High Throughput Computing. It contains a series of paired `sh` and `submit` files, containing the commands to be run, and the resources needed to run the job, respectively.
Helpers scripts (`.sh`, `.py`) are available to set up the project structure or summarize all the data at the end.

## Scripts folders
- `set_up.sh`: a bash script that takes in as an argument your netID and a project name. Will create all the input and output folder structure needed for this pipeline.
- `make_custom_dag.sh`: a bash script that will create a DAG for each sample
- `create_main_dag.sh`: a bash script that will create a "super DAG" based off the .dag files you created using `make_custom_dag.sh`.

-`01-cutadapt.sub`: cutadapt script that takes trim the adapter off of the FASTQ file. For example, `mysequenceADAPTERsomethingelse`, will keep `mysequence` only. 
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

1. Log into the server

```
ssh netid@ap2002.chtc.wisc.edu
# enter password
# make a copy of this github repository
git clone https://github.com/patriciatran/tnseq.git
```

2. Navigate to the tnseq folder, and enter the scripts folder
```
cd tnseq/scripts
ls
```

3. Create the folder structured for the input and output files. The script `set_up` needs two arguments: your `netID` and your project name. 
```
bash set_up.sh bbadger Set1
```
In the example above, `bbadger` is the netid and `Set1` is the projec name.
This will create the following folder structure:

```
/staging/bbadger/Set1
/staging/bbadger/Set1/data
/staging/bbadger/Set1/cutadapt
/staging/bbadger/Set1/aligned
/staging/bbadger/Set1/gff
/staging/bbadger/Set1/insertions
/staging/bbadger/Set1/alignment
```

4. You will need 3 input file types:
- Single end paired reads for each sample (e.g. `sample_R1_001.fastq.gz`)
- The reference genome, this can be a reference genome from NCBI (`reference.fasta`)
- A GFF annotation, which is a `gene feature files` that contains all the annotations of the reference genome. This can also be downloaded from NCBI (`reference.gff`). Make sure that the file name matches that of the fasta file, but just has a different file extension. For example, `Bacillus168.fasta` and `Bacillus168.gff`.

To transfer files from your computer onto the Staging folder, do the following.

Assuming that you have a folder on your laptop:
```
~/Downloads/data/sample1_R1_001.fastq.gz
~/Downloads/data/sample2_R1_001.fastq.gz
~/Downloads/data/sample3_R1_001.fastq.gz
~/Downloads/data/Bacillus168.fasta
~/Downloads/data/Bacillus168.gff
```

You can transfer the whole folder by typing this:
Open a new Terminal tab
```
cd ~/Downloads
scp -r data/* netid@ap2002.chtc.wisc.edu:/staging/netid/Set1/data/.
```

The `scp` command with the `-r` flag allows to transfer a whole folder.
The first argument `data` is the folder to be transferred. This is followed by a `space`. Then we use the netID login onto the server, followed by `:`, and then the path to where we want to transfer these files to. In this case, we want to transfer them into the `data` subfolder that we created in Step 3.

Change Terminal tabs for the one that you're logged into the server.
Make sure the files have been transferred correctly by listing the folder contents.

```
ls -lht /staging/bbadger/Set1/data
```

5. Next, we will create the DAG that defines the steps of our workflow. We will use the script `create_make_custom_dag` to automatically create this DAG file.

The `create_custom_dag.sh` script takes many arguments, in a very specific order.

`bash create_custom_dag.sh <samples_list> <netid> <adapter> <feature> <ref> <project>`

- `samples_list` is the list of samples found in `/staging/netid/project/data/`, without the file extension R1_001.fastq.gz.
- `netid`: your NetID
- `adapter`: the adapter sequence, specific to the TnSeq experiment. No quotation marks, just the sequence.
- `feature`: the feature of the GFF file to extract, when counting the sum of TA in those features. Commons ones are `gene`, `pseudogene` etc. To look at all the options open the GFF file and look at the 3rd column.
- `reference`: the name of the reference genome. reference.fasta or reference.gff
- `project`: the same name as in the set_up.sh script. 

This will create multiple files named `tnseq_SAMPLE.dag`

Here is an example of a command with arguments:

```
bash create_custom_dag.sh samples.txt bbadger ACAGGTTGGATGA gene Bacillus168 BothSets
```

5. Create a main DAG using `create_main_dag.sh`. This only takes two arguments: your samples.txt list and an output file name for the final DAG.

```
bash create_main_dag samples.txt BothSets.dag
```

This will create a file named `BothSets.dag`

5. Submit the workflow.

```
condor_submit_dag BothSets.dag
```

Wait for results to populate the /staging/netid/project/ folder.
You can close the terminal and come back - your jobs will automatically be submitted and ran.

6. Summarize the results. A script named `merged_files.sh` is available to help you summarize your results. This script takes 2 arguments: your `netid` and your `project` name.

```
bash merged_files.sh bbadger BothSets
```

This will create a file named `BothSets_merged_output.txt` containing all sum of insertations per feature across all the samples in the given project.

# Next Steps

Once the data is processed by this pipeline, note that these are the counts of insertions per feature (e.g. genes, etc.)

Some common steps after this would be to normalize the data by the total reads, or by the gene length, and finding out which genes are considered Essential or Non-Essential across samples. Genes with few or no transposons in them are usually considered Essential. Because, if there were transposons that fell into the gene, and disrupted function, yet the bacterial is still growing normally, it means that gene was not that important for the system to be studied to begin with. 

# List of softwares used

This workflow uses:

- Cutadapt v.5.1 


- Bowtie version 1 (v.1.3.1)

Langmead, B., Trapnell, C., Pop, M. et al. Ultrafast and memory-efficient alignment of short DNA sequences to the human genome. Genome Biol 10, R25 (2009). https://doi.org/10.1186/gb-2009-10-3-r25

- Samtools

Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R; 1000 Genome Project Data Processing Subgroup. The Sequence Alignment/Map format and SAMtools. Bioinformatics. 2009 Aug 15;25(16):2078-9. doi: 10.1093/bioinformatics/btp352. Epub 2009 Jun 8. PMID: 19505943; PMCID: PMC2723002.

- BedTools (v.2.27.1)

Quinlan AR, Hall IM. BEDTools: a flexible suite of utilities for comparing genomic features. Bioinformatics. 2010 Mar 15;26(6):841-2. doi: 10.1093/bioinformatics/btq033. Epub 2010 Jan 28. PMID: 20110278; PMCID: PMC2832824.

- Python

# Citation

This code and these instructions were written by Patricia Q. Tran for the project of Arunima Kalita.ß