#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=finish-breseq-fastx
#SBATCH --time=08:00:00
#SBATCH --array=1-25%5
#SBATCH --cpus-per-task=1
#SBATCH --mem=400G
#SBATCH --output=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/%x_%A_%a.out
#SBATCH --error=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/%x_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu

source ./config.cfg

module load anaconda3/2021.05
eval "$(conda shell.bash hook)"
conda activate /work/geisingerlab/conda_env/breseq_env

unfinished_samples_array=(276 280 281 282 283 285 287 289 290 293 294 298 304 306 308 309 310 311 313 314 319 331 342 345 351)

echo "Reference genome files: " $REFERENCE_CHR $REFERENCE_PAB1 $REFERENCE_PAB2 $REFERENCE_PAB3
echo "Breseq output saved to: " $BRESEQ_OUTPATH/breseq-fastx

mkdir -p $BRESEQ_OUTPATH/breseq-fastx

echo breseq -r ${REFERENCE_CHR} -r ${REFERENCE_PAB1} -r ${REFERENCE_PAB2} -r ${REFERENCE_PAB3} -o $BRESEQ_OUTPATH/breseq-fastx/NRA${unfinished_samples_array[$"$SLURM_ARRAY_TASK_ID"]} /work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/input/fastq/trimmed_fastxclip/NRA${unfinished_samples_array[$"$SLURM_ARRAY_TASK_ID"]}_S167_L008_R1_001_fastxclipper_trimmed.fastq
