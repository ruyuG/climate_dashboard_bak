#!/bin/bash

# 配置变量
SERVER="bp1-login.acrc.bris.ac.uk"
USERNAME=""

# 询问用户的用户名
read -p "Enter your username for $SERVER: " USERNAME

# 检查是否已有SSH密钥，如果没有则创建
SSH_KEY="$HOME/.ssh/id_rsa"
if [ ! -f "$SSH_KEY" ]; then
    echo "No SSH key found. Generating one..."
    ssh-keygen -t rsa -N "" -f $SSH_KEY
    echo "SSH key generated."
else
    echo "SSH key already exists."
fi

# 尝试将SSH密钥复制到服务器
echo "Trying to copy SSH key to $SERVER..."
ssh-copy-id -i $SSH_KEY.pub $USERNAME@$SERVER

# 检查SSH免密登录
echo "Checking SSH password-less login..."
ssh -i $SSH_KEY $USERNAME@$SERVER exit
if [ $? -ne 0 ]; then
    echo "SSH password-less login failed. Please ensure your key is set up correctly."
    exit 1
fi


# login hpc and run setup
ssh -t -i $SSH_KEY $USERNAME@$SERVER bash << 'EOF'
    set -e  # 如果任何命令失败，脚本将退出

    echo "Loading Python module..."
    module load lang/python/miniconda/3.10.10.cuda-12
