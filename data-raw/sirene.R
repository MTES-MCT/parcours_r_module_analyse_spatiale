library(sf)
library(tidyverse)

sirene44 <- read_csv("data-raw_extdata/siren44201903/geo-sirene_44.csv") %>%
  st_as_sf(coords = c("longitude", "latitude"), 
           crs = 4326, agr = "constant") %>%
  select(SIREN, APET700, APEN700, LIBAPET, LIBAPEN, NOMEN_LONG) %>%
  st_transform(2154)

save(sirene44, file = "extdata/sirene.RData")
