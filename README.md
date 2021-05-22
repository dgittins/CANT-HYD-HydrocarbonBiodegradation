# CANT-HYD: A database and algorithm for accurate annotation of hydrocarbon degradation genes

The **C**algary approach to **AN**no**T**ating **HYD**rocarbon degrading enzymes is a database used for robust and accurate annotation of genes associated with aerobic and anaerobic hydrocarbon degradation.

## Implementation

1. Download [CANT_HYD.hmm](https://github.com/dgittins/CANT-HYD-HydrocarbonBiodegradation/blob/main/downloads/CANT_HYD.hmm), [HMM_confidence_score.csv](https://github.com/dgittins/CANT-HYD-HydrocarbonBiodegradation/blob/main/downloads/HMM_confidence_score.csv), and [parse_hmmsearch_output.py](https://github.com/dgittins/CANT-HYD-HydrocarbonBiodegradation/blob/main/downloads/parse_hmmsearch_output.py) files from this GitHub repository

2. Annotate protein-coding gene predictions from microbial whole genomes and metagenome-assembled genomes using CANT-HYD HMMs implemented in [HMMER](http://hmmer.org/)

```bash
hmmsearch --tblout hmmsearch_metagenome.tblout CANT-HYD.hmm metagenome_proteins.faa > hmmsearch_metagenome.out
```

3. Filter HMM search ouput to sequence homologs above the confidence threshold

```bash
python parse_hmm_output.py HMM_confidence_score.csv hmmsearch_metagenome.tblout hmmsearch_metagenome.parse.txt
```

## Contributors

Varada Khot<sup>2</sup>, Jackie Zorz<sup>2</sup>, Daniel Gittins<sup>1</sup>, Anirban Chakraborty<sup>1</sup>, Emma Bell<sup>1</sup>, Maria A. Bautista<sup>1</sup>, Alexandre Paquette<sup>2</sup>, Alyse Hawley<sup>2</sup>, Breda Novotnik<sup>2</sup>, Casey Hubert<sup>1</sup>, Marc Strous<sup>2</sup>, Srijak Bhatnagar<sup>1</sup>

<sup>1</sup>Department of Biological Sciences, University of Calgary, Canada

<sup>2</sup>Department of Geoscience, University of Calgary, Canada
