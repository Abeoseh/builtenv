#!/bin/bash 
#SBATCH --partition=Orion
#SBATCH --job-name=combine
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=100000
echo "======================================================"
echo "Start Time : $(date)"
echo "Submit Dir : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo "" cd $SLURM_SUBMIT_DIR

module load R
Rscript ./scripts/combine_pt1.R $1 &> logs/combine_pt1_$1.log





search_dir=./csv_files/combine
amount=$(ls -R | grep "_all.biom" | wc -l)

count_files() {
	file_count=$(find "$search_dir/" | wc -l)
	echo $file_count

}

while [ $(count_files) -lt $amount ]; do
	echo "Waiting for" $amount "files"
	echo $file_count
	sleep 300 # waiting 5 minute before checking again

done

echo $amount "files have been detected"




Rscript ./scripts/combine_pt2.R &> logs/combine_pt2.log

echo ""
echo "======================================================"
echo "End Time : $(date)"
echo "======================================================"
