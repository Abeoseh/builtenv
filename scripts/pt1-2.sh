#!/bin/bash

if [ -f ./csv_files/combine/combine_otus.csv ]; then
	rm ./csv_files/combine/combine_otus.csv
fi

amount=$(ls -R | grep "_all.biom" | wc -l)
echo $amount

for i in $( eval echo {1..$amount} )
do
	echo $i
	sbatch combine_pt1-2.sbatch $i
	echo $i "of" $amount "done"
done



