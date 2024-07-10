

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

Trim adapters
Illumina's website (https://support-docs.illumina.com/SHARE/AdapterSequences/Content/SHARE/AdapterSeq/Nextera/SequencesNextera_Illumina.htm) gives the following adapter sequences:

Nextera Transposase Adapters
The following transposase adapters are used for Nextera tagmentation.
Read 1
5′ TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG

Read 2
5′ GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGA

Command:
`cutadapt -a AACCGGTT -o output.fastq input.fastq`

Pass both adapters just to see what happens.

Test:
`cutadapt -a TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG -a GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGA -o 7141_S7_L001_R1_001_trimmed.fastq 7141_S7_L001_R1_001.fastq`

Process all:
```bash

for file in *1.fastq; do 
  base_name=($echo "${file%%.*}")
  cutadapt -a TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG -a GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGA -o ${base_name}_trimmed.fastq ${file} 1> ${base_name}_report.txt
done
 
```