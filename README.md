

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
Fastqc's adapter_list.txt file (https://github.com/golharam/FastQC/blob/master/Configuration/adapter_list.txt)lists the following for the Nextera adapter: 
Nextera Transposase Sequence				CTGTCTCTTATA

```bash
conda activate /work/geisingerlab/conda_env/cutadapt

# Previously moved untrimmed files to ./input/fastq/untrimmed.  Run this from untrimmed directory.
for file in *.fastq; do 
  base_name=($echo "${file%%.*}")
  cutadapt -a CTGTCTCTTATA -o ../${base_name}_trimmed.fastq ${file} 1> ../cutadapt_reports/${base_name}_report_adapterlist.txt
done
 
```

