#!/bin/bash
# Usage: ./remove_previous.sh compare1.txt compare2.txt ... -- input.txt output.txt

# Parse arguments
input=""
output=""
compare_files=()

# Separate compare_files from input and output using "--" as a delimiter
while [[ "$1" != "--" ]]; do
    compare_files+=("$1")
    shift
done

shift # skip the "--"
input="$1"
output="$2"

# Combine column 3 values from all compare_files into a temporary list
tmp_col3="col3_values.tmp"
> "$tmp_col3"  # empty the file

for f in "${compare_files[@]}"; do
    awk '{print $3}' "$f" >> "$tmp_col3"
done

# Use awk to filter input based on combined column 3 values
awk 'NR==FNR { seen[$1]; next } !($3 in seen)' "$tmp_col3" "$input" > "$output"

# Clean up
rm "$tmp_col3"

echo "Filtered results saved to $output"

