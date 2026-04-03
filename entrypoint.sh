#!/bin/bash
cd /home/container

# Cấu hình Cargo Home vào thư mục có quyền ghi
export CARGO_HOME=/home/container/.cargo
export PATH="/home/container/.cargo/bin:/usr/local/cargo/bin:${PATH}"

echo -e "\e[1;33m[Ptero-Runtime]: \e[1;32mKhởi động hệ thống với Rust Nightly...\e[0m"

# Kiểm tra phiên bản
if ! command -v cargo &> /dev/null
then
    echo -e "\e[1;31m[LỖI]: Không tìm thấy lệnh 'cargo'.\e[0m"
else
    echo -e "\e[1;32m[OK]: $(cargo --version) đã sẵn sàng.\e[0m"
fi

# Nhận lệnh từ Panel Pterodactyl
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

echo -e "\e[1;33m[Ptero-Runtime]: \e[1;32mLệnh khởi chạy: \e[1;34m${MODIFIED_STARTUP}\e[0m"

# Thực thi
eval ${MODIFIED_STARTUP}
