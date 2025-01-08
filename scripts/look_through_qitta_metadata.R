biom.files = list.files(path = ".", "_all.biom", recursive = TRUE)
OTU_reads <- read_hdf5_biom(biom.files[2]) 
OTU_reads = biom(OTU_reads)
OTU_table <- as.data.frame(as.matrix(biom_data(OTU_reads)))
combine_otus <- OTU_tables


if( "V1" %in% colnames(OTU_table)){
  colnames(OTU_table)[colnames(OTU_table) == "V1"] = OTU_reads$columns[[1]][1]
}




ref.files = list.files(path = ".", ".txt", recursive = TRUE)[1:6]
ref.files = ref.files[-c(3)] # remove 11950

# read the first csv
all_ref = read.csv(ref.files[1], sep="\t", header=TRUE)
all_ref = select(all_ref, sample_type, sample_name)
all_ref$Study_ID <- strsplit(ref.files[1], "/")[[1]][1] # split the names of the ref files and assign the folder name (ID) to the Study_ID column


ref1 = read.csv(ref.files[4], sep="\t", header=TRUE)
ref1 = select(ref1, genericdescription, sample_name)
ref1$Study_ID <- strsplit(ref.files[4], "/")[[1]][1]
names(ref1) = c("sample_type", "sample_name", "Study_ID")
all_ref = rbind(all_ref, ref1)

# loop through and do the exact same steps with the rest of ref.files
for( file in ref.files[2:length(ref.files)]){
  print(file)
  ref1 = read.csv(file, sep="\t", header=TRUE)
  ref1 = select(ref1, sample_type) # this is the info about what type of sample each sample is e.g, hand, floor... if I need to select different columns I cannot use this as a loop.
  ref1$Study_ID <- strsplit(file, "/")[[1]][1]
  all_ref = rbind(all_ref, ref1)
  
}

all_ref$sample_type[all_ref$sample_type == "skin of hand" | all_ref$sample_type == "surface"] %>% View


for_demo = all_ref %>% group_by(Study_ID) %>% count(sample_type) 



table <- data.frame(x = c(NA,0,2,4,5),
         y = c(2,2,4,5,3))


percent = colSums(is.na(table))/nrow(table) # percent is a named number
percent = percent[percent < 0.25] # gives the columns with an amount of NAs less than 25%

table <- table %>% select(names(percent)) # select the columns with the amount of NAs less than 25%

print("dim lognorm after filtering NA")
print(dim(table))

percent = colSums(table == 0 | is.na(table), na.rm = T)/nrow(table) # percent is a named number
percent = percent[percent < 0.25] # gives the columns with an amount of NAs less than 25%
write.csv(as.data.frame(percent), "./csv_files/test/percent.csv")



#### PCA of Counts ####
# merge metadata and count tables
df <- read.csv("./csv_files/final_df.csv", check.names = FALSE)

combine_otus <- filter(df, Study_ID == 10172 | Study_ID == 1566)
combine_otus <- combine_otus %>% relocate(Phenotype, .after = sample_name) %>% relocate(Study_ID, .after = Phenotype)
rownames(combine_otus) <- combine_otus$sample_name
combine_otus = combine_otus[,-c(1:3)]
combine_otus <- combine_otus[apply(combine_otus, 2, function(x) !sum(x)==0),]
combine_otus <- combine_otus[,colSums(combine_otus) > 0]


scaled <- as.data.frame(scale(combine_otus))
scaled[!complete.cases(scaled),] %>% View()
dw_pca <- prcomp(scaled)
pca_contr = summary(dw_pca)$importance[2,]
dwpca.df = as.data.frame(dw_pca$x)
# dwpca.df <- save

dwpca.df$Phenotype <- 0
dwpca.df$sample_name = row.names(dwpca.df)
indicies <- match(all_ref$sample_name,dwpca.df$sample_name)
valid_indices <- indicies[!is.na(indicies)]
dwpca.df$Phenotype[valid_indices] <- all_ref$sample_type[!is.na(indicies)]
dwpca.df <- filter(dwpca.df, Phenotype != 0)
# dwpca.df <- dwpca.df %>% relocate(Phenotype, .after = sample_name) 

# dwpca.df$Phenotype[match(all_ref$sample_name,dwpca.df$sample_name)] <- all_ref$sample_type




ggplot(dwpca.df, aes(x = PC1, y = PC2)) +
  geom_point(aes(col = as.factor(Phenotype))) +
  #scale_color_brewer(name = "Phenotype", palette = "Paired") #+
  labs(x = paste("PC1", " (", pca_contr["PC1"] *100, ") ", sep = ""), y = paste("PC2", " (", pca_contr["PC2"] *100,") ", sep=""))







