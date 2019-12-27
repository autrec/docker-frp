FROM alpine
#声明作者
LABEL maintainer="frp docker Autre <mo@autre.cn>"
#升级内核及软件
RUN set -x \
    && apk update \
    && apk upgrade \
    ##设置时区
    && apk --update add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata \
    ## 清除安装软件及缓存
    && rm -rf /tmp/* /var/cache/apk/*
ENV FRP_ENV=frps
ENV FRP_VERSION=0.30.0
WORKDIR /tmp
RUN set -x \
    && wget https://soft.zycao.com/download/frp/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && tar -zxf frp_${FRP_VERSION}_linux_amd64.tar.gz \
    && mv frp_${FRP_VERSION}_linux_amd64 /var/frp \
    && mkdir -p /var/frp/conf \
    && rm -rf /tmp/* /var/cache/apk/* /var/lib/apk/lists/*

#COPY conf/${FRP_ENV}.ini /var/frp/conf/${FRP_ENV}.ini
VOLUME /var/frp/conf    # conf被配置成了卷，方便以后修改frps.ini

WORKDIR /var/frp
CMD ./${FRP_ENV} -c ./conf/${FRP_ENV}.ini