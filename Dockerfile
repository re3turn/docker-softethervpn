#########################
# Build
#########################
FROM alpine as builder

WORKDIR /usr/src

RUN apk update && \
    apk add --no-cache \
    binutils \
    build-base \
    readline-dev \
    openssl-dev \
    ncurses-dev \
    libsodium-dev \
    git \
    cmake \
    zlib-dev \
    gnu-libiconv

RUN git clone --recurse-submodules https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git SoftEtherVPN \
    && cd SoftEtherVPN \
    && ./configure \
    && make

#########################
# Service
#########################
FROM alpine

WORKDIR /svr

RUN apk update && \
    apk add  --no-cache \
    readline \
    openssl \
    libsodium \
    gnu-libiconv

COPY --from=builder /usr/src/SoftEtherVPN/bin/vpnserver /usr/src/SoftEtherVPN/bin/vpncmd ./

CMD ["/svr/vpnserver", "execsvc"]
