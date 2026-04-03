# Sử dụng bản Rust mới nhất trên Alpine của Pterodactyl
FROM ghcr.io/pterodactyl/yolks:rust_1.80

LABEL author="YourName" maintainer="your@email.com"

USER root

# Alpine dùng 'apk' thay vì 'apt'
# - build-base: Tương đương build-essential (g++, gcc, make)
# - openssl-dev: Tương đương libssl-dev
RUN apk update && \
    apk add --no-cache \
        git \
        build-base \
        cmake \
        clang-dev \
        make \
        gcc \
        g++ \
        openssl-dev \
        pkgconfig \
        ca-certificates

# Đường dẫn Clang trên Alpine thường khác Debian
ENV LIBCLANG_PATH=/usr/lib

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

CMD ["/bin/bash"]
