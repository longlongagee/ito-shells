#!/bin/bash
echo `date` @ `hostname`

echo ----执行Ping测试腾信新闻----
ping -c5 r.inews.qq.com

echo ----执行lsof检查端口53的占用数量----
lsof -i :53 |wc -l

echo ----检查最近10000条记录返回200的次数----
tail -n 10000 /usr/local/server/nginx/logs/host.access.log | awk '{print  $9}' | grep '200' | wc -l

echo ----检查最近10000条记录返回302的次数----
tail -n 10000 /usr/local/server/nginx/logs/host.access.log | awk '{print  $9}' | grep '302' | wc -l

echo ----检查最近10000条记录返回异常的次数----
tail -n 10000 /usr/local/server/nginx/logs/host.access.log | awk '{print  $9}' | grep -vE '200|302' | wc -l

echo ----检查最近10000条记录中包含XXXnot200的次数
tail -n 10000 /usr/local/server/nginx/logs/host.access.log | grep '"*not200' | wc -l

