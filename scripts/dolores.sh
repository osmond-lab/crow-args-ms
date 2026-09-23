#!/bin/bash
#SBATCH --account=def-mmosmond
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=192
#SBATCH --job-name=dolores
#SBATCH --output=logs/dolores_%j.out
#SBATCH --error=logs/dolores_%j.err

set -euo pipefail
mkdir -p logs

cd software/dolores/
source dolores-venv/bin/activate

func() {
  chr=$1
  python -m run-dolores -C $chr -n relate_${chr}_popsize --trees_loc ../../data --genetic_map_loc ../../data/${chr}_smooth.hapmap -s None --genetic_map_stdpopsim None
}
export -f func

parallel -j "$SLURM_CPUS_PER_TASK" func :::: ../../data/chr_names.txt

