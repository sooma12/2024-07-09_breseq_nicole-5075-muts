#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=trim-fastx
#SBATCH --time=06:00:00
#SBATCH --array=1-94%20
#SBATCH --cpus-per-task=1
#SBATCH --mem=200G
#SBATCH --output=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/trim_fastxclip/%x_%A_%a.out
#SBATCH --error=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/trim_fastxclip/%x_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu


source ./config.cfg

module load anaconda3/2021.05
eval "$(conda shell.bash hook)"
conda activate /work/geisingerlab/conda_env/fastx

file=`sed -n "$SLURM_ARRAY_TASK_ID"p fastqs_to_trim.list |  awk '{print $1}'`

mkdir -p ${FASTQDIR}/trimmed_fastxclip/

echo "processing $file"
base_path=($echo "${file%%.*}")
base_name=$(basename $base_path)

fastx_clipper -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -l 34 -d 0 -Q 33 -i $file -o ${FASTQDIR}/trimmed_fastxclip/${base_name}_fastxclipper_trimmed.fastq

echo "finished processing file"
