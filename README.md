# CANT-HYD: A database and algorithm for accurate annotation of hydrocarbon degradation genes

The **C**algary approach to **AN**noTating **HYD**rocarbon degrading enzymes is a database used for robust and accurate annotation of genes associated with aerobic and anaerobic hydrocarbon degradation pathways.

## Implementation

1. Download [CANT-HYD.hmm](https://github.com/dgittins/HydrocarbonBiodegradation/blob/main/CANT-HYD.hmm) and [HMM confidence score.csv](https://github.com/dgittins/HydrocarbonBiodegradation/blob/main/HMM%20confidence%20score.csv) files from this GitHub repository

2. Annotate protein-coding gene predictions from microbial whole genomes and metagenome-assembled genomes using CANT-HYD HMMs implemented in [HMMER](http://hmmer.org/)

```bash
hmmsearch --tblout hmmsearch_metagenome.tblout CANT-HYD.hmm metagenome_proteins.faa > hmmsearch_metagenome.out
```

3. Filter output to 