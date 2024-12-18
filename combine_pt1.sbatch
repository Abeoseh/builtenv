#!/bin/bash 
#SBATCH --partition=Orion
#SBATCH --job-name=combine_pt1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=6:00:00
#SBATCH --mem-per-cpu=100000
echo "======================================================"
echo "Start Time : $(date)"
echo "Submit Dir : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo "" cd $SLURM_SUBMIT_DIR

module load R



Rscript ./scripts/combine_pt1.R $1 &> logs/combine/combine_pt1_$1.log



echo ""
echo "======================================================"
echo "End Time : $(date)"
echo "======================================================"
