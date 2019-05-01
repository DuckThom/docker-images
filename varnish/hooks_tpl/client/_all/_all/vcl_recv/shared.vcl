# Allow purging of URLs in the internal network range over HTTP
if (req.method == "PURGE") {
  if (client.ip !~ purge) {
    return (synth(405, "Method not allowed"));
  }
  if (!req.http.X-Magento-Tags-Pattern) {
    return (synth(400, "X-Magento-Tags-Pattern header required"));
  }
  ban("obj.http.X-Magento-Tags ~ " + req.http.X-Magento-Tags-Pattern);
  return (synth(200, "Purged"));
}

# Allow banning of URLs
if (req.method == "BAN") {
  if (!client.ip ~ purge) {
    return(synth(403, "Not allowed."));
  }
  ban("req.http.host == " + req.http.host + " && req.url == " + req.url);
  return(synth(200, "Ban added"));
}

# Allow refreshing of URLs
if (req.method == "REFRESH") {
  set req.method = "GET";
  set req.hash_always_miss = true;
}

# CDN always bypasses Varnish Cache
if (req.http.x-from-cdn == "true") {
  set req.method = "GET";
  set req.hash_always_miss = true;
  return(hash);
}

# Bypass shopping cart and checkout requests
if (req.url ~ "/checkout" || req.url ~ "/catalogsearch") {
  return (pass);
}

# Pass POST Requests
if (req.method == "POST") {
  return(pass);
}

# We only deal with GET and HEAD by default
if (req.method != "GET" && req.method != "HEAD") {
 return (pass);
}

# collect all cookies
std.collect(req.http.Cookie);

# Unset headers and cookies from visitors we do not want to be passed to the backend, if any are set
if (req.url ~ "^/(pub/)?(media|static)/.*\.(png|gif|jpg|jpeg|bmp|js|css|svg|woff|woff2|eot|ico|tiff|mp3|ogg|ttf)(\?.+)?$") {
  unset req.http.Age;
  unset req.http.Expires;
  unset req.http.Cookie;
  unset req.http.Accept;
  unset req.http.Accept-Encoding;
  unset req.http.Accept-Language;
  unset req.http.Accept-Ranges;
  unset req.http.Vary;
  unset req.http.Referer;
  unset req.http.ETag;
  unset req.http.Keep-Alive;
  unset req.http.Date;
  unset req.http.Server;
  unset req.http.Pragma;
  unset req.http.Cache-Control;
  unset req.http.Accept-Ranges;
  unset req.http.Version;
  return(hash);
}

return(hash);
