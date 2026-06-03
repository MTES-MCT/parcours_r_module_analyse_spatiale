ARG R_VERSION=4.6.0

FROM inseefrlab/onyxia-rstudio:r${R_VERSION}

RUN apt-get update && apt-get install -y cargo
RUN R -e "install.packages('pak', repos = c(CRAN = 'https://cloud.r-project.org'))"
COPY DESCRIPTION DESCRIPTION
ARG GITHUB_PAT
RUN git config --global url."https://${GITHUB_PAT}:@github.com/".insteadOf "https://github.com/"
ENV GITHUB_PAT=${GITHUB_PAT}
RUN R -e "install.packages('V8', type = 'source')"
RUN R -e 'remotes::install_deps(dependencies = TRUE)'
RUN R -e 'pak::local_install_deps(upgrade = FALSE, ask = FALSE)
