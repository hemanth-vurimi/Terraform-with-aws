#!/bin/bash
set -e

LOG=/var/log/user-data.log
exec > >(tee -a $LOG) 2>&1

echo "==== Updating system ===="
apt-get update -y

echo "==== Installing basic packages ===="
apt-get install -y curl unzip jq ca-certificates

# -----------------------------
# Install AWS CLI v2
# -----------------------------
if ! command -v aws >/dev/null 2>&1; then
  echo "==== Installing AWS CLI v2 ===="
  curl -s https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
  unzip -q awscliv2.zip
  ./aws/install
fi

aws --version

# -----------------------------
# Install kubectl (latest stable)
# -----------------------------
if ! command -v kubectl >/dev/null 2>&1; then
  echo "==== Installing kubectl ===="
  curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  mv kubectl /usr/local/bin/
fi

kubectl version --client