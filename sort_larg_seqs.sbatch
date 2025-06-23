#!/bin/bash
#SBATCH --time=15:00:00   # job time limit
#SBATCH --nodes=1   # number of nodes
#SBATCH -J "MovLong"
#SBATCH --cpus-per-task=8   # number of CPU cores per task
#SBATCH --partition=standard  # partition
#SBATCH --mail-user=rts3dd@virginia.edu   # email address
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --account=cavorigins  # allocation name

ml load  gcc/11.4.0  openmpi/4.1.4 python/3.11.4

# Create the 'large' subfolder if it doesn't exist
mkdir -p large

# Loop through all JSON files in the current directory
for file in *.json; do
  [ -e "$file" ] || continue

# Use Python to extract the sequence length
  sequence_length=$(python3 -c "
import json
with open('$file') as f:
    data = json.load(f)
    print(len(data['sequences'][0]['protein']['sequence']))
")

# Check if the sequence length is greater than 465
if [[ "$sequence_length" -gt 465 ]]; then
  echo "Moving $file (length: $sequence_length)"
  echo "Moving $file (length: $sequence_length)">>large_seqs.out
  mv "$file" large/
fi
done

echo "Done. Files with sequences > 465 have been moved to the 'large' folder."

