## File locations
Nicole's mutants `/work/geisingerlab/Eddie/WGS2022-NR-bfmRS/fastq_Lane8`
Additional files from Eddie `/work/geisingerlab/Eddie/WGS2017-AB5075parentstrains`

## Fastqc to check reads

All sequences have red fail X in Fastqc for Adapter Content (matches Nextera Transposase Sequence)

## Programs

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

## Trim fastq reads with both fastx_clipper and cutadapt

Make lists of files to trim.  Note, all fastqs provided by Eddie are gzipped.

Gunzipped all fastq files in `/work/geisingerlab/Eddie/WGS2022-NR-bfmRS/fastq_Lane8` and `/work/geisingerlab/Eddie/WGS2017-AB5075parentstrains` to `./input/fastq/untrimmed`

In `./`, made a list of files to trim using:

`find /work/geisingerlab/Mark/breseq/2024-07-09_breseq_nicole-5075-muts/input/fastq/untrimmed -maxdepth 1 -type f -name '*.fastq' >fastqs_to_trim.list`

Trimmed reads using cutadapt by 0a and 0b scripts.

Both scripts used adapter `CTGTCTCTTATACACATCTCCGAGCCCACGAGAC` provided by Eddie, and set the minimum read length to keep at 34.

fastx_clipper options `-a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -l 34 -d 0 -Q 33`

cut adapt options `-a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -m 34`

## fastqc

Checked trimmed files with fastqc using scripts 1a, 1b

## Sample sheet prep

Used scripts 2a, 2b to prepare sample sheets with names and file paths corresponding to fastq samples

## breseq

Re-sequencing analysis performed using breseq with default settings 

## Analysis


### Check number of output directories and compare to number of input fastqs.

In trimmed fastq directories: `find ./  -type f -name '*.fastq' | wc -l`

untrimmed -> **94**

trimmed_fastxclip -> **94**

trimmed_cutadapt_34minlen_egadapter -> **94**

Then, check in breseq output directories: `find . -mindepth 1 -maxdepth 1 -type d | wc -l`

breseq-fastx-trimmed -> **94**

breseq-cutadapt-trimmed -> **91**

So breseq failed on 3 cutadapt-trimmed samples.

Find these!

`cd` to ./logs/breseq-cutadapt/

Code below finds any files that do not have the "SUCCESSFULLY COMPLETED" line in the breseq output and prints the end of each.

`
grep -riL "+++   SUCCESSFULLY COMPLETED" ./*.err > unsuccessful.list
paste unsuccessful.list | while read file; do echo; echo; echo $file; tail -n 20 $file; echo; done
`

./breseq_array_cutadapt_43341106_34.err -> NRA297
./breseq_array_cutadapt_43341106_38.err -> NRA302
./breseq_array_cutadapt_43341106_41.err -> NRA306
./breseq_array_cutadapt_43341106_57.err -> NRA323
./breseq_array_cutadapt_43341106_62.err -> NRA328
./breseq_array_cutadapt_43341106_69.err -> NRA335
./breseq_array_cutadapt_43341106_78.err -> NRA344
./breseq_array_cutadapt_43341106_82.err -> NRA348
./breseq_array_cutadapt_43341106_83.err -> NRA349
./breseq_array_cutadapt_43341106_85.err -> NRA351
./breseq_array_cutadapt_43341106_86.err -> NRA352
./breseq_array_cutadapt_43341106_87.err -> NRA353
./breseq_array_cutadapt_43341106_90.err -> NRA356
./breseq_array_cutadapt_43341106_91.err -> NRA357


### Verify presence of "output" subdirectories containing 

Check for presence of "output" subdirectory in each output folder to ensure complete breseq-ing

From the ./output/breseq/ directory, run:
`find ./ -maxdepth 2 -mindepth 2 -type d '!' -exec test -e "{}/output/summary.json" ';' -print`

Lists any subdirectory that does NOT contain an 'output/summary.json' file





Finished breseq using.... <>

Used run_json_parser.sh to extract key data from 
