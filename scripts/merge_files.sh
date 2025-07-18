#!/bin/bash

# Get sorted list of input files
files=($(ls /staging/ptran5/arunima/insertions/*gene_counts.bed | sort))

# Extract the first 6 columns from the first file as the base
cut -f1-6 "${files[0]}" > merged_tmp.txt

# Loop through each file and extract the 7th column, then paste to merged file
for f in "${files[@]}"; do
    echo "Processing $f"
    cut -f7 "$f" > "${f}.col7"
    paste merged_tmp.txt "${f}.col7" > merged_tmp2.txt
    mv merged_tmp2.txt merged_tmp.txt
done

# Save final output
mv merged_tmp.txt merged_output.txt

# Optional: remove intermediate column files

