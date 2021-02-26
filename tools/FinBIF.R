library(finbif)
library(rnaturalearth)
library(sf)

#finbif_request_token("my-email@here.com")
token <- read.csv("~/Documents/finbif.txt", header = FALSE) #don't store token in git repos
Sys.setenv(FINBIF_ACCESS_TOKEN = token$V1)

# check taxonomy
finbif_check_taxa(c("Cygnus cygnus", "Panthera leo"))
d <- finbif_taxa("Cygnus cygnus", type = "exact")
d <- data.frame(scientific.name = d$content[[1]]$scientificName,
                authority = d$content[[1]]$scientificNameAuthorship,
                rank = d$content[[1]]$taxonRank,
                matched.name = d$content[[1]]$matchingName,
                common.name = d$content[[1]]$vernacularName$en)
finbif_taxa("Ursus arctos", type = "partial") #fuzzy
finbif_taxa("Ursus arctos", 5, type = "likely") #fuzzy

# occurrence data
finland <- ne_countries(country = "Finland", scale = "medium", returnclass = "sf")
p <- finbif_occurrence("Cygnus cygnus",
                       filter = list(coordinates_uncertainty_max = 100),
                       n = 500,
                       sample = TRUE) #random subset of all dataset
p <- st_as_sf(p, coords = c("lon_wgs84", "lat_wgs84"), crs = st_crs(finland))
# remove points outside Finland
within_fin <- st_intersects(p, finland)
empty <- !as.logical(sapply(within_fin, length))
p <- p[!empty, ]
#plot
ggplot2::ggplot() +
  ggplot2::geom_sf(data = finland) +
  ggplot2::geom_sf(data = p)
