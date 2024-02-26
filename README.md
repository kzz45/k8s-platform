# k8s-platform

## 安装配置说明

1. 购买 K8S 集群(阿里云 ACK )

购买成功之后读取集群的 kubeconfig 文件，如：bj.config
```sh
➜ vim bj.config
➜ kubectl --kubeconfig=bj.config get ns
NAME              STATUS   AGE
arms-prom         Active   3m20s
default           Active   5m23s
kube-node-lease   Active   5m23s
kube-public       Active   5m23s
kube-system       Active   5m23s
```

2. 集群需要安装 aliyun-acr-credential-helper 组件(拉取镜像所需，或者可以手动配置，非必要)

3. 生成证书文件

过程中输入你自定义的密码
```sh
# cd pkg/certs/demo && sh gen-ca.sh
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
Enter pass phrase for ca.key:
Certificate request self-signature ok
subject=C = CN, ST = Shanghai, L = XuHui, O = XGame, CN = XGame root CA
Enter pass phrase for ../ca/ca.key:
writing RSA key
```

4. 为安装修改 installer 目录中的 config.yaml 配置文件
    1. caCrt ( pkg/certs/demo/ca/ca.crt )
    2. serverCrt ( pkg/certs/demo/certs/server.crt )
    3. serverKey ( pkg/certs/demo/certs/server.key )
    4. 负载均衡ID ( 阿里云负载均衡的ID ，需要购买)
    5. 访问控制ID ( 阿里云访问控制的ID ，需要购买)
    6. 镜像下载配置 (阿里云的镜像服务，用户名、密码、地址，需要购买)
    7. K8S管理域名 (自定义/例如：k8sadmin.example.com ，需要运维配置域名解析)
5. 安装 CRD kubectl apply -f pkg/deploy/crd/*

6. 软件安装 ./bin/k8s-installer-darwin-arm64 -config=./pkg/installer/config.yaml -kubeconfig=./bj.config

安装输入如下说明安装正常且完成
```txt
2024-02-26T16:16:37.806+0800	INFO	builder/authority.go:43	Successful create ConfigMaps:authority-dashboard-config-json namespace:kube-authority
2024-02-26T16:16:37.867+0800	INFO	builder/authority.go:338	Successful create Thrall:authority namespace:kube-authority
2024-02-26T16:16:37.926+0800	INFO	builder/sargeras.go:63	Successful create Service:sargeras-apiserver namespace:kube-api
2024-02-26T16:16:37.976+0800	INFO	builder/sargeras.go:231	Successful create Deployment:sargeras-apiserver namespace:kube-api
2024-02-26T16:16:38.021+0800	INFO	builder/sargeras.go:266	Successful create ConfigMaps:sargeras-dashboard-config-json namespace:kube-api
2024-02-26T16:16:38.074+0800	INFO	builder/sargeras.go:406	Successful create Thrall:sargeras namespace:kube-api
2024-02-26T16:16:38.123+0800	INFO	builder/guldan.go:66	Successful create ConfigMaps:guldan-dashboard-config-json namespace:kube-api
2024-02-26T16:16:38.192+0800	INFO	builder/guldan.go:357	Successful create Thrall:guldan namespace:kube-api
```

## 地址说明

假如域名为 k8sadmin.example.com

那么 k8sadmin.example.com:9094 为镜像管理平台地址

k8sadmin.example.com:9092 为 RBAC 管理平台地址

k8sadmin.example.com:9091 为 K8S 管理平台地址

## Gitlab 配置

首先需要在 Authority Dashboard 中新增 guldan 的用户，用来上传镜像

其次需要在用户的环境变量中新增 guldan 的用户名密码和地址

```sh
export GULDAN_ADDRESS=""
export GULDAN_USERNAME=""
export GULDAN_PASSWORD=""
```

最后需要在 gitlab 的项目的 Makefile中新增如下(在上传镜像的动作中)

```sh
# PROJECT 项目名称
# service 镜像名称
# TAG 镜像 tag

## make build-server-private author=kongzz service=gateway
bash hack/guldan.sh cli $(PROJECT) $(service)-$(author) $(TAG)
```

```sh
./bin/guldan-cli -h
Usage of ./bin/guldan-cli:
  -address string
    	address
  -branch string
    	branch
  -commitHash string
    	commitHash
  -git string
    	git
  -password string
    	password
  -project string
    	project (default "lunara-common")
  -repository string
    	repository (default "guldan-cli")
  -sha256 string
    	sha256
  -tag string
    	tag
  -username string
    	username
```