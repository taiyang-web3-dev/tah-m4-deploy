#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  IOTA TAH 自动安装${NC}"
echo -e "${BLUE}  github.com/taiyang-web3-dev/tah-m4-deploy${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

GITHUB_USER="taiyang-web3-dev"
REPO_NAME="tah-m4-deploy"
VERSION="v2.1.2"
FILENAME="TAH-macos-arm64-v2.1.2.tar.gz"
DOWNLOAD_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}/releases/download/${VERSION}/${FILENAME}"

# 下载
echo -e "${YELLOW}下载 TAH 客户端...${NC}"
cd ~/Downloads
curl -L -o "$FILENAME" "$DOWNLOAD_URL"

# 解压
echo -e "${YELLOW}解压...${NC}"
tar -xzf "$FILENAME"

# 查找解压出来的应用
APP_NAME=$(find . -maxdepth 1 -name "*.app" -type d | head -1 | sed 's/\.\///')
echo "找到: $APP_NAME"

# 安装
echo -e "${YELLOW}安装到 Applications...${NC}"
sudo mv "$APP_NAME" /Applications/

# 启动 Hornet 节点
echo -e "${YELLOW}启动 IOTA Hornet 节点...${NC}"
docker rm -f iota-hornet 2>/dev/null || true
mkdir -p ~/tah/data
docker run -d \
  --name iota-hornet \
  --restart unless-stopped \
  -p 8082:8081 \
  -p 1883:1883 \
  -v ~/tah/data:/app/data \
  iotaledger/hornet:latest

# 清理
rm -f "$FILENAME"

# 启动
echo -e "${GREEN}启动 TAH 应用...${NC}"
open "/Applications/$APP_NAME"

echo -e "${GREEN}✅ 安装完成！${NC}"
