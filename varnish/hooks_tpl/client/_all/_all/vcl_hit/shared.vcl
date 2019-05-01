# We deliver hits when they are within the TTL time window. Within the grace time window we return a stale item and background fetch a new one.
if (obj.ttl >= 0s) {
  # A pure unadultered hit, deliver it
  return (deliver);
}
if (obj.ttl + obj.grace > 0s) {
  # Object is in grace, deliver it
  # Automatically triggers a background fetch
  return (deliver);
}
# fetch & deliver once we get the result
return (fetch);
