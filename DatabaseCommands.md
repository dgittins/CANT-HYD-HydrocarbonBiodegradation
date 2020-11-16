# **Hydrocarbon biodegradation commands**

## Reference sequences

1. Concatenate all reference sequence files:

cat *.faa > All_hydrocarbon_reference_sequences.faa

## Sequence clustering, homology search, and alignment

1. Assign reference sequences to clusters of probable function homology (homologous groups)

Create a BLAST database from reference sequence files:
makeblastdb -in All_hydrocarbon_reference_sequences.faa -dbtype prot -out Hydrocarbon_reference_sequences.db  

BLAST reference sequences against the BLAST database: 

blastp -db Hydrocarbon_reference_sequences.db -query All_hydrocarbon_reference_sequences.faa -outfmt 6 -evalue 1e-4 -num_threads 40 -out Self_blast_hydrocarbon_references.txt 

2. Perform a sequence homology search for all clustered sequences against the NCBI’s non-redundant protein database in Diamond format

diamond blastp --db /gpfs/ebg_data/database/nr/nr.dmnd --query All_hydrocarbon_reference_sequences.faa --out diamondout_All_hydrocarbon_reference_sequences.txt --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore full_sseq --max-target-seqs 0 --query-cover 70 --evalue 0.0001 --threads 60
    
3. Group sequences into predefined homlogous groups

4. Create .fasta file of blastp results sequences within each group 

5. Remove duplicate sequences

for file in /gpfs/ebg_work/hackathon/Test/*.faa; do newname=\$(basename $file .faa); time usearch -derep_fulllength \$file -fastaout $newname.uniques.fasta; done

6. Cluster sequences within each homlogous group at 98% similarity

for file in /gpfs/ebg_work/hackathon/Test/cluster/*.fasta; do newname=\$(basename $file .fasta); time usearch -cluster_fast $file -id 0.98 -centroids $newname.98.repseqs.fasta -uc \$newname.clusters.uc; done

7. Add reference sequences to the clustered files

grep -A 1 --no-group-separator -w -Ff  Test/HomologGroup1.seqID.list Alignment/All_hydrocarbon_reference_sequences_singleline.fasta >> Alignment/Group1.uniques.98.repseqs.fasta

## Phylogenetic tree generation

#Align sequences

nohup muscle -in Group1.uniques.98.repseqs.fasta -out Group1.uniques.98.repseqs_align.fasta >> DG_nohup.out &


#Tree clustered groups (fastTree)


FastTreeMP -pseudo -spr 4 Group1.uniques.98.repseqs_align.fasta > Group1.uniques.98.repseqs_align_tree.tre