## File locations
Nicole's mutants `/work/geisingerlab/Eddie/WGS2022-NR-bfmRS/fastq_Lane8`
Additional files from Eddie `/work/geisingerlab/Eddie/WGS2017-AB5075parentstrains`

## Fastqc to check reads

All sequences have red fail X in Fastqc for Adapter Content (matches Nextera Transposase Sequence)

## Programs

Install cutadapt

```bash
srun --partition=express --nodes=1 --cpus-per-task=2 --pty --time=00:60:00 /bin/bash
module load anaconda3/2021.05
conda create --prefix /work/geisingerlab/conda_env/cutadapt
# Deal with CommandNotFoundError: Your shell has not been properly configured to use 'conda activate'.
conda init bash
source ~/.bashrc

conda activate /work/geisingerlab/conda_env/cutadapt

conda config 
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict

conda install -p /work/geisingerlab/conda_env/cutadapt cutadapt

cutadapt --version
```

## Trim fastq reads with both fastx_clipper and cutadapt

Make lists of files to trim.  Note, all fastqs provided by Eddie are gzipped.

Gunzipped all fastq files in `/work/geisingerlab/Eddie/WGS2022-NR-bfmRS/fastq_Lane8` and `/work/geisingerlab/Eddie/WGS2017-AB5075parentstrains` to `./input/fastq/untrimmed`

In `./`, made a list of files to trim using:

`find /work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/input/fastq/untrimmed -maxdepth 1 -type f -name '*.fastq' >fastqs_to_trim.list`

Trimmed reads using cutadapt by 0a and 0b scripts.

Both scripts used adapter `CTGTCTCTTATACACATCTCCGAGCCCACGAGAC` provided by Eddie, and set the minimum read length to keep at 34.

fastx_clipper options `-a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -l 34 -d 0 -Q 33`

cut adapt options `-a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -m 34`

## Sample sheet prep



## breseq


