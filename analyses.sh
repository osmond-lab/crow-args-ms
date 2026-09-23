###########################
# fst 
###########################

# convert to tskit
sbatch scripts/tskit.sh

# calculate fst
sbatch scripts/fst.sh

###########################
# dolores 
###########################

# install
git clone https://github.com/a-ignatieva/dolores.git
mv dolores/ software/
cd software/dolores/
module load python/3.11.4
python -m venv dolores-venv
source dolores-venv/bin/activate
module load gcc/12.3
module load gsl/2.7
pip install -r requirements.txt
#had to remove brackets from stored_nbytes() in a tscompress file to run the example

# convert popsize files
while IFS= read -r chrom; do
    coal_file="data/relate_${chrom}_popsize.coal"
    out_file="data/relate_${chrom}_popsize.popsize"

    awk 'NR==2 {split($0, times, " ")}
         NR==3 {
	     n_epochs = NF - 2
	     for (i=3; i<=NF; i++) {
                 t = times[i-2]
                 rate = $i
	         if (rate == 0) {
	             print t",NA"
	             exit
                 }
                 n = 1/rate 
                 print t","n
             }
	     print times[n_epochs]",NA"
	 }' "$coal_file" > "$out_file"
done < data/chr_names.txt

# rename poplabels files
while IFS= read -r chrom; do
    cp data/poplabels_filtered.txt data/relate_${chrom}_popsize.poplabels
done < data/chr_names.txt

#convert maps
while IFS= read -r chrom; do
    awk -v chr="$chrom" 'NR==1 {print "Chromosome\tPosition(bp)\tRate(cM/Mb)\tMap(cM)"; next}
                           {print chr"\t"$0}' "data/${chrom}_smooth.map" > "data/${chrom}_smooth.hapmap"
done < data/chr_names.txt

sbatch scripts/dolores.sh


