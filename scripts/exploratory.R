library(dplyr)
library(tidyverse)


dfs <- list.files("./", pattern=".txt", recursive = TRUE)[1:4]

# 10172
file1 <- read.csv(dfs[1], sep="\t") %>% select(sample_name, surface) %>% distinct(surface) %>% mutate(ID = 10172)
# 11740
file2 <- read.csv(dfs[2], sep="\t") #%>% select(sample_name, surface_sampledsample) %>% distinct(surface_sampledsample) %>% mutate(ID = 11740)
names(file2)[1] <- "surface"
# 11950
file3 <- read.csv(dfs[3], sep="\t") %>% select(sample_name, sample_type) %>% distinct(sample_type) %>% mutate(ID = 11950)
names(file3)[1] <- "surface"
# 12470
file4 <- read.csv(dfs[4], sep="\t") %>% select(sample_name, description) %>% distinct(description) %>% mutate(ID = 12470)
names(file4)[1] <- "surface"



all.files <- rbind(file1, file2, file3, file4) 

write.csv(all.files, "common_ontology.csv", row.names = FALSE)

# # df <- read.csv("./12470/12470_20230201-071433.txt", sep="\t")
# df <- read.csv("./130024_assigned.csv", row.names = 1)
# 
# d <- df %>% select(Row.names, Genus, X11740.13.1.ThursFri.Swab.o, X11740.28.3.MonTues.Swab.pa,
#                    X11740.31.2.MonTues.Swab.o, X11740.33.2.MonTues.Swab.o,
#                    X11740.44.2.ThursFri.Swab.pa, X11740.44.5.ThursFri.Swab.pa,
#                    X11740.7.4.MonTues.Swab.o)
# d %>% filter(X11740.44.5.ThursFri.Swab.pa > 0) %>% select(Genus, X11740.44.5.ThursFri.Swab.pa) %>% View() 
# d2 <-d[grep("Floor", d$subject_surface),] %>% distinct(subject_surface) %>% View()
# 
# 
# for(file in files[2:length(files)]){
#   print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
#   print("current file")
#   print(file)
#   df = read.csv(file, check.names=FALSE)
#   duplicate_samples <- (names(df)[-1] %in% names(combine_otus))
#   duplicate_genus <- df$Genus %in% combine_otus$Genus
#   #if ( (TRUE %in% duplicate_samples) & (TRUE %in% duplicate_genus) ){
#   #	print("duplicate samples and genuses exist")
#   #	print(names(df)[-1][duplicate_samples])
#   #	combine_otus <- aggregate(. ~ Genus, bind_rows(combine_otus, df), sum)
#   #}	
#   if( (TRUE %in% duplicate_samples )){
#     print("duplicate samples exist")
#     print(names(df)[-1][duplicate_samples])
#     
#     #print("___________________________________")
#     #print(names(combine_otus))
#     #v = names(df)[-1][ (names(df)[-1] %in% names(combine_otus)) ]
#     #print(names(df)[-1][ (names(df)[-1] %in% names(combine_otus)) ] )
#     #print(df[,v])
#     #print(combine_otus[,v])
#     #print( (TRUE %in% (names(df)[-1] %in% names(combine_otus)) ) )
#     combine_otus <- bind_rows(combine_otus, df) 
#     if( length(unique(combine_otus$Genus)) == nrow(combine_otus) ){
#       print(names(df)[-1][duplicate_genus])
#       combine_otus <- aggregate(. ~ Genus, combine_otus, sum)}
#     
#   }
#   
#   else( combine_otus <- merge(combine_otus, df, by="Genus", all=TRUE) )
# }


            
