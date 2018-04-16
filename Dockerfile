FROM ubuntu:latest

# Get latest OpenSSL 1.0.2 version from https://openssl.org/source/
# v1.1.0 seems to have removed SSLv2/3 support
ENV openssl_version=1.0.2k

# Build OpenSSL
RUN apt update && apt install -y wget automake \
    build-essential \
    wget \
    p7zip-full \
    curl \ 
    bsdmainutils && wget https://openssl.org/source/openssl-$openssl_version.tar.gz && \
    tar -xvf openssl-$openssl_version.tar.gz && \
    cd openssl-$openssl_version && \
    ./config --prefix=/usr/local --openssldir=/usr/lib/ssl enable-ssl2 enable-ssl3 no-shared && \
    make depend && \
    make && \ 
    make -i install && \ 
    cd .. && \
    rm -rf openssl-$openssl_version && \
    rm openssl-$openssl_version.tar.gz && \
    cd / && wget https://gist.githubusercontent.com/pryorda/10a3df9d2bfba799195e733ae4983c7b/raw/0c15c8fcfdfdca22e852cf34622da450ce0ef72d/ssl_test.sh && \
    chmod +x ssl_test.sh

ENTRYPOINT ["/ssl_test.sh"]
