#!/bin/bash
# Di chuyển vào thư mục chứa server
cd /home/container

# Xuất đường dẫn Rust/Cargo để hệ thống nhận diện được lệnh
export PATH="/usr/local/cargo/bin:${PATH}"
export HOME=/home/container

# Hiển thị thông tin kiểm tra nhanh (Tùy chọn)
echo -e "\e[1;33m[Ptero-Runtime]: \e[1;32mKiểm tra môi trường build...\e[0m"
rustc --version
g++ --version | head -n 1
clang --version | head -n 1

# Nhận lệnh Startup từ Panel Pterodactyl và xử lý các biến {{VARIABLE}}
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

echo -e "\e[1;33m[Ptero-Runtime]: \e[1;32mĐang khởi động với lệnh: \e[1;34m${MODIFIED_STARTUP}\e[0m"

# Thực thi lệnh chính
eval ${MODIFIED_STARTUP}
