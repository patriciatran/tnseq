#!/bin/bash
#arguments = $(sample) $(ref) $(staging) $(request_cpus)

SAMPLE="$1"
REF="$2"
STAGING="$3"
CPUS="$4"

ls -lht

bedtools bamtobed -i ${STAGING}/aligned/${SAMPLE}_sorted.bam > bamtobed_output.bed

ls -lht

python extract_insertions.py bamtobed_output.bed

# this creates a file insertions.bed

ls -lht
