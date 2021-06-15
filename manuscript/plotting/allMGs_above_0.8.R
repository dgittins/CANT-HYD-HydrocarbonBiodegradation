library(reshape2)
library(dplyr)
library(tidyr)
library(ggplot2)

setwd("../My Documents/alkanes_hackathon/validation/Metagenomes/normalized_metagenome_hmmsearch_results")

f <- read.table("./allMG_above_NC_wide.csv", header=TRUE,sep=",")

f_m <- melt(f,id=c("Metagenome","Environment"))

write.csv(f_m,"allMG_above_NC_long.csv")
f_m_new <- read.csv("allMG_above_NC_long.csv")


#keep order same as original data
f_m_new$variable <- factor(f_m_new$variable,levels = unique(f_m_new$variable))

#~~~~~~~~~~~~~~~~~~~~~~~~~~BUBBLE PLOT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

p2 <- ggplot(f_m_new,aes(x=Metagenome,y=variable)) +
  geom_point(aes(size = value, colour = class),alpha=0.75)+
  facet_grid(class ~ Environment ,scales = "free",space="free")+
  scale_y_discrete(limits=rev)+
  scale_size_continuous(limits=c(0.000011,0.03),range = c(1.5,12),breaks=c(0.00001,0.0001,0.001,0.01,0.1))+
  labs(size="# of Hits",colour="HMM Metabolism Classification")  + 
  theme(axis.text.y=element_text(colour="#31393C",size=12),
        axis.ticks.y=element_blank(),
        axis.title=element_blank(),
        axis.text.x=element_text(angle=90,hjust=1,vjust=0.3, colour="#31393C",size=12),
        legend.title = element_text(size = 12), panel.background = element_blank(),
        legend.text = element_text(size=12,color = "#31393C"),
        panel.border = element_rect(colour = "#e6e6e6ff", fill = NA, size = 1.2), 
        legend.position = "right",
        legend.background = element_blank(),
        panel.grid.major.y = element_line(colour = "#fafafaff"),
        panel.grid.major.x = element_line(colour="#fafafaff"),
        strip.text.y = element_text(colour="black",size=12,angle=0),
        strip.background = element_rect(fill = "#f2f2f2ff",color = "#fafafaff"))+
  scale_color_manual(values = c("#3381FF","#ADDAFF","#EC8609","#FED872"), guide = guide_legend(override.aes = list(size=5)))

p2

#~~~~~~~~~~~~~~~~~~~~~~~~~~HEATMAP PLOT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

library(ggdendro)
library(grid)
library(dendextend)

rownames(f) <- f$Metagenome

d <- dist(f,method="euclidean")
h <- as.dendrogram(hclust(d,method = "average"))

mg_dendro <- ggdendrogram(data=h,rotate=TRUE)+
  theme(axis.text.y=element_text(size=10,colour = "#31393C"))

mg_dendro

dend_1 <- f %>% dist %>% hclust %>% as.dendrogram %>% set("labels_cex",0) %>% set("branches_lwd",0.5) %>% set("hang_leaves")

mg_dendro <- ggdendrogram(data=dend_1,rotate=TRUE)+
  theme(axis.text.y=element_text(size=10,colour = "#31393C"))

plot(mg_dendro)

f_m_new$Metagenome <- factor(f_m_new$Metagenome,levels=labels(dend_1),ordered = TRUE)



p1 <- ggplot(f_m_new,aes(x=variable,y=Metagenome), fill=value)+
  geom_tile(aes(fill=value))+
  theme(axis.title=element_blank(),
        axis.text.x = element_text(angle=90, size=10,colour="#31393C",hjust=1,vjust=0.3),
        #axis.text.y=element_blank(),
        axis.text.y = element_text(size=8,colour="#31393C"),
        legend.position = "none",
        legend.text=element_text(size=8,colour="#31393C"))+
  scale_fill_gradient(high = "#EC8609",low = "#FFFFFF",na.value = "#FFFFFF", trans="log10")
                  
  
  #scale_fill_gradient(colours=my_palette,breaks=my_breaks)+
  #coord_flip()#+
  #labs(title = "Mixed Metagenomes, norcutoff >=0.8",value="Counts of gene expression")

p1

#putting plots together
grid.newpage()
print(p1,vp=viewport(x = 0.3, y = 0.5, width = 0.6, height = 1.0))
print(mg_dendro, vp = viewport(x = 0.8, y = 0.69, width = 0.4, height = 0.63))
