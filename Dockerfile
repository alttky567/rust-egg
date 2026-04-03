# Bước 1: Mượn file Rust từ image chính thức (Đảm bảo 100% không lỗi tải file)
FROM rust:1.80-slim-bookworm AS rust-bin

# Bước 2: Tạo image chính trên nền Debian
FROM debian:bookworm-slim

LABEL author="YourName"
ENV DEBIAN_FRONTEND=noninteractive

# Thiết lập đường dẫn Rust cho toàn hệ thống
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/home/container/.cargo \
    PATH=/home/container/.cargo/bin:/usr/local/cargo/bin:$PATH

USER root

# 1. Cài đặt các công cụ hệ thống và thư viện âm thanh (g++, clang, ffmpeg...)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git g++ gcc make cmake clang libclang-dev libssl-dev pkg-config ca-certificates libopus-dev libopusfile-dev ffmpeg python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. COPY RUST TRỰC TIẾP (Loại bỏ hoàn toàn lệnh curl/sh gây lỗi Exit code 2)
COPY --from=rust-bin /usr/local/cargo /usr/local/cargo
COPY --from=rust-bin /usr/local/rustup /usr/local/rustup

# 3. Cấp quyền thực thi và cấu hình User cho Pterodactyl
RUN chmod -R a+rwx /usr/local/cargo /usr/local/rustup && \
    useradd -m -d /home/container container && \
    mkdir -p /home/container/.cargo && \
    chown -R container:container /home/container

# 4. Thiết lập Entrypoint (Phải có file entrypoint.sh cùng thư mục)
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Biến môi trường quan trọng cho bindgen
ENV LIBCLANG_PATH=/usr/lib/libclang.so

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
