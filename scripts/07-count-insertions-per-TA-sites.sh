#!/bin/bash

SAMPLE="$1"
REF="$2"

bedtools coverage -a ${REF}_TA_sites.bed -b ${SAMPLE}_insertions.bed -counts > ${SAMPLE}_insertion_counts.bed
