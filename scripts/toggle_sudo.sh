#!/bin/bash
# Đọc lệnh từ stdin (đây là cách shed chuyển buffer vào script)
line=$(cat)
if [[ "$line" =~ ^sudo\ .* ]]; then
  # Xóa sudo
  echo "${line#sudo }"
else
  # Thêm sudo
  echo "sudo $line"
fi
