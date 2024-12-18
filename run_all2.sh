#!/bin/bash

if [ -f ./csv_files/AUCs/associated/builtenv_AUCs.csv ]; then
	rm ./csv_files/AUCs/skin_floor/builtenv_AUCs.csv
fi

if [ -f ./csv_files/AUCs/associated/builtenv_AUC_pvals.csv ]; then
	rm ./csv_files/AUCs/skin_floor/builtenv_AUC_pvals.csv
fi

search_dir=./csv_files/DEBIAS-M_runs/skin_floor
amount=4

rm "$search_dir/"*

for i in $( eval echo {1..$amount} )
do
	sbatch run_all_pt1_2.sbatch $i 100
	sbatch run_all_pt2_2.sbatch $i
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
	sbatch run_all_pt3_2.sbatch $entry 100 $(echo $entry | cut -d"_" -f7- | cut -d"." -f1) 
	echo $(echo $entry | cut -d"_" -f7- | cut -d"." -f1)
	echo $entry
done

echo "done with all"



