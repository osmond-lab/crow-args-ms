#!/bin/bash
#SBATCH --account=def-mmosmond
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=192
#SBATCH --job-name=fst
#SBATCH --output=logs/fst_%j.out
#SBATCH --error=logs/fst_%j.err

set -euo pipefail
mkdir -p logs

source ../crow-args/crow-args_env/bin/activate

func() {
  chr=$1

  trees="data/relate_${chr}_popsize.trees"
  poplabels="data/poplabels_filtered.txt"
  windows="data/fst_windows_${chr}.npy"
  fst="data/fst_${chr}.npy"

  python scripts/fst.py -t $trees -p $poplabels -w $windows -f $fst 

}
export -f func

parallel -j "$SLURM_CPUS_PER_TASK" func :::: data/chr_names.txt

