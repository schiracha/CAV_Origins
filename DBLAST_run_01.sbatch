#!/bin/bash
#SBATCH --time=15:00:00   # job time limit
#SBATCH --nodes=1   # number of nodes
#SBATCH --cpus-per-task=40   # number of CPU cores per task
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
blastdbcmd -entry  "$accession" -db "nr env_nr tsa_nr" -out  "$accession".fsa
  
#download ncbi databases to folder listed in ~/.ncbirc as BLASTDB environment variable
#update_blastdb.pl --decompress nr tsa_nr env_nr refseq_protein cdd_delta
  
#Search sequence in the databases using BLOSUM45
deltablast -db "nr tsa_nr env_nr cdd_delta" -query  "$accession".fsa -num_threads 40 -matrix BLOSUM62 \
-show_gis -num_alignments 20000 -export_search_strategy "${new_filename%.*}".strategy \
-num_iterations 3 -save_each_pssm -out_pssm outpssm.out -subject_besthit \
-outfmt "10 sskingdom staxids sacc ssciname evalue bitscore stitle qseqid sseqid pident length mismatch gapopen qstart qend sstart send" > "$new_filename"

#Creates files for non-opisthokonta proteins with their phyla

#awk -F "," 'NR > 1 {for (i=2; i<=4; i++) sub (/;.*$/, _, $i)} 1 {print $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7}' "${new_filename}" > "${new_filename%.*}"_short.out
#taxonkit lineage -i 1 "${new_filename%.*}"_short.out | awk -F ";" '{print $3}' >"${new_filename%.*}"_Phyla.out
#paste "${new_filename%.*}"_Phyla.out "${new_filename%.*}"_short.out >"${new_filename%.*}"_PhylaShort.out
#grep -iv opisthokont "${new_filename%.*}"_PhylaShort.out > N-O_HITS_"${accession}_$(printf %02d $counter)".out

awk -F "," 'NR > 1 {for (i=2; i<=4; i++) sub (/;.*$/, _, $i)} 1 {print $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7}' "${new_filename}" > "${new_filename%.*}"_short.out
taxonkit lineage -i 1 "${new_filename%.*}"_short.out | awk -F ";" '{print $4}' >"${new_filename%.*}"_Phyla.out
paste "${new_filename%.*}"_Phyla.out "${new_filename%.*}"_short.out >"${new_filename%.*}"_PhylaShort.out
grep -iv metazoa "${new_filename%.*}"_PhylaShort.out > HITS_"${accession}_$(printf %02d $counter)".out


#move PSSM files into archives
mkdir outpssm_"$(printf %02d $counter)"
mv outpssm.out* outpssm_"$(printf %02d $counter)"
