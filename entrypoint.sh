#!/bin/bash
# Di chuyển vào thư mục làm việc của server
cd /home/container

# Cập nhật lại PATH để chắc chắn hệ thống thấy lệnh cargo
export PATH="/home/container/.cargo/bin:/usr/local/cargo/bin:${PATH}"
export CARGO_HOME=/home/container/.cargo
export HOME=/home/container

# Hiển thị thông tin môi trường để kiểm tra (log ra console Panel)
echo -e "\e[1;33m[Ptero-Runtime]: \e[1;32mĐang kiểm tra môi trường hệ thống...\e[0m"
rustc --version
cargo --version
g++ --version | head -n 1

# Xử lý lệnh Startup từ Panel Pterodactyl
# Thay thế các biến dạng {{VARIABLE}} thành giá trị thực tế
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

echo -e "\e[1;33m[Ptero-Runtime]: \e[1;32mKhởi động server với lệnh: \e[1;34m${MODIFIED_STARTUP}\e[0m"

# Chạy lệnh startup
eval ${MODIFIED_STARTUP}
