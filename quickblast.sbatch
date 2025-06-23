#!/bin/bash
#SBATCH --time=15:00:00   # job time limit
#SBATCH --nodes=1   # number of nodes
#SBATCH --cpus-per-task=8   # number of CPU cores per task
#SBATCH --partition=standard  # partition
#SBATCH --mail-user=rts3dd@virginia.edu   # email address
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --account=cavorigins  # allocation name

#Load the module

module load blast


#download FASTA for sequence in question
blastdbcmd -entry  "Q03135,CAF6771178,CAH9912286" -db "nr env_nr tsa_nr" -out  test.fsa
