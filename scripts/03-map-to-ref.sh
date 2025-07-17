#!/bin/bash
SAMPLE="$1"
REF="$2"
STAGING="$3"
CPUS="$4"

bowtie2 -x ${STAGING}/data/${REF}_index -U ${SAMPLE}_trimmed.fastq.gz -p ${CPUS} | samtools view -bS - > ${SAMPLE}_aligned.bam
