# bac à sable
# pour tester les exemples plus confortablement que dans le book

library(sf)
library(DT)
library(tidyverse)
library(mapview)
library(tmap)
library(rmapshaper)
library(patchwork)

### lire ##########
geo_fichier <- system.file("shapes/NY8_bna_utm18.gpkg", package = "spData")
NY_leukemia <- st_read(dsn = geo_fichier)


### ecrire ##########
st_write(obj = NY_leukemia, dsn = "extdata/NY_leukemia.gpkg")

st_write(
  obj = NY_leukemia,
  dsn = "extdata/NY_leukemia.gpkg",
  delete_layer = TRUE
)

st_write(
  obj = NY_leukemia,
  dsn = "extdata/NY_leukemia.gpkg",
  append = FALSE
)

### transformer un csv ##########

prefectures <- read_csv2("extdata/prefecture.csv")

prefectures_geo <- st_as_sf(prefectures, coords = c("x", "y")) %>%
  st_set_crs(2154)

select(prefectures_geo, NOM_CHF) %>% plot

mapview(prefectures_geo)

### donnees atributaires #########

load("extdata/admin_express.RData")
class(departements_geo)
st_crs(departements_geo)
mapview(departements_geo, zcol = "NOM_DEP", legend = F)

reg52 <- departements_geo %>%
  filter(INSEE_REG == 52)

mapview(reg52, zcol = "NOM_DEP", legend = F)

st_bbox(reg52)
st_bbox(departements_geo)

departements_geo %>%
  select(INSEE_DEP) %>%
  glimpse()

departements_geo %>%
  select(INSEE_DEP) %>%
  st_drop_geometry() %>%
  glimpse()

# departements_geo %>%
#   mutate(centr=st_centroid(geometry)) %>%
#   st_set_geometry(centr)

regions <- departements_geo %>%
  group_by(INSEE_REG) %>%
  summarise(AREA = sum(AREA))

mapview(regions, zcol = "INSEE_REG")

#### chap 6 ##########
departement_44 <- departements_geo %>%
  filter(INSEE_DEP == "44")

epci_d44 <- epci_geo[departement_44, op = st_within]

mapview(list(departement_44, epci_d44), zcol = c("NOM_DEP", "NOM_EPCI"), legend = F)
mapview(list(departement_44, epci_d44), zcol = c("NOM_DEP", "NOM_EPCI"), legend = F)


epci_d441 <- st_filter(epci_geo, departement_44, .predicate = st_within)
mapview(list(departement_44, epci_d441), zcol = c("NOM_DEP", "NOM_EPCI"), legend = F)
st_crs(epci_d44)


mapview(epci_d441, zcol = c("NOM_EPCI"), legend = F)
mapview(list(departement_44, epci_d441), zcol = list("NOM_DEP", NULL), legend = F)

## predicat spatiaux
# polygone (a)
a_poly <- st_polygon(list(rbind(c(-1, -1), c(1, -1), c(1, 1), c(-1, -1))))
a <- st_sfc(a_poly)
# ligne (l)
l1 <- st_multilinestring(list(rbind(c(0.5, -1), c(-0.5, 1))))
l2 <- st_multilinestring(list(rbind(c(.9, -.9), c(.5, 0))))
l <- st_sfc(l1, l2)

# multipoints (p)
p_matrix <- matrix(c(0.5, 1, -1, 0, 0, 1, 0.5, 1), ncol = 2)
p_multi <- st_multipoint(x = p_matrix)
p <- st_cast(st_sfc(p_multi), "POINT")




## multipolygon
outer = matrix(c(0, 0, 10, 0, 10, 10, 0, 10, 0, 0), ncol = 2, byrow = TRUE)
hole1 = matrix(c(1, 1, 1, 2, 2, 2, 2, 1, 1, 1), ncol = 2, byrow = TRUE)
hole2 = matrix(c(5, 5, 5, 6, 6, 6, 6, 5, 5, 5), ncol = 2, byrow = TRUE)

pol1 = list(outer, hole1, hole2)
pol2 = list(outer + 12, hole1 + 12)
pol3 = list(outer + 24)
mp = list(pol1, pol2, pol3)
mp1 = st_multipolygon(mp)
plot(mp1)

st_intersects(p, mp1, sparse = F)
st_intersects(mp1, a, sparse = F)

## Créer un objet des points de p qui intersectent avec le polygone a
inter <- st_intersection(p, a)
plot(inter)
plot(a, add = TRUE)
plot(p, add = TRUE)
plot(p)


load("extdata/sirene.RData")
sirene44_sel <- sirene44 %>%
  filter(APET700 == "0893Z")

mapview(list(departement_44, epci_d44, sirene44_sel), zcol = list("NOM_DEP", "NOM_EPCI", "NOMEN_LONG"), legend = F)

sirene44_sel_avec_code_epci <- sirene44_sel %>%
  st_join(epci_geo)

mapview(list(departement_44, epci_d44, sirene44_sel_avec_code_epci),
  zcol = list("NOM_DEP", "NOM_EPCI", "NOM_EPCI"), legend = F)


epci_d44_avec_departement <- epci_d44 %>%
  st_join(departements_geo %>% st_buffer(dist = -1000), largest = T)

mapview(list(departement_44, epci_d44, sirene44_sel_avec_code_epci),
  list = c("NOM_DEP", "NOM_EPCI", "NOM_EPCI"), legend = F)

epci_d44_avec_departement %>%
  select(NOM_EPCI, NOM_DEP) %>%
  group_by(NOM_EPCI) %>%
  tally() %>%
  arrange(-n)

centres_departements_pdl <- st_centroid(departements_geo) %>%
  filter(INSEE_REG == "52")

st_distance(centres_departements_pdl)

index_dep_pdl <- st_nearest_feature(
  departements_geo,
  centres_departements_pdl
)

liens <- st_nearest_points(departements_geo,
  centres_departements_pdl[index_dep_pdl, ],
  pairwise = TRUE
)

## chap 7



departements_35_44_56 <- departements_geo %>%
  filter(INSEE_DEP %in% c("35", "44", "56"))

departements_35_44_56 <- departements_35_44_56 %>%
  mutate(AREA = as.numeric(AREA))
departements_35_44_56_ms_simplifie <- ms_simplify(departements_35_44_56, method = "vis", keep = 0.01)

p1 <- ggplot() +
  geom_sf(data = departements_35_44_56) +
  theme_void() +
  theme(panel.grid = element_blank(), panel.border = element_blank())

p3 <- ggplot() +
  geom_sf(data = departements_35_44_56_ms_simplifie) +
  theme_void()

p1 + p3 + plot_layout(nrow = 1)

data("World")
World_pekin <- st_transform(World, crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=116 +lat_0=40")
World_pole_sud <- st_transform(World, crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=0 +lat_0=-90")
World_pole_nord <- st_transform(World, crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=0 +lat_0=90")
