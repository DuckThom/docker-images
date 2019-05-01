FROM debian:jessie

LABEL maintainer="Thomas Wiringa <t.wiringa@youwe.nl>"

RUN apt-get update \
 && apt-get install -y curl \
 && curl -s https://packagecloud.io/install/repositories/varnishcache/varnish41/script.deb.sh | bash \
 && apt-get install -y varnish

ENV MALLOC_CACHE_SIZE   64m
ENV FILE_CACHE_SIZE     1G
ENV FILE_CACHE_LOCATION /tmp/varnish
ENV ADMIN_PORT          8080
ENV HTTP_PORT           80
ENV HTTPS_PORT          443
ENV VCL_CONFIG          /etc/varnish/default.vcl
ENV VARNISHD_PARAMS     -p http_req_hdr_len=64000 -p http_resp_hdr_len=64000 -p pipe_timeout=3600 -p feature=+esi_ignore_https
EXPOSE 80
EXPOSE 443
EXPOSE 8080

RUN mkdir /app

ADD default_vcl.tpl /app/default_vcl.tpl
ADD generate.sh /app/generate.sh
ADD hooks_tpl /app/hooks_tpl

ADD start.sh /start.sh

CMD /start.sh

