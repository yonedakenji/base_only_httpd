FROM yonedakenji/packages_installed:latest

MAINTAINER yonedakenji <yon_ken@yahoo.co.jp>

WORKDIR /tmp

### locale, timezone ###
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo -n LANG="ja_JP.UTF-8" > /etc/locale.conf
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8" \
    TZ="Asia/Tokyo"

### copy install files. ###
COPY baseimage-docker-0.11.patch /tmp/

### install baseimage. ###
RUN curl -L https://github.com/phusion/baseimage-docker/archive/0.11.tar.gz -o baseimage-docker-0.11.tar.gz && \
    tar xfz baseimage-docker-0.11.tar.gz && \
    rm baseimage-docker-0.11.tar.gz && \
    patch -p 0 -t < baseimage-docker-0.11.patch && \
    cp -pr baseimage-docker-0.11/image /bd_build && \
    mkdir -p /etc/service && \
    /bd_build/prepare.sh && \
    /bd_build/system_services.sh && \
    /bd_build/utilities.sh && \
    /bd_build/cleanup.sh && \
    rm -rf /bd_build

### install utilities. ###

### clean up ###

### port expose ###

### 
CMD ["/sbin/my_init"]
