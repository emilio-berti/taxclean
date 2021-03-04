library(igraph)

overlap <- read.csv("overlaps.csv") %>%
  filter(V1 != V2)
net <- graph_from_data_frame(overlap, directed = FALSE)
adj <- get.adjacency(net, sparse = FALSE)
for (x in rownames(adj)) {
  for (y in setdiff(colnames(adj), x)) {
    n <- overlap %>%
      filter(V1 == x, V2 == y) %>%
      pull(common_species_n)
    if (is_empty(n)) {
      n <- overlap %>%
        filter(V1 == y, V2 == x) %>%
        pull(common_species_n)
    }
    adj[x, y] <- n
  }
}

net <- graph_from_adjacency_matrix(adj,
                                   mode = "undirected",
                                   weighted = "n",
                                   diag = FALSE)
plot.igraph(net,
            edge.width = edge_attr(net)$n / 100000,
            layout = layout.circle(net))

par(mfrow = c(1, 2))
plot(1:7, centiserve::laplacian(net), frame = FALSE, axes = FALSE, xlab = "", ylab = "Laplacian")
axis(1, at = 1:7, labels = names(centiserve::laplacian(net)))
axis(2, at = centiserve::laplacian(net))

plot(1:7, eigen_centrality(net, weights = edge_attr(net)$n)$vector, frame = FALSE, axes = FALSE, xlab = "", ylab = "Eigen-centrality")
axis(1, at = 1:7, labels = names(eigen_centrality(net, weights = edge_attr(net)$n)$vector))
axis(2, at = round(eigen_centrality(net, weights = edge_attr(net)$n)$vector, 2))
