
1、qemu-img*************************
qemu-img snapshot -l /images/vm2.qcow2
#注意：只有qcow2才支持快照

#打快照
qemu-img snapshot -c booting vm2.qcow2

#举例：
hzgatt@hzgatt:~/images$ qemu-img snapshot -c booting vm2.qcow2 
hzgatt@hzgatt:~/images$ qemu-img snapshot -l vm2.qcow2 
Snapshot list:
ID        TAG                 VM SIZE                DATE       VM CLOCK
1         booting                   0 2012-06-29 14:35:04   00:00:00.000
#从快照恢复：
qemu-img snapshot -a 1 /images/vm2.qcow2
#然后从kvm启动这个虚拟机，会发现虚拟机又在打快照时的状态了
qemu-img snapshot -d 2 /images/vm2.qcow #删除快照：

2、VIRSH********************************************************************
virsh snapshot-create-as jm01_vir01 first_snap
virsh snapshot-list jm01_vir01

镜像大小：
qemu-img convert -c -O qcow2 vm2.raw vm2.qcow2
qemu-img resize jm01_vir01.img +100G



1.kvm克隆
kvm 虚拟机有两部分组成：img镜像文件和xml配置文件（/etc/libvirt/qemu
克隆命令：virt-clone -o rhel6- 71 -n xuegod63-kvm2 -f /var/lib/libvirt/images/xuegod63-kvm2.img
virt-clone -o 原虚拟机 -n 新虚拟机 -f 新img文件
对比配置文件，将两份xml文件做diff对比，里面只修改了name、img、Mac 3个位置信息
克隆完成后，需要修改新虚拟机的网卡配置，并删除/etc/udev/rule.d/70-*-net文件，
2.快照(snapshot)
kvm默认格式为raw格式，如需要修改镜像文件格式。需要配置xml文件
查看镜像文件格式qemu-ig info 镜像文件
1）、转换格式（将raw格式转换为qcow2格式）
qemu-img convert -f raw -O qrow2 /var/lib/libvert/images/xuegod63-kvm2.img
需要修改xml文件virsh edit 虚拟机
2）、创建快照
qemu-img snapshot-create 虚拟机（可以用snapshot-create-as指定快照名称）
3）、快照管理
qemu-img snapshot-list
4）、恢复快照
查看虚拟机状态：virsh domstate xuegod63-kvm2
恢复快照：virsh snapshot-revert 虚拟机 快照名
查看当前快照: virsh snapshot-current xuegod63-kvm2
快照目录：/var/lib/libvert/qemu/snapshot/虚拟机
删除快照： virsh snapshot-delete 虚拟机 快照名

http://blog.csdn.net/gg296231363/article/details/6899533
kvm环境下qcow2的镜像支持快照
1 确认镜像的格式
  [root@nc1 boss]# qemu-img info test.qcow2  
   image: test.qcow2
   file format: qcow2
   virtual size: 10G (10737418240 bytes)
   disk size: 1.6G
   cluster_size: 65536 
   
2 为镜像test.qcow2创建快照，创建快照并没有产生新的镜像，虚拟机镜像大小增加，快照应属于镜像。
  [root@nc1 boss]#qemu-img snapshot -c snapshot01 test.qcow2  
  
   
 3 查看虚拟机testsnp已有的快照 
  [root@nc1 boss]# virsh snapshot-list testsnp
   Name                 Creation Time             State
   ---------------------------------------------------
   1315385065           2011-09-07 16:44:25 +0800 running        //1315385065创建时间比snapshot02早 
  snapshot02           2011-09-07 17:32:38 +0800 running
   同样地，也可以通过qemu-img命令来查看快照
  [root@nc1 boss]# qemu-img info test.qcow2
    image: test.qcow2
    file format: qcow2
    virtual size: 10G (10737418240 bytes)
    disk size: 1.2G
    cluster_size: 65536
    Snapshot list:
    ID        TAG                 VM SIZE                DATE       VM CLOCK
    1         1315385065             149M 2011-09-07 16:44:25   00:00:48.575
    2         snapshot02             149M 2011-09-07 17:32:38   00:48:01.341

4 可以通过snapshot-dumpxml命令查询该虚拟机某个快照的详细配置
[root@nc1 boss]# virsh snapshot-dumpxml testsnp 1315385065
  <domainsnapshot>
   <name>1315385065</name>
   <description>Snapshot of OS install and updates</description>
   <state>running</state>     //虚拟机状态  虚拟机关机状态时创建的快照状态为shutoff（虚拟机运行时创建的快照，即使虚拟机状态为shutoff，快照状态依然为running）
  <creationTime>1315385065</creationTime>   //虚拟机的创建时间 Readonly 由此可以看出没有给快照指定名称的话，默认以时间值来命名快照
  <domain>
     <uuid>afbe5fb7-5533-d154-09b6-33c869a05adf</uuid> //此快照所属的虚拟机(uuid)
   </domain>
 </domainsnapshot>
  查看第二个snapshot
  [root@nc1 boss]# virsh snapshot-dumpxml testsnp snapshot02
  <domainsnapshot>
    <name>snapshot02</name>
    <description>Snapshot of OS install and updates</description>
    <state>running</state>
    <parent> 
      <name>1315385065</name>        //当前快照把前一个快照作为parent
    </parent>
    <creationTime>1315387958</creationTime>
    <domain>
      <uuid>afbe5fb7-5533-d154-09b6-33c869a05adf</uuid>
    </domain>
  </domainsnapshot>

5 查看最新的快照信息
  [root@nc1 boss]# virsh snapshot-current testsnp
   <domainsnapshot>
     <name>1315385065</name>
     <description>Snapshot of OS install and updates</description>
     <state>running</state>
     <creationTime>1315385065</creationTime>   
     <domain>
       <uuid>afbe5fb7-5533-d154-09b6-33c869a05adf</uuid>
     </domain>
    </domainsnapshot>

6 使用快照，指定使用哪一个快照恢复虚拟机
 [root@nc1 boss]# virsh snapshot-revert testsnp snapshot02

7 删除指定快照
  [root@nc1 boss]# virsh snapshot-delete testsnp snapshot02
   Domain snapshot snapshot02 deleted

附：
Snapshot (help keyword 'snapshot')
     snapshot-create                Create a snapshot from XML
     snapshot-create-as             Create a snapshot from a set of args
     snapshot-current               Get the current snapshot
     snapshot-delete                Delete a domain snapshot
     snapshot-dumpxml               Dump XML for a domain snapshot
     snapshot-list                  List snapshots for a domain
     snapshot-revert                Revert a domain to a snapshot
