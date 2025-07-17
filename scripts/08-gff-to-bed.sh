#!/bin/bash
REF="$1"
FEATURE="$2"

echo ${REF}
echo ${FEATURE}

ls -lht

python gff-to-bed.py ${REF}.gff ${REF}_${FEATURE}.bed

head ${REF}_${FEATURE}.bed

ls -lht
