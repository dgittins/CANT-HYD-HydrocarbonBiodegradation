#runs hmmsearch on all genomes within a folder (containing downloaded GTDB genomes). Creates tbl file for each result 

for Genome in ./protein_faa_reps/done_v1/*_protein.faa
do
base=$(basename $Genome _protein.faa)
echo $base
hmmsearch --cpu 10 --notextw --tblout ./TblOuts/${base}.tbl CANT-HYD.hmm ./protein_faa_reps/done_v1/${base}_protein.faa >/dev/null 2>&1
done
