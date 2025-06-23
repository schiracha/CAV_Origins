#!/bin/bash
#SBATCH --time=15:00:00
#SBATCH --nodes=1
#SBATCH -J "MakeJASON"
#SBATCH --cpus-per-task=8
#SBATCH --partition=standard
#SBATCH --mail-user=rts3dd@virginia.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --account=cavorigins

# Usage: ./make_json_from_blast.sh input_file output_file

# Check for required arguments
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 input_file output_file"
  exit 1
fi

input_file="$1"
output_file="$2"

# Step 1: Remove duplicates based on column 3
# Step 2: Add column 5 as numeric helper column
# Step 3: Sort by helper column
# Step 4: Remove helper column and save to output
awk -F'\t' '!seen[$3]++' "$input_file" | \
awk -F'\t' '{OFS="\t"; print $0, $5 + 0}' | \
sort -t$'\t' -k6,6n | \
cut -f1-5 > "$output_file"

# Load BLAST module
module load blast

# Set up paths and variables
BLAST_FILE="$output_file"
OUTPUT_DIR="$(pwd -P)/AF3_Seqs"
DB_DIR="/scratch/rts3dd/BLAST/reference_db"
DBS="nr env_nr tsa_nr"

mkdir -p "$OUTPUT_DIR"

# Extract unique accession numbers from column 3
cut -f3 "$BLAST_FILE" | sort | uniq > accessions.txt

# Loop through accession numbers
while read -r acc; do
    echo "Processing $acc..."

    # Fetch sequence from combined database
    SEQ=$(blastdbcmd -db "$DBS" -entry "$acc" -outfmt "%f" 2>/dev/null)

    if [[ -n "$SEQ" ]]; then
        echo "Found $acc"
        SEQ_ONLY=$(echo "$SEQ" | tail -n +2 | tr -d '\n')

        # Determine number of chains based on sequence length
        SEQ_LEN=${#SEQ_ONLY}
        if (( SEQ_LEN <= 465 )); then
            CHAINS=("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K")
        elif (( SEQ_LEN <= 512 )); then
            CHAINS=("A" "B" "C" "D" "E" "F" "G" "H" "I" "J")
        elif (( SEQ_LEN <= 1024 )); then
            CHAINS=("A" "B" "C" "D" "E")
        else
            CHAINS=("A" "B")
        fi

        # Convert array to JSON array string
        CHAIN_JSON=$(printf '"%s", ' "${CHAINS[@]}")
        CHAIN_JSON="[${CHAIN_JSON%, }]"

        # Create JSON input file
        cat <<EOF > "$OUTPUT_DIR/${acc}.json"
{
  "name": "$acc",
  "modelSeeds": [1, 2],
  "sequences": [
    {
      "protein": {
        "id": $CHAIN_JSON,
        "sequence": "$SEQ_ONLY",
        "unpairedMsa": "",
        "pairedMsa": "",
        "templates": []
      }
    }
  ],
  "dialect": "alphafold3",
  "version": 1
}
EOF
    else
        echo "Warning: $acc not found in any database." >> missing_accessions.log
    fi

done < accessions.txt

# Optional cleanup
rm accessions.txt

echo "Done. JSON files saved in $OUTPUT_DIR/"
