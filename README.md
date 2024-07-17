

## File locations
Nicole's mutants `/work/geisingerlab/Eddie/WGS2022-NR-bfmRS/fastq_Lane8`
Additional files from Eddie `/work/geisingerlab/Eddie/WGS2017-AB5075parentstrains`

## Fastqc to check reads

All sequences have red fail X in Fastqc for Adapter Content (matches Nextera Transposase Sequence)

## Remove adapters

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

Eddie sent this line used with fastx_clipper: 
clipoption="-a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -l 34 -d 0 -Q 33"

Made a list of Nicole's files to trim:
`find /work/geisingerlab/Eddie/WGS2022-NR-bfmRS/fastq_Lane8 -maxdepth 1 -name "**.fastq.gz" | grep "/N" >nra_samples_to_trim.txt`

Trimmed reads using cutadapt by 0_sbatch_trim_cutadapt.sh

Cutadapt usage resulted in several successful breseq runs, but some samples had an error when parsing the FASTQ file where some samples were "missing +NAME."  I had assumed this meant something weird happened with the trimming where some of the 

Some troubleshooting attempts:

From Breseq (breseq_array_nra_43283621_9.err)
```text
  READ FILE::NRA283_S93_L008_R1_001_trimmed
    Converting/filtering FASTQ file...
FASTQ sequence record does not contain +NAME line.
File /work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/input/fastq/NRA283_S93_L008_R1_001_trimmed.fastq
Line: 7064445

```


```bash

# Check lines in a range
sed -n '7064441, 7064449'p NRA283_S93_L008_R1_001_trimmed.fastq
# @D00780:546:CDCJ6ANXX:8:1204:2515:66607 1:N:0:CTCTCTAC+CTCTCTAT
#
# +
# 
# @D00780:546:CDCJ6ANXX:8:1204:2677:66664 1:N:0:CTCTCTAC+CTCTCTAT
# GGCACCATATACCCCAAATTGGACTCGACTCGAAATCATTTGTGGGAGGCCAAGTTTTGGACCTTGAGCTGCGTGTAAAGCCATGACGGCAGCACCAAAGC
# +
# BBBBBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
# @D00780:546:CDCJ6ANXX:8:1204:2919:66740 1:N:0:CTCTCTAC+CTCTCTAT

# Ah, maybe there were blank lines output by cutadapt??

```

Okay, if the problem is that some reads are being trimmed to a length of zero, we can tell cutadapt to keep only reads with a minimum length.
Use option -m

Retry clipping with fastx_clipper using parameters above.


FINAL ANALYSIS:

1. Trimmed adapters using fastx_clipper (installed as Conda env) with following options: `-a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -l 34 -d 0 -Q 33 `
2. Generated sample sheet using bash script
3. Ran Breseq array job.  Default Breseq settings.  Passed each of the following with a separate -r option:
REFERENCE_CHR=/work/geisingerlab/REFERENCES/CP008706.gbk
REFERENCE_PAB1=/work/geisingerlab/REFERENCES/p1AB5075.gbk
REFERENCE_PAB2=/work/geisingerlab/REFERENCES/p2AB5075.gbk
REFERENCE_PAB3=/work/geisingerlab/REFERENCES/p3AB5075.gbk
4. Zipped outputs using bash script 5_zip_all_outputs