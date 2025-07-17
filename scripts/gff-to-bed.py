import sys
import re

# Usage: python gff_to_bed.py input.gff output.bed
gff_file = sys.argv[1]
bed_file = sys.argv[2]

with open(gff_file, "r") as infile, open(bed_file, "w") as outfile:
    for line in infile:
        if line.startswith("#"):
            continue
        fields = line.strip().split("\t")
        if len(fields) < 9:
            continue
        if fields[2] == "gene":
            chrom = fields[0]
            start = str(int(fields[3]) - 1)  # BED is 0-based
            end = fields[4]
            strand = fields[6]
            attributes = fields[8]
            match = re.search(r"Name=([^;]+)", attributes)
            name = match.group(1) if match else "NA"
            outfile.write(f"{chrom}\t{start}\t{end}\t{name}\t.\t{strand}\n")
