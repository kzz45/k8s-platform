# k8s-platform

1. 购买 K8S 集群(阿里云 ACK )

购买成功之后读取 kubeconfig 文件，如：bj.config
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
    4. 负载均衡ID ( 阿里云负载均衡的ID )
    5. 访问控制ID ( 阿里云访问控制的ID )
    6. 镜像下载配置 (阿里云的镜像服务，用户名、密码、地址)
    7. K8S控制台域名 (自定义/例如：k8sadmin.example.com)
5. kubectl apply -f pkg/deploy/crd/*

CRD 安装输出如下
```txt
customresourcedefinition.apiextensions.k8s.io/aliyunloadbalancers.sargeras.nevercase.org configured
customresourcedefinition.apiextensions.k8s.io/aliyunaccesscontrols.sargeras.nevercase.org configured
customresourcedefinition.apiextensions.k8s.io/etcds.sargeras.nevercase.org configured
customresourcedefinition.apiextensions.k8s.io/mysqls.sargeras.nevercase.org configured
customresourcedefinition.apiextensions.k8s.io/redises.sargeras.nevercase.org configured
customresourcedefinition.apiextensions.k8s.io/affinities.sargeras.nevercase.org configured
customresourcedefinition.apiextensions.k8s.io/tolerations.sargeras.nevercase.org configured
customresourcedefinition.apiextensions.k8s.io/nodeselectors.sargeras.nevercase.org configured
customresourcedefinition.apiextensions.k8s.io/thralls.sargeras.nevercase.org created
```

6. 安装 ./bin/k8s-installer-darwin-arm64 -config=./pkg/installer/config.yaml -kubeconfig=./bj.config

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
