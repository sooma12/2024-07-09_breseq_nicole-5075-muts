#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=trim-cutadapt
#SBATCH --time=06:00:00
#SBATCH --array=1-94%20
#SBATCH --cpus-per-task=1
#SBATCH --mem=200G
#SBATCH --output=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/trim-cutadapt/%x_%A_%a.out
#SBATCH --error=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/trim-cutadapt/%x_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu


source ./config.cfg

module load anaconda3/2021.05
eval "$(conda shell.bash hook)"
conda activate /work/geisingerlab/conda_env/cutadapt

file=`sed -n "$SLURM_ARRAY_TASK_ID"p fastqs_to_trim.list |  awk '{print $1}'`

output_dir=${FASTQDIR}/trimmed_cutadapt_34minlen_egadapter
mkdir -p $output_dir
mkdir -p ${FASTQDIR}/cutadapt_reports

echo "processing $file"
base_path=($echo "${file%%.*}")
base_name=$(basename $base_path)
cutadapt -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -m 34 -o $output_dir/${base_name}_cutadapt_trimmed.fastq.gz ${file} 1>${FASTQDIR}/cutadapt_reports/${base_name}_report_cutadapt.txt

echo "finished processing file"