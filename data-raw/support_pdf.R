# Impression du support de cours au format pdf

library(dplyr)

# liste des chap dans l'ordre
chap <- c("index.Rmd", list.files(".", ".Rmd")) %>% 
  setdiff("support_m7.Rmd") %>% 
  unique() %>% 
  gsub(".Rmd", "", .) %>% 
  gsub("^[[:digit:]]*-", "", .)


propre.rpls::creer_pdf_book(nom_pdf = "Parcours_R_support_m7_Analyses_spatiales.pdf",
                            pages_html = chap)

# Des pages blanches ajoutées inutilement
# Pour imprimer, garder les pages
# "1-30;33-48;60-69;81-91;99-153"
# supprimer : 
# 31-32;49-59;70-80;92-98
