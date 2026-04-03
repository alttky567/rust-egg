#!/bin/bash
cd /home/container

# Nạp lại biến môi trường một cách thủ công để chắc chắn Cargo được nhận diện
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/home/container/.cargo
export PATH=/home/container/.cargo/bin:/usr/local/cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Hiển thị log kiểm tra
echo -e "\e[1;33m[Ptero-Runtime]: \e[1;32mĐang kiểm tra lệnh hệ thống...\e[0m"

# Thử tìm đường dẫn cargo, nếu không thấy sẽ báo lỗi cụ thể
if ! command -v cargo &> /dev/null
then
    echo -e "\e[1;31m[LỖI]: Không tìm thấy lệnh 'cargo'. Kiểm tra lại PATH hoặc cài đặt.\e[0m"
    # Liệt kê nội dung để debug nếu cần
    ls -l /usr/local/cargo/bin/cargo || echo "Cargo bin không tồn tại ở /usr/local"
else
    echo -e "\e[1;32m[OK]: $(cargo --version) đã sẵn sàng.\e[0m"
fi

# Xử lý lệnh Startup từ Panel
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

echo -e "\e[1;33m[Ptero-Runtime]: \e[1;32mKhởi động với: \e[1;34m${MODIFIED_STARTUP}\e[0m"

eval ${MODIFIED_STARTUP}
