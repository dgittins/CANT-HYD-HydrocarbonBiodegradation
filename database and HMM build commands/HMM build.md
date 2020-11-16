# **HMM build commands**

1. Extract clustered sequences using the accessions identified from the phylogentic tree analysis

```bash
grep -w -Ff HMM_accession_lists/Group31_con1_apcE_EXP_accesion.UNIX.list Test/cluster/Group31.uniques.clusters.uc | awk '{print $9}' | sort -u | grep -A 1 --no-group-separator -f /dev/stdin Test/Group31.uniques.singleline.fasta > HMM/Group31.fasta
```

2. Extract and add reference sequences

```bash
 grep -w -Ff Group3_con2_AlkylSuccinateSynthaseSubunitD_accession.UNIX.list ../Alignment/All_hydrocarbon_reference_sequences_singleline.fasta -A 1 --no-group-separator >> ../HMM/Group3_con2_AlkylSuccinateSynthaseSubunitD.fasta
 ```
 
 3. Align sequences using [Clustal Omega](https://www.ebi.ac.uk/Tools/msa/clustalo/) web service, with default parameters
 
 4. Build HMM for each target degradation gene using [HMMER](http://hmmer.org/)
 
```bash
hmmbuild -n HMM/Group31 --amino --informat afa HMM/Group31.hmm HMM/Group31.align.fasta 
```