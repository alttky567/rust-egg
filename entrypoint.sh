#!/bin/bash
cd /home/container

# Đảm bảo Cargo ghi vào thư mục có quyền (sửa lỗi Read-only)
export CARGO_HOME=/home/container/.cargo
export PATH="/home/container/.cargo/bin:/usr/local/cargo/bin:${PATH}"
export RUSTC_BOOTSTRAP=1

echo -e "\e[1;33m[Ptero-Runtime]: \e[1;32mĐang chạy trên Ubuntu với $(rustc --version)\e[0m"

# Thực thi lệnh từ Panel
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
eval ${MODIFIED_STARTUP}
