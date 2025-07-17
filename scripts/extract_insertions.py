#!/usr/bin/env python3

import sys

# Usage check
if len(sys.argv) != 2:
    print("Usage: python extract_insertions.py <bamtobed_output.bed>", file=sys.stderr)
    sys.exit(1)

input_bed = sys.argv[1]
output_bed = "insertions.bed"

with open(input_bed, "r") as infile, open(output_bed, "w") as outfile:
    for line in infile:
        fields = line.strip().split("\t")
        if len(fields) < 6:
            continue  # skip malformed lines
        chrom, start, end, name, score, strand = fields[:6]

        if strand == "+":
            insertion_start = int(start)
            insertion_end = insertion_start + 1
        else:
            insertion_end = int(end)
            insertion_start = insertion_end - 1
            if insertion_start < 0:
                continue  # BED coordinates must be >= 0

        outfile.write(f"{chrom}\t{insertion_start}\t{insertion_end}\n")
