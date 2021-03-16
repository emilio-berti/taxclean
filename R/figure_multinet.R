library(tidyverse)
library(igraph)

tools <- sample_smallworld(1, 20, 3, 0.1)
vertex_attr(tools)$name <- LETTERS[1:20]
dbs <- sample_smallworld(1, 5, 2, 0.1)
vertex_attr(dbs)$name <- letters[1:5]

# adjacency matrices
adj_tools <- as_adjacency_matrix(tools, sparse = FALSE)
adj_dbs <- as_adjacency_matrix(dbs, sparse = FALSE)
tool_dbs <- matrix(as.numeric(runif(nrow(adj_tools) * ncol(adj_dbs), 0, 1) >= 0.90),
                   nrow(adj_tools),
                   ncol(adj_dbs))
rownames(tool_dbs) <- vertex_attr(tools)$name
colnames(tool_dbs) <- vertex_attr(dbs)$name

# create multilayer adjacency matrix ----------
multinet <- matrix(0,
                   nrow = nrow(adj_tools) + nrow(adj_dbs),
                   ncol = ncol(adj_tools) + ncol(adj_dbs))
colnames(multinet) <- c(vertex_attr(tools)$name,
                        vertex_attr(dbs)$name)
rownames(multinet) <- c(vertex_attr(tools)$name,
                        vertex_attr(dbs)$name)
multinet[1:nrow(adj_tools), 1:nrow(adj_tools)] <- adj_tools
multinet[(nrow(adj_tools) + 1):nrow(multinet),
         (nrow(adj_tools) + 1):nrow(multinet)] <- adj_dbs
# assign multilayer links
for (i in seq_len(nrow(tool_dbs))) {
  if (any(as.logical(tool_dbs[i, ]))) {
    multinet[i, which(tool_dbs[i, ] == 1) + nrow(adj_tools)] <- 2
    multinet[which(tool_dbs[i, ] == 1) + nrow(adj_tools), i] <- 2
  }
}

multinet <- multinet * upper.tri(multinet)
g <- graph_from_adjacency_matrix(multinet, weighted = TRUE)
vertex_attr(g)$type <- c(rep("steelblue", nrow(adj_tools)),
                         rep("tomato", nrow(adj_dbs)))
edge_attr(g)$type <- sapply(edge_attr(g)$weight, function(x) {
  if (x == 1) {
    "green4"
  } else {
    "goldenrod"
  }
})

par(bg = "grey13",
    mar = c(0, 0, 0, 0))
plot.igraph(g,
            layout = layout.sphere,
            vertex.color = vertex_attr(g)$type,
            edge.color = edge_attr(g)$type)
legend(x = 0.9,
       y = 1,
       legend = c("R package", "Database"),
       col = c("steelblue", "tomato"),
       bty = "n",
       pch = 20,
       pt.cex = 3,
       cex = 1.2,
       text.col = "grey95")
