#!/bin/bash

cat /usr/local/server/nginx/logs/host.access.log* |awk -F '\t' '{print$6}' |sort|uniq -c |sort -nr

