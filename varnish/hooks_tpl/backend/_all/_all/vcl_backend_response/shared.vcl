# Set default storage backend to memory.
set beresp.storage_hint = "malloc";
set beresp.http.X-Varnish-Storage = "Malloc";

# Enable ESI support
if (beresp.http.content-type ~ "text") {
  set beresp.do_esi = true;
}

# Unset cookies set by the backend, if any, to prevent these from being added and then served. Also add a default TTL.
if (bereq.url ~ "^/catalogsearch/result/.*") {
  unset beresp.http.expires;
  unset beresp.http.pragma;
  unset beresp.http.cache-control;
  unset beresp.http.set-cookie;
  set beresp.ttl = 2h;
  set beresp.http.Cache-Control = "max-age=0, private";
  set beresp.http.expires = 0;
  set beresp.grace = 1h;
  return(deliver);
}

# Cache 301 redirects for one day.
if ( beresp.status == 301 ) {
  unset beresp.http.expires;
  unset beresp.http.pragma;
  unset beresp.http.cache-control;
  set beresp.ttl = 1d;
  set beresp.http.Cache-Control = "max-age=2628000, public";
  set beresp.http.expires = 2628000;
  set beresp.grace = 4h;
  return(deliver);
}

# Make sure responses other than 200 and 301 are never cached ( includes 302 status and the 400-500 range )
if ( beresp.status != 200 && beresp.status != 301 ) {
  unset beresp.http.expires;
  unset beresp.http.pragma;
  unset beresp.http.cache-control;
  set beresp.http.Cache-Control = "max-age=0, private";
  set beresp.http.expires = 0;
  set beresp.ttl = 0s;
  set beresp.uncacheable = true;
  return (deliver);
}

# Never cache requests when cache-control has we should not.
if (beresp.http.Cache-Control ~ "(private|no-cache|no-store)") {
  set beresp.ttl = 0s;
  set beresp.uncacheable = true;
  return (deliver);
}

# Unset cookies set by the backend, if any, to prevent these from being added and then served. Also add a default TTL.
if (bereq.url ~ "^/(pub/)?(media|static)/.*\.(png|gif|jpg|jpeg|bmp|js|css|svg|woff|woff2|eot|ico|tiff|mp3|ogg|ttf)(\?.+)?$") {
  unset beresp.http.X-Varnish-Storage;
  set beresp.storage_hint = "file";
  set beresp.http.X-Varnish-Storage = "File";
  unset beresp.http.expires;
  unset beresp.http.pragma;
  unset beresp.http.cache-control;
  unset beresp.http.set-cookie;
  set beresp.ttl = 1d;
  set beresp.http.Cache-Control = "max-age=2628000, public";
  set beresp.http.expires = 2628000;
  set beresp.grace = 1h;
  return(deliver);
}

# Unset cookies set by the backend, if any, to prevent these from being added and then served. Also add a default TTL.
if (bereq.url ~ "^/(pub/)?(media|static)/.*\.(js|css)(\?.+)?$") {
  unset beresp.http.set-cookie;
  unset beresp.http.expires;
  unset beresp.http.pragma;
  unset beresp.http.cache-control;
  set beresp.http.Cache-Control = "max-age=600, private";
  set beresp.http.expires = 0;
  set beresp.ttl = 1d;
  set beresp.grace = 6h;
  return(deliver);
}

# Add grace to all public pages to give a more consistent experience and prevent load spikes.
if (beresp.http.Cache-Control == "max-age=86400, public, s-maxage=86400") {
  unset beresp.http.set-cookie;
  unset beresp.http.expires;
  unset beresp.http.pragma;
  unset beresp.http.cache-control;
  set beresp.http.Cache-Control = "max-age=0, private";
  set beresp.http.expires = 0;
  set beresp.ttl = 1d;
  set beresp.grace = 6h;
  return(deliver);
}

return(deliver);
