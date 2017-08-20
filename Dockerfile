############################################################
# Dockerfile to build Flask App
# Based on
############################################################

# Set the base image
FROM debian:latest

# File Author / Maintainer
MAINTAINER Carlos Tighe

RUN apt-get update && apt-get install -y apache2 apache2-dev \
    build-essential \
 && apt-get clean \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/*


# install miniconda
RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN echo 'export PATH=/opt/conda/bin:$PATH' > ~/.bashrc

RUN /opt/conda/bin/pip install mod_wsgi \
    && /opt/conda/bin/mod_wsgi-express module-config > wsgi.load \
    && mv wsgi.load /etc/apache2/mods-available/ \
    && a2enmod wsgi \
    && service apache2 restart

COPY ./apache-flask/app/requirements.txt /var/www/apache-flask/app/requirements.txt
RUN /opt/conda/bin/pip install -r /var/www/apache-flask/app/requirements.txt

# Copy over the apache configuration file and enable the site
COPY ./apache-flask/apache-flask.conf /etc/apache2/sites-available/apache-flask.conf
RUN a2ensite apache-flask
RUN a2enmod headers

# Copy over the wsgi file
COPY ./apache-flask/apache-flask.wsgi /var/www/apache-flask/apache-flask.wsgi

COPY ./apache-flask/run.py /var/www/apache-flask/run.py
# COPY ./app /var/www/apache-flask/app/

RUN a2dissite 000-default.conf
RUN a2ensite apache-flask.conf

EXPOSE 80

WORKDIR /var/www/apache-flask

CMD  /usr/sbin/apache2ctl -D FOREGROUND
