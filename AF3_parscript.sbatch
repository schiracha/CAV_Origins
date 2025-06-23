#!/bin/bash
#SBATCH --job-name=af3_array
#SBATCH --array=0-9
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --output=logs/af3_%A_%a.out
#SBATCH --allocation=cavorigins

module load AlphaFold/3.0.1

INPUT_DIR="/path/to/json_inputs"
OUTPUT_DIR="/path/to/outputs"
DB_DIR="/path/to/databases"
MODEL_DIR="/path/to/models"

INPUT_FILES=($INPUT_DIR/*.json)
INPUT_FILE=${INPUT_FILES[$SLURM_ARRAY_TASK_ID]}

python run_alphafold.py \
  --json_path="$INPUT_FILE" \
  --output_dir="$OUTPUT_DIR" \
  --db_dir="$DB_DIR" \
  --model_dir="$MODEL_DIR"

