FROM debian:bookworm-slim

LABEL author="YourName"

# Tránh các câu hỏi tương tác
ENV DEBIAN_FRONTEND=noninteractive

# Thiết lập đường dẫn Rust trước khi cài
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

USER root

# 1. Cài đặt các gói phụ thuộc (Chia nhỏ để dễ kiểm soát lỗi)
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

# 2. Cài đặt Rust (Dùng link sh.rustup.rs ổn định hơn)
# Thêm --default-toolchain stable để tránh script dừng lại hỏi
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal && \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME

# 3. Cấu hình User cho Pterodactyl
RUN useradd -m -d /home/container container
USER container
ENV  USER=container HOME=/home/container
WORKDIR /home/container

# Biến môi trường cho bindgen
ENV LIBCLANG_PATH=/usr/lib/libclang.so

CMD ["/bin/bash"]
