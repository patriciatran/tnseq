#!/bin/bash
SAMPLE="$1"
REF="$2"
STAGING="$3"
CPUS="$4"

# BOWTIE 1 only!

#Map reads with Bowtie1. We recommend using most standard flags, with the following modifications: use best,
#try hard, discard reads mapping to multiple locations, and have the output be in map format (as the calc_fit tool
#only takes inputs in this format). The number of allowed mismatches can be fiddled with, but should be relatively
#low to prevent false mapping.
# BOWTIE1 is more sensitive than BOWTIE2 for short reads.

bowtie -t -v 3 \
	-a -m 1 --best --tryhard \
	--strata ${STAGING}/data/${REF}_index \
	${SAMPLE}_trimmed.fastq.gz \
	${SAMPLE}_trimmed_mapped.sam

#bowtie2 -x ${STAGING}/data/${REF}_index \
#	-U ${SAMPLE}_trimmed.fastq.gz \
#	-p ${CPUS} \
#	-N 0 \
#	-s 0 \
#	-L 17  | samtools view -bS - > ${SAMPLE}_aligned.bam
