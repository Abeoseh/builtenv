#!/bin/bash

search_dir=./csv_files/DEBIAS-M_runs/associated_2192



for entry in "$search_dir/"*debiased*
do
	#echo $entry
	entry="${entry##*/}"  # remove everything before the last /
	entry="${entry##*_}"  # Remove everything before the last _
	entry="${entry%.*}"    # Remove everything after the last .
	echo "$entry"
done

#mkdir ./output/$1
#mkdir ./output/$1/AUCs
#mkdir ./output/$1/DEBIAS-M_runs
#mkdir ./output/$1/ROC_histograms

echo "done with all"



