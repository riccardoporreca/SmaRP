FROM rocker/r-ver:3.5.3

## Install required dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ## for R package 'curl'
    libcurl4-gnutls-dev \
    ## for R package 'xml2'
    libxml2-dev \
    ## for R package 'openssl'
    libssl-dev \
    ## for install_tinytex.sh and install_pandoc.sh
    wget \
    ## for install_tinytex.sh
    texinfo \
    ## for install_tinytex.sh
    ghostscript \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

## Install recent pandoc version, required by rmarkdown
# - see https://github.com/rstudio/rmarkdown/blob/master/PANDOC.md
# - https://pandoc.org/installing.html#linux
# We should use the same version as in rocker/rstudio:<R_VER>
#   docker run --rm rocker/rstudio:<R_VER> /usr/lib/rstudio-server/bin/pandoc/pandoc -v
ENV PANDOC_DEB="2.3.1/pandoc-2.3.1-1-amd64.deb"
COPY docker/install_pandoc.sh .
RUN sh install_pandoc.sh $PANDOC_DEB && rm install_pandoc.sh

## Install TinyTeX as LaTeX installation
COPY docker/install_tinytex.sh .
# - Use a version-stable tlnet archive CTAN repo from texlive.info
#   - here we consider the frozen TeXLive 2016 snapshot, corresponding to the TeXLive release
#     shipped as texlive-* in Debian stretch (base image for the rocker/verse currently used)
#   - note that https was not supported in TeXLive 2016 for the CTAN repository
ENV CTAN_REPO=http://www.texlive.info/tlnet-archive/2017/04/13/tlnet
# - It is important to also install all required LaTeX packages when building the image
RUN sh install_tinytex.sh fancyhdr
## Script for re-installation of TinyTeX in the running container
#  - needed if at a certain point the "Remote repository is newer than local",
#    for non-version-stable TinyTeX installations
#  - this also (re-)executes (and therefore depends on) install_tinytex.sh
COPY docker/reinstall_tinytex.sh .

## Install major fixed R dependencies
#  - they will always be needed and we want them in a dedicated layer,
#    as opposed to getting them dynamically via `remotes::install_local()`
RUN install2.r --error \
  shiny \
  dplyr \
  rmarkdown

## Copy the app to the image
# temporary location of the SmaRP source package in the image
ENV MARP=/tmp/SmaRP
COPY . $MARP

# Install SmaRP
RUN install2.r --error remotes \
  && R -e "remotes::install_local('$MARP')" \
  && rm -rf $MARP

# Set host and port
RUN echo "options(shiny.port = 80, shiny.host = '0.0.0.0')" >> /usr/local/lib/R/etc/Rprofile.site

EXPOSE 80

CMD ["R", "-e", "SmaRP::launch_application()"]
