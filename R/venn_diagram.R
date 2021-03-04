library(VennDiagram)

overlap <- read.csv("overlaps.csv")
species <- read_rds("species_list.rds")

for (db in names(species)) {
  if (any(is.na(species[[db]]))) {
    species[[db]] <- species[[db]][-which(is.na(species[[db]]))]
  }
}

venn.diagram(species,
             category.names = names(species),
             filename = "venn.png",
             output = TRUE)
