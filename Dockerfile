# Bước 1: Lấy Rust từ Pterodactyl
FROM ghcr.io/ptero-eggs/yolks:rust_latest AS rust-source

# Bước 2: Dùng Ubuntu làm hệ điều hành chính (Đúng ý bạn, có apt 100%)
FROM ubuntu:22.04

LABEL author="YourName"
ENV DEBIAN_FRONTEND=noninteractive

# Thiết lập đường dẫn Rust
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/home/container/.cargo \
    PATH=/home/container/.cargo/bin:/usr/local/cargo/bin:$PATH

USER root

# 1. Cài đặt mọi thứ bằng 'apt' (Vì đây là Ubuntu)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl git g++ gcc make cmake clang libclang-dev libssl-dev pkg-config ca-certificates libopus-dev ffmpeg python3 bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Copy Rust từ Image Pterodactyl sang Ubuntu này
COPY --from=rust-source /usr/local/cargo /usr/local/cargo
COPY --from=rust-source /usr/local/rustup /usr/local/rustup

# 3. Phân quyền cho Pterodactyl
RUN chmod -R a+rwx /usr/local/cargo /usr/local/rustup && \
    useradd -m -d /home/container container && \
    mkdir -p /home/container/.cargo && \
    chown -R container:container /home/container

# 4. Entrypoint
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV LIBCLANG_PATH=/usr/lib/x86_64-linux-gnu/libclang.so
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
