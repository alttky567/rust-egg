# Sử dụng Debian làm nền tảng
FROM debian:bookworm-slim

LABEL author="YourName"

# Tránh các câu hỏi tương tác của apt
ENV DEBIAN_FRONTEND=noninteractive

# THIẾT LẬP ĐƯỜNG DẪN: Đưa Cargo vào /home/container để tránh lỗi Read-only
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/home/container/.cargo \
    PATH=/home/container/.cargo/bin:/usr/local/cargo/bin:$PATH

USER root

# 1. Cài đặt đầy đủ công cụ build và thư viện âm thanh cho songbird/music bot
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
        ca-certificates \
        libopus-dev \
        libopusfile-dev \
        ffmpeg \
        python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Cài đặt Rust (Sửa lỗi Exit Code 2 bằng cách tải file trước)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup.sh && \
    sh rustup.sh -y --default-toolchain stable --profile minimal --no-modify-path && \
    rm rustup.sh && \
    chmod -R a+w $RUSTUP_HOME

# 3. Cấu hình User và Thư mục cho Pterodactyl
RUN useradd -m -d /home/container container && \
    mkdir -p /home/container/.cargo && \
    chown -R container:container /home/container

# Copy file entrypoint (phải nằm cùng thư mục với Dockerfile trên GitHub)
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Biến môi trường cho bindgen (quan trọng cho các crate Rust kết nối C++)
ENV LIBCLANG_PATH=/usr/lib/libclang.so

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# Khởi động thông qua entrypoint
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
