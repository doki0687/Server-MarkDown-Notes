# 【0】实验环境搭建
## 【1】连接云平台
需要使用三层交换机进行路由转发，二层交换机没有该功能
**使用AC进行实验也可以，使用AC的话不用进行任何配置，插好线即可**

**需要设备清单：**
|名称|数量|功能|
|---|---|---|
|PC|1|配置实例|
|DCN CS6200|1|数据转发|
|DCN CRL1000 R2.0|1|实例载体|
|超五类/六类双绞线|3|数据传输|

**云平台2.0正面外观：**
![60fcb5d07045e0c771653c9869fbc554.jpeg](https://s1.imagehub.cc/images/2023/12/09/60fcb5d07045e0c771653c9869fbc554.jpeg)
**云平台2.0背面外观：**
![b91ecbf09489bb23cefbab5406dae4e2.jpeg](https://s1.imagehub.cc/images/2023/12/09/b91ecbf09489bb23cefbab5406dae4e2.jpeg)
**拓扑图：**
![efc21134d0abe0bb5f9e0fb133191b2c.png](https://s1.imagehub.cc/images/2023/12/09/efc21134d0abe0bb5f9e0fb133191b2c.png)
### 【1】连线
**⚠️注意：⚠️**
<font color=red>
⚠️⚠️⚠️禁止大力出奇迹⚠️⚠️⚠️  
⚠️连线时不要大力出奇迹，看清楚网线水晶头正反和端口再插⚠️  
⚠️听见一声清脆的"咯嘣"声或"噔"声就插好了⚠️  
⚠️拔的时候按下水晶头上的小卡片，轻轻向外拽即可⚠️</font>

首先按照拓扑图去连线
下图蓝框内的为业务口，红框为管理口
业务口开启Trunk，管理口需要和电脑端口处于同一VLAN内
记住四字`上业下管`即可
![62c2228d1e46a434e3f77652bb48cfb0.jpeg](https://s1.imagehub.cc/images/2023/12/09/62c2228d1e46a434e3f77652bb48cfb0.jpeg)
### 【2】配置三层交换机
首先进入全局配置模式，然后创建vlan100，vlan100不能更换为别的vlan ID
因为云平台默认后台地址就是100段内
然后再创建一个vlan供实例使用，这个vlan ID可以更换为其他ID
```
vlan 100  #创建vlan100
exit  #退出vlan100
vlan 10  #创建vlan10
exit  #退出vlan10
```
![ccea9468694f21a62ad6911e8d18c7b9.png](https://s1.imagehub.cc/images/2023/12/09/ccea9468694f21a62ad6911e8d18c7b9.png)
同时进入1口和24口，划入vlan100内
```
interface ethernet 1/0/1;1/0/24  #进入1/0/1端口及1/0/24端口
switchport access vlan 100  #加入到vlan100内
```
![1feb99b809ccb01ec4fc5b52b6c4174f.png](https://s1.imagehub.cc/images/2023/12/09/1feb99b809ccb01ec4fc5b52b6c4174f.png)
进入vlan100内，然后为vlan100配置IP地址及子网掩码
这个地址必须为100段内，这个地址也是实验网卡的默认网关
```
interface vlan 100  #进入vlan100
ip address 192.168.100.254 255.255.255.0  #为vlan100配置IP及子网掩码
```
![7aece3fab03dd3879f039bbf1e2c7e74.png](https://s1.imagehub.cc/images/2023/12/09/7aece3fab03dd3879f039bbf1e2c7e74.png)
进入实例vlan，然后为实例vlan配置一个IP地址及子网掩码
**注意：**
所有实例的默认网关均填写你刚刚为实例vlan配置的IP地址
```
interface vlan 10  #进入vlan10
ip address 10.10.10.254 255.255.255.0  #为vlan10配置IP及子网掩码
```
![7ce5ecfba11fe07a8f0104d77e792a15.png](https://s1.imagehub.cc/images/2023/12/09/7ce5ecfba11fe07a8f0104d77e792a15.png)
进入业务口端口，开启trunk模式
```
interface ethernet 1/0/23  #进入业务口端口
switchport mode trunk  #开启trunk模式
```
![af9de917b583ba000b3c1d34ad0307e1.png](https://s1.imagehub.cc/images/2023/12/09/af9de917b583ba000b3c1d34ad0307e1.png)
设备掉电或重启后配置会丢失，可以`write`一下，写入配置文件
![7eebd42d8e7bf4d692c8f6665c348dd5.png](https://s1.imagehub.cc/images/2023/12/09/7eebd42d8e7bf4d692c8f6665c348dd5.png)
**最后`show running-config`一下检查有没有遗漏的配置：**
```
Interface Ethernet0
!
!
!
vlan 1;10;100 
!
Interface Ethernet1/0/1
 switchport access vlan 100
!
Interface Ethernet1/0/2
!
Interface Ethernet1/0/3
!
....................
省略1/0/4-1/0/20端口
....................
!
Interface Ethernet1/0/21
!         
Interface Ethernet1/0/22
!
Interface Ethernet1/0/23
 switchport mode trunk
!
Interface Ethernet1/0/24
 switchport access vlan 100
!
.....................
省略1/0/25-1/0/28端口
.....................
!
interface Vlan10
 ip address 10.10.10.254 255.255.255.0
!
interface Vlan100
 ip address 192.168.100.254 255.255.255.0
!
!
no login  
!
captive-portal
!
end
```
**完整配置命令：**
```
vlan 100
exit
vlan 10
exit
interface ethernet 1/0/1;1/0/24
switchport access vlan 100
interface vlan 100
ip address 192.168.100.254 255.255.255.0
interface vlan 10
ip address 10.10.10.254 255.255.255.0
interface ethernet 1/0/23
switchport mode trunk
write
```

### 【3】登录云平台Web界面
Win+R输入`ncpa.cpl`打开网络连接
首先把除实验网卡外的其他网卡全部禁用，因为其他网卡的数据会干扰到实验网卡的数据，有的时候Web界面打不开就是因为这种情况
![550368845befbe67cc22b2bb4b7e413f.png](https://s1.imagehub.cc/images/2023/12/09/550368845befbe67cc22b2bb4b7e413f.png)
然后为实验网卡配置静态IP
IP地址填写100段内的任意地址，排除100.100(云平台IP)、100.254(云平台网关)、100.255(广播地址)
默认网关填写你为vlan100配置的IP，是多少填多少即可
![7c0aaac8b4359f4ca927585d846d1bae.png](https://s1.imagehub.cc/images/2023/12/09/7c0aaac8b4359f4ca927585d846d1bae.png)
打开浏览器，在地址栏内输入`http://192.168.100.100/dcncloud`
配置没问题的话，你将会看到以下界面
![b52a6685e8615bc254b20da701442fa9.png](https://s1.imagehub.cc/images/2023/12/09/b52a6685e8615bc254b20da701442fa9.png)
选择"管理员"登录
输入账号密码即可登录
![91aac431e9cef8697f99d3c44051dc85.png](https://s1.imagehub.cc/images/2023/12/09/91aac431e9cef8697f99d3c44051dc85.png)
成功登录云平台Web界面
![ce0da0589aebfc05e96ef76dc7b48d31.png](https://s1.imagehub.cc/images/2023/12/09/ce0da0589aebfc05e96ef76dc7b48d31.png)

## 【2】云平台操作
### 【1】创建实例类型
在"管理员"内创建实例类型
![ef5caed1608c99a57446b66d54be6385.png](https://s1.imagehub.cc/images/2023/12/11/ef5caed1608c99a57446b66d54be6385.png)
名称随意填写;ID保持默认；VCPU数量写4或6均可；内存WinSer和Linux GUI填写4096，Linux CIL填写2048；根磁盘WinSer和Linux GUI填写80，Linux CLI适当减少即可
![fb0e7f7462b818435d230fd094662e32.png](https://s1.imagehub.cc/images/2023/12/11/fb0e7f7462b818435d230fd094662e32.png)
全部填写完毕后点击"创建实例类型"，等待创建完成即可
![f998cc33b27a938230713039b6b0c68f.png](https://s1.imagehub.cc/images/2023/12/11/f998cc33b27a938230713039b6b0c68f.png)

### 【2】创建网络
在"管理员"内创建网络
![39a34dc32409330feec1ab3ac8bdcf2c.png](https://s1.imagehub.cc/images/2023/12/11/39a34dc32409330feec1ab3ac8bdcf2c.png)
点击右侧的"创建网络"
![1a5b59cfa2bc0d097f5f5fae4a8b160e.png](https://s1.imagehub.cc/images/2023/12/11/1a5b59cfa2bc0d097f5f5fae4a8b160e.png)
名称任意填写；用户选择"admin"；VLAN ID填写对应的ID;勾选4个勾
![8910e650f4900e4bcf48a6125c08131e.png](https://s1.imagehub.cc/images/2023/12/11/8910e650f4900e4bcf48a6125c08131e.png)
子网名称任意填写；网络地址填写到网络位，并跟随`/24`；IP版本选择IPV4；网关IP填写你为实例VLAN配置的IP地址
![9f30bddb96bd280fa4bad9aa4e083f44.png](https://s1.imagehub.cc/images/2023/12/11/9f30bddb96bd280fa4bad9aa4e083f44.png)
在"分配地址池"内填写DHCP地址池范围，示例：`10.10.10.100,10.10.10.200`，开始IP与结束IP之间使用英文逗号分隔
![c83839338869e563b2cf9af28737e254.png](https://s1.imagehub.cc/images/2023/12/11/c83839338869e563b2cf9af28737e254.png)
点击"创建"即可
![4a8f488c00cd26e78ce2f511c152e579.png](https://s1.imagehub.cc/images/2023/12/11/4a8f488c00cd26e78ce2f511c152e579.png)

### 【3】创建实例
在"普通用户"内创建实例
![d3c022b813eb0bf7bf584651d2e29487.png](https://s1.imagehub.cc/images/2023/12/11/d3c022b813eb0bf7bf584651d2e29487.png)
点击右侧的"创建实例"
![be9ecf5cbb915053361233212c40040c.png](https://s1.imagehub.cc/images/2023/12/11/be9ecf5cbb915053361233212c40040c.png)
实例名称随意填写
![706868c788c14139d3bea846354a5c39.png](https://s1.imagehub.cc/images/2023/12/11/706868c788c14139d3bea846354a5c39.png)
选择实例镜像
![8f9abe8443a7d6fa551edce3cbb8bb24.png](https://s1.imagehub.cc/images/2023/12/11/8f9abe8443a7d6fa551edce3cbb8bb24.png)
点击右侧的上箭头，为实例分配实例类型
![346a025bc6ff43c74ce888dbcf7a7aff.png](https://s1.imagehub.cc/images/2023/12/11/346a025bc6ff43c74ce888dbcf7a7aff.png)
选择与实例相匹配的网络
![476f7b276144477a32fd7c92bb3108a7.png](https://s1.imagehub.cc/images/2023/12/11/476f7b276144477a32fd7c92bb3108a7.png)
到"网络接口"后，后面的不需要配置了，点击"创建实例"即可
![1ee2caa6a7b508688b839d9696960a2c.png](https://s1.imagehub.cc/images/2023/12/11/1ee2caa6a7b508688b839d9696960a2c.png)
等待10-20秒即可创建完成
![2963ebac9d9cba4d2339c6c63dcd171b.png](https://s1.imagehub.cc/images/2023/12/11/2963ebac9d9cba4d2339c6c63dcd171b.png)

### 【4】创建卷
在"普通用户"内创建卷
![b7328ac52b97a1deab0cedb9900df5aa.png](https://s1.imagehub.cc/images/2023/12/11/b7328ac52b97a1deab0cedb9900df5aa.png)
点击右侧的"创建卷"
![d680075b66cb5fb619d04382b6632da8.png](https://s1.imagehub.cc/images/2023/12/11/d680075b66cb5fb619d04382b6632da8.png)
卷名称写个好分辨的即可；卷来源选择"空白卷"，大小按需填写
![f79be4ea81eedb480433df4c44f334b6.png](https://s1.imagehub.cc/images/2023/12/11/f79be4ea81eedb480433df4c44f334b6.png)
点击"创建卷"后等待10秒即可
![3f0c75ae198639e95b81f7ad5e01a314.png](https://s1.imagehub.cc/images/2023/12/11/3f0c75ae198639e95b81f7ad5e01a314.png)

### 【5】镜像
在"普通用户"内点击"镜像"，即可查看到当前云平台内所有的镜像文件
⚠️⚠️⚠️ 不要私自上传镜像文件，DCN云平台使用的镜像格式与普通的ISO等镜像格式不通用
![395a69fd5a440c2aa3838def0f9fa24a.png](https://s1.imagehub.cc/images/2023/12/11/395a69fd5a440c2aa3838def0f9fa24a.png)

### 【6】实例的启动与关闭
**实例的启动：**
当云平台断电后，所有实例都会关闭
![09bb7bd350b92f74f4b722ac919faa5c.png](https://s1.imagehub.cc/images/2023/12/12/09bb7bd350b92f74f4b722ac919faa5c.png)
首先勾选需要启动的实例
![75ca13ff4adc9e5881991c71f0e92065.png](https://s1.imagehub.cc/images/2023/12/12/75ca13ff4adc9e5881991c71f0e92065.png)
在右侧的"更多操作"中点击"启动实例"
![0b8497a41f704fccaf3ac8be33c0510c.png](https://s1.imagehub.cc/images/2023/12/12/0b8497a41f704fccaf3ac8be33c0510c.png)
等待10秒后，刷新网页就能看到实例已经启动
![8cf51b1693cecf8cc0bd1f87f3c83dcd.png](https://s1.imagehub.cc/images/2023/12/12/8cf51b1693cecf8cc0bd1f87f3c83dcd.png)

**实例的关闭：**
勾选需要关闭的实例
![e033d1150d0390c51049c696e8fc5cd5.png](https://s1.imagehub.cc/images/2023/12/12/e033d1150d0390c51049c696e8fc5cd5.png)
在右侧的"更多操作"中选择"关闭实例"
![ef39e2739792f7e7f1f412bfdc2451f7.png](https://s1.imagehub.cc/images/2023/12/12/ef39e2739792f7e7f1f412bfdc2451f7.png)
在弹出的对话框中再次点击"关闭实例"
![9285df70c968d850d30ba4dfccc4b6ab.png](https://s1.imagehub.cc/images/2023/12/12/9285df70c968d850d30ba4dfccc4b6ab.png)
等待10秒后刷新网页，就能看到实例已经关闭
![ced5865c49c8286233ec432b1b05f42c.png](https://s1.imagehub.cc/images/2023/12/12/ced5865c49c8286233ec432b1b05f42c.png)

## 【3】VMware Workstation Pro
**VMware Workstation简介：**
VMware Workstation（中文名“威睿工作站”）是一款功能强大的桌面虚拟计算机软件，提供用户可在单一的桌面上同时运行不同的操作系统，和进行开发、测试 、部署新的应用程序的最佳解决方案。VMware Workstation可在一部实体机器上模拟完整的网络环境，以及可便于携带的虚拟机器，其更好的灵活性与先进的技术胜过了市面上其他的虚拟计算机软件。对于企业的 IT开发人员和系统管理员而言， VMware在虚拟网路，实时快照，拖曳共享文件夹，支持 PXE 等方面的特点使它成为必不可少的工具
[百度百科-VMware Workstation](https://baike.baidu.com/item/VMware%20Workstation/9884359 "百度百科-VMware Workstation")

### 【1】安装VMware 17 Pro
**本次安装过程适用于VMware Workstation Pro 17，其他版本安装过程大差不差**
解压VMware 17压缩包
![554c8b3055ef1da0543fba7ac406b603.png](https://s1.imagehub.cc/images/2023/12/10/554c8b3055ef1da0543fba7ac406b603.png)
接受霸王条款
![22a998051f7ef4dc0855c4c078b186e1.png](https://s1.imagehub.cc/images/2023/12/10/22a998051f7ef4dc0855c4c078b186e1.png)
选择合适的安装位置
勾选"增强型键盘驱动程序"及"将VMware Workstation控制台工具添加到系统PATH"，即添加到系统环境变量
![cfd1bd79e831a250116ac50b5c7fa71e.png](https://s1.imagehub.cc/images/2023/12/10/cfd1bd79e831a250116ac50b5c7fa71e.png)
不在启动时检查更新，以及不加入体验计划
![fb12469c842d3d090153fee662a6b9be.png](https://s1.imagehub.cc/images/2023/12/10/fb12469c842d3d090153fee662a6b9be.png)
等待安装完成
![8154ffbd7f6a1fbd8625f9e7febc4041.png](https://s1.imagehub.cc/images/2023/12/10/8154ffbd7f6a1fbd8625f9e7febc4041.png)
有实力的请支持正版
[下载 VMware Workstation Pro 17](https://www.vmware.com/cn/products/workstation-pro/workstation-pro-evaluation.html "下载 VMware Workstation Pro 17")
[VMware官网](https://www.vmware.com/cn.html "")
然后随便复制一段激活秘钥
![1bfdf9ed541d4fb03fd952bc52f0bd23.png](https://s1.imagehub.cc/images/2023/12/10/1bfdf9ed541d4fb03fd952bc52f0bd23.png)
复制粘贴，点击"输入"即可
![a42d6be989028558f20e01a746db1170.png](https://s1.imagehub.cc/images/2023/12/10/a42d6be989028558f20e01a746db1170.png)
然后重启系统即可
![b9c165c25a46b0e007e9e07feaca5169.png](https://s1.imagehub.cc/images/2023/12/10/b9c165c25a46b0e007e9e07feaca5169.png)
VMware 17 Pro主界面
![b447dbcb48c9b80301dac16aae96fb6e.png](https://s1.imagehub.cc/images/2023/12/10/b447dbcb48c9b80301dac16aae96fb6e.png)

### 【2】VMware网络类型
|中文名称|英文名称|说明|
|---|---|---|
|桥接模式|Bridged|相当于在本地局域网内新增了一台看不见摸不到的主机，IP和宿主机处于同一网段内|
|NAT模式|NAT|使用本地虚拟网卡进行地址转换，NAT模式下的主机虽然和宿主机不是同一网段，但还是能连通宿主机，这是因为本地虚拟网卡进行了地址转换，如果你的网络ip资源紧缺，但是你又希望你的虚拟机能够联网，这时候NAT模式是最好的选择。NAT模式借助虚拟NAT设备和虚拟DHCP服务器，使得虚拟机可以联网|
|仅主机模式|Host-Only|相当于在本地局域网内又新增了一个虚拟局域网，该模式无法上外网，只能和宿主机通信|

### 【3】虚拟网络编辑器
单击"编辑"选项卡，然后点击"虚拟网络编辑器"
![0ff9314e25094e9a956be4a1af7ac622.png](https://s1.imagehub.cc/images/2023/12/10/0ff9314e25094e9a956be4a1af7ac622.png)
这时候大部分的界面都是灰色，点击"更改设置"即可
![2a2c0d0b46b82cbb14ef25a161652370.png](https://s1.imagehub.cc/images/2023/12/10/2a2c0d0b46b82cbb14ef25a161652370.png)
在"子网"栏内可以自定义网络类型的网段，不要和宿主机网段冲突即可
更改"仅主机模式"的网段
![212709df60166b4cd5af030fe9adf3ec.png](https://s1.imagehub.cc/images/2023/12/10/212709df60166b4cd5af030fe9adf3ec.png)
更改"NAT模式"的网段
![07c1ae0cec6156053ae1c407d37809c1.png](https://s1.imagehub.cc/images/2023/12/10/07c1ae0cec6156053ae1c407d37809c1.png)

想更改桥接模式网段？
你需要进入路由器后台去更改网段，不熟悉操作的不建议更改

### 【4】创建虚拟机
创建虚拟机步骤太多太繁琐了，懒得一张张截图上传了，贴个别人的博客教程算了
[CSDN-使用VMware Workstation一步一步安装Rocky Linux 9](https://blog.csdn.net/fx_yzjy101/article/details/131197116?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522170227386816800222810019%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=170227386816800222810019&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-131197116-null-null.142^v96^pc_search_result_base4&utm_term=vmware%E5%AE%89%E8%A3%85rocky&spm=1018.2226.3001.4187 "CSDN-使用VMware Workstation一步一步安装Rocky Linux 9")👍👍👍
[CSDN-【Windows】VMware WorkStation Pro 17中安装Windows Server 2022虚拟机](https://blog.csdn.net/qq_24122661/article/details/130465759?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522170227616516800215098090%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=170227616516800215098090&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-130465759-null-null.142^v96^pc_search_result_base4&utm_term=vmware%E5%AE%89%E8%A3%85Windows%20server%202022&spm=1018.2226.3001.4187 "CSDN-【Windows】VMware WorkStation Pro 17中安装Windows Server 2022虚拟机")👍👍👍

创建虚拟机之前需要准备好对应的镜像，这里推荐几个镜像站点
**1-Windows镜像：**
第一个推荐的是[HelloWindows](https://hellowindows.cn/ "HelloWindows")
这个站点内的镜像上至Windows 11，下至Windows XP，官方镜像、无篡改、无捆绑下载、无植入广告等流氓行为，同时还支持ed2k和BT下载以及MD5 SHA1 SHA256等主流文件防篡改校验算法
![eb4a9f064605e2bec101b9896d58636a.png](https://s1.imagehub.cc/images/2023/12/10/eb4a9f064605e2bec101b9896d58636a.png)
当然Windows Server的镜像也是有的
![07ab509e3c3ecf7d0e7027086ead98dd.png](https://s1.imagehub.cc/images/2023/12/10/07ab509e3c3ecf7d0e7027086ead98dd.png)

第二个推荐的是[MSDN I TELL YOU](https://msdn.itellyou.cn/ "MSDN I TELL YOU")
该网站创建于2007年，同样也是很好的镜像站点，也有Windows和Server镜像，甚至还有MS-DOS😍
![33455493b69f1fd3cc209ba4a54535c1.png](https://s1.imagehub.cc/images/2023/12/10/33455493b69f1fd3cc209ba4a54535c1.png)

第三个推荐的是去[微软官方网站](https://www.microsoft.com/zh-cn/windows/ "体验Windows11操作系统")去下载
最大的优点就是不用担心任何篡改、捆绑、广告等行为
当然最大的缺点就是下载速度慢
Windows11、10不支持直接下载ISO镜像文件，需要下载其提供的安装工具去下载镜像
[Windows11-23H2](https://www.microsoft.com/zh-cn/software-download/windows11 "Windows11-23H2")
[Windows10-22H2](https://www.microsoft.com/zh-cn/software-download/windows10 "Windows10-22H2")
Windows Server支持直接下载ISO镜像文件
500兆网络环境下实测下载速度在300KB/S上下浮动
在"虚拟专用网络"的加持下可以跑到5MB/S上下
[Windows Server 2022](https://www.microsoft.com/zh-cn/evalcenter/download-windows-server-2022 "Windows Server 2022")
[Windows Server 2019](https://www.microsoft.com/zh-cn/evalcenter/download-windows-server-2019 "Windows Server 2019")
[Windows Server 2016](https://www.microsoft.com/zh-cn/evalcenter/download-windows-server-2016 "Windows Server 2016")
[Windows Server 2012 R2](https://www.microsoft.com/zh-cn/evalcenter/download-windows-server-2012-r2 "Windows Server 2012 R2")

**2-Linux发行版镜像：**
[阿里巴巴开源镜像站](https://developer.aliyun.com/mirror/ "阿里巴巴开源镜像站")
[华为开源镜像站](https://mirrors.huaweicloud.com/home "华为开源镜像站")
[清华大学开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn/?ref=hzwoo.com "清华大学开源软件镜像站")
[网易开源镜像站](https://mirrors.163.com/ "网易开源镜像站")
[腾讯软件源](https://mirrors.cloud.tencent.com/?from_column=20421&from=20421 "腾讯软件源")
更多国内镜像站点以及高校镜像站点：[Linux发行版的镜像网站及开源软件收集](https://cloud.tencent.com/developer/article/1729576 "Linux发行版的镜像网站及开源软件收集")
除了国内镜像站和高校镜像站，各发行版官网也提供下载

### 【5】创建快照
系统安装完毕后，进行一些初始配置后，就可以拍摄一个快照
当你的实验做完或者做毁之后，就可以恢复到你拍摄的某个快照版本，就不需要重装系统了
![a0758eed818edeaacfeab2811a0de2c1.png](https://s1.imagehub.cc/images/2023/12/11/a0758eed818edeaacfeab2811a0de2c1.png)
当你需要回到某个快照版本时，就可以右键虚拟机，选择"快照"，然后选择回到某个快照版本即可
![6391f5267ead997724fec6297b5032a2.png](https://s1.imagehub.cc/images/2023/12/11/6391f5267ead997724fec6297b5032a2.png)

# 【1】域服务器🤡
## 【1.1】创建主域控制器
### 【1】修改计算机名
为了方便后续操作，我们先要改名，2022-1改成server1
![8d635656c31b3ff4230dae59f8b6063b.png](https://s1.imagehub.cc/images/2023/08/18/8d635656c31b3ff4230dae59f8b6063b.png)
点击“下一步”后完成重启
![592230f81b75f110db476be9ddd591f3.png](https://s1.imagehub.cc/images/2023/08/18/592230f81b75f110db476be9ddd591f3.png)
### 【2】安装AD域服务
重启完成后打开“服务器管理器”，点击“添加角色和功能”
![b7e5c20eb282e38f21a86baca0cd868d.png](https://s1.imagehub.cc/images/2023/08/18/b7e5c20eb282e38f21a86baca0cd868d.png)
在“服务器角色”中，勾选“AD域服务”的复选勾
![68ac2e5b26772b609495be870125f1d1.png](https://s1.imagehub.cc/images/2023/08/18/68ac2e5b26772b609495be870125f1d1.png)
等待安装完成即可
![Snipaste_2023-08-18_22-55-01.png](https://s1.imagehub.cc/images/2023/08/18/Snipaste_2023-08-18_22-55-01.png)
### 【3】提升为域控制器
安装完成后，点击蓝字“将此服务器提升为域控制器”
![Snipaste_2023-08-18_22-58-03.png](https://s1.imagehub.cc/images/2023/08/18/Snipaste_2023-08-18_22-58-03.png)
部署操作中，选择“添加新林”，根域名填写自己想要的
![b7e0a02e6ba2a977cddc4eacff699a5e.png](https://s1.imagehub.cc/images/2023/08/18/b7e0a02e6ba2a977cddc4eacff699a5e.png)
“域控制器选项”中，按要求填写，没要求就默认就好，密码还写Qwer1234吧
![7dc32fc53d85fcdd6dcfd5e484510175.png](https://s1.imagehub.cc/images/2023/08/18/7dc32fc53d85fcdd6dcfd5e484510175.png)
DNS选项中，默认就可以
![DNS.png](https://s1.imagehub.cc/images/2023/08/18/DNS.png)
在这一步中，我们需要提供凭据才能进行下一步的操作。需要点击“更改”，以提供凭据
![Snipaste_2023-08-18_23-13-55.png](https://s1.imagehub.cc/images/2023/08/18/Snipaste_2023-08-18_23-13-55.png)
用户名一般就是“administrator”，密码是你当初安装系统时设置的密码。如果你用的是神码云平台的话，那一般就是“Qwer1234”
![Snipaste_2023-08-18_23-15-24.png](https://s1.imagehub.cc/images/2023/08/18/Snipaste_2023-08-18_23-15-24.png)
提供完正确的凭证后，就是这样式儿的
![Snipaste_2023-08-18_23-19-31.png](https://s1.imagehub.cc/images/2023/08/18/Snipaste_2023-08-18_23-19-31.png)
下一步就是NetBIOS域名选项，一般来说就是全大写的域名。这一步不用管，默认下一步就行
![Snipaste_2023-08-18_23-20-58.png](https://s1.imagehub.cc/images/2023/08/18/Snipaste_2023-08-18_23-20-58.png)
AD域服务的各种跟随文件保存路径没特殊要求就默认
![Snipaste_2023-08-18_23-23-13.png](https://s1.imagehub.cc/images/2023/08/18/Snipaste_2023-08-18_23-23-13.png)
到了“查看选项”，这里就是对你前面的操作做一个总结提供给你看，以防出现配置错误
![Snipaste_2023-08-18_23-25-09.png](https://s1.imagehub.cc/images/2023/08/18/Snipaste_2023-08-18_23-25-09.png)
先决检查就是对你当前操作的配置环境进行检测，看当前配置环境是否支持你的操作。就好比你改完计算机名没有重启，你就来安装、升级域控制器了，先决条件检查肯定过不去
完成先决检查后，就可以点击“安装”升级为域控制器了
![Snipaste_2023-08-18_23-34-17.png](https://s1.imagehub.cc/images/2023/08/18/Snipaste_2023-08-18_23-34-17.png)
等待先决安装完成后，重启就好了
安装过程大概需要5-6分钟，挺漫长的
![Snipaste_2023-08-24_13-45-34.png](https://s1.imagehub.cc/images/2023/08/24/Snipaste_2023-08-24_13-45-34.png)
已成功提升为域控制器
![Successfully-promoted-to-domain-controller.png](https://s1.imagehub.cc/images/2023/09/05/Successfully-promoted-to-domain-controller.png)
### 【4】验证环节
右键“此电脑”-“属性”-“重命名这台电脑”
![Bootstrap-click-Rename-this-PC.png](https://s1.imagehub.cc/images/2023/09/05/Bootstrap-click-Rename-this-PC.png)
![Verify-the-primary-domain-controller-computer-name.png](https://s1.imagehub.cc/images/2023/09/05/Verify-the-primary-domain-controller-computer-name.png)
## 【1.2】加入域环境
### 【1】重获SID
由于我是直接用VM克隆的虚拟机，所以他们的SID号是一样的，换到云平台上也是一样的，VM克隆虚拟机和云平台虚拟机都要运行sysprep程序
![sysprep.exe.png](https://s1.imagehub.cc/images/2023/09/05/sysprep.exe.png)
如果不运行sysprep的话，在加入域时就会出现这种情况
![SID-conflicts.png](https://s1.imagehub.cc/images/2023/09/05/SID-conflicts.png)
打开sysprep程序后，记得勾选“通用”选项
![Run-the-preparation-tool.png](https://s1.imagehub.cc/images/2023/09/05/Run-the-preparation-tool.png)
等待sysprep程序清理完成
![sysprep-is-working.png](https://s1.imagehub.cc/images/2023/09/05/sysprep-is-working.png)
### 【2】完成新系统配置
sysprep清理完成后，会进行新系统的配置
![Complete-the-new-system-configuration-1.png](https://s1.imagehub.cc/images/2023/09/05/Complete-the-new-system-configuration-1.png)
第二步输入产品秘钥时，选择“以后再说”
![Complete-the-new-system-configuration-2.png](https://s1.imagehub.cc/images/2023/09/05/Complete-the-new-system-configuration-2.png)
签订霸王条款😅  
![Complete-the-new-system-configuration-3.png](https://s1.imagehub.cc/images/2023/09/05/Complete-the-new-system-configuration-3.png)
输入开机密码后，点击“完成”
![Complete-the-new-system-configuration-3.png](https://s1.imagehub.cc/images/2023/09/05/Complete-the-new-system-configuration-3.png)
这样新系统就配置完成了，现在server-2的SID与server-1的SID就不一样了
![The-new-system-configuration-is-complete.png](https://s1.imagehub.cc/images/2023/09/05/The-new-system-configuration-is-complete.png)
### 【3】修改网卡配置
进系统之后先配置IPV4地址
注意这里的DNS要指向server-1，要不然加入域时会显示无法找到域
![IPV4-PROPERTIES.png](https://s1.imagehub.cc/images/2023/09/05/IPV4-PROPERTIES.png)
### 【4】修改计算机名、加入域
修改计算机名、加入域
![Computer-namedomain-changes.png](https://s1.imagehub.cc/images/2023/09/05/Computer-namedomain-changes.png)点击确定后再输入正确的账户名称和密码
一般来说都是administrator/Qwer1234
![Enter-the-domain-account-name-and-password.png](https://s1.imagehub.cc/images/2023/09/05/Enter-the-domain-account-name-and-password.png)账户名称及密码输入正确后，就会提示你已加入域：  
![Successfully-joined-the-domain.png](https://s1.imagehub.cc/images/2023/09/05/Successfully-joined-the-domain.png)
然后就会提示你必须重启计算机才会生效，这时候重启就行了
![Takes-effect-after-restarting-the-computer.png](https://s1.imagehub.cc/images/2023/09/05/Takes-effect-after-restarting-the-computer.png)
### 【5】验证环节
重启完毕后去看计算机名和域
可以看到，计算机名是server-2，域是chinaskills.com：  
![Takes-effect-after-restarting-the-computer.png](https://s1.imagehub.cc/images/2023/09/05/Takes-effect-after-restarting-the-computer.png)
## 【1.3】只读域控制器
### 【1】重获SID
首先运行sysprep程序🙃  
![Running-the-sysprep-program.png](https://s1.imagehub.cc/images/2023/09/05/Running-the-sysprep-program.png)
### 【2】完成新系统配置
![Complete-the-configuration-of-the-new-system.png](https://s1.imagehub.cc/images/2023/09/05/Complete-the-configuration-of-the-new-system.png)
### 【3】修改网卡配置  
![IPV4-ADDRESS-ATTRIBUTE.png](https://s1.imagehub.cc/images/2023/09/05/IPV4-ADDRESS-ATTRIBUTE.png)
### 【4】修改计算机名、加入域环境
右键“此电脑”-“属性”，更改计算机名
名称改为“server-3”，并加入server-1域环境
![Change-the-computer-name-and-join-the-domain-environment.png](https://s1.imagehub.cc/images/2023/09/05/Change-the-computer-name-and-join-the-domain-environment.png)
### 【5】安装基础AD域服务
打开服务器管理器-添加角色和功能
选择AD域服务
![Install-the-basic-AD-domain-service.png](https://s1.imagehub.cc/images/2023/09/06/Install-the-basic-AD-domain-service.png)
这里要显示到计算机全名才可以
![Installing-the-basic-AD-Domain-Service.png](https://s1.imagehub.cc/images/2023/09/06/Installing-the-basic-AD-Domain-Service.png)
### 【6】提升为域控制器
安装好基础AD域后，点击<font color=DeepSkyBlue>蓝字</font>提升为域控制器
![Promote-to-domain-controller.png](https://s1.imagehub.cc/images/2023/09/06/Promote-to-domain-controller.png)
选择"将域控制器添加到现有域"
![Add-to-an-existing-domain.png](https://s1.imagehub.cc/images/2023/09/06/Add-to-an-existing-domain.png)
这里需要提供当前用户的账户名称及密码，一般都是administrator/Qwer1234
![Provide-the-account-and-password-of-the-current-user.png](https://s1.imagehub.cc/images/2023/09/06/Provide-the-account-and-password-of-the-current-user.png)
勾选"只读域控制器"
![Check-Read-only-domain-controllers.png](https://s1.imagehub.cc/images/2023/09/06/Check-Read-only-domain-controllers.png)
完成先决条件检查
![Pass-the-prerequisite-check.png](https://s1.imagehub.cc/images/2023/09/06/Pass-the-prerequisite-check.png)
先决条件检查完成后，等待只读域控制器安装完成，并等待系统完成重启🤤
![Wait-for-the-restart-to-complete.png](https://s1.imagehub.cc/images/2023/09/06/Wait-for-the-restart-to-complete.png)
### 【7】验证环节
重启完成后，打开系统属性，可以看到计算机全名已经变成了server3.chinaskills.com
![Server3-system-properties.png](https://s1.imagehub.cc/images/2023/09/06/Server3-system-properties.png)
然后打开服务器管理器，打开右上角的"工具"，选择"AD用户和计算机"
![Turn-on-AD-Users-and-Computers.png](https://s1.imagehub.cc/images/2023/09/06/Turn-on-AD-Users-and-Computers.png)
双击打开"Domain Cotrollers"
![Double-click-to-open-Domain-Cotrollers.png](https://s1.imagehub.cc/images/2023/09/06/Double-click-to-open-Domain-Cotrollers.png)
在"Domain Cotrollers"里可以看到本机域控制器和我们刚才搭建好的server3只读域控制器
![Server3-Read-only-domain-controller.png](https://s1.imagehub.cc/images/2023/09/06/Server3-Read-only-domain-controller.png)
## 【1.4】子域控制器
### 【1】重获SID
首先运行sysprep程序，重获SID号
![Run-the-sysprep-program.png](https://s1.imagehub.cc/images/2023/09/06/Run-the-sysprep-program.png)
### 【2】修改网卡配置
DNS指向server1
![Modify-the-NIC-configuration.png](https://s1.imagehub.cc/images/2023/09/06/Modify-the-NIC-configuration.png)
### 【3】修改计算机名并加入域环境
![Modify-the-computer-name-and-join-the-domain-environment.png](https://s1.imagehub.cc/images/2023/09/06/Modify-the-computer-name-and-join-the-domain-environment.png)
### 【4】安装基础AD域服务
![Install-the-AD-domain-environment.png](https://s1.imagehub.cc/images/2023/09/06/Install-the-AD-domain-environment.png)
![53f208314e1fdd339.png](https://s1.imagehub.cc/images/2023/09/06/53f208314e1fdd339.png)
### 【5】提升为域控制器
基础AD域安装完成后，点击蓝字提升为域控制器
[![Promote-this-server-to-a-domain-controller.png](https://s1.imagehub.cc/images/2023/09/06/Promote-this-server-to-a-domain-controller.png)](https://www.imagehub.cc/image/ryvec6)
选择"将新域添加到现有林"，新域名按需填写
[![Add-a-new-domain-to-an-existing-forest.png](https://s1.imagehub.cc/images/2023/09/06/Add-a-new-domain-to-an-existing-forest.png)](https://www.imagehub.cc/image/ryv6xe)
然后提供本机账户名称密码凭证
![Provide-the-native-account-name-password-credentials.png](https://s1.imagehub.cc/images/2023/09/06/Provide-the-native-account-name-password-credentials.png)
填写DSRM密码
![Fill-in-the-DSRM-password.png](https://s1.imagehub.cc/images/2023/09/06/Fill-in-the-DSRM-password.png)
完成先决条件检查
![Complete-the-prerequisite-checks.png](https://s1.imagehub.cc/images/2023/09/06/Complete-the-prerequisite-checks.png)
![The-child-domain-controller-is-installed.png](https://s1.imagehub.cc/images/2023/09/06/The-child-domain-controller-is-installed.png)
子域控制器的安装时间很久的，大概需要5-6分钟，会有很长一段时间卡在这个界面，耐心等待就行
如果比赛中，这时候就去操作别的机器，不要傻傻的等它安装完成，很浪费时间的
![1289fbbb216f8d5e8f.png](https://s1.imagehub.cc/images/2023/09/06/1289fbbb216f8d5e8f.png)
### 【6】验收环节
打开计算机系统属性

<font color=red>
子域控制器计算机全名=计算机名+新域名+域环境名
</font>

[![Computer-system-properties.png](https://s1.imagehub.cc/images/2023/09/06/Computer-system-properties.png)](https://www.imagehub.cc/image/ryvyho)

## 【1.5】用户(组)操作
### 【1】创建新组织单位
打开服务器管理器-AD域用户和计算机
![Open-AD-Domain-Users-and-Computers.png](https://s1.imagehub.cc/images/2023/09/07/Open-AD-Domain-Users-and-Computers.png)
首先点击"chianskills.com"，然后再创建一个新的组织单位
[![Create-a-new-organizational-unit-first.png](https://s1.imagehub.cc/images/2023/09/07/Create-a-new-organizational-unit-first.png)](https://www.imagehub.cc/image/rLc0uv)
输入组织单位名称，并取消"防止容器被意外删除"复选框
[![Uncheck-Prevent-container-from-accidental-deletion.png](https://s1.imagehub.cc/images/2023/09/07/Uncheck-Prevent-container-from-accidental-deletion.png)](https://www.imagehub.cc/image/rLsdI0)
### 【2】创建新组
组织单位创建好之后，然后创建一个组
![Create-a-new-group.png](https://s1.imagehub.cc/images/2023/09/07/Create-a-new-group.png)
组名称和组织单位名称写同样的名字
[![Create-a-new-object-group.png](https://s1.imagehub.cc/images/2023/09/07/Create-a-new-object-group.png)](https://www.imagehub.cc/image/rLHtrz)
### 【3】创建新用户
组织单位和对象组都创建完成后再创建用户
![Create-a-new-user.png](https://s1.imagehub.cc/images/2023/09/07/Create-a-new-user.png)
"姓"和"用户登录名"中都要填写内容
![Fill-in-the-user-name.png](https://s1.imagehub.cc/images/2023/09/07/Fill-in-the-user-name.png)
填写用户登录密码，这4个复选框，1和2选项是冲突的，其余选项根据情况选择
![Enter-the-password-and-select-the-password-attribute.png](https://s1.imagehub.cc/images/2023/09/07/Enter-the-password-and-select-the-password-attribute.png)
然后再创建几个用户
![Create-2-more-users.png](https://s1.imagehub.cc/images/2023/09/07/Create-2-more-users.png)
### 【4】将用户加入用户组
选中这几个用户
![Select-these-users.png](https://s1.imagehub.cc/images/2023/09/07/Select-these-users.png)
点击"添加到组"
[![Add-to-a-group.png](https://s1.imagehub.cc/images/2023/09/07/Add-to-a-group.png)](https://www.imagehub.cc/image/rL8Y6o)
输入组织单位名称，然后点击"检查名称"后，没问题的话，名称下面就会出现一条单下划线
![Enter-the-container-name-and-check.png](https://s1.imagehub.cc/images/2023/09/07/Enter-the-container-name-and-check.png)
点击"确定"后会出现添加成功的提示框
[![Successfully-added-to-the-group.png](https://s1.imagehub.cc/images/2023/09/07/Successfully-added-to-the-group.png)](https://www.imagehub.cc/image/rLJDbs)

### 【5】验证环节
#### 【1】查看用户组成员属性
右键人事部用户组属性
![Right-click-HR-Department-Properties.png](https://s1.imagehub.cc/images/2023/09/07/Right-click-HR-Department-Properties.png)
点击"成员"
![Click-HR-Member-Properties.png](https://s1.imagehub.cc/images/2023/09/07/Click-HR-Member-Properties.png)
可以看到我们刚才加入的3个用户
![3-members.png](https://s1.imagehub.cc/images/2023/09/07/3-members.png)
#### 【2】命令行查看用户组属性
`net group renshibu`
![View-user-group-properties.png](https://s1.imagehub.cc/images/2023/09/07/View-user-group-properties.png)
#### 【3】命令行查看用户属性
`net user adm1`
`net user adm2`
`net user adm3`
![MergedImages.png](https://s1.imagehub.cc/images/2023/09/07/MergedImages.png)
可以在全局组成员中看到2个归属，其中一个是reshibu，这就是创建用户组而不直接创建用户的意义，这是直接创建用户的属性：
![Snipaste_2023-09-07_14-49-02.png](https://s1.imagehub.cc/images/2023/09/07/Snipaste_2023-09-07_14-49-02.png)
可以看到，直接创建用户而不加入用户组的比加入用户组的用户缺失一个renshibu全局组属性

### <font color=red>【特别说明】</font>
如果你要创建多个部门，也就是创建多个组织单位，创建完一个后，请再次点击chinaskills.com
![20bf2b9d7d27291d6.png](https://s1.imagehub.cc/images/2023/09/07/20bf2b9d7d27291d6.png)
否则你创建完一个组织单位后，它是默认选择到你刚刚创建的组织单位上的，如果你没注意到而且直接创建组织单位的话，那么就是这个样子
![Error-condition-display.png](https://s1.imagehub.cc/images/2023/09/07/Error-condition-display.png)
## 【1.6】允许复制用户账户密码到RODC中
### 【1】打开RODC属性
服务器管理器-工具-AD域用户和计算机-chainskills.com-Domain Controllers
![Open-Domain-Colltrollers.png](https://s1.imagehub.cc/images/2023/09/07/Open-Domain-Colltrollers.png)
右键"属性"
![Open-the-Domain-Colltrollers-property.png](https://s1.imagehub.cc/images/2023/09/07/Open-the-Domain-Colltrollers-property.png)
### 【2】添加账户进密码复制策略中
选择"密码复制策略"
![Select-a-password-replication-policy.png](https://s1.imagehub.cc/images/2023/09/07/Select-a-password-replication-policy.png)
点击"添加"
![Click-Add.png](https://s1.imagehub.cc/images/2023/09/07/Click-Add.png)
选择"允许该账户密码复制到此RODC中"
![Select-Allow-the-account-password-to-be-copied-to-this-RODC.png](https://s1.imagehub.cc/images/2023/09/07/Select-Allow-the-account-password-to-be-copied-to-this-RODC.png)
输入账户名称，检查后确定即可，如果有多个账户需要添加，步骤一样
![Enter-the-account-name-and-check.png](https://s1.imagehub.cc/images/2023/09/07/Enter-the-account-name-and-check.png)
### 【3】验收环节
回退至RODC主机属性-密码复制策略中，可以看到我们刚才允许的2台主机
![Password-replication-policy.png](https://s1.imagehub.cc/images/2023/09/07/Password-replication-policy.png)
## 【1.7】域控制器迁移
创建一个新的主机server5，把server1的主域控制器迁移到server5中
### 【1】重获SID
运行sysprep程序
![Running-the-sysprep-program.png](https://s1.imagehub.cc/images/2023/09/05/Running-the-sysprep-program.png)
### 【2】完成新系统配置
![Snipaste_2023-09-07_16-19-51.png](https://s1.imagehub.cc/images/2023/09/07/Snipaste_2023-09-07_16-19-51.png)
如果遇见这种情况直接点"是"即可
![Snipaste_2023-09-07_16-42-39.png](https://s1.imagehub.cc/images/2023/09/07/Snipaste_2023-09-07_16-42-39.png)
### 【3】修改网卡配置
![server5-ip-config.png](https://s1.imagehub.cc/images/2023/09/07/server5-ip-config.png)
### 【4】修改计算机名、加入域环境
![Modify-the-computer-name-and-join-the-domain-environment.png](https://s1.imagehub.cc/images/2023/09/07/Modify-the-computer-name-and-join-the-domain-environment.png)
### 【5】安装基础AD域服务
![194c6969406450785.png](https://s1.imagehub.cc/images/2023/09/07/194c6969406450785.png)
### 【6】提升为域控制器
![21b3d36699eb6f91f.png](https://s1.imagehub.cc/images/2023/09/07/21b3d36699eb6f91f.png)
选择"将域控制器添加到现有域"，并提供账户名称及密码
![3eeff6384daf37931.png](https://s1.imagehub.cc/images/2023/09/07/3eeff6384daf37931.png)
![4679bec3cae97bfde.png](https://s1.imagehub.cc/images/2023/09/07/4679bec3cae97bfde.png)
完成先决条件检查，并安装，等待重启完成
![51a58c5697b8f8bc1.png](https://s1.imagehub.cc/images/2023/09/07/51a58c5697b8f8bc1.png)
打开系统属性后，可以看到server5已经加入到chinaskills.com域环境内
[![82ba8b1228a6fcd52.png](https://s1.imagehub.cc/images/2023/09/07/82ba8b1228a6fcd52.png)](https://www.imagehub.cc/image/rLp5XI)
还可以打开主域控制器的Domain Controllers中查看
![AD-domain-users-and-computers-Domain-Controllers.png](https://s1.imagehub.cc/images/2023/09/07/AD-domain-users-and-computers-Domain-Controllers.png)
### 【7】迁移域控制器代码
> 查看架构主机、域命名主机等信息
> - `netdom query fsmo`

![1c41e4c3e3c246cf4.png](https://s1.imagehub.cc/images/2023/09/07/1c41e4c3e3c246cf4.png)

《也就》输入11行代码：
1. `ntdsutil`
2. `roles`
3. `connections`
4. `connect to server name` name写server5计算机名
5. `q`
6. `?`
![114514f7960abd0bcd1561.png](https://s1.imagehub.cc/images/2023/09/07/114514f7960abd0bcd1561.png)
7. `transfer infrastructure master`
8. `transfer naming master`
9. `transfer pdc`
10. `transfer rid master`
11. `transfer schema master`
![5-commands-to-migrate-domain-controllers.png](https://s1.imagehub.cc/images/2023/09/07/5-commands-to-migrate-domain-controllers.png)
### 【8】全局编录选项
打开AD站点和服务
![46930cfd1f9f6f163.png](https://s1.imagehub.cc/images/2023/09/07/46930cfd1f9f6f163.png)
然后依次展开以下列表：
Sites
    Default-First-Site-Name
        Servers
            SERVER5

![55b03afdd5313db62.png](https://s1.imagehub.cc/images/2023/09/07/55b03afdd5313db62.png)
右键server5的NTDS Setting
![6b5051893f99b6676.png](https://s1.imagehub.cc/images/2023/09/07/6b5051893f99b6676.png)
确保新的域控制器的"全局编录"选项是勾选上的
![733a9b95f3ba5ea94.png](https://s1.imagehub.cc/images/2023/09/07/733a9b95f3ba5ea94.png)
然后打开server1的NTDS Setting
确保server1的NTDS Setting是取消勾选的
![8f8a68c7c97029b14.png](https://s1.imagehub.cc/images/2023/09/07/8f8a68c7c97029b14.png)
![94dfef6dfaa0d3a8b.png](https://s1.imagehub.cc/images/2023/09/07/94dfef6dfaa0d3a8b.png)
### 验收环节
cmd内输入`netdom query fsmo`查看域控制器信息
可以看到，所有的服务器都迁移到server5上了
![103c40a75ced149cc0.png](https://s1.imagehub.cc/images/2023/09/07/103c40a75ced149cc0.png)

## 【1.8】域控制器降级
现在把已经迁移域控制器的server1降级
服务器管理器-管理-删除角色和功能
![1e0d60ade664827cf.png](https://s1.imagehub.cc/images/2023/09/07/1e0d60ade664827cf.png)
把"AD域服务"的复选框取消勾选
![2d2d5a005eaee6aa6.png](https://s1.imagehub.cc/images/2023/09/07/2d2d5a005eaee6aa6.png)
点击"删除功能"
![38d89ed4ddc49f66a.png](https://s1.imagehub.cc/images/2023/09/07/38d89ed4ddc49f66a.png)
这时候会报错，直接点"将此域控制器降级"
![4ec94d0755299eabe.png](https://s1.imagehub.cc/images/2023/09/07/4ec94d0755299eabe.png)
点击"下一步"
![5ad5e4785bb4a7ad2.png](https://s1.imagehub.cc/images/2023/09/07/5ad5e4785bb4a7ad2.png)
勾选"继续删除"
![6bf7fa97b8b2f7cf5.png](https://s1.imagehub.cc/images/2023/09/07/6bf7fa97b8b2f7cf5.png)
输入新的管理员密码
![7a66680ba15abe03b.png](https://s1.imagehub.cc/images/2023/09/07/7a66680ba15abe03b.png)
点击"降级"即可
![82473624d5ed58e4d.png](https://s1.imagehub.cc/images/2023/09/07/82473624d5ed58e4d.png)
等待清理完成
![9a526686e96b3b3e8.png](https://s1.imagehub.cc/images/2023/09/07/9a526686e96b3b3e8.png)
清理完成后会重启，等待重启即可
![109e7f16fa2b33c09e.png](https://s1.imagehub.cc/images/2023/09/07/109e7f16fa2b33c09e.png)
重启过程会持续5-6分钟
![11e50f6773c7a53ddd.png](https://s1.imagehub.cc/images/2023/09/07/11e50f6773c7a53ddd.png)
### 验收环节
重启完成后，输入新的管理员密码，可以看到服务器管理器通知中，有通知我们升级域控制器，就证明现在的server1只有基础AD域服务，不再是域控制器了
![Snipaste_2023-09-07_19-05-38.png](https://s1.imagehub.cc/images/2023/09/07/Snipaste_2023-09-07_19-05-38.png)

# 【2】磁盘管理😎
## 【前要说明】
磁盘管理的视频讲解我也有做，看不懂图文就跳转视频[Windows Server 2019磁盘管理基本操作](https://www.bilibili.com/video/BV1Tj411X75S/?spm_id_from=333.999.0.0&vd_source=f66e9fe7694284f598a5e2b8a3b6c586)

<font color=red>操作前要在云平台创建8块硬盘</font>，全部连接至server1

|卷名称    |hd1        | hd2      | hd3     |hd4     |hd5     |hd6     |hd7     |hd8     |
|-------   | --------  | -------- | --------|--------|--------|--------|--------|--------|
|卷容量    |  5GB      | 5GB      | 4GB     |4GB     |4GB     |10GB    | 10GB   |10GB    |
|卷盘符    |D          |D         |E        |E       |E       |F       |F       |F       |

![1985d07e7126680ab.png](https://s1.imagehub.cc/images/2023/09/09/1985d07e7126680ab.png)
![2665bbb48eca4f52c.png](https://s1.imagehub.cc/images/2023/09/09/2665bbb48eca4f52c.png)
## 【1】带区卷
### 【1】连接hd1 hd2
首先先把hd1和hd2连接到server1
[![1aa877c09b0054433.png](https://s1.imagehub.cc/images/2023/09/09/1aa877c09b0054433.png)](https://www.imagehub.cc/image/ru35iO)
![299bb04a2265e2d27.png](https://s1.imagehub.cc/images/2023/09/09/299bb04a2265e2d27.png)
![3ca56447cd760b255.png](https://s1.imagehub.cc/images/2023/09/09/3ca56447cd760b255.png)
其他硬盘连接也是同样的步骤，以此类推 ~~梗图114514~~
![Snipaste_2023-09-09_18-12-37.png](https://s1.imagehub.cc/images/2023/09/09/Snipaste_2023-09-09_18-12-37.png)
### 【2】联机硬盘
右键左下角Windows徽标，打开磁盘管理
![154275203fa7aba9e.png](https://s1.imagehub.cc/images/2023/09/09/154275203fa7aba9e.png)
先把2块硬盘全部联机
[![2-1.png](https://s1.imagehub.cc/images/2023/09/09/2-1.png)](https://www.imagehub.cc/image/ru6AdB)
### 【3】初始化硬盘
联机硬盘后，再进行初始化
![3dde6499950461061.png](https://s1.imagehub.cc/images/2023/09/09/3dde6499950461061.png)
![44d4cac4d37947f3c.png](https://s1.imagehub.cc/images/2023/09/09/44d4cac4d37947f3c.png)
![5.png](https://s1.imagehub.cc/images/2023/09/09/5.png)
右键磁盘1，选择"新建带区卷"
![1fdce0e51b84f3ce3.png](https://s1.imagehub.cc/images/2023/09/09/1fdce0e51b84f3ce3.png)
先单击磁盘2，然后点击"添加"，这时候磁盘2就会跑到磁盘1的下边去
[![208782e4fca5fa27f.png](https://s1.imagehub.cc/images/2023/09/09/208782e4fca5fa27f.png)](https://www.imagehub.cc/image/runAc6)
分配卷符为"D"
![3482c0255223c00b8.png](https://s1.imagehub.cc/images/2023/09/09/3482c0255223c00b8.png)
默认选项，点击"下一步"即可
![4339bde35e851bcaf.png](https://s1.imagehub.cc/images/2023/09/09/4339bde35e851bcaf.png)
出现这个窗口点"是"就行，不用多看一眼，因为多看一眼就会...
![504412288771d02ec.png](https://s1.imagehub.cc/images/2023/09/09/504412288771d02ec.png)
等待它格式化完毕，大概需要2-3分钟时间
### 【4】验收环节
直接在磁盘管理内就可以看见磁盘1和磁盘2已经格式化好了
![6a785f2b04e261897.png](https://s1.imagehub.cc/images/2023/09/09/6a785f2b04e261897.png)
在资源管理器内也可以看见我们刚才新建的带区卷D盘
![7.png](https://s1.imagehub.cc/images/2023/09/09/7.png)
## 【2】RAID5
### 【1】RAID5简介
raid5需要<font color=red>至少3块硬盘</font>，RAID5把数据和相对应的奇偶校验信息存储到组成RAID5的各个磁盘上，并且奇偶校验信息和相对应的数据分别存储于不同的磁盘上，其中任意N-1块磁盘上都存储完整的数据；当读取写入的数据的时候会分别从3块硬盘上读取数据内容，再通过检验信息进行校验。
![Snipaste_2023-09-09_19-35-41.png](https://s1.imagehub.cc/images/2023/09/09/Snipaste_2023-09-09_19-35-41.png)

由于RAID5需要3块硬盘，所以需要把hd3-5全部挂载到server1上
### 【2】连接hd3 hd4 hd5
我直接放全部连接的图了，就不一个一个截了
![182feff3e1b664857.png](https://s1.imagehub.cc/images/2023/09/09/182feff3e1b664857.png)
### 【3】联机硬盘
![2017932db78dc3aad.png](https://s1.imagehub.cc/images/2023/09/09/2017932db78dc3aad.png)
### 【4】初始化硬盘
右键磁盘3，选择"初始化磁盘"，然后就会出现这样批量初始化磁盘的窗口，把磁盘3，4，5全部勾选并初始化
![2-114514.png](https://s1.imagehub.cc/images/2023/09/09/2-114514.png)
[![337248191b1b0b5a1.png](https://s1.imagehub.cc/images/2023/09/09/337248191b1b0b5a1.png)](https://www.imagehub.cc/image/ruNOYe)
### 【5】创建RAID5阵列
右键"磁盘3"，选择"新建RAID-5卷"
[![1ce652ba66cbcaf4a.png](https://s1.imagehub.cc/images/2023/09/09/1ce652ba66cbcaf4a.png)](https://www.imagehub.cc/image/ruNGlh)
把磁盘4和磁盘5全部添加到右边去
![2d2f096ab7eae06e3.png](https://s1.imagehub.cc/images/2023/09/09/2d2f096ab7eae06e3.png)
分配卷符为"E"
![3029bab6cc3ab076f.png](https://s1.imagehub.cc/images/2023/09/09/3029bab6cc3ab076f.png)
点击"是"
![504412288771d02ec.png](https://s1.imagehub.cc/images/2023/09/09/504412288771d02ec.png)
### 【6】验收环节
RAID5容量计算方式是：单块磁盘容量*（n-1)
4*(3-1)=8GB
![4-1.png](https://s1.imagehub.cc/images/2023/09/09/4-1.png)
![4-2.png](https://s1.imagehub.cc/images/2023/09/09/4-2.png)
## 【3】跨区卷
### 【1】连接hd6 hd7 hd8
![1277e6c6690a7a02f.png](https://s1.imagehub.cc/images/2023/09/09/1277e6c6690a7a02f.png)
### 【2】联机硬盘
![249db98ea6c9373a0.png](https://s1.imagehub.cc/images/2023/09/09/249db98ea6c9373a0.png)
### 【3】初始化硬盘
![36849374b1fc06542.png](https://s1.imagehub.cc/images/2023/09/09/36849374b1fc06542.png)
![40b6d140fe10d9a81.png](https://s1.imagehub.cc/images/2023/09/09/40b6d140fe10d9a81.png)
### 【4】创建跨区卷
![53d814669c996373d.png](https://s1.imagehub.cc/images/2023/09/09/53d814669c996373d.png)
![6355bc00fbbc945f0.png](https://s1.imagehub.cc/images/2023/09/09/6355bc00fbbc945f0.png)
分配盘符"H"
[![74ac8e942312c484b.png](https://s1.imagehub.cc/images/2023/09/09/74ac8e942312c484b.png)](https://www.imagehub.cc/image/ruNYqs)
### 【5】验收环节
![8.png](https://s1.imagehub.cc/images/2023/09/09/8.png)
![9.png](https://s1.imagehub.cc/images/2023/09/09/9.png)
## 【4】共享文件夹
在server1的D盘根目录下创建一个共享文件夹share，只允许本地用户NineBytes具有完全控制权限
### 【1】创建share文件夹
首先去D盘新建一个"share"文件夹
![114514.png](https://s1.imagehub.cc/images/2023/09/09/114514.png)
### 【2】新建NineBytes用户
右键Windows徽标，打开"计算机管理"
![1547e17dfdb6aa5d9.png](https://s1.imagehub.cc/images/2023/09/09/1547e17dfdb6aa5d9.png)
双击打开"本地用户和组"
![22b1c9050c49e8c2a.png](https://s1.imagehub.cc/images/2023/09/09/22b1c9050c49e8c2a.png)
双击打开"用户"文件夹
![36d50ead1add64ef2.png](https://s1.imagehub.cc/images/2023/09/09/36d50ead1add64ef2.png)
右键空白处，单击"新用户"
![4738551a8f9f451ea.png](https://s1.imagehub.cc/images/2023/09/09/4738551a8f9f451ea.png)
输入用户名"NineBytes"和账户密码，点击"创建"
![5b82c78e315e3275a.png](https://s1.imagehub.cc/images/2023/09/09/5b82c78e315e3275a.png)
这样NineBytes用户就创建完成了
![6220d96dc6fa5e6eb.png](https://s1.imagehub.cc/images/2023/09/09/6220d96dc6fa5e6eb.png)
### 【3】安装文件服务器功能
打开服务器管理器-文件和存储服务-卷
点击蓝字"启动添加角色和服务向导"
![7a5dc77b3da258f83.png](https://s1.imagehub.cc/images/2023/09/09/7a5dc77b3da258f83.png)
别问我为什么直接到这儿了，一直点下一步就行，没什么好看的
![8be885736dedf8507.png](https://s1.imagehub.cc/images/2023/09/09/8be885736dedf8507.png)
### 【4】创建共享文件夹
安装好文件服务器之后，点击"共享"
![9b48e95f9e3dc66af.png](https://s1.imagehub.cc/images/2023/09/09/9b48e95f9e3dc66af.png)
点击蓝字，"启动新加共享向导"
![10.png](https://s1.imagehub.cc/images/2023/09/09/10.png)
选择"SMB共享-快速"
![11.png](https://s1.imagehub.cc/images/2023/09/09/11.png)
选择"键入自定义路径"
![12.png](https://s1.imagehub.cc/images/2023/09/09/12.png)
选到D盘下的share文件夹
![13.png](https://s1.imagehub.cc/images/2023/09/09/13.png)
选项缺省
![14.png](https://s1.imagehub.cc/images/2023/09/09/14.png)
点击"自定义权限"
[![15.png](https://s1.imagehub.cc/images/2023/09/09/15.png)](https://www.imagehub.cc/image/rut8Y7)
点击"添加"
![16.png](https://s1.imagehub.cc/images/2023/09/09/16.png)
点击"选择主体"
[![17.png](https://s1.imagehub.cc/images/2023/09/09/17.png)](https://www.imagehub.cc/image/rutUye)
输入用户名NineBytes，然后点击"检查名称"
![18.png](https://s1.imagehub.cc/images/2023/09/09/18.png)
勾选"完全控制"
![19.png](https://s1.imagehub.cc/images/2023/09/09/19.png)
点击"确定"
[![20.png](https://s1.imagehub.cc/images/2023/09/09/20.png)](https://www.imagehub.cc/image/rutL8I)
点击"创建"
[![21.png](https://s1.imagehub.cc/images/2023/09/09/21.png)](https://www.imagehub.cc/image/rutQXh)
创建完成
[![22.png](https://s1.imagehub.cc/images/2023/09/09/22.png)](https://www.imagehub.cc/image/rutuIG)
### 【5】验收环节
server1和server2都配好IP
![1dbb3f932c4febadd.png](https://s1.imagehub.cc/images/2023/09/09/1dbb3f932c4febadd.png)
首先在server1 D盘下右键share文件夹打开属性-共享，再点击"共享"
![575d1ce1c4b1b0f19.png](https://s1.imagehub.cc/images/2023/09/09/575d1ce1c4b1b0f19.png)
选择"Everyone"
![63e90ab07496e9e5e.png](https://s1.imagehub.cc/images/2023/09/09/63e90ab07496e9e5e.png)
![7a27d4f97fce80f0a.png](https://s1.imagehub.cc/images/2023/09/09/7a27d4f97fce80f0a.png)
server2打开运行，输入反斜杠+server1 IP地址
![315138f6276fa8384.png](https://s1.imagehub.cc/images/2023/09/09/315138f6276fa8384.png)
可以访问到了，然后随便创个文件夹验证一下
![4103971f2eb8fede7.png](https://s1.imagehub.cc/images/2023/09/09/4103971f2eb8fede7.png)
[![86454453a79772c2e.png](https://s1.imagehub.cc/images/2023/09/09/86454453a79772c2e.png)](https://www.imagehub.cc/image/ruPgwZ)
然后去server1的D盘share文件夹内看看有没有"ikun"文件夹
![988b67c7f363d9ced.png](https://s1.imagehub.cc/images/2023/09/09/988b67c7f363d9ced.png)
可以看到，server1内有ikun文件夹
## 【5】卷影副本
RAID5盘设置每周周日晚上19:00创建卷影副本，并存储于RAID5卷下，最大值不限
### 【1】启用卷影副本
右键磁盘，选择"配置卷影副本"
![1.png](https://s1.imagehub.cc/images/2023/09/10/1.png)
选中E盘，点击"启用"
![2.png](https://s1.imagehub.cc/images/2023/09/10/2.png)
点击"启用"后会提示是否启用卷影复制，点"是"
![3.png](https://s1.imagehub.cc/images/2023/09/10/3.png)
### 【2】配置卷影副本
选中E盘后点击"设置"
![4.png](https://s1.imagehub.cc/images/2023/09/10/4.png)
最大值改为"没有限制"
![5.png](https://s1.imagehub.cc/images/2023/09/10/5.png)
然后点击"计划"
![6.png](https://s1.imagehub.cc/images/2023/09/10/6.png)
取消勾选周一至周五，勾选周日，开始时间由7点改为19点
蓝框内可以看到卷影计划总结
[![7.png](https://s1.imagehub.cc/images/2023/09/10/7.png)](https://www.imagehub.cc/image/ru7B2A)
点击"高级"
![8-1.png](https://s1.imagehub.cc/images/2023/09/10/8-1.png)
然后就可以更改开始和结束日期了，这里没有要求配置，我就不配置了
[![8-2.png](https://s1.imagehub.cc/images/2023/09/10/8-2.png)](https://www.imagehub.cc/image/ru7tp7)
## 【6】数据重复删除
H盘开启数据重复删除功能，排除<font color=red>.txt和.cf</font>的文件，H盘下"Project"文件夹不进行数据重复删除
### 【1】安装数据重复删除功能
![101008032a661b617.png](https://s1.imagehub.cc/images/2023/09/10/101008032a661b617.png)
![2d97ea4ab962d75de.png](https://s1.imagehub.cc/images/2023/09/10/2d97ea4ab962d75de.png)
### 【2】配置数据重复删除功能
打开文件和存储服务-卷
然后右键H盘，点击"配置重复数据删除"
![379a7f24e2ed41b21.png](https://s1.imagehub.cc/images/2023/09/10/379a7f24e2ed41b21.png)
选择"一般用途文件服务器"
![437670cb5b7351f10.png](https://s1.imagehub.cc/images/2023/09/10/437670cb5b7351f10.png)
默认3天，点击"添加"，添加H盘的Project文件夹
[![5e5c9c66e8ce7537d.png](https://s1.imagehub.cc/images/2023/09/10/5e5c9c66e8ce7537d.png)](https://www.imagehub.cc/image/ruFTLs)
选到"Project"文件夹
![6847991851dd1148a.png](https://s1.imagehub.cc/images/2023/09/10/6847991851dd1148a.png)
这里还可以设置删除计划，没有要求就不配置了
![7b8396b37a9719aa4.png](https://s1.imagehub.cc/images/2023/09/10/7b8396b37a9719aa4.png)
![7-2.png](https://s1.imagehub.cc/images/2023/09/10/7-2.png)
### 【3】验收环节
[![Snipaste_2023-09-10_15-41-31.png](https://s1.imagehub.cc/images/2023/09/10/Snipaste_2023-09-10_15-41-31.png)](https://www.imagehub.cc/image/ruqNV7)

# 【3】FTP服务器🤤
## 【题目要求】
<font color=red>

1. 创建2个实例，server1和server2，server1为主域控制器，完全域名为dc.ninework.com
2. 创建后勤部用户组，组名为中文全拼，组内包括2个用户adm1和adm2
3. server2计算机名为ftp.ninework.com
4. server2安装FTP，创建FTP站点，名称为NineFTP，主目录为C:\FTPRoot。当后勤部用户adm1或adm2登录FTP站点时，只能访问到自己的子文件夹

</font>

## 【1】server1配置 
### 【1】修改网卡配置
![10783762c6fe555d3.png](https://s1.imagehub.cc/images/2023/09/10/10783762c6fe555d3.png)
### 【2】修改计算机名
![29f1c7c3d8cfc47d3.png](https://s1.imagehub.cc/images/2023/09/10/29f1c7c3d8cfc47d3.png)
### 【3】安装基础AD域
![39a02abee387f9307.png](https://s1.imagehub.cc/images/2023/09/10/39a02abee387f9307.png)
### 【4】提升为主域控制器
![43dfc63dd3064d8be.png](https://s1.imagehub.cc/images/2023/09/10/43dfc63dd3064d8be.png)
![11770a755f241b68b.png](https://s1.imagehub.cc/images/2023/09/10/11770a755f241b68b.png)

## 【2】server2配置
### 【1】运行sysprep
![282110bd0e7265c58.png](https://s1.imagehub.cc/images/2023/09/10/282110bd0e7265c58.png)
### 【2】完成新系统配置
![18f23356837c6edef.png](https://s1.imagehub.cc/images/2023/09/10/18f23356837c6edef.png)
### 【3】修改网卡配置
![2351f244ea5fa320b.png](https://s1.imagehub.cc/images/2023/09/10/2351f244ea5fa320b.png)
### 【4】修改计算机名 加入域环境
![3ead20a2193d4dc97.png](https://s1.imagehub.cc/images/2023/09/10/3ead20a2193d4dc97.png)
### 【5】安装WEB服务器及FTP拓展
![4e8d2922b62beec62.png](https://s1.imagehub.cc/images/2023/09/10/4e8d2922b62beec62.png)
### 【6】创建FTPRoot及用户文件夹
![5c161d9b164e89039.png](https://s1.imagehub.cc/images/2023/09/10/5c161d9b164e89039.png)
### 【7】创建adm1 adm2用户
打开"AD用户和计算机"
![19.png](https://s1.imagehub.cc/images/2023/09/10/19.png)
创建后勤部组织单位
![20.png](https://s1.imagehub.cc/images/2023/09/10/20.png)
创建好adm1和adm2用户后添加进houqinbu组织单位内
创建好组织单位后，可以直接创建用户，就不用创建组了，你想创就创
![23.png](https://s1.imagehub.cc/images/2023/09/10/23.png)
### 【8】创建FTP站点
服务器管理器-工具-IIS管理器
![66f52f8c23846c39e.png](https://s1.imagehub.cc/images/2023/09/10/66f52f8c23846c39e.png)
右键"FTP",点击"添加FTP站点"
![779a04f540f9ef4f5.png](https://s1.imagehub.cc/images/2023/09/10/779a04f540f9ef4f5.png)
站点名称填写"NineFTP"，物理路径指向C盘下的FTPRoot文件夹
![8.png](https://s1.imagehub.cc/images/2023/09/10/8.png)
IP地址指向自己，端口默认21，SSL选到"无SSL"
![9.png](https://s1.imagehub.cc/images/2023/09/10/9.png)
身份验证勾选"匿名"和"基本"
授权选择"所有用户"
权限选择"R"和"W"
![10.png](https://s1.imagehub.cc/images/2023/09/10/10.png)
点击"完成"后，FTP站点就创建完成了
![11.png](https://s1.imagehub.cc/images/2023/09/10/11.png)

### 【9】配置FTP用户隔离
双击打开"FTP用户隔离"
![12.png](https://s1.imagehub.cc/images/2023/09/10/12.png)
选择"在AD中配置的FTP主目录"
![13.png](https://s1.imagehub.cc/images/2023/09/10/13.png)
输入server1的用户名及密码
![14-2.png](https://s1.imagehub.cc/images/2023/09/10/14-2.png)
可以打开server1的Windows设置，点击"账户"(Win+I键)
![1325b26d7666c3571.png](https://s1.imagehub.cc/images/2023/09/11/1325b26d7666c3571.png)
可以看到server1的账户名称是NINEWORK\ADMINISTRATOR
![2320f9b321fae36e6.png](https://s1.imagehub.cc/images/2023/09/11/2320f9b321fae36e6.png)
点击"应用"
![15-2.png](https://s1.imagehub.cc/images/2023/09/10/15-2.png)
## 【3】为adm1 adm2用户配置ADSI属性
回到server1中，服务器管理器-工具-ADSI编辑器
![16.png](https://s1.imagehub.cc/images/2023/09/10/16.png)
工具栏内点击"操作"-"连接到..."
![17.png](https://s1.imagehub.cc/images/2023/09/10/17.png)
这一步什么也不用动，直接点击"确定"即可
![18.png](https://s1.imagehub.cc/images/2023/09/10/18.png)

### <font color=red>特别说明(! 必看 !)</font>

1. 由于版本不一，我现在是用的是<font color=red>Windows Server 2022版本</font>，2022版本需要修改的用户属性值存在于"hostname=Domain,hostname=com"文件夹下，换到现在的环境下就是<font color=red>"DC=ninework,DC=com"文件夹内</font>
2. 但是<font color=DeepSkyBlue>Windows Server 2019版本</font>需要修改的用户值却存在于<font color=DeepSkyBlue>CN=Users文件夹内</font>

**一开始我还没看出来，我以为我没创建好用户，所以又创建了个技术部，但其实是我没有看到后勤部在"DC=ninework,DC=com"文件夹里**
**<font color=red> 我只能说"So Windows F``k You !"</font>**
![24.png](https://s1.imagehub.cc/images/2023/09/10/24.png)
右键adm1文件夹，点击"属性"
![Snipaste_2023-09-10_20-36-56.png](https://s1.imagehub.cc/images/2023/09/10/Snipaste_2023-09-10_20-36-56.png)
找到"msIIS-FTPDir",填写adm1用户名，也就是adm1
![25.png](https://s1.imagehub.cc/images/2023/09/10/25.png)
![26.png](https://s1.imagehub.cc/images/2023/09/10/26.png)
msIIS-FTPRoot属性填写FTP主目录路径，不会写就去CV
![27.png](https://s1.imagehub.cc/images/2023/09/10/27.png)
做好了之后就是这样子的
![28.png](https://s1.imagehub.cc/images/2023/09/10/28.png)
adm2用户也是同样的步骤，就不重复写了
## 【4】验收环节
adm1和adm2用户都是使用server1虚拟机登录验证的，不是使用FTP服务器登录的
### 【1】登录adm1用户
在资源管理器内输入FTP地址"ftp://10.10.10.12"
![10f1eb487c1f24200.png](https://s1.imagehub.cc/images/2023/09/10/10f1eb487c1f24200.png)
输入adm1用户名及密码(PASWD=Qwer1234)
![27829ff0a05a4f0e5.png](https://s1.imagehub.cc/images/2023/09/10/27829ff0a05a4f0e5.png)
创建一个文件夹用于验证
![31f3ca1b9f9249cc1.png](https://s1.imagehub.cc/images/2023/09/10/31f3ca1b9f9249cc1.png)
### 【2】登录adm2用户
登录至adm2用户
![4354ea1ede1f07082.png](https://s1.imagehub.cc/images/2023/09/10/4354ea1ede1f07082.png)
创建文件夹用于验证
![52d20a86954910c1b.png](https://s1.imagehub.cc/images/2023/09/10/52d20a86954910c1b.png)
### 【3】server2资源管理器验证
adm1文件夹和adm2文件夹内都可以看见我们刚才创建的文件夹，证明FTP服务器成功
![634440897e018e863.png](https://s1.imagehub.cc/images/2023/09/10/634440897e018e863.png)
### 【4】额外说明
如果server1登录FTP服务器时显示无法登录，请依次检查一下问题：
![q1.png](https://s1.imagehub.cc/images/2023/09/10/q1.png)
1. server1 DNS是否回环？ ~~so windows f ``k you~~
![q2.png](https://s1.imagehub.cc/images/2023/09/10/q2.png)
1. server1 和server2 是否能ping通？
2. 关闭server1及server2全部防火墙

# 【4】DFS分布式文件共享🤔
## 【题目要求】
**为server1和server2配置DFS，空间名称为DFSROOT，文件夹为dfsroot，复制组为DFS-BACKUP，采用交错拓扑。设置周六周日带宽完整，周一至周五带宽为128M**
## 【1】server1前期配置
### 【1】更改计算机名
![Snipaste_2023-09-11_19-51-11.png](https://s1.imagehub.cc/images/2023/09/11/Snipaste_2023-09-11_19-51-11.png)
### 【2】修改网卡配置
![Snipaste_2023-09-11_19-51-37.png](https://s1.imagehub.cc/images/2023/09/11/Snipaste_2023-09-11_19-51-37.png)
### 【3】安装基础AD域服务
![13e01e1266c27928c.png](https://s1.imagehub.cc/images/2023/09/11/13e01e1266c27928c.png)
### 【4】提升为域控制器
添加新林，输入根域名
![2fbaa07dd15e4c7e9.png](https://s1.imagehub.cc/images/2023/09/11/2fbaa07dd15e4c7e9.png)

## 【2】server2前期配置
### 【1】运行sysprep程序
![Snipaste_2023-09-11_19-52-04.png](https://s1.imagehub.cc/images/2023/09/11/Snipaste_2023-09-11_19-52-04.png)
### 【2】完成新系统配置
![28e9b8025745f8b1f.png](https://s1.imagehub.cc/images/2023/09/11/28e9b8025745f8b1f.png)
### 【3】修改网卡配置
![Snipaste_2023-09-11_20-34-58.png](https://s1.imagehub.cc/images/2023/09/11/Snipaste_2023-09-11_20-34-58.png)
### 【4】更改计算机名并加入域环境
![31f16800fe72bf5da.png](https://s1.imagehub.cc/images/2023/09/11/31f16800fe72bf5da.png)
## 【3】ser1安装DFS
勾选"DFS复制"和"DFS命名空间"，"文件服务器"会捆绑安装，无法取消安装
![18a2ec022971748c7.png](https://s1.imagehub.cc/images/2023/09/11/18a2ec022971748c7.png)

## 【4】ser2安装DFS
![8.png](https://s1.imagehub.cc/images/2023/09/11/8.png)
## 【5】创建DFS根目录
server1和server2在C盘下创建dfsroot文件夹
![9.png](https://s1.imagehub.cc/images/2023/09/11/9.png)
## 【6】ser1配置DFS
打开DFS Management
![11157d722e37b8b1f5.png](https://s1.imagehub.cc/images/2023/09/11/11157d722e37b8b1f5.png)
### 【1】新建复制组
点击"新建复制组"
![12.png](https://s1.imagehub.cc/images/2023/09/11/12.png)
选择"多用途复制组"
![13.png](https://s1.imagehub.cc/images/2023/09/11/13.png)
填写复制组名称
![15.png](https://s1.imagehub.cc/images/2023/09/11/15.png)
选择复制组成员
![16.png](https://s1.imagehub.cc/images/2023/09/11/16.png)
![17.png](https://s1.imagehub.cc/images/2023/09/11/17.png)
等待检查完成
![18.png](https://s1.imagehub.cc/images/2023/09/11/18.png)
选择交错拓扑
![20.png](https://s1.imagehub.cc/images/2023/09/11/20.png)
选择"在指定日期和时间复制"，然后点击"编辑计划"
![21.png](https://s1.imagehub.cc/images/2023/09/11/21.png)
长按拖动选择周一至周五的全部时间段
![22.png](https://s1.imagehub.cc/images/2023/09/11/22.png)
带宽使用率选择"128Mbps"
![23.png](https://s1.imagehub.cc/images/2023/09/11/23.png)
然后拖动选择周六至周日的全部时间段
![24.png](https://s1.imagehub.cc/images/2023/09/11/24.png)
带宽使用率选择"完整"
![25.png](https://s1.imagehub.cc/images/2023/09/11/25.png)
全部设置好后点击"确定"
![26.png](https://s1.imagehub.cc/images/2023/09/11/26.png)
主要成员选择server1
![27.png](https://s1.imagehub.cc/images/2023/09/11/27.png)
要复制的文件夹选择C盘下的dfsroot
![28.png](https://s1.imagehub.cc/images/2023/09/11/28.png)
选中server2后点击"编辑"
![29.png](https://s1.imagehub.cc/images/2023/09/11/29.png)
身份状态由"已禁用"改为"已启用"
然后选择到server2 C盘下的dfsroot文件夹
![30.png](https://s1.imagehub.cc/images/2023/09/11/30.png)
然后一直点击"下一步"，再点击"创建"即可
![32.png](https://s1.imagehub.cc/images/2023/09/11/32.png)

### 【2】新建命名空间
点击右侧的"新建命名空间"
![33.png](https://s1.imagehub.cc/images/2023/09/11/33.png)
空间命名服务器选择到server1
![34.png](https://s1.imagehub.cc/images/2023/09/11/34.png)
命名空间名称填写DFSROOT
![35.png](https://s1.imagehub.cc/images/2023/09/11/35.png)
一直点"下一步"，然后创建命名空间即可
![36.png](https://s1.imagehub.cc/images/2023/09/11/36.png)
## 【7】验收环节
在server1 C盘的dfsroot文件夹下创建个文件，随便写点内容
当然，你创建文件夹验证也是可以的
![37.png](https://s1.imagehub.cc/images/2023/09/11/37.png)
打开server2的C:\dfsroot文件夹也可以看到刚刚同步过来的文本文档
同步是需要时间的，不是立即响应的，如果你没有做错的话，等上2-3mins就能同步过来了
![38.png](https://s1.imagehub.cc/images/2023/09/11/38.png)
# 【5】故障转移群集😋
## 【题目要求】
1. 创建server1及server2，全部安装故障转移群集、文件服务器、存储多路径等功能
2. 在server1上添加对iSCSI设备的支持，并新建iSCSI虚拟磁盘，存储位置为C:\；虚拟磁盘名称为Quorum和Files，大小分别为512MB和2GB，访问服务器为server1及server2
3. 在server2上使用iSCSI发起程序连接server1的iSCSI虚拟磁盘Quorum和Files，实现对iSCSI虚拟磁盘Quorum和Files的存储多路径功能，并对Quorum和Files进行初始化和创建卷，设置驱动器号分别为P和R，完成格式化操作
4. 在server2故障转移群集中，添加server1和serevr2服务器，并生成故障转移群集验证报告结果，创建故障转移群集，群集名称为FileoverRoot，IP网段为vlan10网段，地址为66
## 【1】server1前期配置
### 【1】修改计算机名
更改计算机名为server1
![1a9b29b005aa1dc04.png](https://s1.imagehub.cc/images/2023/09/14/1a9b29b005aa1dc04.png)
![2.png](https://s1.imagehub.cc/images/2023/09/14/2.png)
### 【2】修改网卡配置
![3.png](https://s1.imagehub.cc/images/2023/09/14/3.png)
### 【3】安装基础AD域环境
![4.png](https://s1.imagehub.cc/images/2023/09/14/4.png)
### 【4】提升为域控制器
![5.png](https://s1.imagehub.cc/images/2023/09/14/5.png)
![6.png](https://s1.imagehub.cc/images/2023/09/14/6.png)
## 【2】server2前期配置
### 【1】运行sysprep程序
一定要勾选"通用"，否则SID号无法重置
![7.png](https://s1.imagehub.cc/images/2023/09/14/7.png)
### 【2】完成新系统配置
![7c2b0a38b424ab488.png](https://s1.imagehub.cc/images/2023/09/14/7c2b0a38b424ab488.png)
### 【3】修改网卡配置
![8.png](https://s1.imagehub.cc/images/2023/09/14/8.png)
### 【4】更改计算机名并加入域环境
![9.png](https://s1.imagehub.cc/images/2023/09/14/9.png)
## 【3】ser1 ser2安装故障转移群集
### 【1】server1安装故障转移群集
在"服务器角色"中勾选"文件服务器资源管理器"
![10.png](https://s1.imagehub.cc/images/2023/09/14/10.png)
在"功能"中勾选"多路径I/O"以及"故障转移群集"
![11.png](https://s1.imagehub.cc/images/2023/09/14/11.png)
![12.png](https://s1.imagehub.cc/images/2023/09/14/12.png)
### 【2】server2安装故障转移群集
server2也是安装和server1同样的角色及功能
![13.png](https://s1.imagehub.cc/images/2023/09/14/13.png)
## 【4】添加对iSCSI设备的支持
打开"工具"-"MPIO"
![14.png](https://s1.imagehub.cc/images/2023/09/14/14.png)
在"发现多路径"选项卡中，勾选"添加对iSCSI设备的支持"复选框
![15.png](https://s1.imagehub.cc/images/2023/09/14/15.png)
![16.png](https://s1.imagehub.cc/images/2023/09/14/16.png)
操作成功后，该选项会变成灰色
![17.png](https://s1.imagehub.cc/images/2023/09/14/17.png)
## 【5】新建iSCSI虚拟磁盘
### 【1】安装iSCSI目标服务器
首先打开文件和存储服务-iSCSI，然后点击蓝字，安装iSCSI目标服务器
![18png.png](https://s1.imagehub.cc/images/2023/09/14/18png.png)
还要勾选上"iSCSI目标存储提供程序(VDS和VSS硬件提供程序)"
![19.png](https://s1.imagehub.cc/images/2023/09/14/19.png)
完成重启
![20.png](https://s1.imagehub.cc/images/2023/09/14/20.png)
### 【2】创建iSCSI虚拟磁盘
#### 【1】创建Quorum虚拟磁盘
点击蓝字，创建iSCSI虚拟磁盘
![21.png](https://s1.imagehub.cc/images/2023/09/14/21.png)
首先点击C盘
![22.png](https://s1.imagehub.cc/images/2023/09/14/22.png)
填写虚拟磁盘名称
![23.png](https://s1.imagehub.cc/images/2023/09/14/23.png)
选择虚拟磁盘大小及类型，虚拟磁盘类型按需选择
![24.png](https://s1.imagehub.cc/images/2023/09/14/24.png)
![25.png](https://s1.imagehub.cc/images/2023/09/14/25.png)
再次填写虚拟磁盘名称
![26.png](https://s1.imagehub.cc/images/2023/09/14/26.png)
点击"添加"，添加server1目标服务器
![27.png](https://s1.imagehub.cc/images/2023/09/14/27.png)
类型选择"IP地址"
![28.png](https://s1.imagehub.cc/images/2023/09/14/28.png)
填写server1 IP地址
![29.png](https://s1.imagehub.cc/images/2023/09/14/29.png)
填写server2 IP地址
![30.png](https://s1.imagehub.cc/images/2023/09/14/30.png)
![31.png](https://s1.imagehub.cc/images/2023/09/14/31.png)
点击"创建"即可
![32.png](https://s1.imagehub.cc/images/2023/09/14/32.png)
![33.png](https://s1.imagehub.cc/images/2023/09/14/33.png)
#### 【2】创建Files虚拟磁盘
![34.png](https://s1.imagehub.cc/images/2023/09/14/34.png)
![35.png](https://s1.imagehub.cc/images/2023/09/14/35.png)
大小选择2GB，虚拟磁盘类型选择"动态拓展"，当然你也可以选别的
![36.png](https://s1.imagehub.cc/images/2023/09/14/36.png)
选择"新建iSCSI目标"
![37.png](https://s1.imagehub.cc/images/2023/09/14/37.png)
![38.png](https://s1.imagehub.cc/images/2023/09/14/38.png)
添加2台服务器的IP地址
![39.png](https://s1.imagehub.cc/images/2023/09/14/39.png)
确认无误后，点击"创建"即可
![40.png](https://s1.imagehub.cc/images/2023/09/14/40.png)
![41.png](https://s1.imagehub.cc/images/2023/09/14/41.png)
这样，2个iSCSI虚拟磁盘就创建好了
![42.png](https://s1.imagehub.cc/images/2023/09/14/42.png)
## 【6】连接iSCSI虚拟磁盘
### 【1】连接虚拟磁盘
server2中打开"工具"-"iSCSI发起程序"
![43.png](https://s1.imagehub.cc/images/2023/09/14/43.png)
点击"是"
![44.png](https://s1.imagehub.cc/images/2023/09/14/44.png)
在"目标"中输入server1 IP地址，然后点击"快速连接"
![45.png](https://s1.imagehub.cc/images/2023/09/14/45.png)
先单击选中第一块磁盘，然后点击"连接"
![46.png](https://s1.imagehub.cc/images/2023/09/14/46.png)
会显示"已连接"和"登录成功"
![47.png](https://s1.imagehub.cc/images/2023/09/14/47.png)
第2块虚拟磁盘也是同理
![48.png](https://s1.imagehub.cc/images/2023/09/14/48.png)
最后点击"完成即可"
### 【2】初始化虚拟磁盘
然后初始化磁盘
右键Windows徽标，选择"磁盘管理"
![49.png](https://s1.imagehub.cc/images/2023/09/14/49.png)
把两块磁盘联机
![50.png](https://s1.imagehub.cc/images/2023/09/14/50.png)
初始化两块磁盘
![51.png](https://s1.imagehub.cc/images/2023/09/14/51.png)
Quorum虚拟磁盘新建简单卷
![52.png](https://s1.imagehub.cc/images/2023/09/14/52.png)
Quorum虚拟磁盘驱动器号选择"P"
![53.png](https://s1.imagehub.cc/images/2023/09/14/53.png)
Files虚拟磁盘新建简单卷
![54.png](https://s1.imagehub.cc/images/2023/09/14/54.png)
磁盘驱动器号选择"R"
![55.png](https://s1.imagehub.cc/images/2023/09/14/55.png)
在资源管理器内可以看到我们刚才新建的2块磁盘
![56.png](https://s1.imagehub.cc/images/2023/09/14/56.png)

## 【7】创建故障转移群集
打开"服务器管理器"-"工具"-"故障转移群集管理器"
![57.png](https://s1.imagehub.cc/images/2023/09/14/57.png)
点击右侧，"创建群集"
![58.png](https://s1.imagehub.cc/images/2023/09/14/58.png)
![59.png](https://s1.imagehub.cc/images/2023/09/14/59.png)
点击"浏览"，先添加server1
![60.png](https://s1.imagehub.cc/images/2023/09/14/60.png)
输入server1的计算机名后，点击"检查"
![61.png](https://s1.imagehub.cc/images/2023/09/14/61.png)
输入server1账户名和密码
![62.png](https://s1.imagehub.cc/images/2023/09/14/62.png)
点击"确定"添加server1进群集
![63.png](https://s1.imagehub.cc/images/2023/09/14/63.png)
再次点击"浏览"，添加server2进群集内
![64.png](https://s1.imagehub.cc/images/2023/09/14/64.png)
输入server2计算机名，点击"检查"
![65.png](https://s1.imagehub.cc/images/2023/09/14/65.png)
添加server2时，就不用提供凭据了
![66.png](https://s1.imagehub.cc/images/2023/09/14/66.png)
可以看到我们刚才添加的2台服务器然后点击下一步
![67.png](https://s1.imagehub.cc/images/2023/09/14/67.png)
我这里选"否"了
![68.png](https://s1.imagehub.cc/images/2023/09/14/68.png)
群集名称填写"FileoverRoot"，地址填写"10.10.10.66"
![69.png](https://s1.imagehub.cc/images/2023/09/14/69.png)
确认之后点击"下一步"
![70.png](https://s1.imagehub.cc/images/2023/09/14/70.png)
等待群集创建完成
![71.png](https://s1.imagehub.cc/images/2023/09/14/71.png)
创建完成后，点击"查看报告"，可以看到创建好的报告
![72.png](https://s1.imagehub.cc/images/2023/09/14/72.png)
![73.png](https://s1.imagehub.cc/images/2023/09/14/73.png)

# 【6】Web服务器🥰
## 【题目要求】
1. 创建实例server1，升级为主域控制器，完全域名为server1.ninework.com，添加DNS记录，www.ninework.com指向server2，同时安装证书服务，设置为企业根，有效期5年，为企业内部自动回复证书申请
2. 创建server2实例，加入www.ninework.com域，合法域名为web.ninework.com
3. 安装IIS，创建www.ninework.com站点，在C:\My Project文件夹内创建web.html主页，主页内容为"我是ikun"，同时只允许SSL访问
4. 设置网站最大连接数为1500，网页超时数为120s，带宽为4096kb/s，将截图保存为WR913-1
5. 使用W3C记录日志，每天创建一个新的日志文件，使用当时时间为日志文件名；日志记录日期、时间、客户端IP、用户名、服务器IP地址、服务器端口号和方法

## 【1】server1前期配置
### 【1】修改计算机名
![112045ee9a136ed60.png](https://s1.imagehub.cc/images/2023/09/14/112045ee9a136ed60.png)
### 【2】修改网卡配置
![21eedae78a70535e9.png](https://s1.imagehub.cc/images/2023/09/14/21eedae78a70535e9.png)
### 【3】安装基础AD域
![36ad60ae814422f12.png](https://s1.imagehub.cc/images/2023/09/14/36ad60ae814422f12.png)
### 【4】提升为域控制器
![412a04972fb8e0ea1.png](https://s1.imagehub.cc/images/2023/09/14/412a04972fb8e0ea1.png)
![52863f7f50c4faf00.png](https://s1.imagehub.cc/images/2023/09/14/52863f7f50c4faf00.png)
## 【2】server2前期配置
### 【1】运行sysprep程序
![6e02c4f7c41ed8353.png](https://s1.imagehub.cc/images/2023/09/14/6e02c4f7c41ed8353.png)
### 【2】完成新系统配置
![7c2b0a38b424ab488.png](https://s1.imagehub.cc/images/2023/09/14/7c2b0a38b424ab488.png)
### 【3】修改网卡配置
![89fd0ba8518deaced.png](https://s1.imagehub.cc/images/2023/09/14/89fd0ba8518deaced.png)
### 【4】更改计算机名并加入域环境
![96a8a80684ecdbe30.png](https://s1.imagehub.cc/images/2023/09/14/96a8a80684ecdbe30.png)
## 【3】创建DNS正向查找记录
打开"服务器管理器"-"工具"-"DNS"
![107c7d97911d8f1f0b.png](https://s1.imagehub.cc/images/2023/09/14/107c7d97911d8f1f0b.png)
展开server1主机-正向查找区域-ninework.com
右键空白处，选择"新建主机"
![119558d6627b0588cb.png](https://s1.imagehub.cc/images/2023/09/14/119558d6627b0588cb.png)
名称输入"www"，IP地址指向server2
![122951dc18e8b4bc75.png](https://s1.imagehub.cc/images/2023/09/14/122951dc18e8b4bc75.png)
## 【4】安装AD证书服务
勾选"AD证书服务"
![132e63824bd02b6817.png](https://s1.imagehub.cc/images/2023/09/14/132e63824bd02b6817.png)
在"角色服务"中，勾选"证书颁发机构"、"联机响应程序"、"证书颁发机构Web注册"
![14704aaf0fe5c37082.png](https://s1.imagehub.cc/images/2023/09/14/14704aaf0fe5c37082.png)
![159294b68868697a63.png](https://s1.imagehub.cc/images/2023/09/14/159294b68868697a63.png)
## 【5】配置AD证书服务
点击蓝字"配置目标服务器上的AD证书服务"
![160bb339455d88f72b.png](https://s1.imagehub.cc/images/2023/09/14/160bb339455d88f72b.png)
单击"下一步"
![1703df55307a3454a2.png](https://s1.imagehub.cc/images/2023/09/14/1703df55307a3454a2.png)
勾选这3项服务
![18.png](https://s1.imagehub.cc/images/2023/09/14/18.png)
CA类型为"企业"
![190edde6ae618735bb.png](https://s1.imagehub.cc/images/2023/09/14/190edde6ae618735bb.png)
设置为根"
![204f9c10ce21eeac65.png](https://s1.imagehub.cc/images/2023/09/14/204f9c10ce21eeac65.png)
选择"创建新的私钥"
![2135f87593be497f08.png](https://s1.imagehub.cc/images/2023/09/14/2135f87593be497f08.png)
默认选项
![2293b248b8fa3ad4db.png](https://s1.imagehub.cc/images/2023/09/14/2293b248b8fa3ad4db.png)
名称默认
![2350df1da3ba311421.png](https://s1.imagehub.cc/images/2023/09/14/2350df1da3ba311421.png)
有效期设置为5年
![24228b98e1fac4d06a.png](https://s1.imagehub.cc/images/2023/09/14/24228b98e1fac4d06a.png)
默认位置
![25cb6ded014e48b7f7.png](https://s1.imagehub.cc/images/2023/09/14/25cb6ded014e48b7f7.png)
确认是否无误
![2674b81a2f818a4262.png](https://s1.imagehub.cc/images/2023/09/14/2674b81a2f818a4262.png)
配置成功后会出现3个小绿勾
![2791973b630fcad7ba.png](https://s1.imagehub.cc/images/2023/09/14/2791973b630fcad7ba.png)

## 【6】创建站点主页
在C盘下创建"My Project"文件夹，并在文件夹内创建"Web.html"站点主页文件，在web.html内写入"我是ikun"
![30086a5a21b8178a0c.png](https://s1.imagehub.cc/images/2023/09/14/30086a5a21b8178a0c.png)
## 【7】安装Web服务器
勾选"Web服务器(IIS)"
![2891ebd541b95e9354.png](https://s1.imagehub.cc/images/2023/09/14/2891ebd541b95e9354.png)
![29decf75be9cb1d36d.png](https://s1.imagehub.cc/images/2023/09/14/29decf75be9cb1d36d.png)
## 【8】配置Web服务器
### 【1】检查DNS指向
在配置web之前，检查server2 DNS是否依然指向server1
![31b220436252b50c7b.png](https://s1.imagehub.cc/images/2023/09/14/31b220436252b50c7b.png)
### 【2】停止系统自带站点
检查无误后，打开"服务器管理器"-"工具"-"IIS管理器"
![322df7b7cc30238adc.png](https://s1.imagehub.cc/images/2023/09/14/322df7b7cc30238adc.png)
为了防止自带网站干扰我们的站点，先停止"Default Web Site"站点
选中"Default Web Site"站点后，点击右侧的"停止"
![3367d643a96f7b38f0.png](https://s1.imagehub.cc/images/2023/09/14/3367d643a96f7b38f0.png)
### 【3】添加站点
右击"网站"，选择"添加网站"
![342afd005cb63bfbfd.png](https://s1.imagehub.cc/images/2023/09/14/342afd005cb63bfbfd.png)
网站名称填写我们的域名，物理路径指向C盘的My Project文件夹，类型选择http，IP地址指向本机server1，主机名同样填写域名
![354e4d57df846b2dfa.png](https://s1.imagehub.cc/images/2023/09/14/354e4d57df846b2dfa.png)
打开我们的站点主页，双击"默认文档"
![3644acbd798214a85c.png](https://s1.imagehub.cc/images/2023/09/14/3644acbd798214a85c.png)
点击右侧蓝字"添加"
![3776f6c75b28ee4333.png](https://s1.imagehub.cc/images/2023/09/14/3776f6c75b28ee4333.png)
填写站点主页文件名"web.html"
![3850b71d3112f94a3e.png](https://s1.imagehub.cc/images/2023/09/14/3850b71d3112f94a3e.png)
点击"确定"之后就可以看到我们刚才添加的本地站点主页文件了
![39aeea9550fde81066.png](https://s1.imagehub.cc/images/2023/09/14/39aeea9550fde81066.png)
### 【4】验收环节
然后打开浏览器,在地址栏内输入"www.ninework.com"，就可以看到我们的站点了
~~不知道为什么乱码了~~
![400969db99d29c6d42.png](https://s1.imagehub.cc/images/2023/09/14/400969db99d29c6d42.png)
## 【9】配置https访问
题目要求的是使用https访问，不允许使用http协议，现在开始配置SSL证书
### 【1】创建域证书
首先选到SERVER2，双击打开"服务器证书"
![412e700bc41bcb3624.png](https://s1.imagehub.cc/images/2023/09/14/412e700bc41bcb3624.png)
然后点击右侧的"创建域证书"
![4260c20032c59b7ef6.png](https://s1.imagehub.cc/images/2023/09/14/4260c20032c59b7ef6.png)
通用名称填写完整域名，其他的看自己心情写吧
![432af142251471e29b.png](https://s1.imagehub.cc/images/2023/09/14/432af142251471e29b.png)
点击右侧的"选择"，选择本机上的证书颁发机构
![44cfec0b07240e7fcc.png](https://s1.imagehub.cc/images/2023/09/14/44cfec0b07240e7fcc.png)
![455f1189b20d9e254d.png](https://s1.imagehub.cc/images/2023/09/14/455f1189b20d9e254d.png)
然后随便写个好记名称
![46fc8ef9f8e7ceba1c.png](https://s1.imagehub.cc/images/2023/09/14/46fc8ef9f8e7ceba1c.png)
这时候又报错了
![4706af152838b07d6b.png](https://s1.imagehub.cc/images/2023/09/14/4706af152838b07d6b.png)
server2通server1，server1不通server2，很显然，是DNS或者防火墙
![4832b538d16fcf35ac.png](https://s1.imagehub.cc/images/2023/09/14/4832b538d16fcf35ac.png)
<font color=red> So Windows F``k You! </font>

![4985ed2fd28763445c.png](https://s1.imagehub.cc/images/2023/09/14/4985ed2fd28763445c.png)
然后再关闭两台实例的防火墙，软重启server2后，就可以正常创建域证书了
![503fb94d22213d1eb8.png](https://s1.imagehub.cc/images/2023/09/14/503fb94d22213d1eb8.png)
![51301264d4fb67e442.png](https://s1.imagehub.cc/images/2023/09/14/51301264d4fb67e442.png)

### 【2】站点绑定https
然后回到我们的站点，点击右侧的"绑定"
![52e0f0f2ff0b3dfc48.png](https://s1.imagehub.cc/images/2023/09/14/52e0f0f2ff0b3dfc48.png)
再次点击右侧的"添加"
![537e9a3f479c68792b.png](https://s1.imagehub.cc/images/2023/09/14/537e9a3f479c68792b.png)
类型选择"https"
![548b58fa5128c839ff.png](https://s1.imagehub.cc/images/2023/09/14/548b58fa5128c839ff.png)
IP地址指向本机
![55a472b25ed5b2f1dc.png](https://s1.imagehub.cc/images/2023/09/14/55a472b25ed5b2f1dc.png)
主机名填写域名，SSL证书选择我们刚才创建的域证书
![56186f31dfad17485d.png](https://s1.imagehub.cc/images/2023/09/14/56186f31dfad17485d.png)
点击"确定"即可
![57140aeeef28624737.png](https://s1.imagehub.cc/images/2023/09/14/57140aeeef28624737.png)
然后把http删除
![58274ad0ccd6b0e34d.png](https://s1.imagehub.cc/images/2023/09/14/58274ad0ccd6b0e34d.png)
![59f09132be14e02e30.png](https://s1.imagehub.cc/images/2023/09/14/59f09132be14e02e30.png)
### 【3】站点SSL设置
然后点击"SSL设置"
![605acda806315d9735.png](https://s1.imagehub.cc/images/2023/09/14/605acda806315d9735.png)
勾选"要求SSL"和"接受"
![6132cf61333b1070ef.png](https://s1.imagehub.cc/images/2023/09/14/6132cf61333b1070ef.png)
这时候先不要退出，点击右侧的"应用"后再退出！！！
![6237ea8914e5b9247c.png](https://s1.imagehub.cc/images/2023/09/14/6237ea8914e5b9247c.png)
![63c2b79af351a2a897.png](https://s1.imagehub.cc/images/2023/09/14/63c2b79af351a2a897.png)
### 【4】验收环节
在浏览器内输入`https://www.ninework.com/`验证是否配置https成功
由于这个https证书是我们自己为自己颁发的，Edge浏览器并不承认这种行为，全世界就那么几家正经的CA机构，Edge只承认他们的证书，所以就会拦截我们自己给自己颁发证书的网站
![641020ba4642425ad8.png](https://s1.imagehub.cc/images/2023/09/14/641020ba4642425ad8.png)
用IE浏览器验证就好了
![6528551084040fc5e1.png](https://s1.imagehub.cc/images/2023/09/14/6528551084040fc5e1.png)
![669fa1d0181252c038.png](https://s1.imagehub.cc/images/2023/09/14/669fa1d0181252c038.png)

## 【10】设置站点限制规则
双击打开右侧的"限制"
![6766dbdf1498aa46bc.png](https://s1.imagehub.cc/images/2023/09/14/6766dbdf1498aa46bc.png)
限制带宽使用填写"4196304"，4096KB=4096*1024=4196304B
连接超时秒数填写"120"
连接限制数填写"1500"
![681aee6f456a89ff1f.png](https://s1.imagehub.cc/images/2023/09/14/681aee6f456a89ff1f.png)

## 【11】站点日志设置
在站点主页内双击打开"日志"
![69ba50089dacd22aff.png](https://s1.imagehub.cc/images/2023/09/14/69ba50089dacd22aff.png)
日志格式默认就是W3C，点击"选择字段"，选择日志记录字段，勾选题目要求的日志字段即可，没要求的就取消打勾
![700feff26401d7c6cc.png](https://s1.imagehub.cc/images/2023/09/14/700feff26401d7c6cc.png)
计划选择"每天"
勾选"使用本地时间进行文件命名和滚动更新"
![71b9e00d32d3d1b306.png](https://s1.imagehub.cc/images/2023/09/14/71b9e00d32d3d1b306.png)

# 【7】DNS服务器🙃
## 【题目要求】
1. server1升级为主域控制器，完全域名为server1.ninework.com，配置DNS服务，创建ftp、web、dns主机记录，均指向server2。关闭网络掩码功能，设置DNS服务正向、反向区域与活动目录集成，启用AD回收站功能
2. 创建server2，安装DNS服务，将server2配置为network.com的辅助DNS服务器

## 【1】server1前期配置
### 【1】修改计算机名
![1e3cd82e5e1ff8316.png](https://s1.imagehub.cc/images/2023/09/26/1e3cd82e5e1ff8316.png)
### 【2】修改网卡配置
![29851bcf3e4235dfa.png](https://s1.imagehub.cc/images/2023/09/26/29851bcf3e4235dfa.png)
### 【3】安装基础AD域
![3cd616818370a3306.png](https://s1.imagehub.cc/images/2023/09/26/3cd616818370a3306.png)
### 【4】提升为域控制器
![58eed0b9382220973.png](https://s1.imagehub.cc/images/2023/09/26/58eed0b9382220973.png)

## 【2】server2前期配置
### 【1】运行sysprep程序
![4f261a2bddc6ff40c.png](https://s1.imagehub.cc/images/2023/09/26/4f261a2bddc6ff40c.png)
### 【2】完成新系统配置
![6df86dbd9bacfa68d.png](https://s1.imagehub.cc/images/2023/09/26/6df86dbd9bacfa68d.png)
### 【3】修改网卡配置
![7.png](https://s1.imagehub.cc/images/2023/09/26/7.png)
### 【4】更改计算机名并加入域环境
![9.png](https://s1.imagehub.cc/images/2023/09/26/9.png)

## 【3】serer1 主要DNS配置
### 【1】创建DNS反向查找区域
打开"服务器管理器"-"工具"-"DNS"
![8.png](https://s1.imagehub.cc/images/2023/09/26/8.png)
右键"反向查找区域"，点击"新建区域"
![10.png](https://s1.imagehub.cc/images/2023/09/26/10.png)
选择"主要区域"
![11.png](https://s1.imagehub.cc/images/2023/09/26/11.png)
选择"至此域中域控制器上运行的所有DNS服务器"
![12.png](https://s1.imagehub.cc/images/2023/09/26/12.png)
选择"IPv4反向查找区域"
![13.png](https://s1.imagehub.cc/images/2023/09/26/13.png)
输入反向IPv4网络位地址，例如192.168.66.0的反向IPV4地址就是66.168.192，也就是从后往前写
![14.png](https://s1.imagehub.cc/images/2023/09/26/14.png)
更新类型选择"允许非安全和安全动态更新"
![15.png](https://s1.imagehub.cc/images/2023/09/26/15.png)
点击"完成"创建反向查找区域
![16.png](https://s1.imagehub.cc/images/2023/09/26/16.png)
这样就创建完成了
![17.png](https://s1.imagehub.cc/images/2023/09/26/17.png)

### 【2】创建正向查找区域主机
在`ninework.com`正向查找区域中创建3台主机:"ftp"、"web"、"dns"
右键"ninework.com"，单击"新建主机"
![18.png](https://s1.imagehub.cc/images/2023/09/26/18.png)
输入主机名称,IP地址指向server2，并创建对应的反向记录
![19.png](https://s1.imagehub.cc/images/2023/09/26/19.png)
出现提示框后就创建完成了
![20.png](https://s1.imagehub.cc/images/2023/09/26/20.png)
其余2个主机也是大同小异
![21.png](https://s1.imagehub.cc/images/2023/09/26/21.png)
![22.png](https://s1.imagehub.cc/images/2023/09/26/22.png)
这样，3台正向区域主机就创建完成了
![23.png](https://s1.imagehub.cc/images/2023/09/26/23.png)
当然也可以在反向区域中查看到刚刚的3台主机的PTR记录
![24.png](https://s1.imagehub.cc/images/2023/09/26/24.png)

### 【3】关闭网络掩码功能
右键SERVER1主机，点击"属性"
![25.png](https://s1.imagehub.cc/images/2023/09/26/25.png)
点击"高级"，然后取消勾选"启用网络掩码排序"功能复选框
![26.png](https://s1.imagehub.cc/images/2023/09/26/26.png)

### 【4】启用AD回收站功能
打开"服务器管理器"-"工具"-"AD管理中心"
![27.png](https://s1.imagehub.cc/images/2023/09/26/27.png)
点击域名，然后点击"启用回收站"
![28.png](https://s1.imagehub.cc/images/2023/09/26/28.png)
点击"确定"
![29.png](https://s1.imagehub.cc/images/2023/09/26/29.png)
然后刷新AD管理中心
![30.png](https://s1.imagehub.cc/images/2023/09/26/30.png)
这时候"启用回收站"已经变成灰色
![31.png](https://s1.imagehub.cc/images/2023/09/26/31.png)

## 【4】server2 辅助DNS配置
### 【1】server2安装DNS服务
打开"服务器管理器"-"添加角色和功能"，然后勾选"DNS服务器"复选框
![32.png](https://s1.imagehub.cc/images/2023/09/26/32.png)

### 【2】创建DNS辅助域
打开"工具"-"DNS"
![33.png](https://s1.imagehub.cc/images/2023/09/26/33.png)
在"正向查找区域"中，点击"新建区域"
![34.png](https://s1.imagehub.cc/images/2023/09/26/34.png)
区域类型选择"辅助区域"
![35.png](https://s1.imagehub.cc/images/2023/09/26/35.png)
区域名称填写域名
![36.png](https://s1.imagehub.cc/images/2023/09/26/36.png)
然后输入server1的IP地址并回车确认，正确的话会出现小绿勾
![37.png](https://s1.imagehub.cc/images/2023/09/26/37.png)
这时候还没有server1的DNS数据，因为server1还没有勾选数据传送
![39.png](https://s1.imagehub.cc/images/2023/09/26/39.png)
### 【3】server1勾选区域传送
右键正向区域域名，点击属性
![40.png](https://s1.imagehub.cc/images/2023/09/26/40.png)
点击"区域传送"，勾选"允许区域传送"，区域传送类型勾选所有服务器也可以，勾选白名单也可以
![41.png](https://s1.imagehub.cc/images/2023/09/26/41.png)
然后刷新server2的DNS管理器，就可以看到server1的DNS服务器数据就全部同步过来了
![42.png](https://s1.imagehub.cc/images/2023/09/26/42.png)

# 【8】SMB文件共享服务器😶
## 【题目要求】
1. 创建server1为主域控制器，域名为server1.ninework.com
2. 创建server2为辅助域控制器，域名为server2.ninework.com
3. 创建后勤部和技术部2个部门，组织单位名使用部门全拼命名；后勤部包括adm1和adm2用户；技术部包括sys1和sys2用户；用户密码永不过期，且均不能更改密码
4. 在server1 C盘根目录下创建SMB父文件夹，SMB父文件夹命名为"SMBHOME"为2个部门各创建1个子文件夹，文件夹名称由部门名称命名；SMB共享名称为"SMBROOT"
   2个部门文件夹内均包括"部门共享"和"共享文件"2个文件夹，其中"部门共享"文件夹只对部门内所有成员开放，部门内所有成员均对"部门共享"文件夹内所有数据拥有增改查权限，非此部门人员无法看到次文件夹；
   "共享文件"文件夹是该部门对外开放的共享文件夹，外部部门可以访问，但不能增、删、改，只能读

## 【1】server1前期配置
### 【1】修改计算机名
![15106ed50b8084712.png](https://s1.imagehub.cc/images/2023/09/26/15106ed50b8084712.png)
### 【2】修改网卡配置
DNS指向本地
![22d624a1838d8d1fc.png](https://s1.imagehub.cc/images/2023/09/26/22d624a1838d8d1fc.png)
### 【3】安装基础AD域服务
![3a19356734e2841aa.png](https://s1.imagehub.cc/images/2023/09/26/3a19356734e2841aa.png)
### 【4】提升为域控制器
添加新林-www.ninework.com
![4463aec68f1d8ead9.png](https://s1.imagehub.cc/images/2023/09/26/4463aec68f1d8ead9.png)
## 【2】server2前期配置
### 【1】运行sysprep程序
勾选"通用"后再运行
![5ad5e4b61df3ad4eb.png](https://s1.imagehub.cc/images/2023/09/26/5ad5e4b61df3ad4eb.png)

### 【2】完成新系统配置
![62dd80a0189e61f27.png](https://s1.imagehub.cc/images/2023/09/26/62dd80a0189e61f27.png)
### 【3】修改网卡配置
DNS指向server1
![795f1394919d677ac.png](https://s1.imagehub.cc/images/2023/09/26/795f1394919d677ac.png)
### 【4】更改计算机名并加入域环境
![8780a3a1df4e9349f.png](https://s1.imagehub.cc/images/2023/09/26/8780a3a1df4e9349f.png)
## 【3】创建用户及用户组
创建后勤部及技术部组织单位后，再创建相同名称的组，否则到后面添加用户组的时候就会搜索不到用户组，因为你没有创建
![11-1.png](https://s1.imagehub.cc/images/2023/09/27/11-1.png)
## 【4】创建SMB根目录文件夹
![1034e8909e2a9b076a.png](https://s1.imagehub.cc/images/2023/09/26/1034e8909e2a9b076a.png)
在使用`net user YOURUSERNAME`命令时，如果"全局组成员"中显示的是组名和Default Name的话，那么就是正确的
![124634e15b05752a20.png](https://s1.imagehub.cc/images/2023/09/27/124634e15b05752a20.png)
## 【5】安装SMB服务
打开"服务器管理器"-"添加角色和功能"，在"服务器角色"中，勾选"文件服务器资源管理器"
![103fff8da54416bf4.png](https://s1.imagehub.cc/images/2023/09/27/103fff8da54416bf4.png)
然后在"功能"中勾选"SMB 1.0/CIFS文件共享支持"
![2c5cd6b1c598898b0.png](https://s1.imagehub.cc/images/2023/09/27/2c5cd6b1c598898b0.png)
然后重启服务器，SMB就安装完成了
![3e7f1cc1d5fbfd2df.png](https://s1.imagehub.cc/images/2023/09/27/3e7f1cc1d5fbfd2df.png)
## 【6】配置SMB服务
在"文件和存储服务"中，点击"共享"，右键空白处，点击"新建共享"
"NETLOGON"和"SYSVOL"是系统自带的
![485f89270e94984c9.png](https://s1.imagehub.cc/images/2023/09/27/485f89270e94984c9.png)
选择"SMB共享-高级"
![572d0599c46b705cc.png](https://s1.imagehub.cc/images/2023/09/27/572d0599c46b705cc.png)
选择"键入自定义路径"
![6fbcc5f0cd993199a.png](https://s1.imagehub.cc/images/2023/09/27/6fbcc5f0cd993199a.png)
![77acad70c329e5178.png](https://s1.imagehub.cc/images/2023/09/27/77acad70c329e5178.png)
共享名称填写"SMBROOT"
![88ef3df90e6513a4b.png](https://s1.imagehub.cc/images/2023/09/27/88ef3df90e6513a4b.png)
启用基于存取的枚举：如果没有勾选那么用户可以看到没有访问权限的文件夹，勾选后对用户没有权限的文件夹会自动隐藏
允许共享缓存：默认勾选的
加密数据访问：局域网内难道还有人想要通过抓包来截取数据？
![91.png](https://s1.imagehub.cc/images/2023/09/27/91.png)
点击"自定义权限"，然后点击"禁用继承"，点击"将已继承的权限转换为此对象的显式权限"
![10fce7ba366e68e5d0.png](https://s1.imagehub.cc/images/2023/09/27/10fce7ba366e68e5d0.png)
然后点击"自定义权限"，点击"添加"，点击"选择主体"，输入用户组名称，再点击"检查名称"，点击"确定"后即可添加组
![13c3e1550122bc03d7.png](https://s1.imagehub.cc/images/2023/09/27/13c3e1550122bc03d7.png)
设置2个用户组的权限为读取和执行、列出文件夹内容、读取
<font color=red>2个用户组都是这3个权限，如果勾选了修改，那么用户可以在SMBHOME目录下随意创建和删除文件</font>

![1456b4f0804dbc7e16.png](https://s1.imagehub.cc/images/2023/09/27/1456b4f0804dbc7e16.png)
然后再添加技术部组
![1597e086ca4561f9a5.png](https://s1.imagehub.cc/images/2023/09/27/1597e086ca4561f9a5.png)
这样2个组就添加好了
![164fd4cda0231bde66.png](https://s1.imagehub.cc/images/2023/09/27/164fd4cda0231bde66.png)
管理属性：
![15af7278d2536f3f2.png](https://s1.imagehub.cc/images/2023/10/05/15af7278d2536f3f2.png)
配额：
<font color=red>不建议启用配额，启用了配额的话如果文件夹达到了配额的容量将无法在新增文件，不然就是折腾自己</font>

![2e77e5ecbf218f402.png](https://s1.imagehub.cc/images/2023/10/05/2e77e5ecbf218f402.png)
确认：
![19b55e1c2b0d1a8809.png](https://s1.imagehub.cc/images/2023/09/27/19b55e1c2b0d1a8809.png)
创建完成：
![3a06afa7c3e409039.png](https://s1.imagehub.cc/images/2023/10/05/3a06afa7c3e409039.png)
## 【7】设置目录权限
### 【1】设置后勤部访问权限
右键部门，点击"属性"，点击"安全"-"高级"
![4.png](https://s1.imagehub.cc/images/2023/10/05/4.png)
点击"禁用继承"，点击"将已继承的权限转换为此对象的显式权限"
![5.png](https://s1.imagehub.cc/images/2023/10/05/5.png)
保留Administrators、SYSTEM、CREATOR OWNER这三个系统自带的用户组和后勤部、技术部用户组，其他的全部删除即可
![15b226361144703b8.png](https://s1.imagehub.cc/images/2023/10/05/15b226361144703b8.png)
后勤部和技术部用户组只能读取，不能写入
![257d7d29a1b22774e.png](https://s1.imagehub.cc/images/2023/10/05/257d7d29a1b22774e.png)
### 【2】设置后勤部"部门共享"访问权限
右键部门，点击"属性"，点击"安全"-"高级"
[![31f578beac73f6f60.png](https://s1.imagehub.cc/images/2023/10/05/31f578beac73f6f60.png)](https://www.imagehub.cc/image/rD7TRz)
点击"禁用继承"，点击"将已继承的权限转换为此对象的显式权限"
![262d4008b0ff86f53.png](https://s1.imagehub.cc/images/2023/10/05/262d4008b0ff86f53.png)
删除"jishubu"用户组
后勤部的"部门共享"文件夹只能后勤部访问，其他用户组无法访问
![196c53db2824d1bf1.png](https://s1.imagehub.cc/images/2023/10/05/196c53db2824d1bf1.png)
点击"显示高级权限"
![42a49b20458925459.png](https://s1.imagehub.cc/images/2023/10/05/42a49b20458925459.png)
勾选这些权限，这些权限都是基本权限，该给的还是要给
但是"删除"、"更改权限"、"取得所有权"这3个权限不能给，如果勾选了"删除"，用户可以删除根目录也就是 C:\SMBHOME\houqinbu\部门共享 这个文件夹
![19f57e1414dbaf1a9.png](https://s1.imagehub.cc/images/2023/10/05/19f57e1414dbaf1a9.png)
至此，后勤部的权限已经设置完毕，只有后勤部用户组的用户可以看到并访问读取写入文件，其他用户组无法看到这个部门共享文件夹
![2f08276d1272131db.png](https://s1.imagehub.cc/images/2023/10/05/2f08276d1272131db.png)
### 【3】设置后勤部"共享文件"访问权限
右键部门，点击"属性"，点击"安全"-"高级"
![4f6066093ecae4aca.png](https://s1.imagehub.cc/images/2023/10/05/4f6066093ecae4aca.png)
点击"禁用继承"，点击"将已继承的权限转换为此对象的显式权限"
![365daecd7841623f9.png](https://s1.imagehub.cc/images/2023/10/05/365daecd7841623f9.png)
编辑"houqinbu"用户组权限
![561382ff2adf40f91.png](https://s1.imagehub.cc/images/2023/10/05/561382ff2adf40f91.png)
"jishubu"用户组无需更改权限，默认就是只读权限
![6.png](https://s1.imagehub.cc/images/2023/10/05/6.png)
至此，C:\SMBHOME\houqinbu 及houqinbu目录下的"部门共享"和"共享文件"权限已经设置完毕，如有其它新建目录都可以参照设置
![130bf0f316ab537a3.png](https://s1.imagehub.cc/images/2023/10/05/130bf0f316ab537a3.png)
### 【4】设置技术部访问权限
禁用继承
![1bad49ef9c42ee6db.png](https://s1.imagehub.cc/images/2023/10/05/1bad49ef9c42ee6db.png)
保留Administrators、SYSTEM、CREATOR OWNER这三个系统自带的用户组和后勤部、技术部用户组，其他的全部删除即可
![27e657bdc70032b88.png](https://s1.imagehub.cc/images/2023/10/05/27e657bdc70032b88.png)
### 【5】设置技术部"部门共享"访问权限
禁用继承
![14f6f4dcfe3055e97.png](https://s1.imagehub.cc/images/2023/10/05/14f6f4dcfe3055e97.png)
删除后勤部用户组，禁止后勤部用户组访问、查看
![204c8ab0a57cab3be.png](https://s1.imagehub.cc/images/2023/10/05/204c8ab0a57cab3be.png)
勾选基本权限，但不勾选"删除"、"更改权限"、"取得所有权"等3个权限
![35a6c34e59e8294ba.png](https://s1.imagehub.cc/images/2023/10/05/35a6c34e59e8294ba.png)
这样就完成了
![Snipaste_2023-10-05_19-27-53.png](https://s1.imagehub.cc/images/2023/10/05/Snipaste_2023-10-05_19-27-53.png)
### 【6】设置技术部"共享文件"访问权限
禁用继承
![1png.png](https://s1.imagehub.cc/images/2023/10/05/1png.png)
勾选基本权限，但不勾选"删除"、"更改权限"、"取得所有权"等3个权限
![15357aa68f2e5173f.png](https://s1.imagehub.cc/images/2023/10/05/15357aa68f2e5173f.png)
后勤部用户组默认权限即可
![1a186cc856fad2742.png](https://s1.imagehub.cc/images/2023/10/05/1a186cc856fad2742.png)
## 【8】验收环节
### 【1】后勤部组用户登录
以后勤部组adm1用户登录
![1c6eaf4ec1350e67f.png](https://s1.imagehub.cc/images/2023/10/05/1c6eaf4ec1350e67f.png)
资源管理器地址栏内输入`\\192.168.10.211\`
这里是在家里用VM做的，10.211对应的是10.11
"netlogon"和"sysvol"是系统自带的
[295155d68b0419bd7.png](https://s1.imagehub.cc/images/2023/10/05/295155d68b0419bd7.png)
访问自己的用户组可以看到"部门共享"和"共享文件"目录
![3667b06f935dea8b9.png](https://s1.imagehub.cc/images/2023/10/05/3667b06f935dea8b9.png)
在"部门共享"内可以创建文件夹及文件
[![4f6d71a488249d5e0.png](https://s1.imagehub.cc/images/2023/10/05/4f6d71a488249d5e0.png)](https://www.imagehub.cc/image/rD533L)
删除"部门共享"被拒
![5ac6a645e2cd0e5f4.png](https://s1.imagehub.cc/images/2023/10/05/5ac6a645e2cd0e5f4.png)
"共享文件"也可以创建文件夹及文件
![1fb6981e35775a352.png](https://s1.imagehub.cc/images/2023/10/05/1fb6981e35775a352.png)
只能看到技术部的"共享文件"
![Snipaste_2023-10-05_19-49-41.png](https://s1.imagehub.cc/images/2023/10/05/Snipaste_2023-10-05_19-49-41.png)
在技术部共享文件夹内无法写入，只能读取
![2a2cc18a604c6caad.png](https://s1.imagehub.cc/images/2023/10/05/2a2cc18a604c6caad.png)

### 【2】技术部组用户登录
使用技术部用户sys1登录验收
![159ce31d942fa43c8.png](https://s1.imagehub.cc/images/2023/10/05/159ce31d942fa43c8.png)
资源管理器地址栏内输入`\\192.168.10.211\`
![1a431bc1ce1e1f33d.png](https://s1.imagehub.cc/images/2023/10/05/1a431bc1ce1e1f33d.png)
可以访问到我们刚才创建的文件夹及文件
![1cc930c4477af1992.png](https://s1.imagehub.cc/images/2023/10/05/1cc930c4477af1992.png)
且只能看到后勤部的"共享文件"
![37935339781fc8988.png](https://s1.imagehub.cc/images/2023/10/05/37935339781fc8988.png)
均能看到技术部下的"部门共享"及"共享文件"
![4644aee6f6feda83f.png](https://s1.imagehub.cc/images/2023/10/05/4644aee6f6feda83f.png)
"部门共享"内可以删除子文件夹及文件
![1135b06e62f9b0bfd.png](https://s1.imagehub.cc/images/2023/10/05/1135b06e62f9b0bfd.png)
也可以在"共享文件"内删除文件或文件夹
![130419d2a83e8fe38.png](https://s1.imagehub.cc/images/2023/10/05/130419d2a83e8fe38.png)
SMB服务配置结束......

# 【9】NLB配置😊
**NLB简介：**
NLB 全称为 Network Load Balancer，是在开放系统互连（OSI）模型的第四层运行。它每秒可以处理数百万个请求。在负载均衡器收到连接请求后，它会从默认规则的目标组中选择一个目标，尝试在侦听器配置中指定的端口上打开一个到该选定目标的 TCP 连接。
当您为负载均衡器启用可用区时，Network Load Balancing 会在该可用区中创建一个负载均衡器节点。默认情况下，每个负载均衡器节点仅在其可用区中的已注册目标之间分配流量。如果您启用了跨区域负载均衡，则每个负载均衡器节点会在所有启用的可用区中的已注册目标之间分配流量。
## 【1】NLB环境介绍
|计算机名|IPV4地址|NLB优先级|扮演角色|
|-------|--------|--------|--------|
|/|192.168.154.100|/|NLB群集IP
|server1|192.168.154.128|1|主NLB|
|server2|192.168.154.129|2|从NLB|
|server3|192.168.154.130|/|DNS服务器|
|NineBytes-PC|192.168.154.1|/|验证客户端|
## 【2】server1配置
- 修改计算机名为server1
![0.png](https://s1.imagehub.cc/images/2023/10/12/0.png)
- server1 IP地址配置
![1.png](https://s1.imagehub.cc/images/2023/10/12/1.png)
- 安装Web服务及网络负载平衡
![2.png](https://s1.imagehub.cc/images/2023/10/12/2.png)
![38ad3d3f02947737b.png](https://s1.imagehub.cc/images/2023/10/12/38ad3d3f02947737b.png)

## 【3】server2配置
- 修改计算机名为server2
![07da10be1bcba0472.png](https://s1.imagehub.cc/images/2023/10/12/07da10be1bcba0472.png)
- server2 IP地址配置
![1ccb83e09040bd8d0.png](https://s1.imagehub.cc/images/2023/10/12/1ccb83e09040bd8d0.png)
- 安装Web服务及网络负载平衡
![273db1d71938e6ac0.png](https://s1.imagehub.cc/images/2023/10/12/273db1d71938e6ac0.png)

## 【4】修改host文件
- host路径：`C:\Windows\System32\drivers\etc\hosts`
在行尾增加NLB虚拟IP及域名(中间有空格)
`192.168.154.100 www.nlbfark.com`
server1 host：
![00.png](https://s1.imagehub.cc/images/2023/10/12/00.png)
server2 host：
![Snipaste_2023-10-14_20-24-26.png](https://s1.imagehub.cc/images/2023/10/14/Snipaste_2023-10-14_20-24-26.png)

## 【5】新建NLB群集
- 打开"服务器管理器"-"工具"-"网络负载平衡管理器"
[![12c66782f23dac233.png](https://s1.imagehub.cc/images/2023/10/12/12c66782f23dac233.png)](https://www.imagehub.cc/image/1rVKiZ)
- 右键"网络负载平衡群集"，单击"新建群集"
![2a9c17abca90c66ef.png](https://s1.imagehub.cc/images/2023/10/12/2a9c17abca90c66ef.png)
- 在"主机"栏内输入主机名也行，输入IP也行，然后点击"连接"
![3b6b78adce94f58fa.png](https://s1.imagehub.cc/images/2023/10/12/3b6b78adce94f58fa.png)
- "优先级"选择"1"
![4.png](https://s1.imagehub.cc/images/2023/10/12/4.png)
- 首先点击"添加"，然后在IPv4栏内输入NLB虚拟IP地址`192.168.154.100`,子网掩码默认
![5.png](https://s1.imagehub.cc/images/2023/10/12/5.png)
- "完整Internet名称"填写域名
模式选择"多播"
<font color=red>单网卡选择多播，双网卡选择单播</font>

传送门：[博客园-WINDOWS 负载均衡NLB配置中单播与多播区别](https://www.cnblogs.com/grhack/p/13763039.html "博客园-WINDOWS 负载均衡NLB配置中单播与多播区别")
![6.png](https://s1.imagehub.cc/images/2023/10/12/6.png)

- 端口规则默认
![7.png](https://s1.imagehub.cc/images/2023/10/12/7.png)

## 【6】添加主机到群集
- 右键域名，然后单击"添加主机到群集"
![13f670d5d4722bb06.png](https://s1.imagehub.cc/images/2023/10/12/13f670d5d4722bb06.png)
- 主机名填写计算机名或IP地址均可，然后点击"连接"进行下一步
![22aeed05ac5eea4e2.png](https://s1.imagehub.cc/images/2023/10/12/22aeed05ac5eea4e2.png)
- server2优先级默认就是2，直接下一步就行
![3253f9ce6983285ad.png](https://s1.imagehub.cc/images/2023/10/12/3253f9ce6983285ad.png)
- 端口规则默认
![48b3e5604c7ff702a.png](https://s1.imagehub.cc/images/2023/10/12/48b3e5604c7ff702a.png)
- 添加完成后，等待20-30秒，SERVER2就会由"挂起"状态变为"聚合"状态
![5-1.png](https://s1.imagehub.cc/images/2023/10/12/5-1.png)
server1配好NLB后，server2就会自动同步server1的NLB配置，- 就不用再次配置server2NLB了
![6a6c1d7e312b5e44b.png](https://s1.imagehub.cc/images/2023/10/12/6a6c1d7e312b5e44b.png)

## 【7】创建站点默认文档
- 创建html文档，在里边随便写点内容
<font color=red>为了在验收时区分，server1和server2的web主页内容是不同的，但是在实际生产生活中，NLB群集内的主机的Web内容是一致的</font>

![1249c3c3b80944d01.png](https://s1.imagehub.cc/images/2023/10/12/1249c3c3b80944d01.png)
![3b492cb579219c805.png](https://s1.imagehub.cc/images/2023/10/12/3b492cb579219c805.png)
![416fc239f08f85ebd.png](https://s1.imagehub.cc/images/2023/10/12/416fc239f08f85ebd.png)

## 【8】创建Web站点
server1：
- 打开"IIS管理器"
![1b8694bb2d1e56456.png](https://s1.imagehub.cc/images/2023/10/12/1b8694bb2d1e56456.png)
- 先把默认站点停止
![2e7cc632524f91c9a.png](https://s1.imagehub.cc/images/2023/10/12/2e7cc632524f91c9a.png)
- 添加网站
1. 网站名称填写域名
2. 物理路径指向web.html存在的路径
3. 类型选择HTTP
4. IP地址指向NLB虚拟IP
5. 端口默认80
6. 主机名也填写域名
![1a7f5b515ef6f20b9.png](https://s1.imagehub.cc/images/2023/10/12/1a7f5b515ef6f20b9.png)
- 站点默认文档指向"web.html"
![10764a77ec84a35f6.png](https://s1.imagehub.cc/images/2023/10/12/10764a77ec84a35f6.png)

server2：
- server2也是同样的操作
![21d54ea9277489956.png](https://s1.imagehub.cc/images/2023/10/12/21d54ea9277489956.png)
![3afd71af91ad00faa.png](https://s1.imagehub.cc/images/2023/10/12/3afd71af91ad00faa.png)
## 【9】验收环节
- 点击右边的"浏览"
![17bb56743e80442fe.png](https://s1.imagehub.cc/images/2023/10/12/17bb56743e80442fe.png)
- server1成功访问
![2094edb64f2ee320c.png](https://s1.imagehub.cc/images/2023/10/12/2094edb64f2ee320c.png)
- server2成功访问
![3ca9cfb9dafec41e7.png](https://s1.imagehub.cc/images/2023/10/12/3ca9cfb9dafec41e7.png)
- 客户端成功访问
![2815eabe5d07eb670.png](https://s1.imagehub.cc/images/2023/10/12/2815eabe5d07eb670.png)
需要注意的是，客户端也需要增加host文件记录
若无法保存host文件，用火绒修改host文件
![1187b4e3ee51c5d02.png](https://s1.imagehub.cc/images/2023/10/12/1187b4e3ee51c5d02.png)
![157a815d685694b92.png](https://s1.imagehub.cc/images/2023/10/12/157a815d685694b92.png)
- 禁用server1网卡，模拟server1宕机
![1b94e082cf9381075.png](https://s1.imagehub.cc/images/2023/10/12/1b94e082cf9381075.png)
站点主页已经变为server2的主页，证明server2成功接替server1
![25b5280ba70c54a50.png](https://s1.imagehub.cc/images/2023/10/12/25b5280ba70c54a50.png)
## 【10】DNS解析域名方法
如果不想修改host文件，那就做一个DNS服务器
- 修改DNS服务器IP地址
![1cb81b54ecba9d061.png](https://s1.imagehub.cc/images/2023/10/13/1cb81b54ecba9d061.png)
- 安装DNS服务
![2977a3cd5eea9b420.png](https://s1.imagehub.cc/images/2023/10/13/2977a3cd5eea9b420.png)
- 新建反向查找区域
![39ec043706703c6f4.png](https://s1.imagehub.cc/images/2023/10/13/39ec043706703c6f4.png)
- 选择"主要区域"
![486b0cf9d5cac998a.png](https://s1.imagehub.cc/images/2023/10/13/486b0cf9d5cac998a.png)
- 网络ID按顺序填写，不用手动填写反向IP
server 2019版好像是需要手动填写反向IP的
![5a4717c551936683d.png](https://s1.imagehub.cc/images/2023/10/13/5a4717c551936683d.png)
![6.png](https://s1.imagehub.cc/images/2023/10/13/6.png)
- 然后新建正向查找区域
![7.png](https://s1.imagehub.cc/images/2023/10/13/7.png)
- 勾选"主要区域"
![8.png](https://s1.imagehub.cc/images/2023/10/13/8.png)
- 区域名称填写`nlbfark.com`，不用写"www"
![9.png](https://s1.imagehub.cc/images/2023/10/13/9.png)
![10.png](https://s1.imagehub.cc/images/2023/10/13/10.png)
- 右键空白处，点击"新建主机"
![11.png](https://s1.imagehub.cc/images/2023/10/13/11.png)
- 名称填写`www`，IP地址指向NLB虚拟IP，然后勾选"创建相关的指针(PTR)记录"
![12.png](https://s1.imagehub.cc/images/2023/10/13/12.png)
- 成功在正向区域及反向区域新建主机及PTR记录
![13.png](https://s1.imagehub.cc/images/2023/10/13/13.png)
- 验收环节
客户端DNS指向DNS服务器(192.168.154.130)
![16.png](https://s1.imagehub.cc/images/2023/10/13/16.png)
- 这时候显示尚未连接，这是因为没有刷新DNS缓存
![14.png](https://s1.imagehub.cc/images/2023/10/13/14.png)
- 刷新DNS缓存`ipconfig/flushdns`
![15.png](https://s1.imagehub.cc/images/2023/10/13/15.png)
- 成功访问到server1主页
![19.png](https://s1.imagehub.cc/images/2023/10/13/19.png)
- 禁用server1网卡，模拟server1宕机
![20.png](https://s1.imagehub.cc/images/2023/10/13/20.png)
- server2成功接替Web站点
![21.png](https://s1.imagehub.cc/images/2023/10/13/21.png)

NLB参考资料：
1. [博客园-Windows群集之NLB](Windows群集之NLB "博客园-Windows群集之NLB")
2. [博客园-IIS负载均衡的NLB解决方案](https://www.cnblogs.com/Wolfmanlq/p/5737488.html "博客园-IIS负载均衡的NLB解决方案")
3. [博客园-一步一步配置NLB](https://www.cnblogs.com/whtydn/p/4810705.html "博客园-一步一步配置NLB")
4. [博客园-NLB网路负载均衡管理器详解](https://www.cnblogs.com/knowledgesea/p/5157565.html "博客园-NLB网路负载均衡管理器详解")
5. [博客园-Windows 2003 NLB理解](https://www.cnblogs.com/allegro/archive/2011/02/11/1951171.html "博客园-Windows 2003 NLB理解")
6. [博客园-WINDOWS 负载均衡NLB配置中单播与多播区别](https://www.cnblogs.com/grhack/p/13763039.html "博客园-WINDOWS 负载均衡NLB配置中单播与多播区别")
7. [CSDN-windows server 2008 r2搭建NLB负载均衡](https://blog.csdn.net/qlqlulu/article/details/109825905?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169709695816800188535979%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=169709695816800188535979&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-109825905-null-null.142^v96^pc_search_result_base9&utm_term=Windows%20server%20NLB "CSDN-windows server 2008 r2搭建NLB负载均衡")
8. [CSDN-DNS 刷新：清除DNS缓存的方法详解](https://blog.csdn.net/winkexin/article/details/131567668 "CSDN-DNS 刷新：清除DNS缓存的方法详解")

# 【10】组策略配置😀
## 【1】主策略概念
### 【1】本地组策略的介绍
- 命令
> gpedit.msc

- 本地组策略编辑器
![1b9ca853443fc65da.png](https://s1.imagehub.cc/images/2023/10/10/1b9ca853443fc65da.png)

### 【2】AD(域)的组策略的介绍
- 前要条件
  具备域环境：身为域控制器或已加入域环境

- 命令
> gpmc.msc

- 活动目录组策略管理
![2fed14bfc2771520e.png](https://s1.imagehub.cc/images/2023/10/11/2fed14bfc2771520e.png)

- 创建新的组策略对象(GPO)
右键"组策略对象"，点击"新建"
![135c33ea9af7fc2f0.png](https://s1.imagehub.cc/images/2023/10/11/135c33ea9af7fc2f0.png)
- 填写GPO名称
![2e2e97fdff940e33f.png](https://s1.imagehub.cc/images/2023/10/11/2e2e97fdff940e33f.png)
- 对新建的GPO进行编辑
右键Tesing GPO，点击"编辑"
![3a1f80eceda618e76.png](https://s1.imagehub.cc/images/2023/10/11/3a1f80eceda618e76.png)
- AD组策略管理编辑器界面
![41a4c982d398ff564.png](https://s1.imagehub.cc/images/2023/10/11/41a4c982d398ff564.png)

### 【3】GPO的链接
- 新建"技术部"组织单位
右键"www.ninework.com"，点击"新建组织单位"
![5dd7eaff7d349fcd1.png](https://s1.imagehub.cc/images/2023/10/11/5dd7eaff7d349fcd1.png)
- 链接到"Tesing"GPO
右键刚刚新建的"技术部"单位，点击"链接现有GPO"
![68266b3890bc62369.png](https://s1.imagehub.cc/images/2023/10/11/68266b3890bc62369.png)
- 选择到Tesing GPO
![7be24de8a7bfff83f.png](https://s1.imagehub.cc/images/2023/10/11/7be24de8a7bfff83f.png)
- 技术部成功链接到Tesing GPO
![8a3b9a6a336d86138.png](https://s1.imagehub.cc/images/2023/10/11/8a3b9a6a336d86138.png)

## 【2】本地组策略配置
### 【1】无需按Ctrl+Alt+Del登录
- Win+R输入`gpedit.msc`打开本地组策略编辑器
![1.png](https://s1.imagehub.cc/images/2023/10/09/1.png)
- 依次展开"Windows设置"-"安全设置"-"本地策略"-"安全选项"
然后双击打开"安全选项"，找到"交互式登录：无需按Ctrl+Alt+Del"，双击打开
勾选"已启用"
![2.png](https://s1.imagehub.cc/images/2023/10/09/2.png)

### 【2】登录时不显示上次登录
- 展开"计算机配置"-"Windows设置"-"安全设置"
点击"安全选项"，双击打开"交互式登录：不显示上次登陆"，选择"已启用"
![3ac9acfcf8c84c792.png](https://s1.imagehub.cc/images/2023/10/09/3ac9acfcf8c84c792.png)

### 【3】登录时不显示用户名
- 展开"计算机配置"-"Windows设置"-"安全设置"
点击"安全选项"，双击打开"交互式登录：不显示用户名"，选择"已启用"
![4d6e76a7914b54c9c.png](https://s1.imagehub.cc/images/2023/10/09/4d6e76a7914b54c9c.png)
效果：
![1.png](https://s1.imagehub.cc/images/2023/10/10/1.png)
### 【4】关闭服务器管理器自启
#### 【1】服务器管理器属性设置
- 打开"服务器管理器"-"管理"-"服务器管理器属性"
![550c77c78b7455ac8.png](https://s1.imagehub.cc/images/2023/10/09/550c77c78b7455ac8.png)
- 勾选"在登陆时不自动启动服务器管理器"
![645e51739397e04f1.png](https://s1.imagehub.cc/images/2023/10/09/645e51739397e04f1.png)
#### 【2】组策略设置
- 依次展开"计算机配置"–"管理模板"–"系统"–"服务器管理器"
然后双击打开"在登录时不自动显示服务器管理器"
选择"已启用"
![7de2632b4db49c8cc.png](https://s1.imagehub.cc/images/2023/10/09/7de2632b4db49c8cc.png)
#### 【3】任务计划程序设置
- Win+R打开`taskschd.msc`
依次展开"任务计划程序库"–"Microsoft"–"Windows"–"Server Manager"
![8d00488ee2f267dc9.png](https://s1.imagehub.cc/images/2023/10/09/8d00488ee2f267dc9.png)

### 【5】禁止本机用户编辑注册表
- 注册表可以被任何人打开，这是非常危险的一件事
![1a7ff3429e5a0c9e0.png](https://s1.imagehub.cc/images/2023/10/10/1a7ff3429e5a0c9e0.png)
- 展开"用户配置"-"管理模板"-"系统"，然后找到"阻止访问注册表编辑工具"
![2abb34c14ae2e953a.png](https://s1.imagehub.cc/images/2023/10/10/2abb34c14ae2e953a.png)

### 【6】禁止本机用户使用命令提示符及批处理脚本
- 依次展开"用户配置"-"管理模板"-"系统"
双击打开"阻止访问命令提示符"，在"是否也要禁用命令提示符脚本处理"中选择"是"
![1f471819f7df2c4a1.png](https://s1.imagehub.cc/images/2023/10/11/1f471819f7df2c4a1.png)
- 验收环节
![100e8e8137f0f54f9.png](https://s1.imagehub.cc/images/2023/10/11/100e8e8137f0f54f9.png)

### 【7】拒绝所有可移动存储类的所有权限
- 依次展开"计算机配置"-"管理模板"-"系统"-"可移动存储访问"
然后双击打开"所有可移动存储类：拒绝所有权限"，选择"已启用"
![1b463247e07481de9.png](https://s1.imagehub.cc/images/2023/10/09/1b463247e07481de9.png)

### 【8】同时审核成功和失败登录事件
- 依次展开"计算机配置"-"安全设置"-"本地策略"-"审核策略"
双击打开"审核登录事件"，勾选"成功"以及"失败"
![2ddbfdf035d0c378c.png](https://s1.imagehub.cc/images/2023/10/09/2ddbfdf035d0c378c.png)

### 【9】禁用"关闭事件跟踪程序"
- 事件跟踪程序就是在服务器关机、重启时，询问你关闭的原因
![1181a904c06858401.png](https://s1.imagehub.cc/images/2023/10/10/1181a904c06858401.png)
- 依次展开"计算机配置"-"管理模板"-"系统"
然后找到" 显示"关闭事件跟踪程序" "
双击打开，勾选"已禁用"
![3a44720d36af78c43.png](https://s1.imagehub.cc/images/2023/10/09/3a44720d36af78c43.png)
- 禁用后，在服务器关机、重启时，还是要点一下重启
![24666b30636259998.png](https://s1.imagehub.cc/images/2023/10/10/24666b30636259998.png)

### 【10】禁用Internet属性中的"安全"选项卡
- "安全"选项卡存在
![10da961ffcdcc1f26.png](https://s1.imagehub.cc/images/2023/10/11/10da961ffcdcc1f26.png)
- 依次展开"计算机配置"-"管理模板"-"Windows组件"-"Internet Explorer"
然后点击"Internet控制面板"，找到"禁用安全页"，双击打开，点击"已启用"
![20885009b66515280.png](https://s1.imagehub.cc/images/2023/10/11/20885009b66515280.png)
- "安全"选项卡消失
![3414c97748a2e77c8.png](https://s1.imagehub.cc/images/2023/10/11/3414c97748a2e77c8.png)

### 【11】计算机启动和登录时总是等待网络
- 依次展开"计算机配置"-"管理模板"-"系统"-"登录"
然后双击打开"计算机启动和登录时总是等待网络"
![4e766a24f616f7744.png](https://s1.imagehub.cc/images/2023/10/09/4e766a24f616f7744.png)

### 【12】加密数据库修正 
- 加密数据库修正，保护级别为"易受攻击"
依次展开"计算机配置"-"管理模板"-"系统"-"凭据分配"
双击打开"加密数据库修正"
勾选"已启用"，"保护级别"选择"易受攻击"
![5adbe689a6f7e86a1.png](https://s1.imagehub.cc/images/2023/10/09/5adbe689a6f7e86a1.png)
- 输入`gpupdate /force`强制更新组策略
![6f6ccdc514b4c5981.png](https://s1.imagehub.cc/images/2023/10/09/6f6ccdc514b4c5981.png)

## 【3】AD(域)的组策略配置
### 【1】启用任意IP地址的icmpv4回显请求
- 展开"计算机配置"-"策略"-"Windows设置"-"安全设置"-"高级安全Windows Defender防火墙"-"高级安全Windows Defender防火墙"-"入站规则"
![d13481bb3df6448cbbdd8cc97917e3a2.md.png](https://s1.imagehub.cc/images/2023/10/30/d13481bb3df6448cbbdd8cc97917e3a2.md.png)
- 在空白处右键，选择"新建规则"
![3b4446d35fc5e4fff70c66f7b5e3ddf1.md.png](https://s1.imagehub.cc/images/2023/10/30/3b4446d35fc5e4fff70c66f7b5e3ddf1.md.png)
- 规则类型选择"自定义"
![a2a0d4c78c2885169628b6906eeaf40a.md.png](https://s1.imagehub.cc/images/2023/10/30/a2a0d4c78c2885169628b6906eeaf40a.md.png)
- 默认"所有程序"即可
![3ba1e984cfff416b0bbb7b3eaf151905.md.png](https://s1.imagehub.cc/images/2023/10/30/3ba1e984cfff416b0bbb7b3eaf151905.md.png)
- 协议类型选择"ICMPv4"
![651e79f4c51f43e105f7d602e9f2affc.md.png](https://s1.imagehub.cc/images/2023/10/30/651e79f4c51f43e105f7d602e9f2affc.md.png)
- 点击"自定义"
![16c9b03886d34ca9cf3277031d30efbc.png](https://s1.imagehub.cc/images/2023/10/30/16c9b03886d34ca9cf3277031d30efbc.png)
- 选择"特定ICMP类型"
然后勾选"回显请求"
![ad7ab59cfb6316cc27bf8207a8be7a65.png](https://s1.imagehub.cc/images/2023/10/30/ad7ab59cfb6316cc27bf8207a8be7a65.png)
- 下一步
![487c6682ad4133e8426d80d3d1534c54.png](https://s1.imagehub.cc/images/2023/10/30/487c6682ad4133e8426d80d3d1534c54.png)
- 选择"允许连接"
![0fce9fffdeea9692b80f48b8f353d8ca.png](https://s1.imagehub.cc/images/2023/10/30/0fce9fffdeea9692b80f48b8f353d8ca.png)
- 默认勾选即可
![cdc75a777a45f1fb343405fc668e8646.png](https://s1.imagehub.cc/images/2023/10/30/cdc75a777a45f1fb343405fc668e8646.png)
- 名称填写"icmpv4"
![5b42d9e68b2410b397580c7570bb4315.png](https://s1.imagehub.cc/images/2023/10/30/5b42d9e68b2410b397580c7570bb4315.png)
- 创建完成
![b8f5555eb034ed31097232d9161a01e6.png](https://s1.imagehub.cc/images/2023/10/30/b8f5555eb034ed31097232d9161a01e6.png)

### 【2】域中主机自动申请“ipsec”模板证书
- 依次展开"计算机配置"-"策略"-"Windows设置"-"安全设置"-"公钥策略"
然后打开"自动证书申请设置"
![8e0ffc7bcdd1c279d9c14847dc752c8a.png](https://s1.imagehub.cc/images/2023/10/31/8e0ffc7bcdd1c279d9c14847dc752c8a.png)
- 右键空白处，新建"自动证书申请"
![d31b3169fc8d9338f57bcd685433ca2f.png](https://s1.imagehub.cc/images/2023/10/31/d31b3169fc8d9338f57bcd685433ca2f.png)
- 选择"IPSec"
![c6b5b86de1598bec6f400b1330340012.png](https://s1.imagehub.cc/images/2023/10/31/c6b5b86de1598bec6f400b1330340012.png)
- 点击"完成"即可
![3b0bccef5f0070bdeab8a56546adab1d.png](https://s1.imagehub.cc/images/2023/10/31/3b0bccef5f0070bdeab8a56546adab1d.png)
- 然后就能看到刚刚新建的IPSec自动证书申请了
![84a1ca0fd289c8d670f9ee7b49e71d71.png](https://s1.imagehub.cc/images/2023/10/31/84a1ca0fd289c8d670f9ee7b49e71d71.png)
- 然后打开"证书颁发机构"
![8fc2712a407eca06f85e5127cfda5996.png](https://s1.imagehub.cc/images/2023/10/31/8fc2712a407eca06f85e5127cfda5996.png)
- 右键"证书模板"，选择"管理"
![eb2a5920d4c4e998fe7a8af89f2a9a69.png](https://s1.imagehub.cc/images/2023/10/31/eb2a5920d4c4e998fe7a8af89f2a9a69.png)
- 双击打开"工作站身份验证"
![b352e153abeebf57626918bb04d4e35b.png](https://s1.imagehub.cc/images/2023/10/31/b352e153abeebf57626918bb04d4e35b.png)
- 有效期更改为题目要求
![c6fe31b59e3cd75570b090bb58648d7c.png](https://s1.imagehub.cc/images/2023/10/31/c6fe31b59e3cd75570b090bb58648d7c.png)
- 点击"拓展"选项卡，然后双击打开"应用程序策略"
![ce2845eb7a3679ff0a70a07be53d477d.png](https://s1.imagehub.cc/images/2023/10/31/ce2845eb7a3679ff0a70a07be53d477d.png)
- 删除默认的"客户端身份验证"
![4361c460705e6e27f80d9b210722033a.png](https://s1.imagehub.cc/images/2023/10/31/4361c460705e6e27f80d9b210722033a.png)
- 点击"添加"
![0e06d6be9616bd7dfd41844d97e98f01.png](https://s1.imagehub.cc/images/2023/10/31/0e06d6be9616bd7dfd41844d97e98f01.png)
- 找到"服务器身份验证"，点击"确定"
![c77dd38a27d72d9e41f95748943931ea.png](https://s1.imagehub.cc/images/2023/10/31/c77dd38a27d72d9e41f95748943931ea.png)
- 应用确定即可
![86950597f174fc08bf8a8bf021b49fcf.png](https://s1.imagehub.cc/images/2023/10/31/86950597f174fc08bf8a8bf021b49fcf.png)
- 然后打开AD组策略，展开"计算机配置"-"Windows设置"-"安全设置"-"公钥策略"
然后双击打开"证书服务客户端 - 自动注册"
![48601546774818319114381e563640e8.png](https://s1.imagehub.cc/images/2023/10/31/48601546774818319114381e563640e8.png)
- 配置模式选择"启用"
![7e1c42e01e08d2c6e304b1b7994c3b8a.png](https://s1.imagehub.cc/images/2023/10/31/7e1c42e01e08d2c6e304b1b7994c3b8a.png)

### 【3】通信采用ipsec安全连接，采用证书验证
**题目要求：**
通信采用ipsec安全连接，采用windows1颁发的计算机证书验证
**前要说明：**
需要配置AD证书服务，且配置完毕
- 首先打开AD组策略，然后展开"计算机配置"-"Windows设置"-"安全设置"-"高级安全防火墙"-"高级安全防火墙"
然后点击"连接安全规则"，在空白处右键，点击"新建规则"
![01de864bda7a216105e4e416268141c5.png](https://s1.imagehub.cc/images/2023/10/31/01de864bda7a216105e4e416268141c5.png)
- 安全规则类型选择"隧道"
![028e820c1a423dd094f2b0893dfea950.png](https://s1.imagehub.cc/images/2023/10/31/028e820c1a423dd094f2b0893dfea950.png)
- 下一步
![33a829b6fd4780eae6517d546ad89262.png](https://s1.imagehub.cc/images/2023/10/31/33a829b6fd4780eae6517d546ad89262.png)
- 下一步
![78766e0331c878e3bc108681c639134c.png](https://s1.imagehub.cc/images/2023/10/31/78766e0331c878e3bc108681c639134c.png)
- 在"终结点1"中点击"编辑'
![b826034945511d0ad5e948ef29ad1967.png](https://s1.imagehub.cc/images/2023/10/31/b826034945511d0ad5e948ef29ad1967.png)
- 输入终结点1的计算机IP地址
![2765614e3e46a343cae196b29b788b72.png](https://s1.imagehub.cc/images/2023/10/31/2765614e3e46a343cae196b29b788b72.png)
- 终结点2也是如法炮制
![46619cd4d70f6f371e0c752e9b1e1e20.png](https://s1.imagehub.cc/images/2023/10/31/46619cd4d70f6f371e0c752e9b1e1e20.png)
![1999aa488c2e715097e1ffc6ff36b529.png](https://s1.imagehub.cc/images/2023/10/31/1999aa488c2e715097e1ffc6ff36b529.png)
- 然后点击下一步
![5e510ab97fa9e98ea44b55ecf0b3eff1.png](https://s1.imagehub.cc/images/2023/10/31/5e510ab97fa9e98ea44b55ecf0b3eff1.png)
- 点击"浏览"，去添加证书
![9933390ebba5eeb02776429cd7df89ce.png](https://s1.imagehub.cc/images/2023/10/31/9933390ebba5eeb02776429cd7df89ce.png)
- 点击"确定"
![0b859ef2591013413ad22e16216136f9.png](https://s1.imagehub.cc/images/2023/10/31/0b859ef2591013413ad22e16216136f9.png)
- 下一步
![c64b55f7a32128580205c16d7ea44dee.png](https://s1.imagehub.cc/images/2023/10/31/c64b55f7a32128580205c16d7ea44dee.png)
- 下一步
![c7e0b871e5cca83f9a0396803ec8e1a8.png](https://s1.imagehub.cc/images/2023/10/31/c7e0b871e5cca83f9a0396803ec8e1a8.png)
- 填写IPSec名称
![af70b03b3c0dec1d742f6aa3ca54d6de.png](https://s1.imagehub.cc/images/2023/10/31/af70b03b3c0dec1d742f6aa3ca54d6de.png)
- 创建完成
![479d043e4ff5e4163414f55ea2a2ec60.png](https://s1.imagehub.cc/images/2023/10/31/479d043e4ff5e4163414f55ea2a2ec60.png)

### 【4】允许/拒绝用户组登录域控制器
**题目要求：**
允许manager组本地登录域控制器；允许manager1用户远程登录到域控制器；拒绝dev组从网络访问域控制器

**1-允许manager组本地登录域控制器：**
- 打开AD组策略，展开"计算机配置"-"策略"-"Windows设置"-"安全设置"-"本地策略"
然后点击"用户权限分配"，并找到"允许本地登录"
![2bff9566bc84a54313338184ffd4e1ae.png](https://s1.imagehub.cc/images/2023/10/31/2bff9566bc84a54313338184ffd4e1ae.png)
- 勾选"定义这些策略设置"，然后点击"添加用户或组"
![948ba3515d6ac9e3a8e77cfa9f445433.png](https://s1.imagehub.cc/images/2023/10/31/948ba3515d6ac9e3a8e77cfa9f445433.png)
- 点击"浏览"
![878d1e25f8261a2beafc115dc35dca2c.png](https://s1.imagehub.cc/images/2023/10/31/878d1e25f8261a2beafc115dc35dca2c.png)
- 输入"manager"，然后点击"检查名称"
![634d9717babcb136097ca249f41ca1b1.png](https://s1.imagehub.cc/images/2023/10/31/634d9717babcb136097ca249f41ca1b1.png)
- 点击manager用户组，然后点击"确定"
![9ae1a90a788557ebcc30109117e5e404.png](https://s1.imagehub.cc/images/2023/10/31/9ae1a90a788557ebcc30109117e5e404.png)
- 出现manager字样代表添加用户组成功
![95931c46af30b6689ae2a58d574f0977.png](https://s1.imagehub.cc/images/2023/10/31/95931c46af30b6689ae2a58d574f0977.png)
- 这时候会报错"管理员必须被授予登录本地权限"，只需要把域管理账户及普通管理员账户添加进去即可
![4dbdebd374264094b5138001df94ed95.png](https://s1.imagehub.cc/images/2023/10/31/4dbdebd374264094b5138001df94ed95.png)
- 输入`administrator`，先添加带有"管理计算机(域)"字样的域管理员账户
![c5f4323cfb171058bec55dc80486e809.png](https://s1.imagehub.cc/images/2023/10/31/c5f4323cfb171058bec55dc80486e809.png)
- 然后添加普通管理员账户
![8d33840f1597028ea774291901d6da49.png](https://s1.imagehub.cc/images/2023/10/31/8d33840f1597028ea774291901d6da49.png)
- 添加2个管理员账户后，即可定义成功
![3fb2b21ee8466b56ba3757b843622bff.png](https://s1.imagehub.cc/images/2023/10/31/3fb2b21ee8466b56ba3757b843622bff.png)
![1df172e4d1cbc65ce71330b8ac4a57bf.png](https://s1.imagehub.cc/images/2023/10/31/1df172e4d1cbc65ce71330b8ac4a57bf.png)

**2-允许manager1用户远程登录到域控制器：**
- 双击打开"允许通过远程桌面登录"
![da0d2be0f32aaa61e132a6c036d9a8c1.png](https://s1.imagehub.cc/images/2023/10/31/da0d2be0f32aaa61e132a6c036d9a8c1.png)
- 然后输入manager1的用户名，然后点击"检查"
![e767a5089a4b6b4efba48d7f75ff8c5e.png](https://s1.imagehub.cc/images/2023/10/31/e767a5089a4b6b4efba48d7f75ff8c5e.png)
- 这样就好咯
![b0727b884aa07d10cce047a7bebf23b2.png](https://s1.imagehub.cc/images/2023/10/31/b0727b884aa07d10cce047a7bebf23b2.png)

**3-拒绝dev组从网络访问域控制器：**
- 双击打开"拒绝从网络访问这台计算机"
![7e9954a23d01e3f7d7d94d8a4805d09e.png](https://s1.imagehub.cc/images/2023/10/31/7e9954a23d01e3f7d7d94d8a4805d09e.png)
- 输入"dev"组名称，点击检查，最后点击"确定"
![3d6e5bf0d5a3d96530544f320413675b.png](https://s1.imagehub.cc/images/2023/10/31/3d6e5bf0d5a3d96530544f320413675b.png)
- 最终效果：
![358db281f366d0a06466d67c7a703eb8.png](https://s1.imagehub.cc/images/2023/10/31/358db281f366d0a06466d67c7a703eb8.png)

### 【5】创建"后勤部"组织单位，并链接到"后勤部GPO"
- 右键"www.ninework.com"，点击"新建组织单位"
![10805b77a1e8eaa2c.png](https://s1.imagehub.cc/images/2023/10/11/10805b77a1e8eaa2c.png)
- 输入"后勤部"
![213f661fb30d0db8c.png](https://s1.imagehub.cc/images/2023/10/11/213f661fb30d0db8c.png)
- 右键"后勤部"，点击"在这个域中创建GPO并在此处链接"
![3584f043b99393eba.png](https://s1.imagehub.cc/images/2023/10/11/3584f043b99393eba.png)
- 输入GPO名称
![49731b96aadb61a57.png](https://s1.imagehub.cc/images/2023/10/11/49731b96aadb61a57.png)
- 创建组织单位及GPO完成
![12300b64499c2bfa6.png](https://s1.imagehub.cc/images/2023/10/11/12300b64499c2bfa6.png)

### 【6】禁止后勤部访问控制面板和PC设置
- 进入AD组策略管理编辑器
右键"后勤部GPO"，点击"编辑"
![501bb266ee0ec361a.png](https://s1.imagehub.cc/images/2023/10/11/501bb266ee0ec361a.png)
- 依次展开"用户配置"-"管理模板"
然后点击"控制面板"，找到"禁止访问控制面板和PC设置，双击打开，勾选"已启用"
![1c561280f48ece76d.png](https://s1.imagehub.cc/images/2023/10/11/1c561280f48ece76d.png)
- 验证环节
以后勤部用户HQB1用户登录
![17dd2c1983049dc38.png](https://s1.imagehub.cc/images/2023/10/11/17dd2c1983049dc38.png)
- 打开"控制面板"报错
![2b2f81b6f8ff85c0e.png](https://s1.imagehub.cc/images/2023/10/11/2b2f81b6f8ff85c0e.png)

### 【7】禁止后勤部所有用户修改IE默认主页
- 现在可以更改IE主页地址
(~~2345主页是我故意的~~)
![22d8a874ef67a41c7.png](https://s1.imagehub.cc/images/2023/10/11/22d8a874ef67a41c7.png)
![345086db53475f468.png](https://s1.imagehub.cc/images/2023/10/11/345086db53475f468.png)
- 依次展开"用户配置"-"管理模板"-"Windows组件"
然后点击"Internet Explorer"，并找到"禁用更改主页设置"双击打开；勾选"已启用"，在"主页"内填写主页地址，我这里写的是bing国际版地址
![15380bfd6d7f7d4ff.png](https://s1.imagehub.cc/images/2023/10/11/15380bfd6d7f7d4ff.png)
- 验证环节
HQB1账户注销重新登录后，再次打开IE后，就可以看到IE主页已经变成了Bing，且Internet设置也无法更改IE主页
![4132b74838e75f975.png](https://s1.imagehub.cc/images/2023/10/11/4132b74838e75f975.png)

### 【8】禁止后勤部运行"计算器"程序
- 现在是可以正常运行计算器的
![10c5aa29215e08ee9.png](https://s1.imagehub.cc/images/2023/10/11/10c5aa29215e08ee9.png)
- 首先找到计算器的路径，找到后复制
一般都是`C:\windows\system32\calc.exe`
![2ebb4b7549511f235.png](https://s1.imagehub.cc/images/2023/10/11/2ebb4b7549511f235.png)
- 然后依次展开"用户配置"-"Windows设置"-"安全设置"
右击"软件限制策略"，点击"创建软件限制策略"，否则没有子文件夹
![3c6ead64fb10b2489.png](https://s1.imagehub.cc/images/2023/10/11/3c6ead64fb10b2489.png)
- 然后右击"其他规则"，点击"新建路径规则"
![4ed06b3909868b469.png](https://s1.imagehub.cc/images/2023/10/11/4ed06b3909868b469.png)
- 路径填写计算器程序的路径，安全级别选择"不允许"，描述选填
![6091bf9cafec8ec6c.png](https://s1.imagehub.cc/images/2023/10/11/6091bf9cafec8ec6c.png)
- 创建限制计算器程序完成
![561f6dd31611e155b.png](https://s1.imagehub.cc/images/2023/10/11/561f6dd31611e155b.png)
- 验收环节
Win+R输入`calc.exe`
![7ead6b40f2a16fb65.png](https://s1.imagehub.cc/images/2023/10/11/7ead6b40f2a16fb65.png)
- 提示"系统管理员已组织这个应用"
![7-2.png](https://s1.imagehub.cc/images/2023/10/11/7-2.png)
- 但是在桌面创建计算器链接或者使用"开始"-"Windows附件"的计算器还是可以打开
![11d768cb6486783c4.png](https://s1.imagehub.cc/images/2023/10/11/11d768cb6486783c4.png)
- 因为这个计算器是win32calc.exe，不是我们刚才限制的calc.exe程序
解决办法也很简单，再添加一条指向win32calc.exe的软件限制策略就可以了
![20ccff3144ec26b5c.png](https://s1.imagehub.cc/images/2023/10/11/20ccff3144ec26b5c.png)
- 添加指向win32calc.exe的软件限制策略
![139c37b2c5a80cb9c.png](https://s1.imagehub.cc/images/2023/10/11/139c37b2c5a80cb9c.png)
![269bee704a0a4b6b7.png](https://s1.imagehub.cc/images/2023/10/11/269bee704a0a4b6b7.png)
- HQB1账户重新登录后就会阻止启用计算器应用咯
![30bb7f451506c9b5d.png](https://s1.imagehub.cc/images/2023/10/11/30bb7f451506c9b5d.png)

### 【9】禁止后勤部用户使用命令提示符及批处理脚本
- 依次展开"用户配置"-"管理模板"-"控制面板"
然后点击"系统"，双击打开"组织访问命令提示符工具"，在"是否也要禁用命令提示符脚本处理"中选择"是"
![1b6b35a2e56efc803.png](https://s1.imagehub.cc/images/2023/10/11/1b6b35a2e56efc803.png)
- 验收环节
重新登录后，可以看到命令提示符已被禁用
![25f740117e4fc2a2a.png](https://s1.imagehub.cc/images/2023/10/11/25f740117e4fc2a2a.png)

### 【10】后勤部用户登录后隐藏C盘
- 现在可以正常看到C盘
![1ec4246018e891bfb.png](https://s1.imagehub.cc/images/2023/10/11/1ec4246018e891bfb.png)
- 依次展开"用户配置"-"管理模板"-"Windows组件"
[![2ab3c3a04e8f59b59.png](https://s1.imagehub.cc/images/2023/10/11/2ab3c3a04e8f59b59.png)](https://www.imagehub.cc/image/1rrkYe)
- 单击"文件资源管理器"，找到" 隐藏"我的电脑中这些指定的驱动器" "
勾选"已启用"，选择"仅限制驱动器C"
![18af97779d28bd240.png](https://s1.imagehub.cc/images/2023/10/11/18af97779d28bd240.png)
- 再次登录后，文件资源管理器中就看不到C盘了
![3cab92a9d45047dcf.png](https://s1.imagehub.cc/images/2023/10/11/3cab92a9d45047dcf.png)

### 【11】后勤部壁纸不能修改
- 把壁纸存放于wallpaper文件夹内，并设置为Everyone均能读取
![175de32881b72eba4.png](https://s1.imagehub.cc/images/2023/10/11/175de32881b72eba4.png)
- 复制共享路径
![2bf5b52d0bd599ead.png](https://s1.imagehub.cc/images/2023/10/11/2bf5b52d0bd599ead.png)
- 展开"用户配置"-"管理模板"-"桌面"
然后点击"桌面"，双击打开"桌面墙纸"，然后勾选"已启用"，墙纸名称填写标准UNC路径(下边有示例)，墙纸样式默认"居中"就好
![4bb2f3ada5abc59f3.png](https://s1.imagehub.cc/images/2023/10/11/4bb2f3ada5abc59f3.png)
- 设置不能更改桌面背景
展开"用户配置"-"管理模板"-"控制面板"
单击"个性化"，然后双击打开"阻止更改桌面背景"，勾选"已启用"
![67a84c9146ade6750.png](https://s1.imagehub.cc/images/2023/10/11/67a84c9146ade6750.png)
- 验收环节
重新登录后，壁纸已经变成了国旗的壁纸
![5e124d8dd8e46752a.png](https://s1.imagehub.cc/images/2023/10/11/5e124d8dd8e46752a.png)
- 点击"个性化"后，也会报错
![0.png](https://s1.imagehub.cc/images/2023/10/11/0.png)

### 【12】登录计算机自动创建Lnk
- 登录计算机时在桌面新建名为chinaskills的快捷方式
登录计算机时，在桌面新建名称为chinaskills的快捷方式，目标为https://www.skills.com，快捷键为Ctrl+Shift+F6
打开"服务器管理器"-"工具"-"组策略管理"
![76d15c208c1333dc6.png](https://s1.imagehub.cc/images/2023/10/09/76d15c208c1333dc6.png)
- 依次展开"林：www.ninework.com"-"域"-"www.ninework.com"
右键"Default Domain Policy"，点击"编辑"
![8728f2265ac1c41cc.png](https://s1.imagehub.cc/images/2023/10/09/8728f2265ac1c41cc.png)
- 依次展开"用户配置"-"首选项"-"Windows设置"
点击"快捷方式"，在空白区域右键，选择"新建"-"快捷方式"
![114514.png](https://s1.imagehub.cc/images/2023/10/09/114514.png)
1. 操作选择"创建"
2. 名称填写"chinaskills"
3. 目标类型选择"URL"
4. 位置选到桌面
5. 目标URL填写`https://www.skills.com`
6. 快捷键为Ctrl+Shift+F6，点击快捷键栏后，直接在键盘上按Ctrl+Shift+F6即可
![1d3ff94b1934beac8.png](https://s1.imagehub.cc/images/2023/10/09/1d3ff94b1934beac8.png)
![21c7c635aac561982.png](https://s1.imagehub.cc/images/2023/10/09/21c7c635aac561982.png)
- 效果：
![1365233011dcbccde.png](https://s1.imagehub.cc/images/2023/10/10/1365233011dcbccde.png)

### 【13】漫游用户配置文件
- 漫游用户配置文件微软技术文档解释：
传送门：[文件夹重定向、脱机文件和漫游用户配置文件概述](https://learn.microsoft.com/zh-cn/windows-server/storage/folder-redirection/folder-redirection-rup-overview "文件夹重定向、脱机文件和漫游用户配置文件概述")
> 漫游用户配置文件 将用户配置文件重定向到文件共享，以便用户可在多台计算机上检索相同的操作系统和应用程序设置。 当用户使用带有文件共享并共享为配置文件路径的帐户登录计算机时，用户的配置文件可加载到本地计算机，并与本地配置文件（如果有）合并。 当用户注销计算机时，其配置文件的本地副本（包括任何更改）将与配置文件的服务器副本合并。 通常，网络管理员会在域帐户上启用漫游用户策略文件。

- 为正在登录此计算机的所有用户设置漫游配置文件路径为windows1的C:\Roaming Profiles，每个用户提供单独的配置文件文件夹
创建好Roaming Profiles文件夹后，右键打开属性
![1ecddb38f3843ca27.png](https://s1.imagehub.cc/images/2023/10/09/1ecddb38f3843ca27.png)
- 点击"高级共享"
![2dca4d00488b47ca3.png](https://s1.imagehub.cc/images/2023/10/09/2dca4d00488b47ca3.png)
- 点击"权限"
![331ad65160477907c.png](https://s1.imagehub.cc/images/2023/10/09/331ad65160477907c.png)
Everyone组勾选"完全控制"
![4f2b78013712ca59d.png](https://s1.imagehub.cc/images/2023/10/09/4f2b78013712ca59d.png)
- 依次展开"计算机配置"-"管理模板"-"系统"-"用户配置文件"
双击打开"为正在登录此计算机的所有用户设置漫游配置文件路径"
![5dc1cf61ddf4a910b.png](https://s1.imagehub.cc/images/2023/10/09/5dc1cf61ddf4a910b.png)
- 勾选"已启用"
选项路径填写`C:\Roaming Profiles`
![6aa12246036eb2f31.png](https://s1.imagehub.cc/images/2023/10/09/6aa12246036eb2f31.png)

### 【14】文件夹重定向
- 每个用户的“文档”文件夹重定向到 windows1 的 C:\documents，为每一 用户创建一个文件夹
文件夹重定向微软技术文档解释：
传送门：[文件夹重定向、脱机文件和漫游用户配置文件概述](https://learn.microsoft.com/zh-cn/windows-server/storage/folder-redirection/folder-redirection-rup-overview "文件夹重定向、脱机文件和漫游用户配置文件概述")
> 文件夹重定向 可让管理员手动或通过使用组策略将已知的文件夹路径重定向到新的位置。 新位置可以是本地计算机上的文件夹，也可以是文件共享上的目录。 用户可与重定向的文件夹中的文件交互，犹如它依然存在于本地驱动器上。 例如，你可将文档文件夹（通常存储在本地驱动器上）重定向到网络位置。 这样，网络中任何计算机的用户就都可以使用该文件夹中的文件。

- 创建好documents文件夹后，右键点击"属性"-"共享"
![18655fc60cf8d1bc9.png](https://s1.imagehub.cc/images/2023/10/10/18655fc60cf8d1bc9.png)
- 勾选"共享此文件夹"，然后点击"权限"
![2.png](https://s1.imagehub.cc/images/2023/10/10/2.png)
- Everyone组勾选"完全控制"
![3.png](https://s1.imagehub.cc/images/2023/10/10/3.png)
- 打开"服务器管理器"-"工具"-"组策略管理"
[![4.png](https://s1.imagehub.cc/images/2023/10/10/4.png)](https://www.imagehub.cc/image/1frmQZ)
- 依次展开"林：www.ninework.com"-"域"-"www.ninework.com"
右键"Default Domain Policy"，点击"编辑"
![5.png](https://s1.imagehub.cc/images/2023/10/10/5.png)
- 依次展开"用户配置"-"Windows设置"-"文件夹重定向"
![6.png](https://s1.imagehub.cc/images/2023/10/10/6.png)
- 右键"文档"，点击"属性"
![7.png](https://s1.imagehub.cc/images/2023/10/10/7.png)
- "设置"选择"基本 - 将每个人的文件夹重定向到同一个位置"
![8.png](https://s1.imagehub.cc/images/2023/10/10/8.png)
- 根路径填写`\\server1\C:\document`，如果你直接填写C:\documents的话，那么就会报错<font color=red>"目标路径不是UNC路径"</font>
<font color=red>标准根路径格式：</font>`\\PC Name\Path`
![9.png](https://s1.imagehub.cc/images/2023/10/10/9.png)
- 报错<font color=red>"目标路径不是UNC路径"</font>
![108ff80a5e912a4cf.png](https://s1.imagehub.cc/images/2023/10/10/108ff80a5e912a4cf.png)
- 点击"是"
[![105c46f5f85c33ab35.png](https://s1.imagehub.cc/images/2023/10/10/105c46f5f85c33ab35.png)](https://www.imagehub.cc/image/1fb5Tt)

<u>**额外说明：**</u>
> <font color=red>漫游配置文件是将配置文件在服务器中做了备份</font>，而<font color=red>文件夹重定向则是直接将配置文件存储在了服务器中</font>。这两种方式孰优孰劣呢？
我们可以试想一下，如果域用户在配置文件中放置的数据量很大，那么采用漫游配置文件的方式，就会造成域用户登录和注销的速度变得很慢，而文件夹重定向则不会出现这样的问题。因而在实践应用中，还是文件夹重定向更具备可操作性。
最后总结一下，文件夹重定向的作用主要体现在以下两个方面：
>- 一是可以利用该功能对相关文件或者文件夹进行统一备份。由于把分散在各个主机上的文件都重定向到一台服务器上，如此管理员只需要对这台服务器的文件夹进行备份，就可以达到对员工各台电脑的资料进行备份的目的，从而保障数据的安全。
>- 二是用户访问文件夹的位置将不受限制。若桌面或者我的文档等资料保存在本地的话，则用户只有登录本机才能够访问这些文件。而对文件夹进行重定向之后，则只需要员工登录到域，就都可以访问此文件夹。


"额外说明参考资料"：[51-CTO：在AD中设置漫游配置文件与文件夹重定向](https://blog.51cto.com/yttitan/2061840 "51-CTO：在AD中设置漫游配置文件与文件夹重定向")

### 【15】新建GPO并应用到用户
- 新建一个manager00 GPO,并将此GPO应用于manager0用户
新建docshare文件夹
![0-1.png](https://s1.imagehub.cc/images/2023/10/10/0-1.png)
- Everyone组勾选"完全控制"
![0-2.png](https://s1.imagehub.cc/images/2023/10/10/0-2.png)
- 打开"服务器管理器"-"工具"-"AD用户和计算机"创建manager0用户
![1-0.png](https://s1.imagehub.cc/images/2023/10/10/1-0.png)

![1-1.png](https://s1.imagehub.cc/images/2023/10/10/1-1.png)
![1-2.png](https://s1.imagehub.cc/images/2023/10/10/1-2.png)
- 打开"服务器管理器"-"工具"-"组策略管理"
组策略管理CMD命令`gpmc.msc`

![Snipaste_2023-10-10_16-42-05.png](https://s1.imagehub.cc/images/2023/10/10/Snipaste_2023-10-10_16-42-05.png)
- 右键"www.ninework.com"，点击"在这个域中创建GPO并在此处链接"
![2bf891c522634e608.png](https://s1.imagehub.cc/images/2023/10/10/2bf891c522634e608.png)
- 名称输入`manager00`
![Snipaste_2023-10-10_16-46-18.png](https://s1.imagehub.cc/images/2023/10/10/Snipaste_2023-10-10_16-46-18.png)
- 选择到"manager00"，然后点击"添加"
![1-3.png](https://s1.imagehub.cc/images/2023/10/10/1-3.png)
- 输入manager0用户，并点击"检查名称"
![1-4.png](https://s1.imagehub.cc/images/2023/10/10/1-4.png)
- 右键"manager00"GPO，点击"编辑"
![33fcaf5ff07c0be8d.png](https://s1.imagehub.cc/images/2023/10/10/33fcaf5ff07c0be8d.png)
- 依次展开"用户配置"-"首选项"-"Windows设置"
选到"驱动器映射"，然后右键空白处，选择"新建"-"映射驱动器"
![440f53163fc8c47f9.png](https://s1.imagehub.cc/images/2023/10/10/440f53163fc8c47f9.png)
1. 操作选择"更新"
2. 位置写`\\server\C:\docshare`
3. 使用"Z"驱动器号
4. 隐藏/显示此驱动器选择"无更改"
5. 隐藏/显示所有驱动器选择"无更改"
![569e9f028d3a8563f.png](https://s1.imagehub.cc/images/2023/10/10/569e9f028d3a8563f.png)

### 【16】林中主机自动安装软件
- 部署软件 powershell7，让林中主机账户在登录时自动安装powershell
在C盘创建soft文件夹，并共享至Everyone组完全控制
![1ac2f45f32e5f3e7c.png](https://s1.imagehub.cc/images/2023/10/10/1ac2f45f32e5f3e7c.png)
- 复制PowerShell7安装程序至soft文件夹内
![250e352c8f3031f40.png](https://s1.imagehub.cc/images/2023/10/10/250e352c8f3031f40.png)
- 然后复制网络路径
![1e84752c3d8d7890b.png](https://s1.imagehub.cc/images/2023/10/10/1e84752c3d8d7890b.png)
- 组策略管理中，右键Default Domain Policy，点击"编辑"
![2b1d9e43baa0c026c.png](https://s1.imagehub.cc/images/2023/10/10/2b1d9e43baa0c026c.png)
- 展开"用户配置"-"策略"-"软件设置"
右键"软件安装"，点击"属性"
在"默认程序数据包位置"中，输入刚刚复制的"soft"文件夹网络位置
其他配置Default
![4329a1105bc714849.png](https://s1.imagehub.cc/images/2023/10/10/4329a1105bc714849.png)
- 在空白处右键，选择"新建"-"数据包"
![18405665e87e10d15.png](https://s1.imagehub.cc/images/2023/10/10/18405665e87e10d15.png)
- 选到需要自动安装的msi包，需要使用".msi"格式的安装程序
![1be260a59661432b2.png](https://s1.imagehub.cc/images/2023/10/10/1be260a59661432b2.png)
- 部署方法选择"已发布"
![242a95b9da4d10840.png](https://s1.imagehub.cc/images/2023/10/10/242a95b9da4d10840.png)
- 来源显示的是`\\server1`开头的才是正确的，否则本域中其他主机C盘中没有soft文件夹以及msi包，就无法完成自动安装msi包
![3928425865a4e1f9f.png](https://s1.imagehub.cc/images/2023/10/10/3928425865a4e1f9f.png)
- 这时候其他主机还是无法自动安装msi，因为没有开启"在登录时自动安装此应用程序"以及未分配
![1c454ffc9d1628c99.png](https://s1.imagehub.cc/images/2023/10/10/1c454ffc9d1628c99.png)
- 然后再将此任务分配，右键刚才创建的数据包，然后点击"分配"(我这里点过了，才会变成灰色的)
![301092d943cfb0b67.png](https://s1.imagehub.cc/images/2023/10/10/301092d943cfb0b67.png)
- 然后还需要更新组策略
输入`gpupdate /force`强制更新组策略
然后等待10秒后出现是否注销更新组策略决策，输入`y`重新启动
![4f365a35d4aac85e9.png](https://s1.imagehub.cc/images/2023/10/10/4f365a35d4aac85e9.png)
- 重启完成后，域控制器会显示此界面：
![Snipaste_2023-10-10_18-24-13.png](https://s1.imagehub.cc/images/2023/10/10/Snipaste_2023-10-10_18-24-13.png)
- msi包将在域中其他主机账户下次登录时自动安装
<font color=red>在登录时要以域账户登录，否则无法安装msi包，就比如你是以普通的administrator用户登录的，就无法自动安装msi包，因为administrator不属于域</font>
![Snipaste_2023-10-10_19-48-37.png](https://s1.imagehub.cc/images/2023/10/10/Snipaste_2023-10-10_19-48-37.png)
- 以域账户登录后，就开始自动安装托管软件咯
安装完成后，就会自动进入系统了
![Snipaste_2023-10-10_19-42-37.png](https://s1.imagehub.cc/images/2023/10/10/Snipaste_2023-10-10_19-42-37.png) 

组策略配置参考资料：
1. [CSDN-windows server 2012R 组策略](https://blog.csdn.net/qq_45031509/article/details/127395104?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169693589016800197029360%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=169693589016800197029360&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-127395104-null-null.142^v95^insert_down28v1&utm_term=Windows%20server%E7%BB%84%E7%AD%96%E7%95%A5&spm=1018.2226.3001.4187 "windows server 2012R 组策略")
2. [CSDN-【Windows Server 2019】组策略的配置与管理——配置基于本地的组策略](https://blog.csdn.net/NOWSHUT/article/details/108354392?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169702610316800227479507%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=169702610316800227479507&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-4-108354392-null-null.142^v96^pc_search_result_base9&utm_term=Windows%20server%E7%BB%84%E7%AD%96%E7%95%A5&spm=1018.2226.3001.4187 "CSDN-【Windows Server 2019】组策略的配置与管理——配置基于本地的组策略")
3. [CSDN-【Windows Server 2019】组策略的配置与管理——理论基础](https://blog.csdn.net/NOWSHUT/article/details/108354391?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169702610316800227479507%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=169702610316800227479507&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-108354391-null-null.142^v96^pc_search_result_base9&utm_term=Windows%20server%E7%BB%84%E7%AD%96%E7%95%A5&spm=1018.2226.3001.4187 "CSDN-【Windows Server 2019】组策略的配置与管理——理论基础")
4. [CSDN-【Windows Server 2019】组策略的配置与管理——配置基于域的组策略（上）基础配置示例](https://blog.csdn.net/NOWSHUT/article/details/108425129?ops_request_misc=&request_id=&biz_id=102&utm_term=Windows%20server%E7%BB%84%E7%AD%96%E7%95%A5&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-3-108425129.nonecase&spm=1018.2226.3001.4187 "CSDN-【Windows Server 2019】组策略的配置与管理——配置基于域的组策略（上）基础配置示例")
5. [Microsoft-文件夹重定向、脱机文件和漫游用户配置文件概述](https://learn.microsoft.com/zh-cn/windows-server/storage/folder-redirection/folder-redirection-rup-overview "Microsoft-文件夹重定向、脱机文件和漫游用户配置文件概述")
6. [Microsoft-使用组策略实现文件夹重定向](https://learn.microsoft.com/zh-cn/windows-server/storage/folder-redirection/folder-redirection-using-group-policy "Microsoft-使用组策略实现文件夹重定向")
7. [Microsoft-Installing PowerShell on Windows](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3&viewFallbackFrom=powershell-7&WT.mc_id=THOMASMAURER-blog-thmaure "Microsoft-Installing PowerShell on Windows")
8. [Microsoft-如何销毁 GPO](https://learn.microsoft.com/zh-cn/microsoft-desktop-optimization-pack/agpm/destroy-a-gpo-agpm30ops "Microsoft-如何销毁 GPO")
9. [Microsoft-Windows 系统中的文件路径格式](https://learn.microsoft.com/zh-cn/dotnet/standard/io/file-path-formats#unc-paths "Microsoft-Windows 系统中的文件路径格式")
10. [Microsoft-查看GPO设置](https://learn.microsoft.com/zh-cn/microsoft-desktop-optimization-pack/agpm/review-gpo-settings "Microsoft-查看GPO设置")
11. [51-CTO-WINDOWS SERVER 2003 组策略应用](https://blog.51cto.com/20120720/1351739 "51-CTO-WINDOWS SERVER 2003 组策略应用")
12. [51-CTO-在AD中设置漫游配置文件与文件夹重定向](https://blog.51cto.com/yttitan/2061840 "51-CTO-在AD中设置漫游配置文件与文件夹重定向")
13. [博客园-UNC路径](https://www.cnblogs.com/timlong/p/9991564.html "博客园-UNC路径")

# 【11】Tomcat+Java环境配置😑
**Tomcat简介：**
Tomcat是Apache软件基金会（Apache Software Foundation）的Jakarta 项目中的一个核心项目，由Apache、Sun和其他一些公司及个人共同开发而成。由于有了Sun 的参与和支持，最新的Servlet和JSP规范总是能在Tomcat 中得到体现，Tomcat 5支持最新的Servlet 2.4 和JSP 2.0 规范。因为Tomcat技术先进、性能稳定，而且免费，因而深受Java爱好者的喜爱并得到了部分软件开发商的认可，成为目前比较流行的Web应用服务器。
简单来说:Tomcat服务器是一个免费的开放源代码的Web应用服务器,由java语言编写，属于轻量级应用服务器，在中小型系统和并发访问用户不是很多的场合下被普遍使用，是开发和调试JSP程序的首选。对于一个初学者来说，可以这样认为，当在一台机器上配置好Apache服务器，可利用它响应HTML页面的访问请求。实际上Tomcat是Apache服务器的扩展，但运行时它是独立运行的，所以当你运行tomcat时，它实际上作为一个与Apache独立的进程单独运行的。

传送门：
[Tomcat官网](https://tomcat.apache.org/ "Tomcat官网")
[Java8-download](https://www.java.com/en/download/ "Java8-download")
[Java11-download](https://www.oracle.com/cn/java/technologies/javase/jdk11-archive-downloads.html "Java11-download")
[Java21-download](https://www.oracle.com/cn/java/technologies/downloads/#jdk21-windows "Java21-download")
## 【1】安装Java环境
- 下载java时，要看你的Tomcat版本，如果你的Tomcat版本为9.0.*版本，那对应的java版本就是java8及以上
![0.png](https://s1.imagehub.cc/images/2023/10/15/0.png)
![1.png](https://s1.imagehub.cc/images/2023/10/15/1.png)
- 测试java是否配置成功
cmd命令：`java -version`
![2.png](https://s1.imagehub.cc/images/2023/10/15/2.png)

## 【2】配置环境变量
- 右键"此电脑"，选择"属性"
![3.png](https://s1.imagehub.cc/images/2023/10/15/3.png)
- 点击右边的"高级系统设置"
![4.png](https://s1.imagehub.cc/images/2023/10/15/4.png)
- 点击"环境变量"
![5.png](https://s1.imagehub.cc/images/2023/10/15/5.png)

**1-新建Administrator用户变量**
- 在"Administrator用户变量"内，新建变量，点击"新建"
![6.png](https://s1.imagehub.cc/images/2023/10/15/6.png)
- 变量名命名为`JAVA_HOME`
变量值指向jdk-11的安装路径
![7.png](https://s1.imagehub.cc/images/2023/10/15/7.png)
- 我的安装路径就是`C:\Program Files\Java\jdk-11`
![18.png](https://s1.imagehub.cc/images/2023/10/15/18.png)

**2-新建系统变量**
- 在"系统变量"内点击"新建"
![19.png](https://s1.imagehub.cc/images/2023/10/15/19.png)
- 变量名填写`CLASSPATH`，变量值填写`;%JAVA_HOME\lib;%JAVA_HOME%\lib\tools.jar`
![20.png](https://s1.imagehub.cc/images/2023/10/16/20.png)

## 【3】安装Tomcat
- 我的Tomcat版本是Tomcat9.0.82-32-bit/64-bit Windows Service Installer
![00.png](https://s1.imagehub.cc/images/2023/10/15/00.png)
- 安装Tomcat
![21.png](https://s1.imagehub.cc/images/2023/10/15/21.png)
![22.png](https://s1.imagehub.cc/images/2023/10/15/22.png)
![23.png](https://s1.imagehub.cc/images/2023/10/15/23.png)
![32.png](https://s1.imagehub.cc/images/2023/10/16/32.png)
![25.png](https://s1.imagehub.cc/images/2023/10/15/25.png)
![33.png](https://s1.imagehub.cc/images/2023/10/16/33.png)
![34.png](https://s1.imagehub.cc/images/2023/10/16/34.png)
## 【4】配置Tomcat
- 浏览器地址栏内输入本机IP地址+端口号或输入`localhost`+端口号访问本地Tomcat网页
![26.png](https://s1.imagehub.cc/images/2023/10/15/26.png)
- 点击右侧的"Manager App"
![27.png](https://s1.imagehub.cc/images/2023/10/15/27.png)
- 这时候显示403-"您无权查看此页面"
然后复制Tomcat给出的示例用户代码
![38.png](https://s1.imagehub.cc/images/2023/10/16/38.png)
- 然后打开Tomcat的用户配置文件路径，默认路径一般是`C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf`
然后用记事本打开`tomcat-users.xml`
![39.png](https://s1.imagehub.cc/images/2023/10/16/39.png)
- 在左图蓝框内添加Tomcat的示例用户代码
右图绿线处的是用户名，紫线处是密码![37-1.png](https://s1.imagehub.cc/images/2023/10/16/37-1.png)
- 输入你的用户名及密码
![40.png](https://s1.imagehub.cc/images/2023/10/16/40.png)
- 用户名及密码正确的话，就会进入到Tomcat的管理网页
![30.png](https://s1.imagehub.cc/images/2023/10/16/30.png)
- 然后创建Tomcat站点主页文件，在里边随便写点内容
![29.png](https://s1.imagehub.cc/images/2023/10/16/29.png)
- "context路径"填写斜杠+英文
"WAR文件或文件夹路径"填写index.html的路径
最后点击部署即可
![31.png](https://s1.imagehub.cc/images/2023/10/16/31.png)
- 这时候就可以看到刚刚部署的"/a"
![41.png](https://s1.imagehub.cc/images/2023/10/16/41.png)
- 然后停止"/"，点击"停止"即可
![42.png](https://s1.imagehub.cc/images/2023/10/16/42.png)
## 【5】验收环节
- 浏览器地址栏输入
`http://192.168.10.163:8080/a`
或`http://localhost:8080/a`
![43.png](https://s1.imagehub.cc/images/2023/10/16/43.png)
## 【6】更改监听端口
- 更改监听端口要修改conf文件夹内的`server.xml`
![44.png](https://s1.imagehub.cc/images/2023/10/16/44.png)
- 找到69行
然后把`8080`端口修改为你喜欢的端口就好
![45.png](https://s1.imagehub.cc/images/2023/10/16/45.png)
- 然后重启Tomcat服务
![46-1.png](https://s1.imagehub.cc/images/2023/10/16/46-1.png)
- 浏览器地址栏内输入新的端口号+Context路径即可访问到Tomcat站点
![47.png](https://s1.imagehub.cc/images/2023/10/16/47.png)

# 【12】DHCP服务器配置😪
**1.DHCP概述：** 
DHCP(Dynamic Host  Configuration Protocol),动态主机配置协议，是一个应用层协议。当我们将客户主机ip地址设置为动态获取方式时，DHCP服务器就会根据DHCP协议给客户端分配IP，使得客户机能够利用这个IP上网。专门用于为TCP/IP网络中的计算机自动分配TCP/IP参数的协议。

**2.DHCP的特点：**
- DHCP可以自动分配IP、子网掩码、网关、DNS。
- DHCP客户端使用的端口68，服务端使用端口67，使用的UDP传输协议。
- DHCP分配的IP地址有租期，会周期性改变。一般不为服务器分配IP，因为他们要使用固定IP，所以DHCP一般只为办公环境的主机分配IP。
- DHCP服务器和客户端需要在一个局域网内，在为客户端分配IP的时候需要进行多次广播。但DHCP也可以为其他网段内主机分配IP，只要连接两个网段中间的路由器能转发DHCP配置请求即可，但这要求路由器配置中继功能。 

**3.DHCP工作原理：**
1. 客户端广播发送DISCOVER报文寻找服务端；
2. 服务端广播发送OFFER报文响应给客户端，报文中还包含地址池中的一个可用IP；
3. 客户端只会接收第一个发来的OFFER报文并提取出可用IP,再向服务端广播发送REQUEST报文请求使用这个可用IP。
4. 服务端广播发送ACK报文响应给客户端，告知IP合法可用并提供租期信息。
![DHCP.png](https://s1.imagehub.cc/images/2023/10/18/DHCP.png)

## 【1】环境介绍
**使用VMware Workstation Pro version17仅主机模式进行实验**
|主机名称|IP|扮演角色|系统版本|
|---|---|---|---|
|server1|192.168.154.10|DHCP Server|Windows Server 2022 Standard|
|server2|DHCP获取|DHCP Client|Windows Server 2022 Standard|

## 【2】VM网络配置
- 打开VM，点击"编辑"-"虚拟网络适配器"
![4.png](https://s1.imagehub.cc/images/2023/10/23/4.png)
- 点击下面的"更改设置"
![5.png](https://s1.imagehub.cc/images/2023/10/23/5.png)
- 由于我的虚拟机当前是VMNet1仅主机模式，所以只需要把VMNet1仅主机模式的DHCP功能取消即可
选择到"VMNet1 仅主机模式"，把"使用本地DHCP服务将IP地址分配给虚拟机"取消选择
![6.png](https://s1.imagehub.cc/images/2023/10/23/6.png)

## 【3】server1配置
- 修改主机名为"server1"
![1135ba37d8952f036.png](https://s1.imagehub.cc/images/2023/10/18/1135ba37d8952f036.png)
- 网卡配置为静态IP
![28.png](https://s1.imagehub.cc/images/2023/10/24/28.png)

## 【4】server2配置
- 修改计算机名称为server2
![47.png](https://s1.imagehub.cc/images/2023/10/24/47.png)
- 网卡配置修改为DHCP获取
![48.png](https://s1.imagehub.cc/images/2023/10/24/48.png)

## 【5】安装DHCP功能
![910d4f1e8ac8aaab0.png](https://s1.imagehub.cc/images/2023/10/23/910d4f1e8ac8aaab0.png)
![3db3a81280ed3cd2c.png](https://s1.imagehub.cc/images/2023/10/18/3db3a81280ed3cd2c.png)

## 【6】完成DHCP配置
- 在"服务器管理器"-"通知"中，完成DHCP配置
![83a80803a4c06b7e2.png](https://s1.imagehub.cc/images/2023/10/23/83a80803a4c06b7e2.png)
- 点击"提交"
![10173686d12bc36eff.png](https://s1.imagehub.cc/images/2023/10/23/10173686d12bc36eff.png)
- 点击"关闭"即可
![11ea4ca2234571b609.png](https://s1.imagehub.cc/images/2023/10/23/11ea4ca2234571b609.png)

## 【7】配置DHCP服务
- 打开"服务器管理器"-"DHCP"
![125024058f045fda81.png](https://s1.imagehub.cc/images/2023/10/23/125024058f045fda81.png)
- 点击"server1"左边的小箭头，展开server1
![14.png](https://s1.imagehub.cc/images/2023/10/23/14.png)
- 在"IPv4"中，右键，点击"新建作用域"
![13d985f9acecd30921.png](https://s1.imagehub.cc/images/2023/10/23/13d985f9acecd30921.png)
- 点击"下一步"
![15.png](https://s1.imagehub.cc/images/2023/10/23/15.png)
- 名称和描述随便写
![16.png](https://s1.imagehub.cc/images/2023/10/23/16.png)
- 填写DHCP分配池的起始IP地址及结束IP地址，我这里是`190`到`240`共计51个IP地址
![29.png](https://s1.imagehub.cc/images/2023/10/24/29.png)
- 填写要排除DHCP的起始IP及结束IP，这些IP不会被用作DHCP分配
如果没有要排除的IP地址，直接点击"下一步"即可
![30.png](https://s1.imagehub.cc/images/2023/10/24/30.png)
- 设置DHCP租期，默认值为8天
![20.png](https://s1.imagehub.cc/images/2023/10/23/20.png)
- 选择"是，我想现在配置这些选项"
![21.png](https://s1.imagehub.cc/images/2023/10/23/21.png)
- 填写默认网关，填写完毕后，点击右侧的"添加"，点击"添加"之后才会使用该地址作为DHCP默认网关
![31.png](https://s1.imagehub.cc/images/2023/10/24/31.png)
[![32.png](https://s1.imagehub.cc/images/2023/10/24/32.png)](https://www.imagehub.cc/image/1MAUF4)
- 这里我们如果没有父域可以不填写
![34.png](https://s1.imagehub.cc/images/2023/10/24/34.png)
- 直接点击"下一步"
![24.png](https://s1.imagehub.cc/images/2023/10/23/24.png)
- 选择"是，我想现在激活此作用域"
![25.png](https://s1.imagehub.cc/images/2023/10/23/25.png)
- 点击"完成"即可
![26.png](https://s1.imagehub.cc/images/2023/10/23/26.png)
## 【8】验收环节
- DHCP客户端网卡设置为自动获取
![35.png](https://s1.imagehub.cc/images/2023/10/24/35.png)
- 如果没反应那就重启或者输入`ipconfig /renew`
还不行？
那就重新检查DHCP服务配置、VM网卡环境配置、关闭防火墙/开放Server 67端口及Client 68端口或者直接推倒重来
我当前没有并关闭防火墙及开放67、68端口
![36.png](https://s1.imagehub.cc/images/2023/10/24/36.png)
![49-1.md.png](https://s1.imagehub.cc/images/2023/10/24/49-1.md.png)
- 在"DHCP管理器"-"作用域"-"地址租用"中，也可以看到DHCP客户端列表
![37.png](https://s1.imagehub.cc/images/2023/10/24/37.png)

## 【9】备份及还原DHCP服务器
- 右键server1，选择"备份"
![38.png](https://s1.imagehub.cc/images/2023/10/24/38.png)
- 选择备份路径
默认备份路径为`C:\Windows\System32\dhcp\backup`
![39.png](https://s1.imagehub.cc/images/2023/10/24/39.png)
- 当我们"不小心"删除DHCP配置后
![40.png](https://s1.imagehub.cc/images/2023/10/24/40.png)
- 右键server1，选择"还原"
![41.png](https://s1.imagehub.cc/images/2023/10/24/41.png)
- 选择DHCP配置备份文件夹
![42.png](https://s1.imagehub.cc/images/2023/10/24/42.png)
- 点击"是"
![43.png](https://s1.imagehub.cc/images/2023/10/24/43.png)
- 等待20-30秒...
![44.png](https://s1.imagehub.cc/images/2023/10/24/44.png)
- 显示"数据库已成功还原"
![45.png](https://s1.imagehub.cc/images/2023/10/24/45.png)
- "IPv4"显示为绿色就代表DHCP配置还原成功
![46.png](https://s1.imagehub.cc/images/2023/10/24/46.png)

## 【10】相关命令
1. **所有以DHCP形式获取IP的网卡释放IP地址**
`ipconfig /release`
2. **指定网卡释放IP**
`ipconfig /release Ethernet0`
3. **所有网卡重新获取IP**
`ipconfig /renew`
4. **指定网卡获取IP**
`ipconfig /renew Ethernet0`
5. **显示所有当前的网络配置值，并刷新DHCP和DNS设置**
`ipconfig`
6. **刷新DNS缓存**
`ipconfig /flushdns`

参考资料：
[知乎-DHCP协议详解](https://zhuanlan.zhihu.com/p/265293856 "知乎-DHCP协议详解")
[博客园-Windows Server 2016-三种方法备份还原DHCP服务器](https://www.cnblogs.com/wenzhongxiang/p/10350566.html "博客园-Windows Server 2016-三种方法备份还原DHCP服务器")
[CSDN-Windows怎么让防火墙开放端口👍](https://blog.csdn.net/qq754772661/article/details/110876957 "CSDN-Windows怎么让防火墙开放端口")
[CSDN-Windows server： 服务器 DHCP 服务，安装，配置👍👍](https://blog.csdn.net/w14768855/article/details/128841179?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169804079516800182139886%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=169804079516800182139886&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-128841179-null-null.142^v96^pc_search_result_base9&utm_term=Windows%20server%20dhcp&spm=1018.2226.3001.4187 "CSDN-Windows server： 服务器 DHCP 服务，安装，配置")
[CSDN-Windows server——部署DHCP服务（2）](https://blog.csdn.net/yj11290301/article/details/128630925?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169804079516800182139886%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=169804079516800182139886&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-128630925-null-null.142^v96^pc_search_result_base9&utm_term=Windows%20server%20dhcp&spm=1018.2226.3001.4187 "CSDN-Windows server——部署DHCP服务（2）")
[Microsoft-DHCP (Dynamic Host Configuration Protocol) Basics](https://learn.microsoft.com/en-us/windows-server/troubleshoot/dynamic-host-configuration-protocol-basics?source=recommendations "Microsoft-DHCP (Dynamic Host Configuration Protocol) Basics")
[Microsoft-How To Install and Configure a DHCP Server in a Workgroup](https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/install-configure-dhcp-server-workgroup "Microsoft-How To Install and Configure a DHCP Server in a Workgroup")
[Microsoft-Dynamic Host Configuration Protocol (DHCP)](https://learn.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-top "Microsoft-Dynamic Host Configuration Protocol (DHCP)")
[Microsoft-使用DHCP简化IP配置👍👍👍](https://learn.microsoft.com/zh-cn/training/modules/deploy-manage-dynamic-host-configuration-protocol/2-use-dynamic-host-configuration-protocol-simplify-ip-configuration "Microsoft-使用DHCP简化IP配置")

# 【13】DHCP故障转移群集😴
**DHCP简介：**
动态主机配置协议DHCP（Dynamic Host Configuration Protocol）是一种网络管理协议，用于集中对用户IP地址进行动态管理和配置
DHCP于1993年10月成为标准协议，其前身是BOOTP协议。DHCP协议由RFC 2131定义，采用客户端/服务器通信模式，由客户端（DHCP Client）向服务器（DHCP Server）提出配置申请，DHCP Server为网络上的每个设备动态分配IP地址、子网掩码、默认网关地址，域名服务器（DNS）地址和其他相关配置参数，以便可以与其他IP网络通信

**环境介绍：**
使用VMware Workstation Pro Version17 仅主机模式进行实验
|计算机名称|IP地址|扮演角色|
|---|---|---|
|server1|192.168.154.10|DHCP故障转移群集server1|
|server2|192.168.154.20|DHCP故障转移群集server2|
|DHCP-Client|DHCP获取|DHCP故障转移群集客户端|

## 【1】VM网卡配置
- 取消勾选"使用本地DHCP服务将IP地址分配给虚拟机"
![0.png](https://s1.imagehub.cc/images/2023/10/26/0.png)

## 【2】server1配置
- 修改server1计算机名为server1
![1d848a71c5b712a4b.png](https://s1.imagehub.cc/images/2023/10/26/1d848a71c5b712a4b.png)
- 修改server1网卡配置
![2dd12fa63db3b5cd4.png](https://s1.imagehub.cc/images/2023/10/26/2dd12fa63db3b5cd4.png)
- 安装DHCP服务
![3c769a7d631180a7d.png](https://s1.imagehub.cc/images/2023/10/26/3c769a7d631180a7d.png)
- 完成DHCP服务配置
![6.png](https://s1.imagehub.cc/images/2023/10/26/6.png)
![7-2.png](https://s1.imagehub.cc/images/2023/10/26/7-2.png)
![8.png](https://s1.imagehub.cc/images/2023/10/26/8.png)

## 【2】server2配置
- 修改server2计算机名为server2
![4d4bcfd62f0093a92.png](https://s1.imagehub.cc/images/2023/10/26/4d4bcfd62f0093a92.png)
- 修改server2网卡配置
![5.png](https://s1.imagehub.cc/images/2023/10/26/5.png)
- server2安装DHCP服务
![9.png](https://s1.imagehub.cc/images/2023/10/26/9.png)
- 完成server2 DHCP配置
![106bef12add87aec4d.png](https://s1.imagehub.cc/images/2023/10/26/106bef12add87aec4d.png)

## 【3】DHCP-Client配置
- 更改计算机名称为"DHCP-Client"
![250193b67e41d39e65.png](https://s1.imagehub.cc/images/2023/10/26/250193b67e41d39e65.png)
- 更改网卡配置为自动获取
![2650182c096ceb3999.png](https://s1.imagehub.cc/images/2023/10/26/2650182c096ceb3999.png)

## 【4】DHCP服务配置
- server1打开"服务器管理器"-"工具"-"DHCP"
![11460ea7526a7416c0.png](https://s1.imagehub.cc/images/2023/10/26/11460ea7526a7416c0.png)
- 配置DHCP起始IP及结束IP
![124a46be923326a68e.png](https://s1.imagehub.cc/images/2023/10/26/124a46be923326a68e.png)
- 设置DHCP租期为2小时
![131a7c1f37d6107ec9.png](https://s1.imagehub.cc/images/2023/10/26/131a7c1f37d6107ec9.png)
- 设置`192.168.154.254`为DHCP网关
![14b051bc330b43a5e4.png](https://s1.imagehub.cc/images/2023/10/26/14b051bc330b43a5e4.png)
- DHCP作用域配置完成
![157a52382491b19ca9.png](https://s1.imagehub.cc/images/2023/10/26/157a52382491b19ca9.png)

## 【5】DHCP故障转移配置
- 右键DHCP作用域，选择"配置故障转移"
![1632ad44a95238cc48.png](https://s1.imagehub.cc/images/2023/10/26/1632ad44a95238cc48.png)
- 点击"下一步"
![174227b9c7796b3c7c.png](https://s1.imagehub.cc/images/2023/10/26/174227b9c7796b3c7c.png)
- 输入server2 IP地址
⛔需要注意的是，DHCP故障转移对时间很敏感。如果伙伴之间的时差大于1分钟，故障转移过程会因关键错误而停止
解决办法也很简单，只需要把两台服务器设置为同时间即可
![18348d689d363bab08.png](https://s1.imagehub.cc/images/2023/10/26/18348d689d363bab08.png)
- "关系名称"显示的是server2的IP地址才对
模式选择"热备用服务器"

|DHCP故障转移模式|模式特征|
|---|---|
|负载均衡|这是默认模式。在此模式下，两个服务器同时向客户端提供IP配置。哪个服务器响应IP配置请求取决于管理员如何配置负载分布比率。默认比率为50:50。|
|热备用服务器|在此模式下，一个服务器是主服务器，另一个是辅助服务器。主服务器主动为范围或子网分配IP配置。仅当主服务器不可用时，辅助DHCP服务器才担任这一角色。DHCP服务器可充当一个范围或子网的主服务器，同时充当另一范围或子网的辅助服务器。热备用服务器模式最适用于灾难恢复站点位于不同位置的部署。这样一来，DHCP服务器将不会为客户端提供服务，除非有主服务器中断|

![19986554d103454a68.png](https://s1.imagehub.cc/images/2023/10/26/19986554d103454a68.png)
- 伙伴服务器角色设置为"待机"
![20fdc52387eb354697.png](https://s1.imagehub.cc/images/2023/10/26/20fdc52387eb354697.png)
- 填写"共享机密"字符(随便写)
可对复制伙伴之间的故障转移消息流量进行身份验证。管理员可在 DHCP 故障转移的“配置故障转移向导”中建立一个共享机密（类似于密码）。这会验证故障转移消息是否来自故障转移伙伴
![2194410b9fbfd05400.png](https://s1.imagehub.cc/images/2023/10/26/2194410b9fbfd05400.png)
- 最后点击"完成"即可
![22617a3df8c0a8aba6.png](https://s1.imagehub.cc/images/2023/10/26/22617a3df8c0a8aba6.png)
- 在日志内，看到所有配置选项均为"成功"
![23767d6eae6518b56f.png](https://s1.imagehub.cc/images/2023/10/26/23767d6eae6518b56f.png)
- 打开server2的"DHCP"，可以看到server1的DHCP服务配置已经同步到server2了
![241b6869e574e81c23.png](https://s1.imagehub.cc/images/2023/10/26/241b6869e574e81c23.png)

## 【6】验收环节
- 在DHCP客户端中输入`ipconfig /renew`重获IP地址
等待10-20秒后，就会显示出新获得的IP地址及其他配置
![279c20060d2b27db61.png](https://s1.imagehub.cc/images/2023/10/26/279c20060d2b27db61.png)
- 在server1中可以看到客户端的DHCP租用信息
![28b508d8d9d9643d71.png](https://s1.imagehub.cc/images/2023/10/26/28b508d8d9d9643d71.png)
- 然后挂起server1，模拟server1宕机
![2961fc4cdce86b06b2.png](https://s1.imagehub.cc/images/2023/10/26/2961fc4cdce86b06b2.png)
- DHCP客户端输入`ipconfig /release`释放现有IP地址
![30352ba660346f760e.png](https://s1.imagehub.cc/images/2023/10/26/30352ba660346f760e.png)
- 然后输入`ipconfig /renew`重新获取DHCP IP地址
server1宕机后，server2接替了server1的DHCP服务
![31.png](https://s1.imagehub.cc/images/2023/10/26/31.png)

⛔**防火墙注意事项：**
DHCP使用<font color=red>TCP端口647</font>侦听故障转移流量

参考资料：
[CSDN-Windows server 2019搭建DHCP故障转移服务👍👍](https://blog.csdn.net/qq_44484541/article/details/130012773 "CSDN-Windows server 2019搭建DHCP故障转移服务")
[博客园-DHCP配置故障转移](https://www.cnblogs.com/WWDD/p/15822328.html "博客园-DHCP配置故障转移")
[Microsoft-实现DHCP故障转移👍👍👍](https://learn.microsoft.com/zh-cn/training/modules/deploy-manage-dynamic-host-configuration-protocol/7-implement-dynamic-host-configuration-protocol-failover "Microsoft-实现 DHCP 故障转移")
[HUAWEI-什么是DHCP？👍👍👍](https://info.support.huawei.com/info-finder/encyclopedia/zh/DHCP.html "HUAWEI-什么是DHCP？")
[知乎-DHCP协议详解](https://zhuanlan.zhihu.com/p/265293856#:~:text=DHCP%EF%BC%88Dynamic%20Host,Configuration%20Protocol%EF%BC%8C%E5%8A%A8%E6%80%81%E4%B8%BB%E6%9C%BA%E9%85%8D%E7%BD%AE%E5%8D%8F%E8%AE%AE%EF%BC%89%EF%BC%8C%E5%89%8D%E8%BA%AB%E6%98%AFBOOTP%E5%8D%8F%E8%AE%AE%EF%BC%8C%E6%98%AF%E4%B8%80%E4%B8%AA%E5%B1%80%E5%9F%9F%E7%BD%91%E7%9A%84%E7%BD%91%E7%BB%9C%E5%8D%8F%E8%AE%AE%EF%BC%8C%E4%BD%BF%E7%94%A8UDP%E5%8D%8F%E8%AE%AE%E5%B7%A5%E4%BD%9C%EF%BC%8C%E7%BB%9F%E4%B8%80%E4%BD%BF%E7%94%A8%E4%B8%A4%E4%B8%AAIANA%E5%88%86%E9%85%8D%E7%9A%84%E7%AB%AF%E5%8F%A3%EF%BC%9A67%EF%BC%88%E6%9C%8D%E5%8A%A1%E5%99%A8%E7%AB%AF%EF%BC%89%EF%BC%8C68%EF%BC%88%E5%AE%A2%E6%88%B7%E7%AB%AF%EF%BC%89%E3%80%82 "知乎-DHCP协议详解")
