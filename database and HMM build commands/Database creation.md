# **Hydrocarbon biodegradation database commands**

## Reference sequence clustering

1. Concatenate all reference sequence files

```bash
cat *.faa > All_hydrocarbon_reference_sequences.faa
```

2. Assign reference sequences to clusters of probable functional homology (i.e. homologous groups)

   1. Create a [BLAST](https://www.ncbi.nlm.nih.gov/books/NBK52640/) database from reference sequence files
   
    ```bash
    makeblastdb -in All_hydrocarbon_reference_sequences.faa -dbtype prot -out Hydrocarbon_reference_sequences.db
    ```
        
   2. BLAST reference sequences against the reference sequence BLAST database
   
    ```bash
    blastp -db Hydrocarbon_reference_sequences.db -query All_hydrocarbon_reference_sequences.faa -outfmt 6 -evalue 1e-4 -num_threads 40 -out Self_blast_hydrocarbon_references.txt
    ```

   3. <insert script used to cluster at 20% identity>

## Sequence homology search
 
1. Search homologous group sequences against NCBI’s non-redundant protein database in [Diamond](https://github.com/bbuchfink/diamond) format

```bash
diamond blastp --db /gpfs/ebg_data/database/nr/nr.dmnd --query All_hydrocarbon_reference_sequences.faa --out diamondout_All_hydrocarbon_reference_sequences.txt --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore full_sseq --max-target-seqs 0 --query-cover 70 --evalue 0.0001 --threads 60
```
    
2. Add sequences resulting from diamond search to predefined homologous groups

```bash
> insert script used to add sequences
```

3. Remove duplicate sequences using [Usearch](https://www.drive5.com/usearch/)

```bash
for file in /gpfs/ebg_work/hackathon/Test/*.faa; do newname=$(basename $file .faa); time usearch -derep_fulllength $file -fastaout $newname.uniques.fasta; done
```

4. Cluster sequences at 98% similarity using [Usearch](https://www.drive5.com/usearch/)

```bash
for file in /gpfs/ebg_work/hackathon/Test/cluster/*.fasta; do newname=$(basename $file .fasta); time usearch -cluster_fast $file -id 0.98 -centroids $newname.98.repseqs.fasta -uc $newname.clusters.uc; done
```

5. Add reference sequences to the clustered sequence files

```bash
grep -A 1 --no-group-separator -w -Ff  Test/HomologGroup1.seqID.list Alignment/All_hydrocarbon_reference_sequences_singleline.fasta >> Alignment/Group1.uniques.98.repseqs.fasta
```

## Phylogenetic tree generation

1. Align clustered sequences using [Muscle](https://www.drive5.com/muscle/)

```bash
muscle -in Group1.uniques.98.repseqs.fasta -out Group1.uniques.98.repseqs_align.fasta
```

2. Create phylogentic trees from aligned clustered sequences using [FastTree](http://www.microbesonline.org/fasttree/)

```bash
FastTreeMP -pseudo -spr 4 Group1.uniques.98.repseqs_align.fasta > Group1.uniques.98.repseqs_align_tree.tre
```

3. Visualize trees using [iTOL](https://itol.embl.de/)