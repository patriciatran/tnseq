#!/bin/bash

SAMPLE="$1"

bedtools bamtobed -i ${SAMPLE}_sorted.bam | awk 'BEGIN{OFS="\t"} {if ($6=="+") print $1, $2, $2+1; else print $1, $3-1, $3}' > ${SAMPLE}_insertions.bed
