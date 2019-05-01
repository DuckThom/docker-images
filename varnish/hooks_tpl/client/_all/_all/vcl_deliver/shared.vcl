# Add header to each request to make validating the cache status of each objects easier.
if (obj.hits > 0) {
  set resp.http.X-Varnish-Cache = "HIT";
} else {
  set resp.http.X-Varnish-Cache = "MISS";
}

unset resp.http.X-Magento-Debug;
unset resp.http.X-Magento-Tags;
unset resp.http.X-Powered-By;
unset resp.http.Server;
unset resp.http.Link;

