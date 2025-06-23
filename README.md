# CAV_Origins
BLAST+ SLURM scripts for searching for distant homologues in NCBI databases
AF3 SLURM scripts for creating repositories to run AF3 oligomer modeling and organize output

DBLAST_run_##.sbatch and DBLAST_run_multi.sbatch
  USE:
  Must use jobname and give accession number(s) as argument when using
  sbatch -J [job_name] DELTABLAST.sbatch [accession_code]
  (see bash script comments "#" for more details)
