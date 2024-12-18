#!/bin/bash

#search_dir=./csv_files/DEBIAS-M_runs/associated_2192



#for entry in "$search_dir/"*debiased*
#do
#	sbatch run_all_pt3.sbatch $entry 100 $(echo $entry | cut -d"_" -f7- | cut -d"." -f1) 
#	echo $(echo $entry | cut -d"_" -f7- | cut -d"." -f1)
#	echo $entry
#done

mkdir ./output/$1
mkdir ./output/$1/AUCs
mkdir ./output/$1/DEBIAS-M_runs
mkdir ./output/$1/ROC_histograms

echo "done with all"



