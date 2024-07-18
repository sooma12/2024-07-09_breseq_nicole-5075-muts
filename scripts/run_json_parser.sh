#!/bin/bash
# Usage: `bash run_json_parser.sh <breseq_parent_dir>

# Run this script from a directory containing many breseq outputs.
# Example folder tree (note that the summary.json files are 3 levels down inside output):
# clipper_output
#   7141
#     ...
#     output
#       summary.json
#   7142
#     ...
#     output
#       summary.json

BRESEQ_PARENT_DIR=${1}
JSON_PARSER_SCRIPT=/work/geisingerlab/Mark/breseq/breseq_scripts_mws/parse_summary_json.py

find $BRESEQ_PARENT_DIR -maxdepth 2 -mindepth 2 -type d -name output >breseq_dirs.list

out_filename=breseq_summary_stats.csv

if [ -f "${out_filename}" ] ; then
  rm "${out_filename}"
fi

echo "read_file,total_reads,total_bases,percent_bases_mapped,chr_accession,chr_coverage_avg,chr_coverage_rel_variance,chr_num_reads_mapped,chr_num_bases_mapped,chr_length,chr_nbinom_fit_mean,chr_nbinom_fit_rel_var,pab1_accession,pab1_coverage_avg,pab1_coverage_rel_variance,pab1_num_reads_mapped,pab1_num_bases_mapped,pab1_length,pab1_nbinom_fit_mean,pab1_nbinom_fit_rel_var,pab2_accession,pab2_coverage_avg,pab2_coverage_rel_variance,pab2_num_reads_mapped,pab2_num_bases_mapped,pab2_length,pab2_nbinom_fit_mean,pab2_nbinom_fit_rel_var,pab3_accession,pab3_coverage_avg,pab3_coverage_rel_variance,pab3_num_reads_mapped,pab3_num_bases_mapped,pab3_length,pab3_nbinom_fit_mean,pab3_nbinom_fit_rel_var" >>$out_filename

paste breseq_dirs.list | while read dir ;
do
  python $JSON_PARSER_SCRIPT -i ${dir}/summary.json >>$out_filename
done
