#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=fastqc
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
echo "Fastq files location: " $FASTQDIR
echo "Fastqc output: " $FASTQC_OUT_DIR
echo "Scripts found in: " $SCRIPT_DIR

mkdir -p $FASTQDIR $FASTQC_OUT_DIR $SCRIPT_DIR

echo "Running fastqc in directory $FASTQDIR"
fastqc $FASTQDIR/*.fastq

echo "Cleaning up logs and output files"
mkdir -p $SCRIPT_DIR/logs
mv $SCRIPT_DIR/fastq_breseq_* $SCRIPT_DIR/logs
mkdir -p $FASTQC_OUT_DIR/fastqc_html $FASTQC_OUT_DIR/fastqc_zip
mv $FASTQDIR/*fastqc.html $FASTQC_OUT_DIR/fastqc_html
mv $FASTQDIR/*fastqc.zip $FASTQC_OUT_DIR/fastqc_zip
