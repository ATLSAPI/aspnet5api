#!/bin/bash

echo "Setting ENV variables for cntlm..."
export HTTP_PROXY=http://10.0.2.2:3128
export HTTPS_PROXY=http://10.0.2.2:3128
export NO_PROXY=192.168.99.*,*.local.dev

docker build --build-arg http_proxy=http://10.0.2.2:3128 -t api .
docker run -p 7000:7000 api
