FROM openjdk:8-jre-alpine
RUN apk add --update pwgen bash curl ca-certificates && rm -rf /var/cache/apk/*

# Update below according to https://jena.apache.org/download/ and
# corresponding *.tar.gz.sha512 from https://www.apache.org/dist/jena/binaries/
ENV FUSEKI_SHA512 18018d262987673c2707e0f8daac407eb61dfc4a08015e19b72b1d682d1540eddf2507575b79a161b37f029da63a58d71ba7772c1b5b5fca80d845527a6f7a7a
ENV FUSEKI_VERSION 3.11.0
# Tip: No need for https as we've coded the sha512 above
ENV ASF_MIRROR_EU http://www.eu.apache.org/dist
#

# Config and data
VOLUME /fuseki
ENV FUSEKI_BASE /fuseki


# Installation folder
ENV FUSEKI_HOME /jena-fuseki

WORKDIR /tmp

# Download/unpack/move in one go (to reduce image size)
RUN     wget -O fuseki.tar.gz $ASF_MIRROR_EU/jena/binaries/apache-jena-fuseki-3.13.1.tar.gz && \
        tar zxf fuseki.tar.gz && \
        mv apache-jena-fuseki* $FUSEKI_HOME && \
        rm fuseki.tar.gz* && \
        cd $FUSEKI_HOME && rm -rf fuseki.war

# As "localhost" is often inaccessible within Docker container,
# we'll enable basic-auth with a random admin password
# (which we'll generate on start-up)
COPY shiro.ini /jena-fuseki/shiro.ini
COPY docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh

COPY load.sh /jena-fuseki/
COPY tdbloader /jena-fuseki/
RUN chmod 755 /jena-fuseki/load.sh /jena-fuseki/tdbloader
#VOLUME /staging


# Where we start our server from
WORKDIR /jena-fuseki
EXPOSE 3030
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/jena-fuseki/fuseki-server"]