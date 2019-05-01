hash_data(req.url);
hash_data(req.backend_hint);

if (req.http.cookie ~ "X-Magento-Vary=") {
  hash_data(regsub(req.http.cookie, "^.*?X-Magento-Vary=([^;]+);*.*$", "\1"));
}
