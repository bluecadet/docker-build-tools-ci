# Use an official Python runtime as a parent image
FROM ataylorme/docker-node-advanced-wordpress-on-pantheon:backstop-js

# Set the working directory to /build-tools-ci
WORKDIR /build-tools-ci

# Copy the current directory contents into the container at /build-tools-ci
ADD . /build-tools-ci
