#!/bin/bash

if [ -f ./csv_files/AUCs/associated_2192/builtenv_AUCs.csv ]; then
	rm ./csv_files/AUCs/associated_2192/builtenv_AUCs.csv
fi

if [ -f ./csv_files/AUCs/associated_2192/builtenv_AUC_pvals.csv ]; then
	rm ./csv_files/AUCs/associated_2192/builtenv_AUC_pvals.csv
fi

mkdir ./output/$1
mkdir ./output/$1/AUCs
mkdir ./output/$1/DEBIAS-M_runs
mkdir ./output/$1/ROC_histograms

search_dir=./csv_files/$1/DEBIAS-M_runs
amount=$2

rm "$search_dir/"*

for i in $( eval echo {1..$amount} )
do
	sbatch run_all_pt1.sbatch $i 100 $1
	sbatch run_all_pt2.sbatch $i
	echo $i "of $amount done"
done



count_files() {
	file_count=$(find "$search_dir/"*debiased* | wc -l)
	echo $file_count

}

while [ $(count_files) -lt $amount ]; do
	echo "Waiting for $amount files"
	echo $file_count
	sleep 300 # waiting 5 minute before checking again
done

echo "$amount files have been detected"



for entry in "$search_dir/"*debiased*
do
	sbatch run_all_pt3.sbatch $entry 100 $(echo $entry | cut -d"_" -f7- | cut -d"." -f1) $1
	echo $(echo $entry | cut -d"_" -f7- | cut -d"." -f1)
	echo $entry
done

echo "done with all"



