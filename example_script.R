library(bipartite)
library(igraph)
library(ggplot2)
# read in the lovely open-data from Hackett et al 2019
talyas_data <- read.csv('https://figshare.com/ndownloader/files/15122768')


# Basic formatting --------------------------------------------------------

# remove unwanted metadata
talyas_data <- talyas_data[,c('habitat', 'upper_taxon', 'lower_taxon', 'freq')]
# split into a list by habitat type
df_list <- split(talyas_data, talyas_data$habitat)

# convert the edgelist to adjacency matrices, as r likes those
network_list <- list()
for(i in 1:length(df_list)){
  el <- df_list[[i]][,c(2:4)]
  colnames(el) <- c('from', 'to', 'weight')
  g=graph_from_data_frame(el, vertices = NULL)
  adj_mat <- get.adjacency(g,sparse=FALSE, attr = 'weight')
  network_list[[i]] <- adj_mat
}
# format the list a little so we know which network is which
names(network_list) <- names(df_list)


# Exploratory plotting ----------------------------------------------------



dir.create('figures')
jpeg(filename = 'figures/networks.jpg', res = 100)
par(mfrow = c(3, 3))
for(i in 1:length(network_list)){
    plotweb(network_list[[i]])
  title(names(network_list)[i])
}
dev.off()


# Innovative, imaginative analyses ----------------------------------------

nestedness_list <- list()
for(i in 1:length(network_list)){
  nestedness_list[[i]] <- c(nestedness = networklevel(web = network_list[[i]],
                                         index = 'nestedness'),
                            habitat = names(network_list)[i])
}


combined_results <- as.data.frame(do.call(rbind, nestedness_list))
combined_results$nestedness <- as.numeric(combined_results$nestedness.nestedness)
dir.create('results')
write.csv(combined_results, file = 'results/network_p_hacking.csv')

# lets plot it
ggplot(combined_results, aes(x = as.numeric(nestedness), y = habitat))+
  geom_bar(stat = 'identity') +
  theme_bw()
ggsave('figures/nestedness.jpeg')

