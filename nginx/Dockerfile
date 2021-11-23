FROM 		ghcr.io/frickeldave/fd_alpine:3.14.3

LABEL		org.opencontainers.image.authors="David Koenig <dave@frickeldave.de>"
LABEL		org.opencontainers.image.created="2021-11-23"
LABEL		org.opencontainers.image.version="1.21.4"
LABEL		org.opencontainers.image.url="https://github.com/Frickeldave/ContainerBase/nginx"
LABEL		org.opencontainers.image.documentation="https://github.com/Frickeldave/ContainerBase/nginx/README.md"
LABEL		org.opencontainers.image.source="https://github.com/Frickeldave/ContainerBase/ngix"
LABEL 		org.opencontainers.image.description "This is the nginx base image for the docker infrastructure of the Frickeldave environment."

ARG 		NGX_VERSION=1.21.4

# Additionally openssl and curl is needed which is installed in alpine base.
RUN apk add --no-cache --virtual .build-deps \
				gcc \
				libc-dev \
				make \
				openssl-dev \
				pcre-dev \
				zlib-dev \
				linux-headers \
				gnupg \
				libxslt-dev \
				gd-dev \
				geoip-dev \
 				&& rm -rf /var/lib/apt/lists/* \
 				&& rm -rf /var/cache/apk/*

RUN 		mkdir /home/appuser/app/nginx \
				&& mkdir /home/appuser/app/nginx/client_temp \
				&& mkdir /home/appuser/app/nginx/proyx_temp \
				&& mkdir /home/appuser/app/nginx/fastcgi_temp \
				&& mkdir /home/appuser/app/nginx/uwsgi_temp \
				&& mkdir /home/appuser/app/nginx/scgi_temp \
				&& touch /home/appuser/app/nginx/nginx.pid \
				&& touch /home/appuser/app/nginx/nginx.lock \
				&& mkdir /home/appuser/data/nginx \
				&& mkdir /home/appuser/data/nginx/certificates \
				&& mkdir /home/appuser/data/nginx/log \
				&& mkdir /home/appuser/data/nginx/conf.d \
				&& mkdir /home/appuser/data/nginx/html

COPY 		./nginx.cnf /home/appuser/app/nginx/nginx.cnf
COPY 		./nginx_init.cnf /home/appuser/app/nginx/nginx_init.cnf
COPY 		./start.sh /home/appuser/app/nginx/start.sh
COPY 		./index.html /home/appuser/data/nginx/html/index.html
COPY 		./mime.types /home/appuser/data/nginx/mime.types

# We do not install nginx with apt install, because this will result in several permission issues during the runtime of nginx
RUN 		cd /home/appuser/app/nginx \
				&& curl https://nginx.org/download/nginx-$NGX_VERSION.tar.gz --progress-bar | tar xzf - \
				&& mv nginx-* /home/appuser/app/nginx-install

RUN 		cd /home/appuser/app/nginx-install && ./configure \
				--prefix=/usr/share/nginx \
				--sbin-path=/usr/local/bin/nginx \
				--conf-path=/home/appuser/data/nginx/nginx.cnf \
				--error-log-path=/home/appuser/data/nginx/log/nginx_error.log \
				--http-log-path=//home/appuser/data/nginx/log/nginx_access.log \
				--pid-path=/home/appuser/app/nginx/nginx.pid \
				--lock-path=/home/appuser/app/nginx/nginx.lock \
				--http-client-body-temp-path=/home/appuser/app/nginx/client_temp \
				--http-proxy-temp-path=/home/appuser/app/nginx/proxy_temp \
				--http-fastcgi-temp-path=/home/appuser/app/nginx/fastcgi_temp \
				--http-uwsgi-temp-path=/home/appuser/app/nginx/uwsgi_temp \
				--http-scgi-temp-path=/home/appuser/app/nginx/scgi_temp \
				--user=appuser \
				--group=appuser \
				--with-http_addition_module \
				--with-http_auth_request_module \
				--with-http_gunzip_module \
				--with-http_gzip_static_module \
				--with-http_realip_module \
				--with-http_ssl_module \
				--with-http_stub_status_module \
				--with-http_sub_module \
				--with-http_v2_module \
				--with-threads \
				--with-stream \
				--with-stream_ssl_module \
				--without-http_memcached_module \
				--without-mail_pop3_module \
				--without-mail_imap_module \
				--without-mail_smtp_module \
				--with-pcre-jit \
				--with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security' \
				--with-ld-opt='-Wl,-z,relro -Wl,--as-needed' \
			&& make install \
			&& cd /home/appuser/app \
			&& rm -rf /home/appuser/app/nginx-install

RUN 		setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/nginx

RUN 		chown -R appuser:appuser /home/appuser/data/nginx \
				&& chown -R appuser:appuser /home/appuser/app/nginx

USER 		appuser

ENTRYPOINT 	["/home/appuser/app/nginx/start.sh"]