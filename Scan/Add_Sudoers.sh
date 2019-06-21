#!/bin/bash
#add sudoers
chmod 640 /etc/sudoers
echo '%wanglingda  ALL=(ALL) ALL' >> /etc/sudoers
chmod 440 /etc/sudoers
chmod 751 /etc