#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=fastqc_trimmed_fastxclip
#SBATCH --time=04:00:00
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --output=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/%x-%j.out
#SBATCH --error=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/%x-%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu

echo "Starting fastqc SBATCH script $(date)"

echo "Loading environment and tools"
#fastqc requires OpenJDK/19.0.1
module load OpenJDK/19.0.1
module load fastqc/0.11.9

source ./config.cfg

echo "Project directory: " $BASE_DIR
echo "Fastq files location: " $FASTQDIR/trimmed_cutadapt_34minlen_egadapter/
echo "Fastqc output: " $FASTQC_OUT_DIR

mkdir -p $FASTQC_OUT_DIR

echo "Running fastqc in directory $FASTQDIR/trimmed_cutadapt_34minlen_egadapter"
fastqc $FASTQDIR/trimmed_cutadapt_34minlen_egadapter/*trimmed.fastq

echo "Cleaning up logs and output files"

mkdir -p $FASTQC_OUT_DIR/fastqc_trim_cutadapt_html $FASTQC_OUT_DIR/fastqc_trim_cutadapt_zip
mv $FASTQDIR/*fastqc.html $FASTQC_OUT_DIR/fastqc_trim_cutadapt_html
mv $FASTQDIR/*fastqc.zip $FASTQC_OUT_DIR/fastqc_trim_cutadapt_zip
