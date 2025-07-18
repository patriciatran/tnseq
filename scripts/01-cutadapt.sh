#!/bin/bash

SAMPLE="$1"
CUTADAPT="$2"
CPUS="$3"

#before:mysequenceADAPTERsomething
#after:mysequence
#-a option removes the adapter and things downstreams

cutadapt -a ${CUTADAPT} \
	-o ${SAMPLE}_trimmed.fastq.gz -j ${CPUS}\
	${SAMPLE}_R1_001.fastq.gz

ls -lht

echo "done cutadapt on ${SAMPLE}"
