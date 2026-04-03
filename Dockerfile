# Sử dụng base image Rust chính thức của Pterodactyl
FROM ghcr.io/pterodactyl/yolks:rust_latest

LABEL author="YourName" maintainer="your@email.com"

# Chuyển sang quyền root để cài đặt hệ thống
USER root

# Cập nhật và cài đặt các phụ thuộc "phải có"
# - build-essential, g++, make: Biên dịch C/C++
# - clang, libclang-dev: Cần cho bindgen (kết nối C-Rust)
# - cmake: Công cụ build cho nhiều thư viện C
# - libssl-dev, pkg-config: Cần cho các crate như OpenSSL, reqwest, tokio
# - ca-certificates: Đảm bảo kết nối HTTPS/SSL không lỗi
RUN apt update && \
    apt install -y \
        git \
        g++ \
        gcc \
        make \
        build-essential \
        cmake \
        clang \
        libclang-dev \
        libssl-dev \
        pkg-config \
        ca-certificates && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Thiết lập biến môi trường để Rust biết tìm Clang ở đâu (quan trọng cho bindgen)
ENV LIBCLANG_PATH=/usr/lib/llvm-14/lib

# Trả lại quyền cho user 'container' để vận hành an toàn trên Pterodactyl
USER container
ENV  USER=container HOME=/home/container
WORKDIR /home/container

# Lệnh mặc định (sẽ được ghi đè bởi Startup Command của Egg)
CMD ["/bin/bash"]
