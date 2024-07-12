#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=trimmomatic
#SBATCH --time=02:00:00
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --output=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/%x-%j.log
#SBATCH --error=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/logs/%x-%j.err
#SBATCH --mail-type=END
#SBATCH --mail-user=soo.m@northeastern.edu

# Load trimmomatic and java
module load oracle_java/jdk1.8.0_181
module load trimmomatic/0.39

# path to NU Discovery cluster's Trimmomatic program folder with Illumina adapters
PATH_TO_TRIMMOMATIC="/shared/centos7/anaconda3/2021.11/envs/BINF-12-2021/pkgs/trimmomatic-0.39-hdfd78af_2/share/trimmomatic-0.39-2"

## Initialize variables to contain file suffixes and output paths
inSuffix="_R1_001.fastq"
outSuffix="_trimmo-trimmed_R1.fastq"

FASTQ_DIR=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/input/fastq/untrimmed
FASTQ_TRIM_OUT=/work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/input/fastq/paired

mkdir -p $FASTQ_TRIM_OUT
# Loop through all the left-read fastq files in INDIR
for file in ${FASTQ_DIR}*${inSuffix}
do
  # Remove path from filename
  pathRemoved="${file/"$FASTQ_DIR"/}"
  # Remove left-read suffix, leaving the name of the sample
  sampleName="${pathRemoved/$inSuffix/}"
  echo Trimming $sampleName
  # Use sample name derived from shell replacement to trim left AND right reads
  java -jar /shared/centos7/trimmomatic/0.39/trimmomatic-0.39.jar PE \
  -threads 1 -phred33 \
  $FASTQ_DIR$sampleName$inSuffix \
  $FASTQ_TRIM_OUT$sampleName$outSuffix \
  ILLUMINACLIP:$PATH_TO_TRIMMOMATIC/adapters/NexteraPE-PE.fa:2:30:10
done
