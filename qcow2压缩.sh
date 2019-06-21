dd if=/dev/zero of=~/junk
#dd: writing to `/homejunk’: No space left on device
rm junk
# 关闭客户机
# 转换磁盘镜像文件
qemu-img convert -O qcow2 old.qcow2 new.qcow2
