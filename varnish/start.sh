#!/bin/bash

set -e

# ENV MALLOC_CACHE_SIZE   64m
# ENV FILE_CACHE_SIZE     1G
# ENV FILE_CACHE_LOCATION /tmp/varnish
# ENV ADMIN_PORT          8080
# ENV HTTP_PORT           80
# ENV HTTPS_PORT          443
# ENV VCL_CONFIG          /etc/varnish/default.vcl
# ENV CACHE_SIZE          64m
# ENV VARNISHD_PARAMS     -p http_req_hdr_len=64000 -p http_resp_hdr_len=64000 -p pipe_timeout=3600 -p feature=+esi_ignore_https

if [[ -z $VIRTUAL_HOST ]]; then
    echo "VIRTUAL_HOST env var not set"
    exit 1
fi

if [[ ! -f '/app/generate.done' ]]; then
    mkdir /app/generated

    /app/generate.sh /app/generated $VIRTUAL_HOST || {
        echo "Failed to generate varnish config"
        exit 2
    }

    cp -r /app/generated/hooks /etc/varnish
    cp /app/generated/default.vcl /etc/varnish/default.vcl

    touch /app/generate.done
fi

exec bash -c \
  "exec varnishd -F \
  -T :$ADMIN_PORT -a :$HTTP_PORT -a :$HTTPS_PORT \
  -s malloc=malloc,$MALLOC_CACHE_SIZE \
  -s file=file,$FILE_CACHE_LOCATION,$FILE_CACHE_SIZE \
  -f $VCL_CONFIG \
  $VARNISHD_PARAMS"
