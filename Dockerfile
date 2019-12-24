FROM alpine
#声明作者
LABEL maintainer="frp docker Autre <mo@autre.cn>"
#升级内核及软件
RUN apk update \
    && apk upgrade \
    ##设置时区
    && apk --update add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata \
    ## 清除安装软件及缓存
    && rm -rf /tmp/* /var/cache/apk/*
ARG FRP_VERSION=0.25.1
WORKDIR /tmp/frp
RUN set -x && wget https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && tar -zxvf frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && cp frp_${FRP_VERSION}_linux_amd64/frps /usr/bin/frps \
    && mkdir -p /etc/frps \
    && cp frp_${FRP_VERSION}_linux_amd64/frps.ini /etc/frps \
    && cp frp_${FRP_VERSION}_linux_amd64/frps_full.ini /etc/frps \
    && mkdir -p /etc/frpc \
    && cp frp_${FRP_VERSION}_linux_amd64/frpc.ini /etc/frpc \
    && cp frp_${FRP_VERSION}_linux_amd64/frpc_full.ini /etc/frpc \
    && rm -rf /tmp/frp

#开放端口
EXPOSE 80 443
CMD ["nginx","-g","daemon off;"]
