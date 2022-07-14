# CANT-HYD: A database and algorithm for accurate annotation of hydrocarbon degradation genes

The **C**algary approach to **AN**no**T**ating **HYD**rocarbon degrading enzymes is a database used for robust and accurate annotation of genes associated with aerobic and anaerobic hydrocarbon degradation.

## Implementation

1. Download [individual](https://github.com/dgittins/CANT-HYD-HydrocarbonBiodegradation/blob/main/HMMs/individual%20HMMs) or [concatenated](https://github.com/dgittins/CANT-HYD-HydrocarbonBiodegradation/tree/main/HMMs/concatenated%20HMMs) HMM files from this GitHub repository

2. Annotate protein-coding gene predictions from microbial whole genomes and metagenome-assembled genomes using CANT-HYD HMMs implemented in [HMMER](http://hmmer.org/)

```bash
hmmsearch --tblout hmmsearch_metagenome.tblout CANT-HYD.hmm metagenome_proteins.faa > hmmsearch_metagenome.out
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Options:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a. ```--cut_tc``` for trusted cutoff

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b. ```--cut_nc``` for noise cutoff

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c. no option, for exploring genes below the noise cutoff


## Article

Varada Khot<sup>2</sup>, Jackie Zorz<sup>2</sup>, Daniel Gittins<sup>1</sup>, Anirban Chakraborty<sup>1</sup>, Emma Bell<sup>1</sup>, Maria A. Bautista<sup>1</sup>, Alexandre Paquette<sup>2</sup>, Alyse Hawley<sup>2</sup>, Breda Novotnik<sup>2</sup>, Casey Hubert<sup>1</sup>, Marc Strous<sup>2</sup>, Srijak Bhatnagar<sup>1</sup> CANT-HYD: a curated database of phylogeny-derived hidden Markov models for annotation of marker genes involved in hydrocarbon degradation. Frontiers in microbiology 12 (2022). [https://doi.org/10.3389/fmicb.2021.764058](https://doi.org/10.3389/fmicb.2021.764058)

<sup>1</sup>Department of Biological Sciences, University of Calgary, Canada

<sup>2</sup>Department of Geoscience, University of Calgary, Canada
