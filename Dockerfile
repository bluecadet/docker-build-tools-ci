# Use an official Python runtime as a parent image
FROM backstopjs/backstopjs:3.9.5

# Switch to root user
USER root

RUN npm install -g slimerjs
RUN npm install -g casperjs
