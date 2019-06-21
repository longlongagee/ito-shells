#!/usr/bin/env bash
yum upgrade
#yum install glibc
#yum install cups
#yum install abrt dbus abrt-tui
#yum install ntp
#yum install bind
#yum install bash
yum install xinetd
yum install PolicyKit
yum install rtkit libvirt
yum install xorg-x11-server*
yum list|grep librsvg



1、两台消费服务器修复环境拷贝、部署，脚本配置
2、117服务器搭建本机源，关键旧文件备份
3、服务器待消费服务关停后，进行版本升级、漏洞修复
    升级内容及版本列表:
    openssh -->7.5p1
    openssl -- 1.0.1m
    glibc -->2.12-1.192
    cups -->1.4.2-74
    bash -->4.1.2-41
    bind -->9.8.2-0.47
    xined -->2.3.14-40
    polkit --> 0.96-11
    rtkit --> 0.10.2-60
    libvirt --> 0.5-2
    xorg-x11-server *
    librsvg --> 2.26.0-14
4、修复完成通知再次进行漏洞扫描，恢复消费服务