#!/bin/bash
STAGING="$1"
REF="$2"

bowtie-build ${STAGING}/data/${REF}.fasta ${STAGING}/data/${REF}_index
