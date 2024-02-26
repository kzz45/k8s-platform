#!/usr/bin/env bash

#mkdir ca
cd ca
openssl genrsa -des3 -out ca.key 2048
# Enter pass phrase for ca.key: discovery

# 生成CA证书 20 years
openssl req -x509 \
  -new \
  -nodes \
  -key ca.key \
  -days 7300 \
  -out ca.crt \
  -sha256 \
  -subj "/C=CN/ST=Shanghai/L=XuHui/O=XGame/CN=XGame root CA"

cd ..
# 创建ssl证书私钥
# 此文件夹存放待签名的证书
#mkdir certs
cd certs
openssl genrsa -out server.key 2048
#Generating RSA private key, 2048 bit long modulus
#........+++
#............+++
#e is 65537 (0x10001)

# 不使用CA 创建ssl证书CSR
openssl req -new -key server.key -out server.csr \
  -subj "/C=CN/ST=Shanghai/L=XuHui/O=XGame/CN=XGame root CA"

# 使用CA签署ssl证书 ssl证书有效期10年
openssl x509 -req -in server.csr -out server.crt -days 3650 \
  -CAcreateserial -CA ../ca/ca.crt -CAkey ../ca/ca.key \
  -CAserial serial -extfile cert.ext

openssl x509 -in server.crt -out cert.pem
openssl rsa -in server.key -text -out key.pem
