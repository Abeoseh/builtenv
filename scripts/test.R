# #!/usr/bin/env/Rscript
# 
# .libPaths( c( .libPaths(), "~/my_R_libs") )
suppressPackageStartupMessages(library(dplyr))
# suppressPackageStartupMessages(library(biomformat))
# suppressPackageStartupMessages(library(dada2))
suppressPackageStartupMessages(library(tidyverse))
# suppressPackageStartupMessages(library(BSDA))
# suppressPackageStartupMessages(library(randomForest))
# suppressPackageStartupMessages(library(pROC))


files = list.files(".", "*.SraRunTable.txt", recursive = TRUE)
files = files[c(1,2,4)]


# PRJEB3232

file = read.csv(files[1], header=TRUE)

df = distinct(file, genericdescription)

df$ID <- file$BioProject[dim(df)[1]]
colnames(df) = c("surface", "ID")

# PRJEB3250
file = read.table(files[2], sep=",", header=TRUE)

df1 = distinct(file, surface) 

df1$ID <- file$BioProject[dim(df1)[1]]
colnames(df1) = c("surface", "ID")
df = rbind(df, df1)

# PRJNA878661

file = read.table(files[3], sep=",", header=TRUE)

df1 = distinct(file, sample_type)

df1$ID <- file$BioProject[dim(df1)[1]]
colnames(df1) = c("surface", "ID")
df = rbind(df, df1)

write.csv(df, "common_ontology.csv", row.names = F)

d <- function(df, x){
  x <- deparse(substitute(x))
  filter(df, ID == x)
}

d(df, PRJEB3250)
