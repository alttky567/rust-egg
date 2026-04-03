# Sử dụng đúng image bạn vừa chọn
FROM ghcr.io/ptero-eggs/yolks:rust_latest

LABEL author="YourName" maintainer="your@email.com"

# Chuyển sang root để cài đặt đồ chơi
USER root

# Trên Alpine, chúng ta dùng 'apk' thay vì 'apt'
# build-base: Bao gồm g++, gcc, make (tương đương build-essential)
# openssl-dev: Tương đương libssl-dev
# pkgconfig: Tương đương pkg-config
RUN apt update && \
    apt install \
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

# Chỉ định đường dẫn cho bindgen tìm thấy Clang trên Alpine
ENV LIBCLANG_PATH=/usr/lib

# Trả lại quyền cho user container của Pterodactyl
USER container
ENV  USER=container HOME=/home/container
WORKDIR /home/container

CMD ["/bin/bash"]
