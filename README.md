# CANT-HYD: A database and algorithm for accurate annotation of hydrocarbon degradation genes

The **C**algary approach to **AN**noTating **HYD**rocarbon degrading enzymes is a database used for robust and accurate annotation of genes associated with aerobic and anaerobic hydrocarbon degradation pathways.

## Implementation

1. Download [CANT_HYD.hmm](https://github.com/dgittins/HydrocarbonBiodegradation/blob/main/CANT_HYD.hmm), [HMM_confidence_score.csv](https://github.com/dgittins/HydrocarbonBiodegradation/blob/main/HMM_confidence_score.csv), and [parse_hmmsearch_output.py](https://github.com/dgittins/HydrocarbonBiodegradation/blob/main/parse_hmmsearch_output.py) files from this GitHub repository

2. Annotate protein-coding gene predictions from microbial whole genomes and metagenome-assembled genomes using CANT-HYD HMMs implemented in [HMMER](http://hmmer.org/)

```bash
hmmsearch --tblout hmmsearch_metagenome.tblout CANT-HYD.hmm metagenome_proteins.faa > hmmsearch_metagenome.out
```

3. Filter HMM search ouput to sequence homologs above the confidence threshold

```bash
python parse_hmm_output.py HMM_confidence_score.csv hmmsearch_metagenome.tblout hmmsearch_metagenome.parse.txt
```