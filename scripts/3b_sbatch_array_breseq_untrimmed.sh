#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=breseq_array_untrimmed
#SBATCH --time=04:00:00
#SBATCH --array=1-11%12
#SBATCH --cpus-per-task=1
#SBATCH --mem=100G
#SBATCH --output=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/%x_%A_%a.out
#SBATCH --error=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/%x_%A_%a.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu

source ./config.cfg

echo "Starting breseq SBATCH script $(date)"

echo "Loading environment and tools"
module load anaconda3/2021.05
eval "$(conda shell.bash hook)"
conda activate /work/geisingerlab/conda_env/breseq_env
SAMPLE_SHEET_UNTRIM=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/input/fastq/untrimmed/sample_sheet_untrim.txt

echo "Reference genome files: " $REFERENCE_CHR $REFERENCE_PAB1 $REFERENCE_PAB2 $REFERENCE_PAB3
echo "Sample sheet: " $SAMPLE_SHEET_UNTRIM
echo "Breseq output saved to: " $BRESEQ_OUTPATH

mkdir -p $BRESEQ_OUTPATH

# Run breseq
# -r options specify reference genome(s)
# Pass fastq files as positional arguments after reference genome files

name=`sed -n "$SLURM_ARRAY_TASK_ID"p $SAMPLE_SHEET_UNTRIM |  awk '{print $1}'`
r1=`sed -n "$SLURM_ARRAY_TASK_ID"p $SAMPLE_SHEET_UNTRIM |  awk '{print $2}'`

echo "Running breseq on file $r1"
breseq -r ${REFERENCE_CHR} -r ${REFERENCE_PAB1} -r ${REFERENCE_PAB2} -r ${REFERENCE_PAB3} -o ${BRESEQ_OUTPATH}/${name} ${r1}

echo "breseq script complete $(date)"
