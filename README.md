Directory Structure:


folders that are numbers: contains the metadata for each sample and the otu count tables (*_all.biom)
________________________________________________________
Combine files:

to run all:
combine_pt1-2.sh
combine_pt3.sbatch

./scripts/combine_pt1.R $1
$1 is the amount of _all.biom files
- run separately using combine_pt1.sbatch
- assigns taxonomy using dada2 and returns individual count tables for each file
- logs are named ./combine/combine_pt1_*number denoting order it was made in*.log
	logs all begin with number, then file name 

./scripts/combine_pt2.R
- run separately using combine_pt2.sbatch
- merges the count tables made by combine_pt1.R 
- log is named ./combine/combine_pt2.log
	if a duplicate sample exists it logs it

 
./scripts/combine_pt3.R $1 $2 $3 $4
$1 output folder name
$2 first phenotype
$3 second phenotype
$4 (""/T) keep NA as NA

ex:
sbatch combine_pt3.sbatch "associated" "skin associated" "floor associated" # results in NA values being coded as 0
sbatch combine_pt3.sbatch "associated_na" "skin associated" "floor associated" "T" # results in NA staying as NA

- run separately using combine_pt3.sbatch
- assigns ontology and log normalizes
- log file is named ./combine/combine_pt3.log
NOTE: phenotype column within file ./csv_files/combine/common_ontology_2192.csv has to be named common_name 
________________________________________________________

Random Forest and DEBIAS-M:
pipeline: 

run_all.sh $1 $2 $3
$1 input folder (ensure it's located within ./csv_files)
$2 output folder (ensure folder ./output is created)
$3 amount of studies

random forest without DEBIAS-M








________________________________________________________


pval vs pval

sbatch pval-pval_plot.sbatch $1 $2
$1 input folder (ensure it's located within ./csv_files)
$2 output folder (ensure ./output/$2 is created)

ex:
sbatch pval-pval_plot.sbatch skinVSskin_associated_na skinVSskin_associated
________________________________________________________

./scripts/Percent_as_NA:

For percent_missing_na_as_na.csv I did not code NA values as NA
For percent_missing_na_as_0.csv I coded NA values as 0

I got the percents by summing the amount of values labeled 0 OR Na in a given column and divided that by the length of the column

EX: (R code)
If NA is left as NA
   x y
1 NA 2
2  0 2
3  2 4
4  4 5
5  5 3


x has 2/5 labeled NA or 0, y has 0/5 labeled NA

If NA is coded as 0:
   x y
1  0 2
2  0 2
3  2 4
4  4 5
5  5 3


x has 2/5 labeled NA or 0, y has 0/5 labeled NA

I did not count the number of NAs separately since NA and 0 served the same purpose

_______________________________________________________________