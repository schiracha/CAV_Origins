#!/bin/bash

# Check if at least three arguments are provided
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <input_file> <output_file> <word1> [word2] [word3] ..."
    exit 1
fi

# Assign arguments to variables
input_file="$1"
output_file="$2"

# Shift the first two arguments so that remaining arguments are the words to exclude
shift 2

# Use grep to exclude lines containing any of the provided words
#grep -v -E "$(printf "|%s" "$@")" "$input_file" > "$output_file"
grep -v -E "$(printf "%s|" "$@" | sed 's/|$//')" "$input_file" > "$output_file"

echo "Filtered lines (excluding '$*') saved to $output_file"

