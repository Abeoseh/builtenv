library(dplyr)
# PCoA
library(ecodist)
library(vegan)
# PCA
library(factoextra)
library(lemon)
library(ggplot2)

skin_floor <- read.csv("./csv_files/skin_floor/lognorm_data.csv")
associated <- read.csv("./csv_files/associated_2192/lognorm_data.csv")
combine_otus <- read.csv("./csv_files/combine/combine_otus.csv", check.names = FALSE)

a = t(combine_otus) 
colnames(a) = combine_otus$Genus
a <- as.data.frame(a[-c(1),])
a$sample_name = row.names(a)
a[is.na(a)] <- 0

skin_floor_labels <- case_when(skin_floor$Phenotype == 0 ~ "floor",
                               skin_floor$Phenotype == 1 ~ "skin")
skin_floor$Phenotype <- skin_floor_labels


associated_labels <- case_when(associated$Phenotype == 0 ~ "floor associated",
                               associated$Phenotype == 1 ~ "skin associated")
associated$Phenotype <- associated_labels

duplicate_names <- skin_floor$sample_name[skin_floor$sample_name %in% associated$sample_name]
duplicates <- row.names(skin_floor)[skin_floor$sample_name %in% associated$sample_name]

phenotype <- skin_floor$Phenotype[row.names(skin_floor) %in% duplicates]
df = data.frame(rows = as.numeric(duplicates), phenos = phenotype, sample_name = duplicate_names)

merged <- associated

### 2192.H01a.Bathroom.Door.Knob.30.lane1.NoIndex.L001
skin_floor <- skin_floor[-c(df$rows[df$phenos == "skin"]),]
df <- df[df$phenos=="floor",]

merged <- bind_rows(merged, skin_floor[skin_floor$Phenotype == "skin",])

merged$Phenotype[merged$sample_name %in% df$sample_name]  <- "floor" 
merged[is.na(merged)] <- 0

cols.num <- colnames(a)[1:length(a)-1]
a[cols.num] <- sapply(a[cols.num],as.numeric)
pcoa_df = a[(a$sample_name %in% merged$sample_name),]
pcoa_df <- select(merged, "sample_name", "Phenotype", "Study_ID") %>% merge(pcoa_df, by.all="sample_name")

phenos <- select(pcoa_df, sample_name, Phenotype, Study_ID)

numeric_df <- pcoa_df[,4:length(pcoa_df)]
row.names(numeric_df) <- phenos$sample_name
d <- colSums(numeric_df) != 0
numeric_df <- numeric_df[,d] 


#### PCOA ####
bray <- vegdist(numeric_df, method = "bray")
pcoa_val <- pco(bray, negvals = "zero", dround = 0)

pco.labels = lapply(row.names(pcoa_val$vectors), function(x) unlist(strsplit(x, split = ".", fixed=TRUE))[1]) # remove .numbers from the end of the row names
pco.labels = row.names(pcoa_val$vectors) # remove .numbers from the end of the row names

pcoa_val.df = data.frame(sample_name = row.names(pcoa_val$vectors),
                         PCoA1 = pcoa_val$vectors[,1], 
                         PCoA2 = pcoa_val$vectors[,2])

pcoa_val.df = merge(pcoa_val.df, phenos, by.all = "sample_name")

pco.plot = ggplot(data = pcoa_val.df, mapping = aes(x = PCoA1, y = PCoA2)) + 
  geom_point(aes(col = as.factor(Phenotype)), alpha = 0.7) +
  scale_color_brewer(name = "phenotype", palette = "Paired") +
  labs(title = "PCoA of Count data", x = "PC1", y = "PC2")

print(pco.plot)


#### PCA ####
scaled <- as.data.frame(scale(numeric_df))

dw_pca <- prcomp(scaled)
var = get_pca_var(dw_pca)
dwpcacontr.df = as.data.frame(var$contrib)
pca_contr = summary(dw_pca)$importance[2,]

dwpca.df = as.data.frame(dw_pca$x)
dwpca.df$sample_name = row.names(dwpca.df)
dwpca.df = merge(dwpca.df, phenos, by.all = "sample_name")

ggplot(dwpca.df, aes(x = PC1, y = PC2)) +
  geom_point(aes(col = as.factor(Phenotype))) +
  scale_color_brewer(name = "phenotype", palette = "Paired") +
  labs(title = "PCA of Count data", x = paste("PC1 ", "(", pca_contr[["PC1"]]*100, "%)", sep = ""), y = paste("PC2 ", "(", pca_contr[["PC2"]]*100,"%)", sep=""))

