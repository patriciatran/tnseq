#!/bin/bash

SAMPLE="$1"
CUTADAPT="$2"

cutadapt -g ^${CUTADAPT} \
	-o ${SAMPLE}_trimmed.fastq.gz \
	${SAMPLE}_R1_001.fastq.gz

ls -lht

echo "done cutadapt on ${SAMPLE}"
