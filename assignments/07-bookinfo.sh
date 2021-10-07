#!/bin/sh


# ratings
docker build -t ratings .
docker run -d --name mongodb -p 27017:27017 \
  -v $(pwd)/databases:/docker-entrypoint-initdb.d bitnami/mongodb:5.0.2-debian-10-r2
docker run -d --name ratings -p 8080:8080 --link mongodb:mongodb \
  -e SERVICE_VERSION=v2 -e 'MONGO_DB_URL=mongodb://mongodb:27017/ratings' ratings

# reviews
docker build -t reviews .
docker run -d --name reviews -p 8082:8082 --link ratings:ratings -e ratings_enabled -e star_color -e ratings_service  reviews

# datails
docker build -t datails .
docker run -d --name ratings -p 8081:8081 datails

# productpage
docker build -t productpage .
docker run -d --name productpage -p 8083:8083 --link ratings:ratings --link datails:datails --link ratings:ratings -e detailsHostname -e ratingsHostname -e reviewsHostname -e flood_factor  productpage
