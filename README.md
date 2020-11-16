# CANT-HYD: A database and algorithm for accurate annotation of hydrocarbon degradation genes

The **C**algary approach to **AN**noTating **HYD**rocarbon degrading enzymes is a database used for robust and accurate annotation of genes associated with aerobic and anaerobic hydrocarbon degradation pathways.

## Implementation

1. Download **[CANT-HYD HMMs]**(https://github.com/dgittins/HydrocarbonBiodegradation/blob/main/CANT-HYD.hmm) and **[HMM confidence scores]**(https://github.com/dgittins/HydrocarbonBiodegradation/blob/main/HMM%20confidence%20score.csv) 

```bash
hmmsearch --tblout hmmsearch_result_SRR10302630.tblout ../../Final_HMMs_for_testing/renamed_hmms/catallgenes.hmm SRR10302630_proteins.faa > hmmsearch_result_SRR10302630.out
```

