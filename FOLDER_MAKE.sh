#!/bin/bash

# Prompt for the input file
read -p "Enter the path to the text file with folder names: " input_file

# Check if the input file exists
if [[ ! -f "$input_file" ]]; then
  echo "Error: File '$input_file' not found!"
  exit 1
fi

# Prompt for files to copy (space-separated)
read -p "Enter the path(s) to the file(s) to copy into each folder (space-separated): " -a files_to_copy

# Check if each file exists
for file in "${files_to_copy[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found!"
    exit 1
  fi
done

# Loop through each line in the input file
while IFS= read -r line || [[ -n "$line" ]]; do
  # Create a directory named after the line
  mkdir -p "$line"

  # Copy each specified file into the new directory
  for file in "${files_to_copy[@]}"; do
    cp "$file" "$line/"
  done
done < "$input_file"

echo "All folders created and files copied successfully."

