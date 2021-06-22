#set working directory and load tidyverse package
setwd("~/University of Calgary/PhD/hackathon/HMM_testing/GTDB_Final_HMMs")
library(tidyverse)

#read in table from normalize_hmm_scores_taxonomy_and_metadata.py script 
jz = read.table("GTDB_domain_scores_metadata.txt", header = FALSE)

#read in cutoff scores
cut = read.csv("cutoff_score.csv", header = TRUE)


#add column names 
colnames(jz) = c("Genome", "HMM", "evalue", "score", "accession", "norm_score", "oxygen", "HC", "taxonomy", "species")


#join cutoff scores with GTDB results using HMM name
jz_cut = left_join(jz, cut, by = "HMM")

#delete rows with a score less than the noise score
jz_cut2 = jz_cut %>% filter(score > Noise)

#delete rows with a score less than the threshold 
#jz_cut2 = jz_cut %>% filter(score > Threshold)
 
#get rid of weird species column 
jz3 = jz_cut2 %>% select(-species)
 
#split taxonomy into separate columns 
jz4 = jz3 %>% separate(taxonomy, c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species"), sep = ";")

#get rid of underscores in phylum names
jz4$Phylum <- gsub('p__', '', jz4$Phylum)

#get rid of long HMM name
jz4$HMM <- gsub('Group[0-9][0-9]_con[0-9]_[A-Z][A-Z]_', '', jz4$HMM) 
jz4$HMM <- gsub('Group[0-9][0-9]_con[0-9]_', '', jz4$HMM) 
jz4$HMM <- gsub('Group[0-9]_con[0-9]_[A-Z][A-Z]_', '', jz4$HMM) 
jz4$HMM <- gsub('non_NdoB_type_Naphthalene_Dioxygenase_Alpha', 'non_NdoB_type', jz4$HMM)
jz4$HMM <- gsub('RingHydroxylatingDioxygenase_Alpha', 'RingDioxygenase_alpha', jz4$HMM)
jz4$HMM <- gsub('RingHydroxylating_dioxygenases_beta', 'RingDioxygenase_beta', jz4$HMM)
jz4$HMM <- gsub('MonoAromatic_bphA_tcbA_ipbA_bnzA', 'Monoaromatics_Alpha', jz4$HMM)
jz4$HMM <- gsub('MAH_tcbAb_todC2_bphAb', 'Monoaromatics_Beta', jz4$HMM)
 
 
#select or exclude specific phylum
jz5 = jz4 %>% filter(Phylum != "Proteobacteria" & Phylum != "Actinobacteriota")
jz5 = jz4 %>% filter(Phylum != "Proteobacteria" & Phylum != "Actinobacteriota" & Phylum != "Firmicutes" & Phylum != "Bacteroidota")
jz5 = jz4 %>% filter(Phylum == "Asgardarchaeota")



############HMM Frequency count plot
hmm_freq = as.data.frame(summary(as.factor(jz4$HMM)))
colnames(hmm_freq) = c("count_noise")
hmm_freq$HMM = rownames(hmm_freq)

xx = ggplot(hmm_freq, aes(x = HMM, y = log10(count_noise), fill = count_noise < 10)) + geom_bar(stat = "identity", colour = "black") + labs(x = "", y = "Number of GTDB hits > NC", fill = "") + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 7), axis.title.x = element_blank(),  legend.position = "top", legend.text = element_text(size = 10), panel.background = element_blank(), panel.border = element_rect(fill = NA, colour = "grey30")) + scale_y_continuous(expand = c(0,0), limits = c(0,4.4)) + scale_fill_manual(values = c('grey', 'red'), labels = c("> 10 hits", "< 10 hits"))



##################Phyla frequency plots
###normalize phylum hits to number of phyla reps in GTDB database
bac = read.table("bac120_taxonomy.tsv")

bac2 = bac[,1: ncol(bac)-1]
 
#split taxonomy into separate columns 
bac3 = bac2 %>% separate(V2, c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species"), sep = ";")

#get rid of underscores in phylum names
bac3$Phylum <- gsub('p__', '', bac3$Phylum)


#create summary database
phyla_freq = as.data.frame(summary(as.factor(bac3$Phylum), maxsum = 150))
colnames(phyla_freq) = c("count")
phyla_freq$Phylum = rownames(phyla_freq)


#optional: archaea phyla frequency plot
arc = read.table("ar122_taxonomy.tsv")
arc2 = arc[,1: ncol(arc)-1]
arc3 = arc2 %>% separate(V2, c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species"), sep = ";")
arc3$Phylum <- gsub('p__', '', arc3$Phylum)
#create summary database
phyla_freq = as.data.frame(summary(as.factor(arc3$Phylum), maxsum = 150))
colnames(phyla_freq) = c("count")
phyla_freq$Phylum = rownames(phyla_freq)


#reduce df to only unique accessions - acc_score_count contains number of hits above noise for each accession 
jz_single = jz4 %>% group_by(Genome, Phylum) %>% summarize(acc_score_count = n())

#reduce df to only unique phyla - phylum_score_count contains number of hits above noise for each phylum (only one per species allowed) 
jz_single2 = jz_single %>% group_by(Phylum) %>% summarize(phylum_score_count = n())

#join phyla summary database with norm. score domain by phylum summary table
new_phyla = left_join(phyla_freq, jz_single2, by = "Phylum")


#create column with percent of gtdb reps from phyla with hits above noise -- doesn't take into account that there might be multiple hits in the same species 
new_phyla$percent_gtdb = (new_phyla$phylum_score_count/new_phyla$count)*100
 
 
#get rid of NAs
new_phyla2 = new_phyla %>% filter(phylum_score_count != "NA")
 
 
 #plot 
 gg = ggplot(new_phyla2, aes(y = Phylum, x = (percent_gtdb), colour = percent_gtdb > 20)) + geom_point(aes(size = (count)), alpha = 0.3) + theme(axis.text.y = element_text(size = 10), panel.background = element_blank(), panel.border = element_rect(fill = NA, colour = "grey60"), panel.grid.major = element_line(colour = "grey99"), legend.box = "vertical", legend.position = "top", legend.spacing.y = unit(0.1, "cm"), legend.key = element_blank()) + labs(x = "HMM hits above NC per phylum as ratio of phyla reps in GTDB", y = "", colour = "% of reps in Phyla with HMM hit", size = "Number of reps in GTDB") + scale_colour_manual(values = c("black", "red"), labels = c("< 20%", "> 20%")) + scale_radius(range = c(1,7), trans = 'log10') + geom_text(aes(label = round(percent_gtdb,2)))
 
 #add colours to axis text
new_phyla2$Phylum <- factor(new_phyla2$Phylum,levels=unique(new_phyla2$Phylum))
 con <- ifelse(new_phyla2$percent_gtdb >= 15, 'red', 'black')
 con2 = rev(con)
 

gg = ggplot(new_phyla2, aes(y = Phylum, x = (percent_gtdb), colour = percent_gtdb > 20)) + geom_point(aes(size = (count)), alpha = 0.7) + theme(axis.text.y = element_text(size = 9.5, colour = rev(con)), panel.background = element_blank(), panel.border = element_rect(fill = NA, colour = "grey60"), panel.grid.major = element_line(colour = "grey99"), legend.box = "vertical", legend.position = "top", legend.spacing.y = unit(0.1, "cm"), legend.key = element_blank()) + labs(x = "HMM hits (>0.8) per phylum normalized to phyla reps in GTDB", y = "", colour = "% of reps in GTDB with HMM hit", size = "Number of reps in GTDB") + scale_colour_manual(values = c("black", "red"), labels = c("< 20%", "> 20%")) + scale_radius(range = c(1,7), trans = 'log10') + scale_y_discrete(limits = rev(levels(new_phyla2$Phylum)))
 

#####HMM distribution in phyla
#order the dataframe based on accession and highest normalized score to noise 
 aa <- jz4[order( jz4$score/jz4$Noise, jz4$accession, decreasing = TRUE), ]
 #select only unique accessions (first in list which should have the highest normalized score)
 bb = aa[ !duplicated(aa$accession), ] 

#reduce df to only unique accessions - acc_score_count contains number of hits > Noise for each accession 
jz_single = bb %>% select(Phylum, HMM, score, oxygen, HC, Threshold, Noise) %>% group_by(Phylum, HMM,  oxygen, HC, Threshold, Noise) %>% summarize(hmm_score_count = n(), mean_score = mean(score) )


#join phyla summary database with norm. score domain by phylum summary table
new_phyla = left_join(phyla_freq, jz_single, by = "Phylum")
#get rid of NAs
 new_phyla2 = new_phyla %>% filter(hmm_score_count != "NA")
 
 new_phyla2$oxygen_HC = paste(new_phyla2$oxygen,new_phyla2$HC,sep=" ")
 
 #cluster phyla based on HMM hits
 library(vegan)
 clust_phyla = data.frame(Phylum = new_phyla2$Phylum, HMM = new_phyla2$HMM, hmm_score_count = as.numeric(new_phyla2$hmm_score_count))
 #make data frame wide
 clust_phyla_wide = pivot_wider(clust_phyla, names_from = HMM, values_from = hmm_score_count)
 #turn NA into zeroes
 clust_phyla_wide[is.na(clust_phyla_wide)] = 0
 
 #create matrix for distance clustering
 clustm = as.matrix(clust_phyla_wide[,2:ncol(clust_phyla_wide)])
 row.names(clustm) = clust_phyla_wide$Phylum
  phyl_dist = vegdist(clustm, method= "jaccard")
   phyl_clust = as.dendrogram(hclust(phyl_dist, method = "average"))
   plot(phyl_clust)
   

 new_phyla3 = new_phyla2
  
 new_phyla3$Phylum = factor(new_phyla3$Phylum, levels = labels(phyl_clust), ordered = TRUE)
 
 
 xx = ggplot(new_phyla3,aes(x = Phylum, y = reorder(HMM, desc(HMM)))) + geom_point(aes(size = hmm_score_count, colour = oxygen_HC), alpha = 0.9) + facet_grid(oxygen_HC~., space = "free", scales = "free_y") + theme(axis.text.x = element_text(size = 10, angle = 90, vjust = 0.3, hjust = 1, colour = "grey30"), axis.text.y = element_text(size = 9, colour= "grey30"), axis.ticks = element_line(colour = "grey30"), strip.text.y  = element_text(angle = 0), strip.background = element_rect(fill = "grey95", colour = "grey90"), legend.background = element_blank(), panel.grid.major = element_line(colour = "grey98"), legend.key = element_blank(), panel.background = element_blank(), panel.border = element_rect(fill = NA, colour ="grey90"), legend.position = "top") + labs(x = "", y = "", size = "Number of HMM hits") + scale_colour_manual(guide = "none", values = c("#3381ff", "#addaff", "#ec8609", "#fed872")) + scale_size_continuous(breaks = c(1, 10, 100, 1000), trans = "log10", range = c(1,4)) 
 
 ###GTDB reps vs hits relationship
 
 p = ggplot(new_phyla2, aes(x = count, y = phylum_score_count)) + geom_smooth(method = "lm", colour = "black", alpha = 0.15)+ geom_point(size = 4, alpha =0.6)  + scale_x_continuous(trans = "log",breaks = c(1,10,100,1000,10000,100000)) + scale_y_continuous(trans = "log", breaks = c(1,10,100,1000,10000)) + labs(x = "GTDB reps", y = "HMM hits") + scale_colour_manual(values = colours) + theme(axis.text.y = element_text(size = 10), panel.background = element_blank(), panel.border = element_rect(fill = NA, colour = "grey60"), panel.grid.major = element_line(colour = "grey99"), legend.box = "vertical", legend.position = "none", legend.spacing.y = unit(0.1, "cm"), legend.key = element_blank()) + geom_text(aes(label = Phylum), alpha = 0.5, size =2.5,  colour = "grey40")
 
 #GTDB reps vs hits relationship - black
 p = ggplot(new_phyla2, aes(x = count, y = phylum_score_count)) + geom_smooth(method = "lm", colour = "grey80", alpha = 0.05)+ geom_point(size = 4, alpha =0.6)  + scale_x_continuous(trans = "log",breaks = c(1,10,100,1000,10000,100000)) + scale_y_continuous(trans = "log", breaks = c(1,10,100,1000,10000, 100000)) + labs(x = "GTDB reps", y = "HMM hits")  + theme(axis.text.y = element_text(size = 10), panel.background = element_blank(), panel.border = element_rect(fill = NA, colour = "grey60"), panel.grid.major = element_line(colour = "grey99"), legend.box = "vertical", legend.position = "none", legend.spacing.y = unit(0.1, "cm"), legend.key = element_blank()) + geom_text(aes(label = Phylum, y = phylum_score_count+(phylum_score_count/5)), alpha = 0.65, size =2.5,  colour = "grey20") + coord_equal()


  ###########Cyanobacteria LadA 
  
  jz5 = jz4 %>% filter(Phylum == "Cyanobacteria")
  jz6 = jz5 %>% filter(HMM == "LadA_beta")
  jz6$Genus <- gsub('g__', '', jz6$Genus)
  jz6$Family <- gsub('f__', '', jz6$Family)
  jz6$Genus <- gsub('_.', '', jz6$Genus)
  
  #make Cyanobacteria genus figure
  
  xx = ggplot(jz6, aes(x = score, y = reorder(Genus, desc(Genus)))) + geom_point(size = 3, alpha = 0.5) + theme(axis.text.x = element_text(size = 10, colour = "grey30"), axis.text.y = element_text(size = 9, colour= "grey30"), axis.ticks = element_line(colour = "grey30"), panel.grid.major = element_line(colour = "grey98"),  panel.background = element_blank(), panel.border = element_rect(fill = NA, colour ="grey90"), axis.title.x = element_text(colour = "grey30", face = "bold")) + labs(x = "LadA beta HMM score", y = "")

#horizontal 
xx = ggplot(jz6, aes(y = score, x= Genus)) + geom_point(size = 3, alpha = 0.55) + theme(axis.text.x = element_text(angle = 90, vjust = 0.3, hjust = 1, size = 10, colour = "grey30"), axis.text.y = element_text(size = 9, colour= "grey30"), axis.ticks = element_line(colour = "grey30"), panel.grid.major = element_line(colour = "grey98"),  panel.background = element_blank(), panel.border = element_rect(fill = NA, colour ="grey90"), axis.title.y = element_text(colour = "grey30", face = "bold"), legend.text = element_text(size = 9, colour = "grey30"), legend.position = "top", legend.key = element_blank()) + labs(y = "LadA beta HMM score", x = "", colour = "") 

#add colours for family
xx = ggplot(jz6, aes(x = score, y = reorder(Genus, desc(Genus)))) + geom_point(size = 3, alpha = 0.85, aes(colour = Family)) + theme(axis.text.x = element_text(size = 10, colour = "grey30"), axis.text.y = element_text(size = 9, colour= "grey30"), axis.ticks = element_line(colour = "grey30"), panel.grid.major = element_line(colour = "grey98"),  panel.background = element_blank(), panel.border = element_rect(fill = NA, colour ="grey90"), axis.title.x = element_text(colour = "grey30", face = "bold"), legend.text = element_text(size = 9, colour = "grey30"), legend.title = element_text(colour = "grey30"), legend.position = "right", legend.key = element_blank()) + labs(x = "LadA beta HMM score", y = "") + scale_colour_manual(values = c("#173A17", "#3A7132", "#84C072", "#C6E7C6"))
  
 #horizontal 
 xx = ggplot(jz6, aes(y = score, x= Genus)) + geom_point(size = 3, alpha = 0.85, aes(colour = Family)) + theme(axis.text.x = element_text(angle = 90, vjust = 0.3, hjust = 1, size = 10, colour = "grey30"), axis.text.y = element_text(size = 9, colour= "grey30"), axis.ticks = element_line(colour = "grey30"), panel.grid.major = element_line(colour = "grey98"),  panel.background = element_blank(), panel.border = element_rect(fill = NA, colour ="grey90"), axis.title.y = element_text(colour = "grey30", face = "bold"), legend.text = element_text(size = 9, colour = "grey30"), legend.position = "top", legend.key = element_blank()) + labs(y = "LadA beta HMM score", x = "", colour = "") + scale_colour_manual(values = c("#173A17", "#3A7132", "#84C072", "#C6E7C6"))
  
  #concatenate cyanobacteria genome list 
  new = as.data.frame(summary(as.factor(jz7$Genome)))
   write.csv(new, "Cyano_ladA-beta_genome.csv")
  sed 's/\r$//' cyano_genome_ladA_list.txt > cyano_genome_ladA_list.UNIX.list 
  #in bash
    for file in $(<../../cyano_genomes/cyano_genome_ladA_list.UNIX.list ); do cp "$file" ../../cyano_genomes/; done
	#### fix gene headers so that they contain organsim accession ### 

for var in *.faa; do sed 's/>/>'$var'_/g' $var > 'Header_'$var;done
	
	cat Header* > cyano_ladA_cat_genomes.fasta

   #convert to single line fasta file 
 awk '{if(NR==1) {print $0} else {if($0 ~ /^>/) {print "\n"$0} else {printf $0}}}' cyano_ladA_cat_genomes.fasta > cyano_ladA_genomes_singleline.fasta


#collect ladA sequences - need to add extra spaces for grep command  
new2 = as.data.frame(summary(as.factor(jz6$accession),maxsum = 160))
write.csv(new2, "Cyano_ladA-beta_accession.csv")
sed 's/\r$//' cyano_accession_ladA_list.txt > cyano_accession_ladA_list.UNIX.txt
grep -A1 -f cyano_accession_ladA_list.UNIX.txt cyano_ladA_genomes_singleline.fasta --no-group-separator > cyano_ladA_accessions_seqs.fasta

#add lad ref seqs back in   - need to add new lines between fasta files 
#98% clusters
cat cyano_ladA_accessions_seqs.fasta ../../../JZ/LadA_redo/Group8.ladA_beta.98.repseqs.fasta ../../../JZ/LadA_redo/Group8.ladA_alpha.98.repseqs.fasta ../../../JZ/LadA_redo/Group8.ladB.98.repseqs.fasta > lad_cyano_seqs_98.fasta
  
  
  #only seqs used for HMM
 cat cyano_ladA_accessions_seqs.fasta ../../../HMM/for_HMM_alignment/Supplementary_Data_HMM_Fastas/Group8_con1_JZ_LadA_alpha.fasta ../../../HMM/for_HMM_alignment/Supplementary_Data_HMM_Fastas/Group8_con1_JZ_LadA_beta.fasta ../../../HMM/for_HMM_alignment/Supplementary_Data_HMM_Fastas/Group8_con1_JZ_LadB.fasta > cyano_ladA_plus_lad_HMM_seqs.fasta 
  
  #shorten long gene names
  sed 's/\#.*//g' cyano_ladA_plus_lad_HMM_seqs.fasta > test_cyano_ladA_plus_lad_HMM_seqs.fasta 
  
  #cluster at 70% ID
  usearch -cluster_fast test_lad_cyano_seqs_98.fasta -id 0.70 -centroids test_lad_cyano_seqs_70.fasta -uc test_lad_cyano_seqs_70.clusters.uc

  #add EXP sequences back in 
  
#muscle alignment 
  muscle -in test_cyano_ladA_plus_lad_HMM_seqs.fasta -out test_cyano_ladA_plus_lad_HMM_seqs_align.fasta
  
