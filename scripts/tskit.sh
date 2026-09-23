#!/bin/bash
#SBATCH --account=def-mmosmond
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=192
#SBATCH --job-name=tskit
#SBATCH --output=logs/tskit_%j.out
#SBATCH --error=logs/tskit_%j.err

set -euo pipefail
mkdir -p logs

func() {
  chr=$1

  in="data/relate_${chr}_popsize"
  out=$in

  software/relate_v1.2.4_x86_64_dynamic/bin/RelateFileFormats \
                 --mode ConvertToTreeSequence \
                 -i $in \
                 -o $out
}
export -f func

parallel -j "$SLURM_CPUS_PER_TASK" func :::: data/chr_names.txt

