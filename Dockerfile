ARG R_VERSION=4.4.1
ARG GITHUB_PAT=${{ secrets.GITHUB_TOKEN }}

FROM inseefrlab/onyxia-rstudio:r${R_VERSION}
RUN apt-get update && apt-get install -y cargo
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
COPY DESCRIPTION DESCRIPTION
RUN R -e 'remotes::install_deps(dependencies = TRUE)'
