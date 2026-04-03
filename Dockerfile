FROM debian:bookworm-slim

LABEL author="YourName"

ENV DEBIAN_FRONTEND=noninteractive
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

USER root

# 1. Cài đặt công cụ hệ thống
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

# 2. Cài đặt Rust - THAY ĐỔI Ở ĐÂY ĐỂ TRÁNH EXIT CODE 2
# Tải file cài đặt về trước, sau đó mới chạy để kiểm soát lỗi tốt hơn
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup.sh && \
    sh rustup.sh -y --default-toolchain stable --profile minimal --no-modify-path && \
    rm rustup.sh && \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME

# 3. Cấu hình cho Pterodactyl
RUN useradd -m -d /home/container container
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV LIBCLANG_PATH=/usr/lib/libclang.so

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
