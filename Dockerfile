# Sử dụng Debian Bookworm (bản mới nhất, cực kỳ ổn định)
FROM debian:bookworm-slim

LABEL author="YourName" maintainer="your@email.com"

# Tránh các câu hỏi tương tác khi cài đặt apt
ENV DEBIAN_FRONTEND=noninteractive

USER root

# 1. Cài đặt các công cụ hệ thống và thư viện bạn cần
RUN apt update && \
    apt install -y \
        curl \
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

# 2. Cài đặt Rust (Rustup) cho toàn hệ thống
# Chúng ta cài vào /usr/local để mọi user đều dùng được
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://rustup.rs | sh -s -- -y --no-modify-path && \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME

# 3. Thiết lập môi trường cho Pterodactyl
# Tạo user 'container' giống như tiêu chuẩn của Pterodactyl
RUN useradd -m -d /home/container container
USER container
ENV  USER=container HOME=/home/container
WORKDIR /home/container

# Biến môi trường quan trọng cho bindgen trong Rust
ENV LIBCLANG_PATH=/usr/lib/libclang.so

CMD ["/bin/bash"]
