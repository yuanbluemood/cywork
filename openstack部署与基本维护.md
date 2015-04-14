##部署文档
按照http://docs.openstack.org/juno/install-guide/install/yum/content/一步步执行即可
团队合作部署需统一定好每个人负责模块和公用密码信息
##基本维护和启动连接第一个虚机
###Controller节点：
* 重启服务

  systemctl restart openstack-nova-api.service openstack-nova-cert.service   openstack-nova-consoleauth.service openstack-nova-scheduler.service   openstack-nova-conductor.service openstack-nova-novncproxy.service
* 启动虚机（页面操作或cli）

  nova boot --flavor m1.large --image Fedora --nic net-id=87b6c484-b886-45c9-8748-e07bf09321f2   --security-group default --key-name mobo-key_malai Fedora
此时可以去计算节点上看nova日志，没有报错就顺利的起来了，可以给新启动的实例绑定一个浮动ip，就可以利用制定的key在外网去连了
* 查看信息

    nova list 查看现有虚机
    nova service-list 查看现有计算节点
    nova image-list 查看镜像信息
    cinder list 查看现有块设备
    cinder service-list 查看块存储节点
    nova net-list 查看现有网络信息
    neutreon agent-list查看现有网络agent信息
    neutron subnet-list查看现有子网信息
  
###Computer节点：
* 重启服务
  /usr/bin/systemctl restart libvirtd.service openstack-nova-compute.service
* 重要日志
  tail -f /var/log/nova/nova-compute.log
###Network节点
* 重启服务
  systemctl restart openvswitch.service neutron-openvswitch-agent.service neutron-l3-agent.service   neutron-dhcp-agent.service neutron-metadata-agent.service

##网络结构说明
![](http://docs.openstack.org/juno/install-guide/install/yum/content/figures/1/a/common/figures/installguidearch-neutron-networks.png)
* 参考上面的架构图，需提前规划好网络架构，这里的部署有四种网络
* 1 管理内网：用于controller管理所有其他各节点
* 2 虚机流量网络：用于网络节点和计算节点之间传递VM流量
* 3 存储网络：用于计算节点和block或object存储之间通信
* 4 Internet公网：用于同internet公网交互
###从安全和架构清晰角度，除公网外这几种内部网络最好是分开
具体实现上需要网络管理员将内网段口设为trunk，并在物理节点以多vlan虚ip的方式绑定各对应内网，参照这篇来配computer节点的多vlan支持
http://kc1985.blog.51cto.com/2407758/1051333
network节点上：

  [root@network ~]# ifconfig|awk '{print $1}'|grep :
  em1:
  em2:
  em1.88:
  em1.500:
  lo:
  virbr0:
  
##注意事项：
###1可以开启VNC来从web上连接虚机
 
###2计算节点
为避免网络和安全问题，可以关闭防火墙，同时禁掉外网，只需要内网有vlan和网络节点通即可
###3关于镜像
如fedora的云镜像一般都是直接通过key访问的，这个要在启动vm时就要设置好，之后绑定好ip直接通过key从外网就可以登陆了
