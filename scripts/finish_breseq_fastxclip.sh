#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=breseq
#SBATCH --time=04:00:00
#SBATCH -N 2
#SBATCH -n 2
#SBATCH --mem=200G
#SBATCH --output=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/%x_%y.out
#SBATCH --error=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/%x_%y.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu

source ./config.cfg

module load anaconda3/2021.05
eval "$(conda shell.bash hook)"
conda activate /work/geisingerlab/conda_env/breseq_env

breseq -r ${REFERENCE_CHR} -r ${REFERENCE_PAB1} -r ${REFERENCE_PAB2} -r ${REFERENCE_PAB3} -o output/breseq/trimmed_fastxclip/NRA277 ./input/fastq/trimmed_fastxclipper_egadapter/NRA275_S168_L008_R1_001_trimmed.fastq
breseq -r ${REFERENCE_CHR} -r ${REFERENCE_PAB1} -r ${REFERENCE_PAB2} -r ${REFERENCE_PAB3} -o output/breseq/trimmed_fastxclip/NRA295 ./input/fastq/trimmed_fastxclipper_egadapter/NRA295_S105_L008_R1_001_trimmed.fastq
breseq -r ${REFERENCE_CHR} -r ${REFERENCE_PAB1} -r ${REFERENCE_PAB2} -r ${REFERENCE_PAB3} -o output/breseq/trimmed_fastxclip/NRA296 ./input/fastq/trimmed_fastxclipper_egadapter/NRA296_S106_L008_R1_001_trimmed.fastq
breseq -r ${REFERENCE_CHR} -r ${REFERENCE_PAB1} -r ${REFERENCE_PAB2} -r ${REFERENCE_PAB3} -o output/breseq/trimmed_fastxclip/NRA297 ./input/fastq/trimmed_fastxclipper_egadapter/NRA297_S107_L008_R1_001_trimmed.fastq
breseq -r ${REFERENCE_CHR} -r ${REFERENCE_PAB1} -r ${REFERENCE_PAB2} -r ${REFERENCE_PAB3} -o output/breseq/trimmed_fastxclip/NRA299 ./input/fastq/trimmed_fastxclipper_egadapter/NRA299_S109_L008_R1_001_trimmed.fastq

