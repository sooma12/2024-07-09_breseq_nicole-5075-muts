#!/bin/bash
## 2a_make_sample_sheet_cutadapt.sh
# Usage: `bash 2a_make_sample_sheet_cutadapt.sh`

source ./config.cfg
echo "Fastq files found in: " $FASTQDIR/trimmed_fastxclip
echo "Sample sheet: " $SAMPLE_SHEET_FASTX

# Create .list files with R1 and R2 fastqs.  Sort will put them in same orders, assuming files are paired
find $FASTQDIR/trimmed_fastxclip -maxdepth 1 -name "*.fastq" | sort > R1.list

# For debug purposes... delete sample sheet if it exists
if [ -f "${SAMPLE_SHEET_FASTX}" ] ; then
  rm "${SAMPLE_SHEET_FASTX}"
fi

paste R1.list | while read R1;
do
    outdir_root=$(basename ${R1} | cut -f1 -d"_")
    sample_line="${outdir_root} ${R1}"
    echo "${sample_line}" >> "${SAMPLE_SHEET_FASTX}"
done

rm R1.list

echo 'Sample sheet contents:'
cat $SAMPLE_SHEET_FASTX
