#!/bin/bash
#SBATCH -A cavorigins           # your allocation account
#SBATCH -p gpu               # partition
#SBATCH --gres=gpu:1         # number of GPUs
#SBATCH --cpus-per-task=8
#SBATCH -C "a100"  # compatible with A40, A6000, A100
#SBATCH -t 3-00:00:00          # time
#SBATCH --constraint=a100_80gb
#SBATCH --job-name=AF3_memtest

module purge
module load gcc/11.4.0 alphafold
mkdir $(pwd -P)/OUTPUT_MODELS



python $EBROOTALPHAFOLD/app/alphafold/run_alphafold.py \
    --db_dir=$ALPHAFOLD_DATA_PATH \
    --jax_compilation_cache_dir /scratch/rts3dd/jaxcache \
    --model_dir=/scratch/rts3dd/AF3 \
    --input_dir=$(pwd -P)/AF3_Seqs \
    --output_dir=$(pwd -P)/OUTPUT_MODELS
