#!/bin/bash

if [ -f ./csv_files/combine/combine_otus.csv ]; then
	rm ./csv_files/combine/combine_otus.csv
fi

amount=$(ls -R | grep "_all.biom" | wc -l)
echo "amount of files: $amount"

#string of submitted sbatch files for submission
sbatch_string=""

for i in $( eval echo {1..$amount} )
do
	echo $i

	#make string of sbatch jobs 
	sbatch1=$(sbatch combine_pt1.sbatch $i)
	sbatch1=${sbatch1##* }
	sbatch_string+=",$sbatch1"
	echo $i "of" $amount "done"
done

sbatch_string=${sbatch_string#,}

echo "all submitted jobs from first step: $sbatch_string"

sbatch --dependency=afterok:$sbatch_string combine_pt2.sbatch
