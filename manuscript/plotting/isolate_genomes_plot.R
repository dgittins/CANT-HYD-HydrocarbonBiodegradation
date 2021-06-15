library(reshape2)
library(dplyr)
library(tidyr)
library(ggplot2)

setwd("alkanes_hackathon/validation/")

f <- read.table("./isolate_hmmsearch_results.csv", header=TRUE,sep="\t")

f_m <- melt(f,id=c("genome","genome_class"))

write.csv(f_m,"isolate_hmmsearch_results_long.csv")
f_m_new <- read.csv("isolate_hmmsearch_results_long.csv")

f_m_new$genome <- factor(f_m_new$genome,levels = unique(f_m_new$genome))

p1 <- ggplot(f_m_new,aes(x=genome,y=hmm_new_name))+
  geom_point(aes(size = value,colour=hmm_class),alpha=0.75)+
  facet_grid(hmm_class ~genome_class,scales = "free", space = "free",labeller = label_wrap_gen())+ 
  scale_size_continuous(limits=c(1,9),range = c(1.5,9),breaks=c(1,3,5,7))+
  labs(size="Count of Normalized Scores > 1",colour="HMM Classification")+
  theme(axis.text.y=element_text(colour="#31393C",size=10),
        axis.ticks.y=element_blank(),
        axis.title=element_blank(),
        axis.text.x=element_blank(),#text(angle=90,hjust=1,vjust=0.3, colour="#31393C",size=12),
        legend.title = element_text(size = 11), panel.background = element_blank(),
        legend.text = element_text(size=11,color = "#31393C"),
        panel.border = element_rect(colour = "#e6e6e6ff", fill = NA, size = 1.2), 
        legend.position = "right",
        panel.grid.major.y = element_line(colour = "#fafafaff"),
        panel.grid.major.x = element_line(colour="#fafafaff"),
        strip.text.x = element_text(colour="black",size=10,angle=90),
        strip.text.y = element_text(colour="black",size=10,angle=0),
        strip.background = element_rect(fill = "#f2f2f2ff",color = "#fafafaff"))+
  scale_color_manual(values = c("#3381FF","#ADDAFF","#EC8609","#FED872"), guide = guide_legend(override.aes = list(size=5)))#
p1

