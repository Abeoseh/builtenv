#!/usr/bin/env/Rscript

.libPaths( c( .libPaths(), "~/my_R_libs") )
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(biomformat))
suppressPackageStartupMessages(library(dada2))
suppressPackageStartupMessages(library(tidyverse))

set.seed(100)

args <- commandArgs(trailingOnly = TRUE)
i = as.numeric(args[1])
print("working dir")
print(getwd())

biom.files <- list.files(pattern ="all.biom$", full.name=TRUE, recursive = TRUE) #contains all the all.biom files
#biom.files <- c("./10172/128720_all.biom", "./10172/127245_all.biom","./10172/131351_all.biom")
print(i)
print(biom.files[i])

# read one biom file from the list and make it a dataframe
OTU_reads <- read_hdf5_biom(biom.files[i]) 
OTU_reads = biom(OTU_reads)
OTU_table <- as.data.frame(as.matrix(biom_data(OTU_reads)))
  
if( "V1" %in% colnames(OTU_table)){
  colnames(OTU_table)[colnames(OTU_table) == "V1"] = OTU_reads$columns[[1]][1]
  }

seqs <- row.names(OTU_table)
taxa <- assignTaxonomy(seqs, "~/Taxonomy_Dada2/silva_nr99_v138.1_train_set.fa.gz", multithread=TRUE)
  
df <- as.data.frame(taxa) %>% select(Genus) %>% drop_na(Genus) %>% merge(OTU_table, by="row.names", all=TRUE)

row.names(df) = df$Row.names
df <- subset(df, select=-c(Row.names)) 
  
# df <- aggregate(.~Genus, data= df, FUN=sum)
df <- aggregate(.~Genus, data= df, FUN=sum)
  
#### print colnames
print("individual df")
print(colnames(df))
print(head(df))
  

name = strsplit(biom.files[i], "/")
name1 = name[[1]][2]
name2 = strsplit(name[[1]][3], "_all.biom")[[1]][1]
print(paste("./csv_files/combine/single",name1,"_",name2,".csv",sep=""))

write.csv(df, paste("./csv_files/combine/single_",name1,"_",name2,".csv",sep=""), row.names=FALSE)




