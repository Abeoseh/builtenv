#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=run_all_pt2
#SBATCH --mem=100000
#SBATCH --time=1:20:00
#SBATCH --ntasks=2
#SBATCH --ntasks-per-node=2
#SBATCH --nodes 2
echo "======================================================"
echo "Start Time : $(date)"
echo "Submit Dir : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Num Tasks : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
cd $SLURM_SUBMIT_DIR

module load anaconda3/2022.10 # load modules
python scripts/DEBIAS-M_semi_leaky.py $1 &> ~/builtenv/logs/run_dm_2192/run_DEBIAS-M_out_${1}.log &

wait

echo ""
echo "======================================================"
echo "End Time : $(date)"
echo "======================================================"
