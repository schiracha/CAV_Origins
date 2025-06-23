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

#Give the Accesssion for the sequence which will also be the output filename and a number

accession=${1?Usage: $0 <accession>}

filename="$accession"
extension=out

counter=1
new_filename="${filename}_$(printf %02d $counter).${extension}"

while [ -f "$new_filename" ]; do
  counter=$((counter + 1))
  new_filename="${filename}_$(printf %02d $counter).${extension}"
done

#download FASTA for sequence in question
blastdbcmd -entry  "$accession" -db "nr env_nr tsa_nr" -out  MULTIFASTA.fsa

