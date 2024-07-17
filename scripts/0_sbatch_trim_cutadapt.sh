#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=trim-cutadapt
#SBATCH --time=04:00:00
#SBATCH --array=1-83%20
#SBATCH --cpus-per-task=1
#SBATCH --mem=100G
#SBATCH --output=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/temp/%x_%A_%a.out
#SBATCH --error=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/temp/%x_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu

# Cutadapt can handle gzipped files
# `find /work/geisingerlab/Eddie/WGS2022-NR-bfmRS/fastq_Lane8 -maxdepth 1 -name "**.fastq.gz" | grep "/N" | wc -l` gives 83 samples

source ./config.cfg

module load anaconda3/2021.05
eval "$(conda shell.bash hook)"
conda activate /work/geisingerlab/conda_env/cutadapt

file=`sed -n "$SLURM_ARRAY_TASK_ID"p nra_samples_to_trim.txt |  awk '{print $1}'`

echo "processing $file"
base_path=($echo "${file%%.*}")
base_name=$(basename $base_path)
cutadapt -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -m 34 -o ${FASTQDIR}/trimmed_cutadapt_34minlen_egadapter/${base_name}_minlen_trimmed.fastq.gz ${file} 1>${FASTQDIR}/cutadapt_reports/${base_name}_report_cutadapt_minlen_egadapter.txt

gunzip ${FASTQDIR}/trimmed_cutadapt_34minlen_egadapter/${base_name}_minlen_trimmed.fastq.gz

echo "finished processing file"