# Bước 1: Lấy Rust từ Pterodactyl (Chứa Rust mới nhất và GLIBC 2.39)
FROM ghcr.io/ptero-eggs/yolks:rust_latest AS rust-source

# Bước 2: Dùng Ubuntu 24.04 (Có GLIBC 2.39 để không bị lỗi libc.so.6)
FROM ubuntu:24.04

LABEL author="YourName"
ENV DEBIAN_FRONTEND=noninteractive

# Thiết lập đường dẫn Rust
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/home/container/.cargo \
    PATH=/home/container/.cargo/bin:/usr/local/cargo/bin:$PATH

USER root

# 1. Cài đặt mọi thứ bằng 'apt' (Ubuntu 24.04 hỗ trợ cực tốt)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl git g++ gcc make cmake clang libclang-dev libssl-dev pkg-config ca-certificates libopus-dev ffmpeg python3 bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Copy Rust từ Image Pterodactyl sang
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

# Đường dẫn Clang mới trên Ubuntu 24.04
ENV LIBCLANG_PATH=/usr/lib/x86_64-linux-gnu/libclang.so.1
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
