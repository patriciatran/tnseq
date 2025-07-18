#!/bin/bash
SAMPLE="$1"
REF="$2"
FEATURE="$3"

ls -lht 

bedtools map -a ${REF}_${FEATURE}.bed -b ${SAMPLE}_insertions_counts.bed -c 4 -o sum > ${SAMPLE}_gene_counts.bed

ls -lht
