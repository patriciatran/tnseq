import sys
from Bio import SeqIO
import matplotlib.pyplot as plt

# Check for input FASTA argument
if len(sys.argv) > 1:
    input_fasta = sys.argv[1]
    print(f"The argument provided is: {input_fasta}")
else:
    print("No argument was provided.")
    print("Usage: python your_script_name.py <reference.fasta>")
    sys.exit(1)

ta_positions = []

# Parse the FASTA and find TA sites
with open("TA_sites.bed", "w") as out:
    for record in SeqIO.parse(input_fasta, "fasta"):
        seq = str(record.seq).upper()
        for i in range(len(seq) - 1):
            if seq[i:i+2] == "TA":
                out.write(f"{record.id}\t{i}\t{i+2}\n")
                ta_positions.append(i)

# Create a plot of TA site positions
plt.figure(figsize=(12, 2))
plt.plot(ta_positions, [1]*len(ta_positions), '|', color='darkblue', markersize=10)
plt.title('TA Site Positions Along the Genome')
plt.xlabel('Genome Position (bp)')
plt.yticks([])
plt.tight_layout()
plt.savefig("TA_sites_plot.png", dpi=300)
plt.close()
print("Plot saved to TA_sites_plot.png")
