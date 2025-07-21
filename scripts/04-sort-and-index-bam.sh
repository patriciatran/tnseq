#!/bin/bash

SAMPLE="$1"
STAGING="$3"
CPUS="$4"

samtools view -bS ${STAGING}/aligned/${SAMPLE}_trimmed_mapped.sam > ${STAGING}/aligned/${SAMPLE}_aligned.bam

samtools sort ${STAGING}/aligned/${SAMPLE}_aligned.bam -o ${STAGING}/aligned/${SAMPLE}_sorted.bam -@ ${CPUS}

samtools index ${STAGING}/aligned/${SAMPLE}_sorted.bam
