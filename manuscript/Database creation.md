# **CANT-HYD database commands**

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

   3. Cluster at 20% sequence identity
   
<details>
<summary>Show code</summary>
<p>
     
```bash
    #!/usr/bin/perl

use strict;

my(@homolog,%homo,%homoCheck,@done,%seqID, %seqNO, %hasHomolog) = ();
open(IN,$ARGV[0]) or die "Can't open input file\n";
open(IN2,$ARGV[1]) or die "Can't open acc file\n";
my $count = 0;
while(my $line = <IN2>){
	chomp($line);
	$seqID{$line} = $count;
	$seqNO{$count} = $line;
	$count++;
}
	
while(my $line = <IN>){
	chomp($line);
	my @junk = split("\t",$line);
	if($junk[0] ne $junk[1]){
		if($junk[2] >= 25 && $junk[10] <= 0.0001){
			 $homolog[$seqID{$junk[0]}][$seqID{$junk[1]}] = 1;
		}
	}
}
for(my $i=0; $i < $count; $i++){
	my $seq1 = $seqNO{$i};
	for(my $j=0; $j < $count; $j++){
		my $seq2 = $seqNO{$j};
		if($seq1 ne $seq2){
			if($homolog[$i][$j]){	#If homolog exists between seq1 and seq2
				if($homoCheck{$seq1}){	#if the seq1 already has a homolog
					if($homoCheck{$seq2}){	#does seq2 also, the do nothing
						if($homoCheck{$seq1} ne $homoCheck{$seq2}){	#Check if they are not part of same cluster
							$homo{$homoCheck{$seq1}} = $homo{$homoCheck{$seq1}}."XXYYZZ".$homo{$homoCheck{$seq2}};
							delete($homo{$homoCheck{$seq2}});
							foreach my $key (keys %homoCheck){
								if($homoCheck{$key} eq $homoCheck{$seq2}){
									$homoCheck{$key} = $homoCheck{$seq1};
								}
							}
							#print "OOOOOOO:$homoCheck{$seq1}  $homoCheck{$seq2}\n";
						}
					}			
					else{				#If seq2 doesn't
						my $h = $homoCheck{$seq1};	#find which sequence is seq1 homolog of
						$homo{$h} = $homo{$h}."XXYYZZ".$seq2; 	#and append seq2 to the list of homologs that seq1 belongs to
						$homoCheck{$seq2} = $h;		#and add seq2 to homolog check
					}
				}
				else{		#if seq1 has not been detected as homolog os anything
					if($homoCheck{$seq2}){		# But seq2 has
						my $h = $homoCheck{$seq2};	#find which sequence is seq2 homolog of
						$homo{$h} = $homo{$h}."XXYYZZ".$seq1; #append seq1 to the list os homologs that seq2 belongs to
						$homoCheck{$seq1} = $h;		#and add seq1 to the homolog check
					}
					else{		#if seq2 also doens't belong to any other homologs as well
						if($homo{$seq1}){
							$homo{$seq1} = $homo{$seq1}."XXYYZZ".$seq2;
						}
						else{
							$homo{$seq1} = $seq2;
						}
						$homoCheck{$seq2} = $seq1;	#add seqs2 homolog check
					}
				}
			}
		}
	}
}
my $filenum=1;
my $selfCheck;
foreach my $key (keys %homo){
	my $outfilename = "HomologGroup".$filenum.".seqID.list";
	open(OUT,">$outfilename") or die "Can't create $outfilename\n";
	my $list = $homo{$key};
	my @outList = split(/XXYYZZ/,$list);
	foreach my $outID (@outList){
		if($outID){
			print OUT "$outID\n";
			$hasHomolog{$outID}++;
			if($outID eq $key){	$selfCheck = 1;	}
		}
	}
	if($selfCheck){}
	else{	print OUT "$key\n";	}
	$selfCheck = 0;
	$filenum++;
}
open(SIG,">SingletonHomolog.list");
for(my $i=0; $i < $count; $i++){
	if(!($hasHomolog{$seqNO{$i}})){
		my $outfilename = "HomologGroup".$filenum.".seqID.list";
		open(OUT,">$outfilename") or die "Can't create $outfilename\n";
		print OUT "$seqNO{$i}\n";
		print SIG "$seqNO{$i}\n";
		$filenum++;
	}
}	
```

</details>    

## Sequence homology search
 
1. Search homologous group sequences against NCBI’s non-redundant protein database in [Diamond](https://github.com/bbuchfink/diamond) format

```bash
diamond blastp --db /gpfs/ebg_data/database/nr/nr.dmnd --query All_hydrocarbon_reference_sequences.faa --out diamondout_All_hydrocarbon_reference_sequences.txt --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore full_sseq --max-target-seqs 0 --query-cover 70 --evalue 0.0001 --threads 60
```
    
2. Add sequences resulting from diamond search to predefined homologous groups

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