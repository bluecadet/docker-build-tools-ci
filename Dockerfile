# Use an official Python runtime as a parent image
# FROM drupaldocker/php:7.1-cli
FROM drupalci/php-7.1-apache:production

# Set the working directory to /build-tools-ci
WORKDIR /build-tools-ci

# Copy the current directory contents into the container at /build-tools-ci
ADD . /build-tools-ci

# Collect the components we need for this image
RUN apt-get update
RUN composer -n global require -n "hirak/prestissimo:^0.3"
RUN mkdir -p /usr/local/share/terminus
RUN /usr/bin/env COMPOSER_BIN_DIR=/usr/local/bin composer -n --working-dir=/usr/local/share/terminus require pantheon-systems/terminus "^1.7.1"
RUN mkdir -p /usr/local/share/drush
RUN /usr/bin/env composer -n --working-dir=/usr/local/share/drush require drush/drush "^8"
RUN ln -fs /usr/local/share/drush/vendor/drush/drush/drush /usr/local/bin/drush
RUN chmod +x /usr/local/bin/drush

# Install the gmp and mcrypt extensions
RUN apt-get update -y
RUN apt-get install -y libgmp-dev re2c libmhash-dev libmcrypt-dev file
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/
RUN docker-php-ext-configure gmp 
RUN docker-php-ext-install gmp
RUN docker-php-ext-configure mcrypt
RUN docker-php-ext-install mcrypt

RUN echo extension=gmp.so > /usr/local/etc/php/conf.d/gmp.ini
RUN echo extension=mcrypt.so > /usr/local/etc/php/conf.d/mcrypt.ini

env TERMINUS_PLUGINS_DIR /usr/local/share/terminus-plugins
RUN mkdir -p /usr/local/share/terminus-plugins
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-build-tools-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-secrets-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-rsync-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-quicksilver-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-composer-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-drupal-console-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-mass-update:^1

# From ataylorme/docker-php-Advanced-WordPress-on-Pantheon
# Install wget
RUN \
	echo -e "\nInstalling wget..." && \
	apt-get install -y wget

# Install openssl
RUN \
	echo -e "\nInstalling openssl..." && \
	apt-get install -y openssl

# Install rsync
RUN \
	echo -e "\nInstalling rsync..." && \
	apt-get install -y rsync

# Install jq
RUN \
	echo -e "\nInstalling jq..." && \
	apt-get install -y jq

# Install ssh
RUN \
	echo -e "\nInstalling ssh..." && \
	apt-get install -y openssh-client

# Install Terminus
RUN \
	echo -e "\nInstalling Terminus 1.x..." && \
	/usr/bin/env COMPOSER_BIN_DIR=$HOME/bin composer --working-dir=$HOME require pantheon-systems/terminus "^1"

# Enable Composer parallel downloads
RUN \
	echo -e "\nInstalling hirak/prestissimo for parallel Composer downloads..." && \
	composer global require -n "hirak/prestissimo:^0.3"

