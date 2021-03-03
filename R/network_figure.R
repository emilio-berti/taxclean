library(igraph)

d <- read.csv("overlaps.csv")
net <- graph_from_data_frame(d, directed = FALSE)
plot.igraph(net,
            edge.width = log10(edge_attr(net)$common_species_n / 100),
            layout = layout.star(net))
