#!/bin/bash

FOLDER_NAME="../AF3_Seqs/DONE"

# Check if the folder exists
if [ ! -d "$FOLDER_NAME" ]; then
    echo "Folder '$FOLDER_NAME' does not exist. Creating it now..."
    mkdir -p "$FOLDER_NAME"
    echo "Folder created successfully."
else
    echo "Folder '$FOLDER_NAME' already exists."
fi

# Generate a new log file name if it already exists
COUNT=1
while true; do
    LOG_FILE=$(printf "../AF3_Seqs/Moved_files_%02d.log" "$COUNT")

    if [ ! -f "$LOG_FILE" ]; then
        break  # Stop when we find an available filename
    fi

    ((COUNT++))
done

echo "Using log file: $LOG_FILE"

# Iterate over directories that contain ranking_scores.csv and move input files
while IFS= read -r dir; do 
    dir="${dir#./}"         # Remove leading './' to clean up names
    dir="${dir%/}"          # Remove trailing slash before processing
    FILE_NAME="../AF3_Seqs/${dir^^}.json"

    echo "Looking for: $FILE_NAME"  # Debugging output

    if [ -f "$FILE_NAME" ]; then
        mv "$FILE_NAME" "$FOLDER_NAME/"
        echo "Moved: $FILE_NAME to $FOLDER_NAME"
        echo "Moved: $FILE_NAME" >> "$LOG_FILE"
    else
        echo "Skipping: $FILE_NAME (not found)"
        echo "Skipping: $FILE_NAME (not found)" >> "$LOG_FILE"
    fi
done < <(find . -maxdepth 1 -type d -print)



echo "File move process completed. See '$LOG_FILE' for details."
