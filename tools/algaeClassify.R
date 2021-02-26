library(algaeClassify)
data("lakegeneva")

# accumulation curve
accum(lakegeneva)

# compare with algaebase online database
algae_search(lakegeneva$phyto_name[3], long = TRUE) #preferred for one species
algae <- spp_list_algaebase(lakegeneva[1:5, ], long = TRUE) #preferred for multiple species data.frame
# altertively:
algae_base <- lapply(lakegeneva$phyto_name[1:5], "algae_search", long = TRUE)
algae_base <- do.call("rbind", algae_base)

# fuzzy partial matching with known names
bestmatch(d$orig.name[2],
          c("Gyrodinium helsetica", "Gyrod helveticum", "Phyto spp."))

