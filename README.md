# CANT-HYD: A curated database of phylogeny-derived hidden markov models for annotation of marker genes involved in hydrocarbon degradation

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

Khot V, Zorz J, Gittins DA, Chakraborty A, Bell E, Bautista MA, Paquette AJ, Hawley AK, Novotnik B, Hubert CRJ, Strous M and Bhatnagar S (2022) **CANT-HYD: A Curated Database of Phylogeny-Derived Hidden Markov Models for Annotation of Marker Genes Involved in Hydrocarbon Degradation.** *Front. Microbiol.* 12:764058. doi: [10.3389/fmicb.2021.764058](https://www.frontiersin.org/articles/10.3389/fmicb.2021.764058/full)
