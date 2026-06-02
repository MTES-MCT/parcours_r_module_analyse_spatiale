ARG R_VERSION=4.6.0

FROM inseefrlab/onyxia-rstudio:r${R_VERSION}
ARG GITHUB_PAT
ENV GITHUB_PAT=${GITHUB_PAT}

RUN apt-get update && apt-get install -y cargo
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
COPY DESCRIPTION DESCRIPTION
RUN git config --global url."https://${GITHUB_PAT}:@github.com/".insteadOf "https://github.com/"
RUN R -e "install.packages('V8', type = 'source')"
RUN R -e 'remotes::install_deps(dependencies = TRUE)'
