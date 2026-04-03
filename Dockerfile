# Sử dụng Debian Bookworm làm nền tảng
FROM debian:bookworm-slim

LABEL author="YourName" maintainer="your@email.com"

# Thiết lập môi trường không tương tác cho apt
ENV DEBIAN_FRONTEND=noninteractive

# Thiết lập đường dẫn Rust toàn cục
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

USER root

# 1. Cài đặt các công cụ biên dịch (g++, clang, cmake...)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        g++ \
        gcc \
        make \
        cmake \
        clang \
        libclang-dev \
        libssl-dev \
        pkg-config \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Cài đặt Rust (stable)
RUN curl --proto '=https' --tlsv1.2 -sSf https://rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal && \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME

# 3. Cấu hình User và Entrypoint cho Pterodactyl
RUN useradd -m -d /home/container container
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Biến môi trường cho bindgen (giúp Rust tìm thấy Clang)
ENV LIBCLANG_PATH=/usr/lib/libclang.so

USER container
ENV  USER=container HOME=/home/container
WORKDIR /home/container

# Điểm mấu chốt để tự động chạy lệnh từ Panel
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
