#!/bin/bash

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

