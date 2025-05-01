#!/bin/bash
#SBATCH --time=15:00:00   # job time limit
#SBATCH --nodes=1   # number of nodes
#SBATCH --cpus-per-task=40   # number of CPU cores per task
#SBATCH --partition=standard  # partition
#SBATCH -J "000XXXXX"   # job name
#SBATCH --mail-user=rts3dd@virginia.edu   # email address
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --account=cavorigins  # allocation name

#Load the module
module load blast

#Give the Accesssion for the sequence which will also be the output filename and a number
accession=000XXXXX

filename="$accession"
extension=out

counter=1  #can set counter to another number if runs are moved or deleted or simply to staart on a different number
new_filename="${filename}_$(printf %02d $counter).${extension}"

while [ -f "$new_filename" ]; do
  counter=$((counter + 1))
  new_filename="${filename}_$(printf %02d $counter).${extension}"
done

#download FASTA for sequence in question.  IF your accession return no result, you will need to manually make the fsa (FASTA_ file and comment this line out
blastdbcmd -entry  "$accession" -db nr -out  "$accession".fsa

#download ncbi databases to folder listed in ~/.ncbirc as BLASTDB environment variable. Make sure to set your BLAST_DB variable if you use this line.
#update_blastdb.pl --decompress nr tsa_nr env_nr refseq_protein cdd_delta

#Search sequence in the databases using BLOSUM45
blastp -db "nr tsa_nr env_nr" -query  "$accession".fsa -num_threads 40 -matrix BLOSUM45 \
-show_gis -max_target_seqs 20000 -export_search_strategy "${new_filename%.*}".strategy \
-outfmt "10 sskingdom staxids sacc ssciname stitle std" > "$new_filename"


#Gathers Phyla and creates file for NON-opisthokonta hits in a tab deliminated table

awk -F "," 'NR > 1 {for (i=2; i<=4; i++) sub (/;.*$/, _, $i)} 1 {print $2 "\t" $3 "\t" $4 "\t" $5 "\t" $16 "\t" $17}' "${new_filename}" \
>"${new_filename%.*}"_short.out

taxonkit lineage -i 1 "${new_filename%.*}"_short.out | awk -F ";" '{print $3}' >"${new_filename%.*}"_Phyla.out

paste "${new_filename%.*}"_Phyla.out "${new_filename%.*}"_short.out >"${new_filename%.*}"_PhylaShort.out

grep -iv opisthokont "${new_filename%.*}"_PhylaShort.out > N-O_HITS_"${accession}_$(printf %02d $$counter)".out
