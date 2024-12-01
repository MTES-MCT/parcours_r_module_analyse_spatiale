# Impression du support de cours au format pdf

library(dplyr)

# liste des chap dans l'ordre
chap <- c("index.Rmd", list.files(".", ".Rmd")) %>% 
  setdiff("support_m7.Rmd") %>% 
  unique() %>% 
  gsub(".Rmd", ".html", .) %>% 
  gsub("^[[:digit:]]*-", "", .)


propre.rpls::creer_pdf_book(nom_pdf = "Parcours_R_support_m7_Analyses_spatiales.pdf",
                            pages_html = chap)

# Des pages blanches ajoutées inutilement
# Pour imprimer, garder les pages
# "1-30;33-48;60-69;81-91;99-153"
# supprimer : 
# 31-32;49-59;70-80;92-98

# Impression du support de cours au format pdf

library(dplyr)

# liste des chap dans l'ordre
chap <- c("index.Rmd", list.files(".", ".Rmd")) %>% 
  setdiff("support_m7.Rmd") %>% 
  unique() %>% 
  gsub(".Rmd", "", .) %>% 
  gsub("^[[:digit:]]*-", "", .) %>% 
  gsub("exercices-corriges", "exercices-corrigés", .)


propre.rpls::creer_pdf_book(nom_pdf = "Parcours_R_support_m7_Analyses_spatiales.pdf",
                            pages_html = chap)

# Des pages blanches ajoutées inutilement
# Pour imprimer, garder les pages
# "1-30;33-48;60-69;81-91;99-153"
# supprimer : 
# 31-32;49-59;70-80;92-98

# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo apt-get update --fix-missing
# sudo apt install ./google-chrome-stable_current_amd64.deb


creer_pdf_book_ssp <- function (chemin_book = "_book/", nom_pdf = "Parcours_R_support_m7_Analyses_spatiales.pdf", 
                                pages_html = chap, 
                                scale = 0.9) {
  if (!dir.exists(chemin_book)) {
    message(glue::glue("Le repertoire {chemin_book} n'existe pas, creation au prealable de la publication au format html."))
    rmarkdown::render_site(encoding = "UTF-8")
    chemin_book = "_book/"
  }
  else {
    chemin_book <- paste0(chemin_book, ("/"))
  }
  pages_html <- gsub(".html$", "", pages_html)
  pages_html <- paste0(chemin_book, pages_html, ".html")
  pages_pdf <- gsub(".html", ".pdf", pages_html)
  attempt::stop_if_any(!file.exists(pages_html), msg = glue::glue("Il manque au moins un fichier html dans {chemin_book} ou il y a probleme de nommage, revoyez l'argument 'pages_html'."))
  file.copy(from = paste0(chemin_book, "gouv_book.css"), to = paste0(chemin_book, "style.css"))
  message("Export des pages html au format PDF en cours :")
  impress <- function(page, echelle = scale) {
    message(glue::glue("- {page}"))
    pagedown::chrome_print(input = page, extra_args = c("--disable-gpu", "--no-sandbox", "--disable-dev-shm-usage"), 
                           verbose = 0, timeout = 600, options = list(transferMode = "ReturnAsStream", scale = echelle))
  }
  purrr::map(.x = pages_html, .f = impress)
  qpdf::pdf_combine(pages_pdf, output = glue::glue("{chemin_book}{nom_pdf}"))
  file.remove(pages_pdf, glue::glue("{chemin_book}style.css"))
  suppressWarnings(file.remove(glue::glue("{chemin_book}404.pdf")))
  message(glue::glue("Le fichier {nom_pdf} est disponible dans {chemin_book}."))
}

creer_pdf_book_ssp()

