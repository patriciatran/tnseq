#!/bin/bash
REF="$1"
echo "Ref is $REF"

pip install matplotlib
pip install biopython

python3 count_TA.py ${REF}.fasta

ls -lht
