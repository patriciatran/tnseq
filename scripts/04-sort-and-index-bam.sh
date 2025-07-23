#!/bin/bash

SAMPLE="$1"
STAGING="$3"
CPUS="$4"

ls -lht

samtools sort ${SAMPLE}_aligned.bam -o ${SAMPLE}_sorted.bam -@ ${CPUS}

ls -lht

samtools index -@ ${CPUS} ${SAMPLE}_sorted.bam

ls -lht
