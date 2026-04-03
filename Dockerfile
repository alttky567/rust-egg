FROM debian:bookworm-slim

LABEL author="YourName"
ENV DEBIAN_FRONTEND=noninteractive

# Thiết lập đường dẫn gốc cho Rust
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/home/container/.cargo \
    PATH=/home/container/.cargo/bin:/usr/local/cargo/bin:$PATH

USER root

# 1. Cài đặt công cụ hệ thống và thư viện âm thanh
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl git g++ gcc make cmake clang libclang-dev libssl-dev pkg-config ca-certificates libopus-dev libopusfile-dev ffmpeg python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Cài đặt Rust vào hệ thống
RUN curl --proto '=https' --tlsv1.2 -sSf https://rustup.rs -o rustup.sh && \
    sh rustup.sh -y --default-toolchain stable --profile minimal --no-modify-path && \
    rm rustup.sh

# 3. QUAN TRỌNG: Cấp quyền đọc/thực thi cho toàn bộ thư mục Rustup
# Điều này giúp user 'container' có thể chạy được rustc/cargo cài ở /usr/local
RUN chmod -R a+rwx $RUSTUP_HOME

# 4. Cấu hình User cho Pterodactyl
RUN useradd -m -d /home/container container && \
    mkdir -p /home/container/.cargo && \
    chown -R container:container /home/container

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV LIBCLANG_PATH=/usr/lib/libclang.so

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
