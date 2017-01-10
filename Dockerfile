FROM node:7.4.0-alpine
MAINTAINER Jesus Macias <jmacias@solidgear.es>

# CREDITS
# https://github.com/smebberson/docker-alpine
# https://github.com/just-containers/base-alpine
# https://github.com/bytepark/alpine-nginx-php7

# s6 overlay
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --update upgrade && apk add curl

RUN curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz \
  | tar xvzf - -C / 

#Node Project root
RUN mkdir -p /opt/nodeapp

#Instal packages
RUN apk add nginx bash git openssh rsync pwgen netcat-openbsd

#Generate Host ssh Keys
RUN mkdir -p ~root/.ssh && chmod 700 ~root/.ssh/ && \
    echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
    cp -a /etc/ssh /etc/ssh.cache

# Update root password
# CHANGE IT # to something like root:ASdSAdfÑ3
RUN echo "root:root" | chpasswd

# Enable ssh for root
RUN printf "\\nPermitRootLogin yes" >> /etc/ssh/sshd_config
# Enable this option to prevent SSH drop connections
RUN printf "\\nClientAliveInterval 15\\nClientAliveCountMax 8" >> /etc/ssh/sshd_config

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/default.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /var/log/nginx

# Create nginx document pat
RUN mkdir -p /var/www/html

# Clean packages cache
RUN rm -rf /var/cache/apk/*

# root filesystem (S6 config files)
COPY rootfs /

# Install node global packages
RUN npm install -g gulp bower pm2

EXPOSE 3000 80 22

# S6 init script
ENTRYPOINT [ "/init" ]