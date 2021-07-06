FROM rocker/tidyverse:latest

MAINTAINER Weecology "https://github.com/weecology/deepforestr"

# Write enviromental options to config files
RUN echo "options(repos='https://cloud.r-project.org/')" >> ~/.Rprofile
RUN echo "options(repos='https://cloud.r-project.org/')" >> ~/.Renviron
RUN echo "R_LIBS=\"/usr/lib/R/library\"">> ~/.Rprofile
RUN echo "R_LIBS=\"/usr/lib/R/library\"">> ~/.Renviron
RUN echo "R_LIBS_USER=\"/usr/lib/R/library\"">> ~/.Renviron

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --force-yes build-essential wget git locales locales-all > /dev/null

# Set encoding
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Remove python2 and install python3
RUN apt-get remove -y python && apt-get install -y python3  python3-pip curl
RUN rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python
RUN rm -f /usr/bin/pip && ln -s /usr/bin/pip3 /usr/bin/pip

RUN echo "export PATH="/usr/bin/python:$PATH"" >> ~/.profile
RUN echo "export PYTHONPATH="/usr/bin/python:$PYTHONPATH"" >> ~/.profile


# Add permissions to config files
RUN chmod 0644 ~/.Renviron
RUN chmod 0644 ~/.Rprofile
RUN chmod 0644 ~/.profile

# Install deepforest python package
RUN pip install pillow
# h5py, pillow, kaggle fail to install from the requirement file.
RUN pip install git+https://git@github.com/weecology/DeepForest.git
RUN R_RETICULATE_PYTHON="/usr/bin/python" | echo $R_RETICULATE_PYTHON >>  ~/.Renviron

COPY . ./deepforestr

WORKDIR ./deepforestr


CMD ["bash", "-c", "deepforestr -v"]
