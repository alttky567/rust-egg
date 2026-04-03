# Bước 1: Mượn file Rust từ image NIGHTLY chính thức để hỗ trợ Edition 2024
FROM rust:nightly-bookworm AS rust-bin

# Bước 2: Tạo image chính trên nền Debian
FROM debian:bookworm-slim

LABEL author="YourName"
ENV DEBIAN_FRONTEND=noninteractive

# Thiết lập đường dẫn Rust cho toàn hệ thống
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/home/container/.cargo \
    PATH=/home/container/.cargo/bin:/usr/local/cargo/bin:$PATH

USER root

# 1. Cài đặt các công cụ hệ thống và thư viện âm thanh
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git g++ gcc make cmake clang libclang-dev libssl-dev pkg-config ca-certificates libopus-dev libopusfile-dev ffmpeg python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. COPY RUST NIGHTLY TRỰC TIẾP (Hỗ trợ Edition 2024 và tránh lỗi tải file)
COPY --from=rust-bin /usr/local/cargo /usr/local/cargo
COPY --from=rust-bin /usr/local/rustup /usr/local/rustup

# 3. Cấp quyền thực thi và cấu hình User cho Pterodactyl
RUN chmod -R a+rwx /usr/local/cargo /usr/local/rustup && \
    useradd -m -d /home/container container && \
    mkdir -p /home/container/.cargo && \
    chown -R container:container /home/container

# 4. Thiết lập Entrypoint
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Biến môi trường cho bindgen
ENV LIBCLANG_PATH=/usr/lib/libclang.so

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
