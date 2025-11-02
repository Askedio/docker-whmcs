docker buildx create --name whmcs-builder --use 2>/dev/null || docker buildx use whmcs-builder

docker buildx build \
  --platform linux/amd64 \
  -t whmcs-whmcs:dev \
  ./web \
  --load
