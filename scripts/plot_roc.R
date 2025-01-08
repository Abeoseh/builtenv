library(ggplot2)
library(dplyr)

roc <- read.csv("./roc_df.csv")
current_roc <- filter(roc, Study_ID == 10172) %>% filter(Permutation == 0)



roc_plot <- ggplot(current_roc, aes(x = specificities, y = sensitivities)) + 
  geom_line(col = "red") + 
  xlim(1.00,0) +
  ylim(0,1.00) 

permutations = distinct(roc, Permutation)$Permutation
for(permutation in 1:length(permutations)){
    current_roc <- filter(roc, Study_ID == 10172 & Permutation == permutation)
    head(current_roc) %>% print()
    roc_plot <- roc_plot + 
      geom_line(current_roc, mapping = aes(x = specificities, y = sensitivities))
    print("done")
  }

print(roc_plot)
