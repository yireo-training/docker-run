#!/bin/bash

docker run \
    --name=hypernode_testing \
    -p 2242:22 \
    -p 8042:80 \
    -p 44342:443 \
    byte/hypernode
