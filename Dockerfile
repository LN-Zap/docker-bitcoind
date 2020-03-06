FROM alpine:3.10 as final
MAINTAINER Tom Kirkpatrick <tkp@kirkdesigns.co.uk>

ARG VERSION=0.19.0.1
ARG GLIBC_VERSION=2.29-r0

ENV FILENAME bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz
ENV DOWNLOAD_URL https://bitcoincore.org/bin/bitcoin-core-${VERSION}/${FILENAME}

# Install bitcoind
RUN apk update \
  && apk add --no-cache --virtual=.build-dependencies tar wget ca-certificates \
  && apk --no-cache add bash su-exec tzdata \
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-bin-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
  && wget $DOWNLOAD_URL \
  && tar xzvf /bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz \
  && mv /bitcoin-${VERSION}/bin/* /usr/local/bin/ \
  && rm -rf /bitcoin-${VERSION}/ \
  && rm -rf /bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz \
  && apk del .build-dependencies

ARG USER_ID
ARG GROUP_ID

ENV HOME /bitcoin

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies
# get added
RUN addgroup -g ${GROUP_ID} -S bitcoin && \
  adduser -u ${USER_ID} -S bitcoin -G bitcoin -s /bin/bash -h /bitcoin bitcoin

## Set BUILD_VER build arg to break the cache here.
ARG BUILD_VER=unknown

# Add startup scripts.
ADD ./bin /usr/local/bin

# Create a volume to house bitcoind data
VOLUME ["/bitcoin"]

# Expose mainnet ports (server, rpc)
EXPOSE 8332 8333

# Expose testnet ports (server, rpc)
EXPOSE 18332 18333

WORKDIR /bitcoin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bitcoind_oneshot"]
