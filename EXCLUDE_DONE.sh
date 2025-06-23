#!/bin/bash

# Usage: ./filter_by_column3.sh file1.txt file2.txt output.txt

file1="$1"
file2="$2"
output="$3"

# Extract column 3 values from file1 and store in an associative array
awk 'FNR==NR { seen[$3]; next } !($3 in seen)' "$file1" "$file2" > "$output"

echo "Filtered results saved to $output"

