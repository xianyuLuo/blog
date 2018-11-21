FROM i.registry.dragonest.net/nginx:v0.0.1
ADD . /blog
WORKDIR /blog
RUN echo "add blog file"
RUN ls -l /blog/*
RUN echo "Success"