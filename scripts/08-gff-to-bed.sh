#!/bin/bash
REF="$1"
FEATURE="$2"

awk '$3 == "gene"' ${REF}.gff | awk 'BEGIN{OFS="\t"} {match($9, /Name=([^;]+)/, a); print $1, $4-1, $5, a[1], ".", $7}' > ${REF}_${FEATURE}.bed

