# Impression du support de cours au format pdf

library(dplyr)

# liste des chap dans l'ordre
chap <- c("index.Rmd", list.files(".", ".Rmd")) %>% 
  setdiff("support_m7.Rmd") %>% 
  unique() %>% 
  gsub(".Rmd", "", .) %>% 
  gsub("^[[:digit:]]*-", "", .)


propre.rpls::creer_pdf_book(nom_pdf = "Parcours_R_support_m7_Analyses_spaciales.pdf",
                            pages_html = chap)

"1-25;28-39;51-60;72-136;138-146"