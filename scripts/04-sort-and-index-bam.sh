#!/bin/bash

SAMPLE="$1"
STAGING="$3"
CPUS="$4"

samtools sort ${STAGING}/aligned/${SAMPLE}_aligned.bam -o ${STAGING}/aligned/${SAMPLE}_sorted.bam -@ ${CPUS}

samtools index ${STAGING}/aligned/${SAMPLE}_sorted.bam
