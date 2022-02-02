FROM rocker/rstudio:latest

RUN apt update
RUN apt upgrade -yq
RUN apt-get -yq install libxml2-dev libglpk-dev libgl1-mesa-glx libxt6

RUN Rscript -e 'install.packages(c("bipartite", "igraph", "ggplot2"))'
