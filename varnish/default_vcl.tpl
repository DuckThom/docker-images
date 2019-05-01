#!/bin/bash

#
# default.vcl template file
#
# Outputs generated template based on DOMAINS environment variabele
#

# HEADER
# -------------------------
cat << EOF
vcl 4.0;
import std;

EOF

# BACKENDS
#--------------------------
for DOMAIN in $(echo $DOMAINS | tr "," "\n"); do
  DOMAIN_BACKEND_BASE_NAME=$(echo $DOMAIN | sed s@'\.'@'__'@g | sed s@'-'@'___'@g)

  cat << EOF
backend ${DOMAIN_BACKEND_BASE_NAME}_http {
    .host = "backend-host";
    .port = "80";
    .connect_timeout = 600s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 600s;
}

backend ${DOMAIN_BACKEND_BASE_NAME}_http_www {
    .host = "backend-host";
    .port = "80";
    .connect_timeout = 600s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 600s;
}

backend ${DOMAIN_BACKEND_BASE_NAME}_https {
    .host = "backend-host";
    .port = "443";
    .connect_timeout = 600s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 600s;
}

backend ${DOMAIN_BACKEND_BASE_NAME}_https_www {
    .host = "backend-host";
    .port = "443";
    .connect_timeout = 600s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 600s;
}
EOF
done


# CLIENT HOOKS
#--------------------------
for HOOK in $(echo "vcl_recv,vcl_pipe,vcl_pass,vcl_hit,vcl_miss,vcl_hash,vcl_purge,vcl_deliver,vcl_synth" | tr "," "\n"); do

  cat << EOF

sub $HOOK {
EOF

  for DOMAIN in $(echo $DOMAINS | tr "," "\n"); do
    DOMAIN_BACKEND_BASE_NAME=$(echo $DOMAIN | sed s@'\.'@'__'@g | sed s@'-'@'___'@g)

    # Only vcl_recv hook has backend hints
    if [[ $HOOK = "vcl_recv" ]]; then
      BACKEND_HINT_HTTP="set req.backend_hint = ${DOMAIN_BACKEND_BASE_NAME}_http;"
      BACKEND_HINT_HTTPS="set req.backend_hint = ${DOMAIN_BACKEND_BASE_NAME}_https;"
      BACKEND_HINT_HTTP_WWW="set req.backend_hint = ${DOMAIN_BACKEND_BASE_NAME}_http_www;"
      BACKEND_HINT_HTTPS_WWW="set req.backend_hint = ${DOMAIN_BACKEND_BASE_NAME}_https_www;"
    else
      BACKEND_HINT_HTTP=""
      BACKEND_HINT_HTTPS=""
      BACKEND_HINT_HTTP_WWW=""
      BACKEND_HINT_HTTPS_WWW=""
    fi

    cat << EOF
    // domain: $DOMAIN
    if (req.http.host == "$DOMAIN") {
      set req.http.host = "$DOMAIN";
      if ( std.port(server.ip) == 80 ) {
        $BACKEND_HINT_HTTP
        // _all level includes
        include "/etc/varnish/hooks/client/_all/http/$HOOK/before_shared.vcl";
        include "/etc/varnish/hooks/client/_all/_all/$HOOK/shared.vcl";
        include "/etc/varnish/hooks/client/_all/http/$HOOK/after_shared.vcl";

        // domain level included
        include "/etc/varnish/hooks/client/$DOMAIN/http/$HOOK/before_shared.vcl";
        include "/etc/varnish/hooks/client/$DOMAIN/_all/$HOOK/shared.vcl";
        include "/etc/varnish/hooks/client/$DOMAIN/http/$HOOK/after_shared.vcl";
      }
      if ( std.port(server.ip) == 443 ) {
        $BACKEND_HINT_HTTPS
        // _all level includes
        include "/etc/varnish/hooks/client/_all/https/$HOOK/before_shared.vcl";
        include "/etc/varnish/hooks/client/_all/_all/$HOOK/shared.vcl";
        include "/etc/varnish/hooks/client/_all/https/$HOOK/after_shared.vcl";

        // domain level included
        include "/etc/varnish/hooks/client/$DOMAIN/https/$HOOK/before_shared.vcl";
        include "/etc/varnish/hooks/client/$DOMAIN/_all/$HOOK/shared.vcl";
        include "/etc/varnish/hooks/client/$DOMAIN/https/$HOOK/after_shared.vcl";
      }
    }
    if (req.http.host == "www.$DOMAIN") {
      set req.http.host = "www.$DOMAIN";
      if ( std.port(server.ip) == 80 ) {
        $BACKEND_HINT_HTTP_WWW
        // _all level includes
        include "/etc/varnish/hooks/client/_all/http/$HOOK/before_shared.vcl";
        include "/etc/varnish/hooks/client/_all/_all/$HOOK/shared.vcl";
        include "/etc/varnish/hooks/client/_all/http/$HOOK/after_shared.vcl";

        // domain level included
        include "/etc/varnish/hooks/client/$DOMAIN/http/$HOOK/before_shared.vcl";
        include "/etc/varnish/hooks/client/$DOMAIN/_all/$HOOK/shared.vcl";
        include "/etc/varnish/hooks/client/$DOMAIN/http/$HOOK/after_shared.vcl";
      }
      if ( std.port(server.ip) == 443 ) {
        $BACKEND_HINT_HTTPS_WWW
        // _all level includes
        include "/etc/varnish/hooks/client/_all/https/$HOOK/before_shared.vcl";
        include "/etc/varnish/hooks/client/_all/_all/$HOOK/shared.vcl";
        include "/etc/varnish/hooks/client/_all/https/$HOOK/after_shared.vcl";

        // domain level included
        include "/etc/varnish/hooks/client/$DOMAIN/https/$HOOK/before_shared.vcl";
        include "/etc/varnish/hooks/client/$DOMAIN/_all/$HOOK/shared.vcl";
        include "/etc/varnish/hooks/client/$DOMAIN/https/$HOOK/after_shared.vcl";
      }
    }
EOF

  done

  cat << EOF
}
EOF

done

# BACKEND HOOKS
#--------------------------
cat << EOF

sub vcl_backend_fetch {
  include "/etc/varnish/hooks/backend/_all/_all/vcl_backend_fetch/shared.vcl";
}

sub vcl_backend_response {
  include "/etc/varnish/hooks/backend/_all/_all/vcl_backend_response/shared.vcl";
}

sub vcl_backend_error {
  include "/etc/varnish/hooks/backend/_all/_all/vcl_backend_error/shared.vcl";
}
EOF

# ACL
#--------------------------
cat << EOF

acl purge {
  "0.0.0.0"/0;
}
EOF
