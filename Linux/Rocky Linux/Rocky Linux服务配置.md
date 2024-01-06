# <font color =red>【0】Rocky基础操作</font>  
  
## 【1】Rocky忘记账户密码  
此教程适用于Rocky Linux，其余发行版自行尝试或自己去找教程  
使用root账户举例  
首先重启你的linux虚拟机  
![4ed62914f7d7261ed7b6ed531588be90.png](https://s1.imagehub.cc/images/2023/12/04/4ed62914f7d7261ed7b6ed531588be90.png)  
当出现这个界面时，按下"e"键  
可以看下方第2行单引号内的键位，是什么键按什么键就可以  
![57f6732fb219d3ff3e1b48e6dcd51e51.png](https://s1.imagehub.cc/images/2023/12/04/57f6732fb219d3ff3e1b48e6dcd51e51.png)  
出现这个界面就可以进行下一步操作了  
![e4cea1e6e25e5f919ae36908af898515.png](https://s1.imagehub.cc/images/2023/12/04/e4cea1e6e25e5f919ae36908af898515.png)  
然后在第6行末尾的"rhgb quiet"中间写入`init=/bin/bash`  
![3334f396d55ec3afe3b964d022d5a166.png](https://s1.imagehub.cc/images/2023/12/04/3334f396d55ec3afe3b964d022d5a166.png)  
修改好后：  
![478925bd5f6091599fb63b95b77d14ac.png](https://s1.imagehub.cc/images/2023/12/04/478925bd5f6091599fb63b95b77d14ac.png)  
再把第5行行首的"ro"修改为`rw`  
![90aff59ae1299e96da5a20562c2c0c90.png](https://s1.imagehub.cc/images/2023/12/04/90aff59ae1299e96da5a20562c2c0c90.png)  
修改好后：  
![d58b392ee0557eb164a2933b27b4885d.png](https://s1.imagehub.cc/images/2023/12/04/d58b392ee0557eb164a2933b27b4885d.png)  
两处全部修改完毕后，按下Ctrl+X来启动当前修改完成的配置  
来到此处界面后，直接输入`paawd`更改root账户密码  
![56dabb66b0d44119a59b99041fc909d1.png](https://s1.imagehub.cc/images/2023/12/04/56dabb66b0d44119a59b99041fc909d1.png)  
输入`passwd`后，输入2遍密码，提示"updated successfully"即修改成功  
![df180eee2b8d11c6273abf003aca78ad.png](https://s1.imagehub.cc/images/2023/12/04/df180eee2b8d11c6273abf003aca78ad.png)  
如果是修改其他账户的密码，那就输入`passwd username`即可  
如果还开启了SELinux，那么还要设置SElinux重启标记  
命令：`touch /.autorelabel`  
然后重启就修改好了  
命令：`exec /sbin/init`  
重启完毕后，输入root用户名及刚刚修改的密码，就能成功登入了  
![259744e5ddf4862ae91be0b132630379.png](https://s1.imagehub.cc/images/2023/12/04/259744e5ddf4862ae91be0b132630379.png)  
  
## 【2】修改主机名称  
**1-临时修改主机名称：**  
命令：`hostname name`  
在下一次连接时生效  
![e0c7352996f7de02376aa61434b205dc.png](https://s1.imagehub.cc/images/2023/12/05/e0c7352996f7de02376aa61434b205dc.png)  
重新连接后生效：  
![05cafeccda9e4b0853733c62675c907a.png](https://s1.imagehub.cc/images/2023/12/05/05cafeccda9e4b0853733c62675c907a.png)  
重启后失效：  
![f94d6814486f1b725158adfe037de42a.png](https://s1.imagehub.cc/images/2023/12/05/f94d6814486f1b725158adfe037de42a.png)  
  
**2-永久修改主机名称：**  
1):修改主机名称配置文件  
直接在hostname文件内写入名称即可  
`vi /etc/hostname`  
  
2):命令修改  
1：`hostnamectl set-hostname --static "hostname"`  
2：`hostnamectl set-hostname hostname`  
这两行代码都可以修改主机名称，第1行是把主机名和昵称都修改为一致了  
第2行仅仅是修改主机名称，并没有修改主机昵称  
修改主机昵称命令：`hostnamectl set-hostname --pretty "name"`  
![97897a155871a2c1af43a736610865a2.png](https://s1.imagehub.cc/images/2023/12/05/97897a155871a2c1af43a736610865a2.png)  
查看主机名命令：`hostnamectl`或`hostname`均可  
![e0bde274ea535091a6151d1d42c01ad4.png](https://s1.imagehub.cc/images/2023/12/05/e0bde274ea535091a6151d1d42c01ad4.png)  
  
3):图形化界面修改  
命令：`nmtui`  
使用小箭头选择到"设置系统主机名"，然后回车  
![9ce30cd852cce8737a6db7723f6437d3.png](https://s1.imagehub.cc/images/2023/12/05/9ce30cd852cce8737a6db7723f6437d3.png)  
输入主机名  
![f02255b72fee85b4dc9cc4adfc382c56.png](https://s1.imagehub.cc/images/2023/12/05/f02255b72fee85b4dc9cc4adfc382c56.png)  
然后用小方向键选择到"确定"，回车即可  
![473c3695ff1cdfb35cd93d19fb5d1bb2.png](https://s1.imagehub.cc/images/2023/12/05/473c3695ff1cdfb35cd93d19fb5d1bb2.png)  
![9d5b7b6bd5d47b061104708d337844b5.png](https://s1.imagehub.cc/images/2023/12/05/9d5b7b6bd5d47b061104708d337844b5.png)  
  
## 【3】关闭SELinux  
**1-什么是SELinux：**  
自行跳转：  
[知乎-一文彻底明白linux中的selinux到底是什么](https://zhuanlan.zhihu.com/p/165974960 "知乎-一文彻底明白linux中的selinux到底是什么")  
[红帽-什么是SELinux？](https://www.redhat.com/zh/topics/linux/what-is-selinux#:~:text=%E5%AE%89%E5%85%A8%E5%A2%9E%E5%BC%BA%E5%9E%8B%20Linux%EF%BC%88SELinux%EF%BC%89%E7%94%B1%E7%BE%8E%E5%9B%BD%E5%9B%BD%E5%AE%B6%E5%AE%89%E5%85%A8%E5%B1%80%EF%BC%88NSA%EF%BC%89%E5%88%A9%E7%94%A8%20Linux,%E5%AE%89%E5%85%A8%E6%A8%A1%E5%9D%97%EF%BC%88LSM%EF%BC%89%E5%BC%80%E5%8F%91%E8%80%8C%E6%88%90%EF%BC%8C%E6%98%AF%E4%B8%80%E7%A7%8D%E9%87%87%E7%94%A8%E5%AE%89%E5%85%A8%E6%9E%B6%E6%9E%84%E7%9A%84%20Linux%20%E7%B3%BB%E7%BB%9F%EF%BC%8C%E8%83%BD%E5%A4%9F%E8%AE%A9%E7%AE%A1%E7%90%86%E5%91%98%E6%9B%B4%E5%A5%BD%E5%9C%B0%E7%AE%A1%E6%8E%A7%E5%93%AA%E4%BA%9B%E4%BA%BA%E5%8F%AF%E4%BB%A5%E8%AE%BF%E9%97%AE%E7%B3%BB%E7%BB%9F%E3%80%82 "红帽-什么是SELinux？")  
  
**2-查看SELinux状态：**  
命令：`cat /etc/selinux/config`  
或`cat /etc/sysconfig/selinux`  
或`getenforce`  
cat /etc/selinux/config：  
![97e5aade9ab412a28380afe1aea7ba5a.png](https://s1.imagehub.cc/images/2023/12/05/97e5aade9ab412a28380afe1aea7ba5a.png)  
cat /etc/sysconfig/selinux：  
![329eeba84f69e44d0d01a3a5c4c5a131.png](https://s1.imagehub.cc/images/2023/12/05/329eeba84f69e44d0d01a3a5c4c5a131.png)  
getenforce：  
![b6b3d1672c550a56a1af206cc7d270a2.png](https://s1.imagehub.cc/images/2023/12/05/b6b3d1672c550a56a1af206cc7d270a2.png)  
**SELinux状态有3种：**  
|SELinux运行状态|备注|setenforce选项|  
|---|---|---|  
|enforcing|执行中|1|  
|permissive|不执行但产生警告|0|  
|disabled|关闭|/|  
  
**2-临时关闭SELinux：**  
重启后失效  
命令：`setenforce 0`  
  
**3-永久关闭SELinux：**  
编写SELinux配置文件`vi /etc/sysconfig/selinux`或`vi /etc/selinux/config`  
将22行的`enforcing`修改为`disabled`即可  
![b77038efaad236aaa5ffbc84a5a96f04.png](https://s1.imagehub.cc/images/2023/12/05/b77038efaad236aaa5ffbc84a5a96f04.png)  
重启后生效  
![9b86b4f26bfb4685c84ac71e1bbee732.png](https://s1.imagehub.cc/images/2023/12/05/9b86b4f26bfb4685c84ac71e1bbee732.png)  
  
## 【4】更换yum源  
Rocky默认的yum源有时不是国内镜像，导致yum在线安装或更新时速度不是很理想，这时候需要将yum源设置为国内镜像站点  
### 【1】阿里镜像源  
首先打开阿里Rocky Linux镜像站  
[阿里云-Rocky Linux镜像站](https://developer.aliyun.com/mirror/rockylinux?spm=a2c6h.13651102.0.0.6bd71b11GzHnmv "阿里云-Rocky Linux镜像站")  
然后复制其提供的代码  
![e4c1b7316fd60f61e144889513323946.png](https://s1.imagehub.cc/images/2023/12/06/e4c1b7316fd60f61e144889513323946.png)  
**CV工程师福利：**  
  
```  
sed -e 's|^mirrorlist=|#mirrorlist=|g' \  
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.aliyun.com/rockylinux|g' \  
    -i.bak \  
    /etc/yum.repos.d/rocky-*.repo  
dnf makecache  
```  
然后编写一个sh脚本文件，并把刚刚复制的代码复制进去  
`vi 1.sh`  
替换时需要根据自己系统实际文件修改最后一行  
cd到`/etc/yum.repos.d`，`ls`一下，如果里面的文件是大R就保持不变，像我的就是小r，就需要把大R改成小r，否则原来的Rocky-*.repo会报错  
![92c861d57d69409c422c2e070ddf7424.png](https://s1.imagehub.cc/images/2023/12/07/92c861d57d69409c422c2e070ddf7424.png)  
![3d64bb24e7d9127c288caed558a0a599.png](https://s1.imagehub.cc/images/2023/12/06/3d64bb24e7d9127c288caed558a0a599.png)  
运行脚本：`sh 1.sh`  
清除缓存：`yum clean all`  
生成新缓存：`yum makecache`  
升级软件：`yum -y update`  
![a0b0be2f05fd9e5336cc80467e4cd6f6.png](https://s1.imagehub.cc/images/2023/12/06/a0b0be2f05fd9e5336cc80467e4cd6f6.png)  
  
### 【2】上海交大镜像源  
首先打开上海交通大学Rocky Linux镜像站  
[上海交通大学-软件源镜像服务](https://mirror.sjtu.edu.cn/docs/rocky "上海交通大学-软件源镜像服务")  
复制上交大提供的代码  
![18eec41e2d2c0a63b3cc631c994e4a59.png](https://s1.imagehub.cc/images/2023/12/06/18eec41e2d2c0a63b3cc631c994e4a59.png)	  
**CV工程师福利：**  
```  
sed -e 's|^mirrorlist=|#mirrorlist=|g' \  
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.sjtug.sjtu.edu.cn/rocky|g' \  
    -i.bak \  
    /etc/yum.repos.d/Rocky-*.repo  
```  
然后编写sh脚本文件，复制代码进去，再填写自己环境的实际路径  
`vi sh-shangjiaoda.sh`  
![5d057429a6ef37ed29f60c70866b2afc.png](https://s1.imagehub.cc/images/2023/12/06/5d057429a6ef37ed29f60c70866b2afc.png)  
然后在末尾写入`dnf makecache`  
![5cb573cafb5ff56fe6eed0498e11d3ee.png](https://s1.imagehub.cc/images/2023/12/06/5cb573cafb5ff56fe6eed0498e11d3ee.png)  
运行即可  
![b7ac3784b27a96487a8b63be5ecc5956.png](https://s1.imagehub.cc/images/2023/12/06/b7ac3784b27a96487a8b63be5ecc5956.png)  
  
### 【3】浙江大学镜像源  
[浙江大学-开源软件镜像站-Rocky Linux](http://mirrors.zju.edu.cn/docs/rocky/ "浙江大学-开源软件镜像站Rocky Linux")  
复制对应版本的命令即可，更换步骤和上面两个大同小异，就不细说了  
Rocky Linux查看系统版本：`cat /etc/rocky-release`  
![cf84ca23cb587af4f696e8c649de704f.png](https://s1.imagehub.cc/images/2023/12/06/cf84ca23cb587af4f696e8c649de704f.png)  
  
**Rocky Linux9：**  
```  
sed -e 's|^mirrorlist=|#mirrorlist=|g' \  
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.zju.edu.cn/rocky|g' \  
    -i.bak \  
    /etc/yum.repos.d/rocky-extras.repo \  
    /etc/yum.repos.d/rocky.repo  
```  
**Rocky Linux8：**  
```  
sed -e 's|^mirrorlist=|#mirrorlist=|g' \  
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.zju.edu.cn/rocky|g' \  
    -i.bak \  
    /etc/yum.repos.d/Rocky-AppStream.repo \  
    /etc/yum.repos.d/Rocky-BaseOS.repo \  
    /etc/yum.repos.d/Rocky-Extras.repo \  
    /etc/yum.repos.d/Rocky-PowerTools.repo  
```  
### 【4】中科大镜像源  
[中科大-Rocky Linux源](https://mirrors.ustc.edu.cn/help/rocky.html "中科大-Rocky Linux源")  
复制对应版本的命令即可，更换步骤大同小异，就不细说了  
![5bcece9801bd3a57c1e98b93c926b846.png](https://s1.imagehub.cc/images/2023/12/06/5bcece9801bd3a57c1e98b93c926b846.png)  
  
**Rocky Linux9：**  
```  
sed -e 's|^mirrorlist=|#mirrorlist=|g' \  
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.ustc.edu.cn/rocky|g' \  
    -i.bak \  
    /etc/yum.repos.d/rocky-extras.repo \  
    /etc/yum.repos.d/rocky.repo  
```  
**Rocky Linux8：**  
```  
sed -e 's|^mirrorlist=|#mirrorlist=|g' \  
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.ustc.edu.cn/rocky|g' \  
    -i.bak \  
    /etc/yum.repos.d/Rocky-AppStream.repo \  
    /etc/yum.repos.d/Rocky-BaseOS.repo \  
    /etc/yum.repos.d/Rocky-Extras.repo \  
    /etc/yum.repos.d/Rocky-PowerTools.repo  
```  
  
# <font color=red>【1】DNS服务器搭建</font>  
  
## 【1】DNS介绍：  
DNS这里就不多赘述了，感兴趣的话就去看这篇文章  
传送门：[知乎-什么是DNS？](https://zhuanlan.zhihu.com/p/186028919 "知乎-什么是DNS？")  
  
## 【2】安装DNS：  
`yum -y install bind*`  
  
## 【3】配置DNS Config  
### 【3.1】配置named.conf  
`vi /etc/named.conf`  
把左图红框内的11行和19行的内容全部替换为"any"  
![named.conf-former-and-after.png](https://s1.imagehub.cc/images/2023/09/05/named.conf-former-and-after.png)  
### 【3.2】配置named.rfc1912.zones  
`vi /etc/named.rfc1912.zones`  
<font color=red>左边红框内的16行至34行内容全部删除</font>，只留下倒数两段内容  
<font color=DeepSkyBlue>右边蓝框双引号内填写域名</font>  
<font color=Blue>深蓝色双引号填写正向解析文件文件名</font>  
<font color=yellow>黄色双引号填写反向IP</font>  反向IP只写到网络位，不写主机位，例如你的网络位是192.168.100，那么这里的反向IP就填100.168.192  
<font color=DarkOrange>橙色双引号填写反向解析文件文件名</font>  
![named.rfc1912.zones-former-and-after.png](https://s1.imagehub.cc/images/2023/09/05/named.rfc1912.zones-former-and-after.png)  
  
### 【3.3】复制正反向解析文件  
去到/var/named内  
[![var-named-ls.png](https://s1.imagehub.cc/images/2023/09/05/var-named-ls.png)](https://www.imagehub.cc/image/rktY1e)  
这两个文件复制哪个都可以，我这里就复制localhost文件了  
  
复制正向解析文件ninework.com.a  
> `cp -p named.localhost ninework.com.a`  
  
复制反向解析文件ninework.com.fx  
> `cp -p named.localhost ninework.com.fx`  
  
cp选项说明：  
原链接：https://www.runoob.com/linux/linux-comm-cp.html  
![Description-of-the-cp-option.png](https://s1.imagehub.cc/images/2023/09/05/Description-of-the-cp-option.png)  
![After-copying.png](https://s1.imagehub.cc/images/2023/09/05/After-copying.png)  
### 【3.3】编辑DNS正向解析文件  
`vi /var/named/ninework.com.a`  
![ninework.com.a-former-and-after.png](https://s1.imagehub.cc/images/2023/09/05/ninework.com.a-former-and-after.png)  
<font color=red>红框内填写域名并在末尾加上英文点`.`</font>  
<font color=DeepSkyBlue>蓝框内填写虚拟机本机IP地址</font>  
### 【3.4】编辑DNS反向解析文件  
![ninework.com.fx-former-and-after.png](https://s1.imagehub.cc/images/2023/09/05/ninework.com.fx-former-and-after.png)  
<font color=red>左边红框内替换为域名</font>  
<font color=DeepSkyBlue>蓝色框内的是IPV4的主机位，注意每条跟域名有关的记录都有英文点`.`</font>  
### 【3.5】重启Bind  
<font color=red>Bind的进程名叫named</font>  
`systemctl restart named`  
### 【3.6】虚拟机DNS指向本地  
网卡的配置文件存在于`/etc/NetworkManager/system-connections/ens33.nmconnection`内  
<font color=red>红框内的内容是DNS</font>  
![ens33-config-Former-and-After.png](https://s1.imagehub.cc/images/2023/09/05/ens33-config-Former-and-After.png)  
### 【3.7】加载激活网卡配置文件  
加载网卡配置文件  
> `nmcli connection load  /etc/NetworkManager/system-connections/ens33.nmconnection`  
  
激活网卡配置文件  
> `nmcli connection up  /etc/NetworkManager/system-connections/ens33.nmconnection`  
  
![nmcil-load-up.png](https://s1.imagehub.cc/images/2023/09/05/nmcil-load-up.png)  
## 【4】验证环节  
### 【4.1】验证  
输入`nslookup`验证DNS是否配置成功  
![nslookup.png](https://s1.imagehub.cc/images/2023/09/05/nslookup.png)  
输入域名和IP后，要是都能解析的到，DNS配置才算成功  
### <font color=red>【4.2】错误情况</font>  
***<font color=red>以下情况全是配置错误的情况：</font>***  
[1]  
![error-1.png](https://s1.imagehub.cc/images/2023/09/05/error-1.png)  
[2]  
![error-2.png](https://s1.imagehub.cc/images/2023/09/05/error-2.png)  
[3]  
![error-3.png](https://s1.imagehub.cc/images/2023/09/05/error-3.png)  
  
# <font color=red>【2】 DNS主从服务器配置</font>  
## 【1】环境介绍  
|主机名称|IP|DNS指向|扮演角色|系统版本|  
|---|---|---|---|---|  
|Rocky-Master|192.168.10.181|192.168.10.181|DNS主服务器|Rocky_boot_9.1|  
|Rocky-Slave|192.168.10.182|192.168.10.181|DNS从服务器|Rocky_boot_9.1|  
|Rocky-Client|192.168.10.183|192.168.10.181|DNS客户端|Rocky_boot_9.1|  
  
## 【2】修改网卡配置文件  
命令：`vi /etc/NetworkManager/system-connections/ens33.nmconnection `  
DNS指向本机  
![d03d16090e948999f5e9af88a7548526.png](https://s1.imagehub.cc/images/2023/11/02/d03d16090e948999f5e9af88a7548526.png)  
  
激活网卡配置：  
`nmcli connection load /etc/NetworkManager/system-connections/ens33.nmconnection`  
`nmcli connection up /etc/NetworkManager/system-connections/ens33.nmconnection`  
![bb8d9283fab5298e7151b52f8962f127.png](https://s1.imagehub.cc/images/2023/11/02/bb8d9283fab5298e7151b52f8962f127.png)  
  
## 【3】Master修改主机名  
命令：`vi /etc/hostname`  
修改完成后，重启生效  
![683a34b086665d01026e3eb6a5994499.png](https://s1.imagehub.cc/images/2023/11/02/683a34b086665d01026e3eb6a5994499.png)  
  
## 【4】Master安装Bind  
命令：`yum -y install bind*`  
![2c9ddc35fc1439139d65c865425bcae8.png](https://s1.imagehub.cc/images/2023/11/02/2c9ddc35fc1439139d65c865425bcae8.png)  
  
## 【5】Master修改Bind主配置文件  
  
命令：`vi /etc/named.conf`  
**1-第11行：**  
把第11行的`127.0.0.1`替换为`any`或本机IP地址  
![93fd80e8157a1efee9baba263c9c024b.png](https://s1.imagehub.cc/images/2023/11/02/93fd80e8157a1efee9baba263c9c024b.png)  
  
**2-第19行：**  
更改19行的`localhost`为`any`或本机IP地址  
![040b2f2ccd69d5d7cdce541610292ccd.png](https://s1.imagehub.cc/images/2023/11/02/040b2f2ccd69d5d7cdce541610292ccd.png)  
  
## 【6】Master修改区域配置文件  
建议备份一下区域配置文件  
备份命令：`cp -p /etc/named.rfc1912.zones /etc/named.rfc1912.zones.bak`  
  
修改区域配置文件  
命令：`vi /etc/named.rfc1912.zones`  
我这里只留下了35-45行，其他行内容对于本节来说作用不大，看个人喜好删除  
![7eedb813f96d456db429746458c52c3b.png](https://s1.imagehub.cc/images/2023/11/02/7eedb813f96d456db429746458c52c3b.png)  
删除后的内容比较简洁明了  
![2c0b03af18c53b79233d3b3fa6147e5f.png](https://s1.imagehub.cc/images/2023/11/02/2c0b03af18c53b79233d3b3fa6147e5f.png)  
  
**1-第1行：**  
把zone双引号内的内容替换为你的域名  
![dab02056a8579dc5c1708e39e6b26d59.png](https://s1.imagehub.cc/images/2023/11/02/dab02056a8579dc5c1708e39e6b26d59.png)  
  
**2-第3行：**  
file双引号内替换为正向解析文件名  
![307c5bd087a9872c0e5c7f3c82654359.png](https://s1.imagehub.cc/images/2023/11/02/307c5bd087a9872c0e5c7f3c82654359.png)  
  
**3-第4行：**  
把花括号内的`none`替换为DNS从服务器的IP地址  
![f0e7c4946790fd685ce724cecc728367.png](https://s1.imagehub.cc/images/2023/11/02/f0e7c4946790fd685ce724cecc728367.png)  
  
**4-第7行：**  
在第7行的`.in`前填写反向网络位IP地址  
![a9751861e166f58f314d183bbed823ba.png](https://s1.imagehub.cc/images/2023/11/02/a9751861e166f58f314d183bbed823ba.png)  
  
不知道自己的网络位IP？  
命令：`ifconfig`  
第6行的`inet`后面的4段点分十进制就是你的IP地址，前3段是你的网络位地址  
<font color=red>反向地址填写时要从后向前写</font>  
例：192.168.1=1.168.192  
![c5251bd962ace6af852f33fe3ba1f413.png](https://s1.imagehub.cc/images/2023/11/02/c5251bd962ace6af852f33fe3ba1f413.png)  
  
**5-第9行：**  
在第9行的file双引号内填写反向解析文件的文件名  
![7bfd21d76e3faa2c67b7beb8e0f2c41b.png](https://s1.imagehub.cc/images/2023/11/02/7bfd21d76e3faa2c67b7beb8e0f2c41b.png)  
  
**6-第10行：**  
在第10行的allow-update后边的花括号内填写DNS从服务器IP地址  
![ed290445e5b97d1d3a80f93fa2bec7d9.png](https://s1.imagehub.cc/images/2023/11/02/ed290445e5b97d1d3a80f93fa2bec7d9.png)  
  
## 【7】修改正向解析文件  
去到var/named内：`cd /var/named`  
复制模板：  
`cp -p named.localhost a`  
`cp -p named.localhost fx`  
![42b1c5b951cb2ce5d08a4d169c0ca401.png](https://s1.imagehub.cc/images/2023/11/02/42b1c5b951cb2ce5d08a4d169c0ca401.png)  
修改正向解析文件：`vi a`  
![93a0634917d5adbb9605e31be2183c0c.png](https://s1.imagehub.cc/images/2023/11/02/93a0634917d5adbb9605e31be2183c0c.png)  
修改反向解析文件：`vi fx`  
![44ff57b285205190ca32ee88d06f6007.png](https://s1.imagehub.cc/images/2023/11/02/44ff57b285205190ca32ee88d06f6007.png)  
  
## 【8】重启Bind服务  
重启Bind:`systemctl restart named`  
查看Bind状态：`systemctl status named`  
![c3aab82651754abcc92d17b5b5337698.png](https://s1.imagehub.cc/images/2023/11/02/c3aab82651754abcc92d17b5b5337698.png)  
  
## 【9】Slave安装Bind  
命令：`yum -y install bind*`  
![16e5cfb2a1ded26e6a701c3db7bb497f.png](https://s1.imagehub.cc/images/2023/11/02/16e5cfb2a1ded26e6a701c3db7bb497f.png)  
  
## 【10】Slave修改Bind主配置文件  
命令：`vi /etc/named.conf`  
**1-第11行：**  
把11行内的花括号内的内容修改为`any`  
![4d4a92c84b9b3714110d93afbc963fae.png](https://s1.imagehub.cc/images/2023/11/02/4d4a92c84b9b3714110d93afbc963fae.png)  
  
**2-第19行：**  
把19行花括号内的`localhost`修改为`any`  
![24f2440d3e1679acd8fe01c9bac46c0b.png](https://s1.imagehub.cc/images/2023/11/02/24f2440d3e1679acd8fe01c9bac46c0b.png)  
  
## 【11】Slave修改区域配置文件  
命令：`vi /etc/named.rfc1912.zones`  
保留35-45行内容  
![e205e89b0fa7a52523c2ecf7a6a7297d.png](https://s1.imagehub.cc/images/2023/11/02/e205e89b0fa7a52523c2ecf7a6a7297d.png)  
![d00a97023d5eecb1ff9dc28cf5c25956.png](https://s1.imagehub.cc/images/2023/11/02/d00a97023d5eecb1ff9dc28cf5c25956.png)  
  
**1-第1行：**  
把第1行双引号内的内容替换为你的域名  
![b889741a26848819f017fecbe6229a8b.png](https://s1.imagehub.cc/images/2023/11/02/b889741a26848819f017fecbe6229a8b.png)  
  
**2-第2行:**  
把type后边的`master`修改为`slave`  
![f3f439b6146c06eed2c15625c086f3f7.png](https://s1.imagehub.cc/images/2023/11/02/f3f439b6146c06eed2c15625c086f3f7.png)  
  
**3-第3行：**  
把第3行双引号内的内容修改为反向解析文件的文件名  
![97b71590838b7e970747504dc2ca8e17.png](https://s1.imagehub.cc/images/2023/11/02/97b71590838b7e970747504dc2ca8e17.png)  
  
**4-第5行：**  
第4行的内容不涉及，可以注释掉  
在第5行内添加一条指向master的IP记录  
`master {192.168.10.181;};`  
![de0fd728adea4f5ac50f20d65ab28d59.png](https://s1.imagehub.cc/images/2023/11/03/de0fd728adea4f5ac50f20d65ab28d59.png)  
  
**5-第8行：**  
在第8行双引号内添加反向网络位IP  
![60eb8dcf9b9877b116956822856adcc1.png](https://s1.imagehub.cc/images/2023/11/03/60eb8dcf9b9877b116956822856adcc1.png)  
  
**6-第9行：**  
把第9行的类型由`master`修改为`slave`  
![ddeb7094aba8dcf1a90eba96e7e1d15c.png](https://s1.imagehub.cc/images/2023/11/03/ddeb7094aba8dcf1a90eba96e7e1d15c.png)  
  
**7-第10行：**  
指向反向解析文件  
第11行不涉及，可以注释掉  
![71a0163d93c65d3940947de227783360.png](https://s1.imagehub.cc/images/2023/11/03/71a0163d93c65d3940947de227783360.png)  
  
**8-第12行：**  
添加指向master的IP记录  
`masters {192.168.10.181;};`  
![e5df3968cc32e9223d55e9ff8d6e84b8.png](https://s1.imagehub.cc/images/2023/11/03/e5df3968cc32e9223d55e9ff8d6e84b8.png)  
  
## 【12】验收环节  
3台主机均关闭防火墙和SELinux  
`systemctl stop firewalld`  
`setenforce 0`  
  
Client输入`nslookup`  
然后输入`Rocky-Slave`和`192.168.10.182`  
若都能解析出来，那么DNS主从服务器配置成功  
![134285ba521b8af8edda938555d3a14e.png](https://s1.imagehub.cc/images/2023/11/03/134285ba521b8af8edda938555d3a14e.png)  
  
# <font color=red>【3】Apache+SSL服务器配置</font>  
**说明：**  
当前Apache需要DNS支持，所以在做Apache事先前就要做好DNS  
![nslookup-verify.png](https://s1.imagehub.cc/images/2023/09/05/nslookup-verify.png)  
## 【1】安装Apache  
`yum -y install httpd`  
## 【2】编写Apache配置文件  
Apache配置文件存在于`/etc/httpd/conf/httpd.conf`  
### 【2.1】第一处-124行  
这里存放的是站点根目录，网站上的文件都存放于该目录下  
![httpd.conf-124row-former-and-after.png](https://s1.imagehub.cc/images/2023/09/05/httpd.conf-124row-former-and-after.png)  
### 【2.2】第二处-129行  
![httpd.conf-129row-former-and-after.png](https://s1.imagehub.cc/images/2023/09/05/httpd.conf-129row-former-and-after.png)  
### 【2.3】第三处-136行  
![httpd.conf-136row-former-and-after.png](https://s1.imagehub.cc/images/2023/09/05/httpd.conf-136row-former-and-after.png)  
### 【2.4】第四处-169行  
<font color=DeepSkyBlue>这里可以改也可以不改，看自己心情吧，不改的话，创建网站根文件的时候记得也要写"index.html"</font>  
![httpd.conf-169row-former-and-after.png](https://s1.imagehub.cc/images/2023/09/05/httpd.conf-169row-former-and-after.png)  
## 【3】创建站点根目录  
由于httpd.conf里都是指定的/www/web目录，所以要添加-p选项  
`mkdir -p /www/web`  
## 【4】创建站点根文件  
如果你之前在httpd.conf 169行是缺省值的话，那就把`web.html`替换为缺省值的`index.html`，我这里改过名字了，那我就创建`web.html`了  
`touch /www/web/web.html`  
## 【5】编写站点根文件  
创建好站点根文件后，里面没有任何内容，这时候去里边随便写点内容  
`vi /www/web/web.html`  
## 【6】SSL证书  
### 【6.1】安装SSL证书  
`yum -y install mod_ss`  
### 【6.2】生成SSL证书  
无脑按回车就行  
`openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -days 365 -out server.crt`  
![httpd.conf-169row-former-and-after.png](https://s1.imagehub.cc/images/2023/09/05/httpd.conf-169row-former-and-after.png)  
### 【6.3】复制SSL证书及秘钥  
把这两份SSL证书及秘钥复制到/etc/pki/tls/certs及/private目录内  
![Snipaste_2023-09-03_16-48-43.png](https://s1.imagehub.cc/images/2023/09/05/Snipaste_2023-09-03_16-48-43.png)  
`cp server.crt /etc/pki/tls/certs/server.crt`  
`cp server.key /etc/pki/tls/private/server.key`  
### 【6.4】修改SSL配置文件  
`vi /etc/httpd/conf.d/ssl/conf`  
把"local"替换为"server"即可  
![ssl.conf-85and-93-row-former-and-after.png](https://s1.imagehub.cc/images/2023/09/05/ssl.conf-85and-93-row-former-and-after.png)  
## 【7】重启服务  
重启Apache  
`systemctl restart httpd`  
重启SSL  
`service sshd restart`  
## 【8】关闭防火墙及SELinux  
关闭防火墙：  
`systemctl stop firewalld`  
  
关闭SELinux：  
`setenforce 0`  
## 【9】验证  
### 【9.1】IP地址验证  
打开浏览器输入虚拟机IP地址  
`192.168.10.181`  
![The-IP-address-method-is-successfully-verified.png](https://s1.imagehub.cc/images/2023/09/05/The-IP-address-method-is-successfully-verified.png)  
### 【9.2】域名验证  
输入域名后，可以看到并不是我们的HTML  
![Domain-name-method-validation-failed.png](https://s1.imagehub.cc/images/2023/09/05/Domain-name-method-validation-failed.png)  
这是因为宿主机的DNS是223.6.6.6，电脑跑到阿里的DNS服务器上找"www.ninework.com"这个网站去了  
找到了就显示你输入的域名，如果没有找到就会像下面这样：  
![This-website-cannot-be-accessed.png](https://s1.imagehub.cc/images/2023/09/05/This-website-cannot-be-accessed.png)  
<font color=red>  
这里建议 *除跟虚拟机有数据流通的网卡外全部禁用*  
我用的是桥接模式，所以VM的2个虚拟网卡也禁用了  
如果你是VM NAT模式，那就禁用上网卡，打开VM虚拟网卡  
</font>  
  
![ncpa.cpl.png](https://s1.imagehub.cc/images/2023/09/05/ncpa.cpl.png)  
把DNS指向虚拟机后就可以访问到我们的ninework.com站点了  
![The-domain-name-method-is-successfully-verified.png](https://s1.imagehub.cc/images/2023/09/05/The-domain-name-method-is-successfully-verified.png)  
## 【10】原理讲解  
该讲解面向网络/服务器小白，了解DNS的就不用看了  
### 【10.1】DNS指向公网DNS服务器  
DNS=223.6.6.6的时候，电脑会向阿里DNS服务器搜寻是否有"www.ninework.com"这个网站，事实上是有这个网站的，只不过不是我们刚才搭建的网站  
![www.ninework.com-Erection-address.png](https://s1.imagehub.cc/images/2023/09/05/www.ninework.com-Erection-address.png)  
经过查询后，这个站点是架设在美国亚马逊的服务器站点，并不是我们想要的内网站点  
~~我们局域网内的网站也不可能出现在阿里的DNS服务器里，因为虚拟机并没有公网IP，公网访问不到我们局域网里的网站~~  
### 【10.2】DNS指向内网DNS服务器  
DNS=192.168.10.181的时候，电脑就会向虚拟机找寻是否有"www.ninework.com"这个网站，这就是为什么做Apache要事先做好DNS，当然你也可以不做DNS，只不过无法用域名访问罢了。找到这个网站后，DNS把域名解析成IP地址，然后电脑获取到域名的IP地址后，就能打开网站了，输IP访问和输域名访问的东西都是同一个东西，只不过IP地址不好记，域名就很好记  
### 【10.3】为什么会产生~~https~~  
跳转这个链接，讲的很通透：  
https://www.bilibili.com/video/BV1uY4y1D7Ng/?vd_source=f66e9fe7694284f598a5e2b8a3b6c586  
  
# <font color=red>【4】Mail服务器搭建</font>  
## 【前期准备工作】  
### 【1】修改主机名  
需要保证服务器主机名称与发信域名保持一致  
也可以直接修改/etc/hostname文件  
`hostnamectl set-hostname mail.`  
  
### 【2】关闭防火墙  
`systemctl stop firewalld`  
## 【1】配置DNS：    
### 【1.1】安装DNS：  
> `yum -y install bind*`  
  
![Install-DNS.png](https://s1.imagehub.cc/images/2023/09/05/Install-DNS.png)  
### 【1.2】配置named.conf：    
cd到etc：    
`cd /etc`  
![cd-etc.png](https://s1.imagehub.cc/images/2023/09/05/cd-etc.png)  
编辑named.conf文件：  
`vi named.conf`  
![Edit-the-named.conf-file.png](https://s1.imagehub.cc/images/2023/09/05/Edit-the-named.conf-file.png)  
把红框内圈出的花括号内的内容替换为"any"：   
![Replace-the-two-places-with-any.png](https://s1.imagehub.cc/images/2023/09/05/Replace-the-two-places-with-any.png)  
替换后：    
![After-replacement.png](https://s1.imagehub.cc/images/2023/09/05/After-replacement.png)  
### 【1.3】配置named.rfc1912.zones文件：    
把16-34行的内容删掉：  
![named.rfc1912.zones.png](https://s1.imagehub.cc/images/2023/09/05/named.rfc1912.zones.png)  
把红圈内的内容换成域名，蓝圈内的"0"换成反向的网络位IPV4地址：  
然后18和24行分别指向正向解析文件和反向解析文件(a fx)   
![named.rfc1912.zones-after.png](https://s1.imagehub.cc/images/2023/09/05/named.rfc1912.zones-after.png)  
![named.rfc1912.zones-after-the-change.png](https://s1.imagehub.cc/images/2023/09/05/named.rfc1912.zones-after-the-change.png)  
  
### 【1.4】编写a文件及fx文件：    
首先cd到var/named内：  
> `cd /var/named`    
  
然后复制两份文件：  
> `cp -p named.localhost a`  
> `cp -p named.localhost fx`  
  
![Copy-two-files-in-the-var-folder.png](https://s1.imagehub.cc/images/2023/09/05/Copy-two-files-in-the-var-folder.png)  
首先编辑a文件：  
> `vi a`  
  
![a-file.png](https://s1.imagehub.cc/images/2023/09/05/a-file.png)  
然后修改fx文件：  
> `vi fx`  
  
![fx-file.png](https://s1.imagehub.cc/images/2023/09/05/fx-file.png)  
### 【1.5】配置虚拟机DNS  
虚拟机网卡的DNS须指向自己才可以，所以要修改虚拟机网卡DNS：  
> `vi /etc/NetworkManager/system-connections/ens33.nmconnection`    
  
![The-DNS-of-the-virtual-machine-NIC-points-to-itself.png](https://s1.imagehub.cc/images/2023/09/05/The-DNS-of-the-virtual-machine-NIC-points-to-itself.png)  
### 【1.6】重启网卡  
> `systemctl restart NetworkManager`  
### 【1.7】重启Bind  
> `systemctl restart named`  
  
### 【1.8】验证  
输入`nslookup`验证：  
![nslookup-verifyd1090d8ffa42d5aa.png](https://s1.imagehub.cc/images/2023/09/05/nslookup-verifyd1090d8ffa42d5aa.png)  
输入域名和IP后，不报错或者没有出现别的IP地址就是配置好了  
  
## 【2】配置postfix  
### 【2.1】安装postfix  
> `yum -y install postfix`  
  
### 【2.2】编辑postfix配置文件  
postfix配置文件存放于`vim /etc/postfix/main.cf`中  
#### 【2.2.1】第一处  
打开main.cf后，先修改第一处内容  
找到94行,取消注释(#)  
然后后边跟上mail域名  
![94-row.png](https://s1.imagehub.cc/images/2023/09/05/94-row.png)  
#### 【2.2.2】第二处  
找到102行，取消注释(#)  
后边跟域名  
![102-row.png](https://s1.imagehub.cc/images/2023/09/05/102-row.png)  
#### 【2.2.3】第三处  
找到118行，取消注释(#)  
![118-row.png](https://s1.imagehub.cc/images/2023/09/05/118-row.png)  
#### 【2.2.4】第四处  
找到132行，取消注释(#)  
![132-row.png](https://s1.imagehub.cc/images/2023/09/05/132-row.png)  
#### 【2.2.5】第五处  
找到135行，在行首加注释  
![135-row.png](https://s1.imagehub.cc/images/2023/09/05/135-row.png)  
#### 【2.2.6】第六处  
找到183行，在行首加注释  
找到184行，取消注释(#)  
![183-184-row.png](https://s1.imagehub.cc/images/2023/09/05/183-184-row.png)  
  
## 【3】配置dovecot  
### 【3.1】安装dovecot  
> `yum -y install dovecot`  
  
### 【3.2】编辑dovecot配置文件  
dovecot配置文件存放于`/etc/dovecot/dovecot.conf`中  
#### 【3.2.1】第一处  
找到24行，取消行首注释  
并在25行添加一行  
`disable_plaintext_auth = no`  
允许用户使用明文进行密码验证  
![dovecot-24-25-row.png](https://s1.imagehub.cc/images/2023/09/05/dovecot-24-25-row.png)  
  
#### 【3.2.2】第二处  
找到49行的login_trusted_networks，根据需要来选择取消注释并配置允许登录的网段地址  
我们可以在这里限制只有来自于某个网段的用户才能使用电子邮件系统。如果想允许所有人都能使用，则不用修改本参数  
我这里就限制10段用户才能使用mail  
![dovecot-49-row.png](https://s1.imagehub.cc/images/2023/09/05/dovecot-49-row.png)  
### 【3.3】配置10-ssl.conf  
这步按需配置，如果需要SSL证书，那直接进行下一步即可，如果这步默认的话，Outlook无法接受邮件  
10-SSL.conf配置文件存在于`/etc/dovecot/conf.d/10-ssl.conf`  
![10-ssl.conf.png](https://s1.imagehub.cc/images/2023/09/05/10-ssl.conf.png)  
### 【3.4】配置10-mail.conf  
在子配置文件/etc/dovecot/conf.d/10-mail.conf 中，找到mail_location并把注释去掉即可  
`vim /etc/dovecot/conf.d/10-mail.conf`  
![10-mail.conf-25.png](https://s1.imagehub.cc/images/2023/09/05/10-mail.conf-25.png)  
  
## 【4】重启工作  
重启bind  
`systemctl restart named`  
重启postfix  
`systemctl restart postfix`  
重启dovecot  
`systemctl restart dovecot`  
  
## 【5】创建mail登录用户  
### 【5.1】创建用户及设置密码  
创建space7用户  
`useradd space7`  
为space7用户设置登录密码  
`echo "123456" | passwd --stdin space7`  
![Set-a-login-password-for-space7-users.png](https://s1.imagehub.cc/images/2023/09/05/Set-a-login-password-for-space7-users.png)  
### 【5.2】创建保存邮件目录  
先切换到刚才创建的space7用户  
`su - space7`  
在space7家目录中创建用于保存邮件的目录  
`mkdir -p mail/.imap/INBOX`  
  
## 【6】验收  
### 【6.1】安装s-nail  
安装s-nail，否则会出现`-bash: mail：未找到命令`的报错  
`yum -y install s-nail`  
### 【6.2】使用root账户给其他用户发送邮件  
然后使用root账户给space7用户发送一封标题为"Hello"的邮件  
`echo "I am Ikun" | mail -s "Hello" space7@ninework.com`  
然后切换到space7用户  
`su - space7`  
输入`mail`查看收件箱  
![from-root-mail-tospace7.png](https://s1.imagehub.cc/images/2023/09/05/from-root-mail-tospace7.png)  
### 【6.3】使用Foxmail验证  
填写账户密码及服务器名称  
服务器名称均是mail.+域名  
![Foxmail-verify.png](https://s1.imagehub.cc/images/2023/09/05/Foxmail-verify.png)  
宿主DNS须指向虚拟机DNS  
![IPV4-PROPERTIESf90069f4b771e0dd.png](https://s1.imagehub.cc/images/2023/09/05/IPV4-PROPERTIESf90069f4b771e0dd.png)  
点击创建后就能登录成功了  
![Account-login-successful.png](https://s1.imagehub.cc/images/2023/09/05/Account-login-successful.png)  
![Verifying.png](https://s1.imagehub.cc/images/2023/09/05/Verifying.png)  
  
# <font color=red>【5】Rsyslog服务器搭建</font>  
## 【1.1】rsyslog介绍：  
rsyslog 是一个快速处理收集系统日志的开源程序，提供了高性能、安全功能和模块化设计。rsyslog 是 syslog 的升级版，它将多种来源输入输出转换结果到目的地， rsyslog 被广泛用于 Linux 系统以通过 TCP/UDP 协议转发或接收日志消息  
## 【1.2】rsyslog环境：  
镜像版本：Rocky Linux 9.1 boot  
server ip：192.168.10.171  
client ip：192.168.10.172  
均关闭firewall及selinux  
## 【2】配置server  
### 【2.1】安装rsyslog  
`yum -y install rsyslog`  
### 【2.2】修改server rsyslog config  
rsyslog配置文件存在于`/etc/rsyslog.conf`  
`vim /etc/rsyslog.conf`  
红圈内的的UDP传输，绿圈内的是TCP传输，看情况使用，用哪个就把"module"和"input"开头的2段内容取消注释即可  
![server-rsyslog-config.png](https://s1.imagehub.cc/images/2023/09/05/server-rsyslog-config.png)  
### 【2.3】重启server rsyslog  
`systemctl restart rsyslog`  
### 【2.4】关闭server防火墙及SELinux  
关闭防火墙：  
`systemctl stop firewalld`  
临时关闭SELinux(下次重启会再次启动SELinux)  
`setenforce 0`  
## 【3】配置client  
### 【3.1】安装rsyslog  
`yum -y install rsyslog`  
### 【3.2】修改client rsyslog config  
`vim /etc/rsyslog.conf`  
找到"local7.*"，一般在60多行，在"local7"下边填写服务器端IP地址及端口  
`*.*                                                     @192.168.10.181:514`(按7下Tab键)  
注：如果你server端取消注释的是TCP，那么在这里就加2个@，2个@代表TCP传输，1个@代表UDP传输  
`*.*                                                     @@192.168.10.181:514`  
![client-rsyslog-config-1.png](https://s1.imagehub.cc/images/2023/09/05/client-rsyslog-config-1.png)  
### 【3.3】其他记录内容  
[rsyslog other client config](https://www.123pan.com/s/OG4rVv-q2eJH.html) 提取码:WL95  
上边的文件是rsyslog记录其他日志内容的命令，可以按需复制并加在rsyslog.conf文件末  
![Demonstrates-additional-client-configurations.png](https://s1.imagehub.cc/images/2023/09/05/Demonstrates-additional-client-configurations.png)  
### 【3.4】重启client rsyslog  
`systemctl restart rsyslog`  
### 【3.5】关闭client 防火墙和SELinux  
关闭防火墙：  
`systemctl stop firewalld`  
临时关闭SELinux(下次重启会再次启动SELinux)  
`setenforce 0`  
## 【4】验收环节  
### 【4.1】client给server发送logger信息  
<font color=red>说明：</font>  
由于我们这里使用的是TCP传输，所以给server发送logger信息的命令就是`logger "test"`  
logger后边直接跟上双引号内容就行  
  
如果走的是UDP，那就在`logger`后边跟上`-d`选项，也就是  
`logger -d "test"`  
![client-logger.png](https://s1.imagehub.cc/images/2023/09/05/client-logger.png)  
### 【4.2】server验证logger信息  
client发送的logger信息存在于/var/log/messages内，所以用tail命令查看messages后10行内容就可以了  
`tail /var/log/messages`  
可以看到server这里可以看到我们在client发送的logger信息`I am Ikun`  
![Server-side-acceptance.png](https://s1.imagehub.cc/images/2023/09/05/Server-side-acceptance.png)  
  
# <font color=red>【6】KeepAlive配置</font>  
**KeepAlive简介：**  
Keepalived一个基于VRRP 协议来实现的 LVS 服务高可用方案，可以利用其来解决单点故障。一个LVS服务会有2台服务器运行Keepalived，一台为主服务器（MASTER），一台为备份服务器（BACKUP），但是对外表现为一个虚拟IP，主服务器会发送特定的消息给备份服务器，当备份服务器收不到这个消息的时候，即主服务器宕机的时候， 备份服务器就会接管虚拟IP，继续提供服务，从而保证了高可用性  
[keepalive官网](https://www.keepalived.org "keepalive官网")  
## 【1】测试环境  
|名称|IP|优先级|  
|---|---|---|  
|server1|192.168.10.181|100|  
|server2|192.168.10.182|99|  
KeepAlive虚拟IP|192.168.10.180|/|  
## 【2】KeepAlive安装  
- `yum -y install keepalived`  
## 【3】配置KeepAlive  
- KeepAlive配置文件路径：`/etc/keepalived/keepalived.conf`  
### 【1】配置server1  
- 12行  
"router_id"后修改为自己喜欢的名称  
![1-1.png](https://s1.imagehub.cc/images/2023/10/14/1-1.png)  
- 14行  
删除14行内容  
![2-1.png](https://s1.imagehub.cc/images/2023/10/14/2-1.png)  
- 20行  
"interface"后边写上网卡名称  
![3-1.png](https://s1.imagehub.cc/images/2023/10/14/3-1.png)  
不知道网卡名称？  
键入`ifconfig`  
![49dae13fd0846a525.png](https://s1.imagehub.cc/images/2023/10/14/49dae13fd0846a525.png)  
- 29行  
删除现有的IP地址，输入KeepAlive虚拟IP地址  
![5-1.png](https://s1.imagehub.cc/images/2023/10/14/5-1.png)  
- 19行的"state MASTER"的MASTER是主KeepAlive，默认就行，不用修改  
![69bccd4bb0fc04c88.png](https://s1.imagehub.cc/images/2023/10/14/69bccd4bb0fc04c88.png)  
- 22行的"priority"是优先权，优先权值越大，优先级越高  
默认就是100，  
![7210147c82a327444.png](https://s1.imagehub.cc/images/2023/10/14/7210147c82a327444.png)  
- 保存并退出  
![8605e0155765df3b3.png](https://s1.imagehub.cc/images/2023/10/14/8605e0155765df3b3.png)  
- 重启KeepAlive服务  
`systemctl restart keepalived.service`  
### 【2】配置server2  
- 12行  
修改名称  
![97265c8e23581a761.png](https://s1.imagehub.cc/images/2023/10/14/97265c8e23581a761.png)  
- 14行  
删除"vrrp_strict"  
![10-1.png](https://s1.imagehub.cc/images/2023/10/14/10-1.png)  
- 19行  
更改服务器扮演角色为BACKUP  
![11-1.png](https://s1.imagehub.cc/images/2023/10/14/11-1.png)  
- 20行  
修改网卡名称  
![12-1.png](https://s1.imagehub.cc/images/2023/10/14/12-1.png)  
- 22行  
修改服务器优先级，server1优先级是100，server2优先级只要比100低就行  
![13-1.png](https://s1.imagehub.cc/images/2023/10/14/13-1.png)  
- 键入KeepAlive虚拟IP  
![14-1.png](https://s1.imagehub.cc/images/2023/10/14/14-1.png)  
- 重启KeepAlive服务  
`systemctl restart keepalived.service`  
## 【4】创建HTTP站点  
**1-创建web主页文件**  
- 创建http站点路径  
`mkdir -p /www/web`  
- 创建web主页文件  
`touch /www/web/web.html`  
- 随便在里边写点内容  
![15-5.png](https://s1.imagehub.cc/images/2023/10/14/15-5.png)  
  
**2-修改httpd配置文件**  
- 124行  
![15-1.png](https://s1.imagehub.cc/images/2023/10/14/15-1.png)  
- 129行  
![15-2.png](https://s1.imagehub.cc/images/2023/10/14/15-2.png)  
- 136行  
![15-3.png](https://s1.imagehub.cc/images/2023/10/14/15-3.png)  
- 169行  
![15-4.png](https://s1.imagehub.cc/images/2023/10/14/15-4.png)  
  
**3-重启http服务**  
`systemctl restart httpd`  
  
**4-server2配置http**  
server2也是如法炮制，只不过为了区分server1和server2，web.html的内容是不一样的，但是在实际生活中，它们的内容是一致的  
![15-6.png](https://s1.imagehub.cc/images/2023/10/14/15-6.png)  
## 【5】验收环节  
**1-关闭防火墙**  
`systemctl stop firewalld.service`  
  
**2-关闭SELinux**  
`setenforce 0`  
  
**3-浏览器验证**  
- 浏览器内输入KeepAlive虚拟IP后，可以看到是server1接管的http服务  
如果这时候是server2接管的服务，那说明配置文件是错误的  
![16-1.png](https://s1.imagehub.cc/images/2023/10/14/16-1.png)  
  
**4-模拟宕机**  
- 然后停止server1的keepalive服务，模拟server1宕机  
`systemctl stop keepalived.service`  
- 查看keepalive是不是死掉了  
`systemctl status keepalived.service`  
![Snipaste_2023-10-14_18-37-19.png](https://s1.imagehub.cc/images/2023/10/14/Snipaste_2023-10-14_18-37-19.png)  
- 这时候刷新网页，可以看到server2已经接替了http服务  
![16-2.png](https://s1.imagehub.cc/images/2023/10/14/16-2.png)  
  
**5-重新接管**  
- 然后server1 keepalive服务重新启动  
`systemctl start keepalived.service`  
- keepalive活动  
![Snipaste_2023-10-14_18-40-59.png](https://s1.imagehub.cc/images/2023/10/14/Snipaste_2023-10-14_18-40-59.png)  
- server1重新接管http服务  
![16-3.png](https://s1.imagehub.cc/images/2023/10/14/16-3.png)  
  
  
# <font color=red>【7】Chrony时间同步配置</font>  
**环境介绍：**  
|名称|IP|扮演角色|镜像版本|  
|---|---|---|---|  
|Rocky-server|192.168.10.181|chrony server|Rocky Linux Boot 9.1|  
|Rocky-client|192.168.10.182|chrony client|Rocky Linux Boot 9.1|  
  
## 【1】server安装chrony  
`yum -y install chrony`  
![e0594fdee12ab0ead40923c4b9bf0b48.png](https://s1.imagehub.cc/images/2023/11/01/e0594fdee12ab0ead40923c4b9bf0b48.png)  
  
## 【2】server修改chrony配置文件  
命令：`vi /etc/chrony.conf`  
  
**1-第3行：**  
把第三行的内容注释掉，该行用于填写外网时间服务器网址  
![6910e3629f5c87cf29c2bcd1bae0b1ee.png](https://s1.imagehub.cc/images/2023/11/01/6910e3629f5c87cf29c2bcd1bae0b1ee.png)  
  
**2-第4行：**  
格式：server IP iburst  
填写本地chrony时间同步服务器  
![5e5c35a289966213df67bed64104b7c1.png](https://s1.imagehub.cc/images/2023/11/01/5e5c35a289966213df67bed64104b7c1.png)  
  
**3-第27行：**  
取消注释allow  
然后后边填写允许哪些服务器或客户端到这台时间服务器来同步时间，可以是某个网段或具体的IP  
![eec05d2e14d9d3215a80ee2526a0c778.png](https://s1.imagehub.cc/images/2023/11/01/eec05d2e14d9d3215a80ee2526a0c778.png)  
  
**4-第30行：**  
取消注释local startum 10  
否则NTP synchronized: 为no  
取消掉后变为NTP synchronized:yes  
![a1a4b63680c099475698213dde594ebc.png](https://s1.imagehub.cc/images/2023/11/01/a1a4b63680c099475698213dde594ebc.png)  
  
## 【2】重启chrony服务  
命令：`systemctl restart chronyd`  
![3e2fbccc58bb6b41a2403266b8901ae5.png](https://s1.imagehub.cc/images/2023/11/01/3e2fbccc58bb6b41a2403266b8901ae5.png)  
加入开机自启：`systemctl enable chronyd`  
  
## 【3】检查配置  
命令：  
`netstat -antulp|grep chronyd`  
`ss -antulp|grep chronyd`  
![c7e1264f53bde977dac44dd56554f4c3.png](https://s1.imagehub.cc/images/2023/11/01/c7e1264f53bde977dac44dd56554f4c3.png)  
  
## 【4】client下载chrony  
命令：  
`yum -y install chrony`  
![1e836fd7ab5d9f8235dfae4b92877a20.png](https://s1.imagehub.cc/images/2023/11/01/1e836fd7ab5d9f8235dfae4b92877a20.png)  
  
## 【5】client修改chrony配置文件  
命令：  
`vi /etc/chrony.conf`  
**1-第3行：**  
注释掉第三行，该行为填写网络时间服务器网址  
![594de402cc14cd5297725d8b85f736b3.png](https://s1.imagehub.cc/images/2023/11/01/594de402cc14cd5297725d8b85f736b3.png)  
  
**2-第4行：**  
第四行填写本地chrony服务器地址，指向chrony server  
![3f2c3155cd8d63e7205fd17783e3355a.png](https://s1.imagehub.cc/images/2023/11/01/3f2c3155cd8d63e7205fd17783e3355a.png)  
  
## 【6】重启chrony服务  
重启chrony服务：  
`systemctl restart chronyd`  
将chrony加入开机自启：  
`systemctl enable chronyd`  
![c7e06abb4d54b2b0b261ff2f748d6162.png](https://s1.imagehub.cc/images/2023/11/01/c7e06abb4d54b2b0b261ff2f748d6162.png)  
  
## 【7】关闭防火墙及SELinux  
server和client均关闭  
`systemctl stop firewalld`  
`setenforce 0`  
  
## 【8】检查状态  
`timedatectl`  
![68eaebc788137bc08c7d91468ef1a174.png](https://s1.imagehub.cc/images/2023/11/01/68eaebc788137bc08c7d91468ef1a174.png)  
  
## 【9】查看时间源信息  
**server：**  
`chronyc sources -v`  
![bf5e6a8b80af891518827b5650d8695a.png](https://s1.imagehub.cc/images/2023/11/01/bf5e6a8b80af891518827b5650d8695a.png)  
  
**client：**  
`chronyc sources -v`  
![25de26ec99cb5deffe0033c1dd15f50b.png](https://s1.imagehub.cc/images/2023/11/01/25de26ec99cb5deffe0033c1dd15f50b.png)  
  
## 【10】验收环节  
查看当前server时间：  
`date`  
![c9c3149913204343851c8999c2ce38be.png](https://s1.imagehub.cc/images/2023/11/01/c9c3149913204343851c8999c2ce38be.png)  
查看当前client时间：  
![0c367b59ea5a27ee3c9f951fe6c1bda8.png](https://s1.imagehub.cc/images/2023/11/01/0c367b59ea5a27ee3c9f951fe6c1bda8.png)  
修改server时间为08:00  
`date -s "2023-11-1 08:00:00"`  
![9a7a1361f10d1e9104fcbb7c7df0bba4.png](https://s1.imagehub.cc/images/2023/11/01/9a7a1361f10d1e9104fcbb7c7df0bba4.png)  
等待客户端自动同步  
同步时间较为缓慢，我这里用了7分钟才同步过来  
![5b0e642c03b050f2a4a873ab41be114c.png](https://s1.imagehub.cc/images/2023/11/01/5b0e642c03b050f2a4a873ab41be114c.png)  
同步成功后，System clock synchronized会变为"yes"  
![ed977597acf935de02291225a947b5dd.png](https://s1.imagehub.cc/images/2023/11/01/ed977597acf935de02291225a947b5dd.png)  
  
# <font color=red>【8】FTP服务配置</font>  
**1-FTP服务概述：**  
1. FTP是File Transfer Protocol（文件传输协议）的英文简称，它工作在OSI模型的第七层，TCP模型的第四层上，使用TCP传输而不是UDP，这样FTP客户在和服务器建立连接前就要经过一个被广为熟知的”三次握手”的过程，它带来的意义在于客户与服务器之间的连接是可靠的，而且是面向连接，为数据的传输提供了可靠的保证。  
2. FTP服务使用FTP协议（文件传输协议）来进行文件的上传和下载，可以非常方便的进行远距离的文件传输，还支持断点续传功能，可以大幅度地减小CPU和网络带宽的开销，并实现相应的安全控制。  
3. FTP协议中，控制连接均有客户端发起，而数据连接有两种工作方式：PORT(主动)方式和PASV(被动)方式  
  
**被动模式：**  
![e6d8f6b74e2aa10a6ba5947b653c7a47.png](https://s1.imagehub.cc/images/2023/11/20/e6d8f6b74e2aa10a6ba5947b653c7a47.png)  
  
**主动模式：**  
![0d5c3a6e20cc8f729ee0d27e7258ab76.png](https://s1.imagehub.cc/images/2023/11/20/0d5c3a6e20cc8f729ee0d27e7258ab76.png)  
  
**2-FTP登入概述：**  
FTP可以有三种登入方式，分别是：  
1. 匿名登录方式：不需要用户密码  
2. 本地用户登入：使用本地用户和密码登入  
3. 虚拟用户方式：也是使用用户和密码登入，但是该用户不是linux中创建的用户  
  
**环境介绍：**  
|名称|IP|扮演角色|  
|---|---|---|  
|Rocky-Master|192.168.10.181|FTP服务器|  
|Win-Client|192.168.10.161|FTP客户端|  
  
## 【1】安装FTP服务👨‍💻  
命令：`yum -y install vsftpd`  
![5e6e2b3b44340cda73c1a2a4853b546e.png](https://s1.imagehub.cc/images/2023/11/08/5e6e2b3b44340cda73c1a2a4853b546e.png)  
  
## 【2】编写vsftpd配置文件✍️  
安装完之后在/etc/vsftpd/路径下会存在三个配置文件：  
1. vsftpd.conf: vsftp主配置文件  
2. ftpusers: 指定哪些用户不能访问FTP服务器,这里的用户包括root在内的一些重要用户。  
3. user_list: 指定的用户是否可以访问ftp服务器，通过vsftpd.conf文件中的userlist_deny的配置来决定配置中的用户是否可以访问，userlist_enable=YES ，userlist_deny=YES ，userlist_file=/etc/vsftpd/user_list 这三个配置允许文件中的用户访问FTP  
  
![8a825743db90991933b54a9f1a4cfa0b.png](https://s1.imagehub.cc/images/2023/11/08/8a825743db90991933b54a9f1a4cfa0b.png)  
  
**查看主配置文件缺省配置：**  
命令：`cat /etc/vsftpd/vsftpd.conf | grep -v '^#';`  
![5407a37abe209d68671af344503d6c6b.png](https://s1.imagehub.cc/images/2023/11/08/5407a37abe209d68671af344503d6c6b.png)  
  
**备份主配置文件：**  
命令：`cp -p vsftpd.conf vsftpd.conf.bak`  
![a4822e665e3f03b3d6d35e02bd5cebea.png](https://s1.imagehub.cc/images/2023/11/08/a4822e665e3f03b3d6d35e02bd5cebea.png)  
  
**重建vsftpd.conf：**  
比起直接修改原有ftp配置文件，我更喜欢重建ftp配置文件，当然你也可以在原配置文件上改写，看自己心情吧  
重命名`vsftpd.conf`为`vsftpd.old`：  
`mv /etc/vsftpd.conf vsftpd.old`  
新建ftp配置文件：  
`touch /etc/vsftpd/vsftpd.conf`  
**编写ftp配置文件：**  
命令：`vi /etc/vsftpd/vsftpd.conf`  
  
## 【3】配置文件详解👍  
**1-登录设置：**  
1. 是否对<font color=red>登录用户</font>开启写权限。属全局性设置。默认NO  
`write_enable=YES`  
2. 是否允许<font color=red>本地用户</font>登录FTP服务器。默认为NO  
`local_enable=YES`  
3. 设置是否允许<font color=red>匿名用户</font>登录FTP服务器。默认为YES  
`anonymous_enable=YES`  
4. 定义<font color=red>匿名用户</font>的账户名称，默认值为ftp  
`ftp_username=ftp`  
5. <font color=red>匿名用户</font>登录时是否询问口令。设置为YES，则不询问。默认NO  
`no_anon_password=YES`  
6. <font color=red>匿名用户</font>是否允许下载可阅读的文档，默认为YES  
`anon_world_readable_only=YES`  
7. 是否允许<font color=red>匿名用户</font>上传文件。只有在write_enable设置为YES时，该配置项才有效。而且匿名用户对相应的目录必须有写权限。默认为NO  
`anon_upload_enable=YES`  
8. 是否允许<font color=red>匿名用户</font>创建目录。只有在write_enable设置为YES时有效。且匿名用户对上层目录有写入的权限。默认为NO  
`anon_mkdir_write_enable=YES`  
9. 若设置为YES，则<font color=red>匿名用户</font>会被允许拥有多于上传和建立目录的权限，还会拥有删除和更名权限。默认值为NO  
`anon_other_write_enable=NO`  
  
**2-欢迎信息设置**  
1. 用户登录FTP服务器成功后，服务器可向登录用户输出预设置的欢迎信息，该配置项仅用于设置比较简短的欢迎信息  
`ftpd_banner=Welcome To My FTP Site`  
2. 若欢迎信息较多，则可使用banner_file配置项  
`banner_file=/etc/vsftpd/banner`  
3. 设置用户登录时，将要显示输出的文件。该设置项将覆盖ftpd_banner的设置  
`dirmessage_enable=YES`  
4. 设置是否显示目录消息。若设置为YES，则当用户进入特定目录（比如/var/ftp/pub）时，将显示该目录中的由message_file配置项指定的文件（.message）中的内容  
`message_file=.message`  
  
**3-用户登录后所在的目录设置：**  
1. 设置本地用户登录后所在的目录。默认配置文件中没有设置该项，此时用户登录FTP服务器后，所在的目录为该用户的主目录，对于root用户，则为/root目录  
`local_root=/var/ftp`  
2. 设置匿名用户登录后所在的目录。若未指定，则默认为/var/ftp目录  
`anon_root=/var/ftp`  
  
**4-控制用户是否允许切换到上级目录设置：**  
在默认配置下，用户可以使用“cd..”命名切换到上级目录。比如，若用户登录后所在的目录为/var/ftp，则在"ftp>"命令行下，执行“cd..”命令后，用户将切换到其上级目录/var，若继续执行该命令，则可进入Linux系统的根目录，从而可以对整个Linux的文件系统进行操作  
如果同时设置了`write_enable=YES`，则用户还可对根目录下的文件进行改写操作，会给系统带来极大的安全隐患，因此，必须防止用户切换到Linux的根目录  
  
1. 设置是否启用chroot_list_file配置项指定的用户列表文件。设置为YES则除了列在j/etc/vsftpd/chroot_list文件中的的帐号外，所有登录的用户都可以进入ftp根目录之外的目录。默认NO  
`chroot_list_enable=YES`  
2. 用于指定用户列表文件，该文件用于控制哪些用户可以切换到FTP站点根目录的上级目录  
`chroot_list_file=/etc/vsftpd/chroot_list`  
3. 用于指定用户列表文件中的用户，是否允许切换到上级目录。默认NO  
`chroot_local_user=YES`  
  
**具体情况示例：**  
1. 当chroot_list_enable=YES，chroot_local_user=YES时:  
在/etc/vsftpd/chroot_list文件中列出的用户，可以切换到上级目录；未在文件中列出的用户，不能切换到站点根目录的上级目录  
2. 当chroot_list_enable=YES，chroot_local_user=NO时:  
在/etc/vsftpd/chroot_list文件中列出的用户，不能切换到站点根目录的上级目录；未在文件中列出的用户，可以切换到上级目录  
3. 当chroot_list_enable=NO，chroot_local_user=YES时:  
所有用户均不能切换到上级目录  
4. 当chroot_list_enable=NO，chroot_local_user=NO时:  
所有用户均可以切换到上级目录  
5. 当用户不允许切换到上级目录时，登录后FTP站点的根目录“/”是该FTP账户的主目录，即文件的系统的/var/ftp目录  
  
**5-访问控制设置：**  
<font color=DeepSkyBlue>1):设置允许或不允许访问的主机：</font>  
tcp_wrappers=YES用来设置vsftpd服务器是否与tcp wrapper相结合，进行主机的访问控制。默认设置为YES，vsftpd服务器会检查/etc/hosts.allow和/etc/hosts.deny中的设置，以决定请求连接的主机是否允许访问该FTP服务器。这两个文件可以起到简易的防火墙功能。  
比如，若要仅允许192.168.168.1～192.168.168.254的用户，可以访问连接vsftpd服务器，则可在/etc/hosts.allow文件中添加以下内容：  
```  
vsftpd:192.168.168.0/255.255.255.0:allow  
all:all:deny  
```  
<font color=DeepSkyBlue>2):设置允许或不允许访问的用户：</font>  
  
对用户的访问控制由<font color=Lime>/etc/vsftpd/user_list</font>和<font color=Lime>/etc/vsftpd/ftpusers</font>文件来控制实现:  
1. 决定/etc/vsftpd/user_list文件是否启用生效。YES则生效，NO不生效  
`userlist_enable=YES`  
2. 决定/etc/vsftpd/user_list文件中的用户是允许访问还是不允许访问。若设置为YES，则/etc/vsftpd/user_list文件中的用户将不允许访问FTP服务器；若设置为NO，则只有vsftpd.user_list文件中的用户，才能访问FTP服务器  
`userlist_deny=YES`  
  
**6-访问速度设置：**  
  
1. 设置匿名用户所能使用的最大传输速度，单位为b/s。若设置为0，则不受速度限制，默认值为0  
`anon_max_rate=0`  
2. 设置本地用户所能使用的最大传输速度  
`local_max_rate=0`  
  
**7-定义用户配置文件：**  
在vsftpd服务器中，不同用户还可使用不同的配置，这要通过用户配置文件来实现。  
user_config_dir=/etc/vsftpd/userconf  
用于设置用户配置文件所在的目录。  
设置了该配置项后，当用户登录FTP服务器时，系统就会到/etc/vsftpd/userconf目录下读取与当前用户名相同的文件，并根据文件中的配置命令，对当前用户进行更进一步的配置。比如，利用用户配置文件，可实现对不同用户进行访问的速度进行控制，在各用户配置文件中，定义local_max_rate配置，以决定该用户允许的访问速度。  
  
**8-连接设置：**  
1. 设置vsftpd服务器是否以standalone模式运行。以standalone模式运行是一种较好的方式，此时listen必须设置为YES，此为默认值，建议不要更改。很多与服务器运行相关的配置命令，需要此运行模式才有效。若设置为NO，则vsftpd不是以独立的服务运行，要受xinetd服务的管理控制，功能上会受限制  
`listen=YES`  
2. 设置vsftpd允许的最大连接数，默认为0，表示不受限制。若设置为150时，则同时允许有150个连接，超出的将拒绝建立连接。只有在以standalone模式运行时才有效  
`max_clients=0`  
3. 设置在指定的IP地址上侦听用户的FTP请求。若不设置，则对服务器所绑定的所有IP地址进行侦听。只有在以standalone模式运行时才有效。对于只绑定了一个IP地址的服务器，不需要配置该项，默认情况下，配置文件中没有该配置项。若服务器同时绑定了多个IP地址，则应通过该配置项，指定在哪个IP地址上提供FTP服务，即指定FTP服务器所使用的IP地址。  
注意：设置此值前后，可以通过netstat -tnl对比端口的监听情况  
`max_per_ip=0`  
4. 设置在指定的IP地址上侦听用户的FTP请求。若不设置，则对服务器所绑定的所有IP地址进行侦听。只有在以standalone模式运行时才有效。对于只绑定了一个IP地址的服务器，不需要配置该项，默认情况下，配置文件中没有该配置项。若服务器同时绑定了多个IP地址，则应通过该配置项，指定在哪个IP地址上提供FTP服务，即指定FTP服务器所使用的IP地址。  
注意：设置此值前后，可以通过netstat -tnl对比端口的监听情况  
`listen_address=IP地址`  
5. 设置建立被动（PASV）数据连接的超时时间，单位为秒，默认值为60  
`accept_timeout=60`  
6. PORT方式下建立数据连接的超时时间，单位为秒  
`connect_timeout=60`  
7. 设置建立FTP数据连接的超时时间，默认为300秒  
`data_connection_timeout=300`  
8. 设置多长时间不对FTP服务器进行任何操作，则断开该FTP连接，单位为秒，默认为600秒。即设置发呆的逾时时间，在这个时间内，若没有数据传送或指令的输入，则会强行断开连接  
`idle_session_timeout＝600`  
9. 设置在PAM所使用的名称，默认值为vsftpd  
`pam_service_name=vsftpd`  
10. 设置每个与FTP服务器的连接，是否以不同的进程表现出来，默认值为NO，此时只有一个名为vsftpd的进程。若设置为YES，则每个连接都会有一个vsftpd进程，使用“ps -ef|grep ftp”命令可查看到详细的FTP连接信息。安全起见，建议关闭  
`setproctitle_enable=NO|YES`  
  
**9-FTP工作方式与端口设置：**  
<font color=DeepSkyBlue>1):FTP工作方式简介：</font>  
|FTP工作模式|工作方式|客户端连接模式|备注|  
|---|---|---|---|  
|PORT(主动)|数据传输端口由FTP服务器指定|PASV|若客户端连接类型设置为PORT，则能建立FTP连接，但在执行ls或get等需要数据请求的命令时，将会出现无响应并最终报告无法建立数据连接|  
|PASV(被动)|数据传输端口由FTP客户端指定|/|/|  
  
<font color=DeepSkyBlue>2):端口相关配置：</font>  
  
1. 设置FTP服务器建立连接所侦听的端口，默认值为21  
`listen_port=21`  
2. 连接非标准端口示例：ftp www.sunflower.org 7000  
默认值为YES，指定FTP数据传输连接使用20端口。若设置为NO，则进行数据连接时，所使用的端口由ftp_data_port指定  
`connect_from_port_20＝YES`  
3. 设置PORT方式下FTP数据连接所使用的端口，默认值为20  
`ftp_data_port=20`  
4. 若设置为YES，则使用PASV工作模式；若设置为NO，使用PORT模式。默认为YES，即使用PASV模式  
`pasv_enable=YES|NO`  
5. 设置在PASV工作方式下，数据连接可以使用的端口范围的上界。默认值为0，表示任意端口  
`pasv_max_port=0`  
6. 设置在PASV工作方式下，数据连接可以使用的端口范围的下界。默认值为0，表示任意端口  
`pasv_mim_port=0`  
  
**10-传输模式设置：**  
FTP在传输数据时，可使用二进制（Binary）方式，也可使用ASCII模式来上传或下载数据  
1. 设置是否启用ASCII模式下载数据。默认为NO  
`ascii_download_enable=YES`  
2. 设置是否启用ASCII模式上传数据。默认为NO  
`ascii_upload_enable=YES`  
  
**11-上传文档的所属关系和权限设置：**  
  
<font color=DeepSkyBlue>1):设置匿名上传文档的属主：</font>  
  
用于设置是否改变匿名用户上传的文档的属主。默认为NO。若设置为YES，则匿名用户上传的文档的属主将被设置为chown_username配置项所设置的用户名  
`chown_uploads=YES`  
设置匿名用户上传的文档的属主名。只有chown_uploads=YES时才有效。建议不要设置为root用户。 但系统默root  
`chown_username=whoever`  
  
<font color=DeepSkyBlue>2):新增文档的权限设定：</font>  
  
设置本地用户新增文档的umask，默认为022，对应的权限为755。umask为022，对应的二进制数为000 010 010，将其取反为111 101 101，转换成十进制数，即为权限值755，代表文档的所有者（属主）有读写执行权，所属组有读和执行权，其他用户有读和执行权。022适合于大多数情况，一般不需要更改。若设置为077，则对应的权限为700  
`local_umask=022`  
设置匿名用户新增文档的umask。默认077  
`anon_umask=022`  
设置上传文档的权限。权限采用数字格式。 默认0666  
`file_open_mode=0755`  
  
**12-日志设置：**  
1. 是否启用上传/下载日志记录。默认为NO  
`xferlog_enable=YES`  
2. 设置日志文件名及路径。需启用xferlog_enable选项  
`xferlog_file=var/log/vsftpd.log`  
3. 日志文件是否使用标准的xferlog日志文件格式（与wu-ftpd使用的格式相同） 。默认为NO  
`xferlog_std_format=YES`  
  
**13-其他设置：**  
1. 设置在执行ls命令时，是显示UID、GID还是显示出具体的用户名或组名称。默认为NO，以UID和GID方式显示，若希望显示用户名和组名称，则设置为YES  
`text_userdb_names=NO`  
2. 若设置为YES，则允许执行“ls –R”这个命令，默认值为NO。在配置文件中该配置项被注释掉了，与此类似的还有一些配置，需要启用时，将注释符去掉并进行YES或NO的设置即可  
`ls_recurse_enable=YES`  
  
## 【4】编写vsftpd.conf  
```  
anonymous_enable=YES  
write_enable=YES  
local_umask=022  
anon_upload_enable=YES  
anon_mkdir_write_enable=YES  
anon_other_write_enable=YES  
anon_root=/var/ftp/pub  
ftp_username=ftp  
ftpd_banner=Welcome To My FTP Site  
```  
## 【5】设置映射文件夹权限  
设置FTP所映射的文件夹/var/ftp/pub为755  
命令：`chmod 755 /var/ftp/pub`  
[腾讯云开发者社区-Linux主机文件777，755，644权限详解[通俗易懂]](https://cloud.tencent.com/developer/article/2029893 "腾讯云-Linux主机文件777，755，644权限详解[通俗易懂]")  
  
## 【6】验收环节  
**重启vsftpd：**  
`systemctl restart vsftpd`  
**防火墙允许通过21端口：**  
`firewall-cmd --zone=public --add-port=21/tcp --permanent`  
**或者直接关闭防火墙：**  
`systemctl stop firewalld`  
**客户端关闭防火墙：**  
![bc33a501ad698755774fd46fab76f8ca.png](https://s1.imagehub.cc/images/2023/11/22/bc33a501ad698755774fd46fab76f8ca.png)  
**测试连通：**  
![2b421ebe1191df14297a60c9bc9a8e66.png](https://s1.imagehub.cc/images/2023/11/22/2b421ebe1191df14297a60c9bc9a8e66.png)  
**1):使用命令行连接FTP：**  
`ftp 192.168.10.181`  
输入匿名用户名"ftp"，密码空，然后就能连上咯  
![3d69e68ca830cfee3734d493b06a3823.png](https://s1.imagehub.cc/images/2023/11/22/3d69e68ca830cfee3734d493b06a3823.png)  
**2):使用可视化客户端"FileZilla"测试：**  
"主机"填写FTP服务器地址  
"用户名"填写匿名用户名"ftp"  
"密码"为空  
"端口"填写"21"  
![b35c450c30148998786d59b5c27c55f3.png](https://s1.imagehub.cc/images/2023/11/22/b35c450c30148998786d59b5c27c55f3.png)  
![a9414077c4a1ac9f6914dd3659176778.png](https://s1.imagehub.cc/images/2023/11/22/a9414077c4a1ac9f6914dd3659176778.png)  
**参考资料：**  
[CSDN-FTP服务](https://blog.csdn.net/liuhuanboke/article/details/104940796 "CSDN-FTP服务")  
[CSDN-在linux上搭建ftp服务器及其配置文件常用参数详解](https://blog.csdn.net/weixin_42499593/article/details/86666176?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169942076816800182751667%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=169942076816800182751667&biz_id=0&spm=1018.2226.3001.4187 "CSDN-在linux上搭建ftp服务器及其配置文件常用参数详解")👍  
[CSDN-Linux-vsftpd配置文件解析](https://blog.csdn.net/qq_39720594/article/details/115300454 "CSDN-Linux-vsftpd配置文件解析")👍  
[CSDN-LInux的FTP服务](https://blog.csdn.net/m0_57515995/article/details/125363237?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169941985416800188523346%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=169941985416800188523346&biz_id=0&spm=1018.2226.3001.4187 "CSDN-LInux的FTP服务")👍👍👍  
[CSDN-【Linux】FTP文件服务器](https://blog.csdn.net/qq_45277554/article/details/131452806?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169941985416800188523346%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=169941985416800188523346&biz_id=0&spm=1018.2226.3001.4187 "CSDN-【Linux】FTP文件服务器")👍👍👍  
[博客园-linux中ftp配置文件详解](https://www.cnblogs.com/chenjianhong/p/4144303.html "博客园-linux中ftp配置文件详解")👍👍👍  
[博客园-linux下ftp配置文件详解](https://www.cnblogs.com/cqlb/p/9511186.html "博客园-linux下ftp配置文件详解")👍👍👍  
  
# <font color=red>【9】DHCP服务器配置</font>  
  
**1):什么是DHCP：**  
动态主机配置协议DHCP（Dynamic Host Configuration Protocol）是一种网络管理协议，用于集中对用户IP地址进行动态管理和配置。  
DHCP于1993年10月成为标准协议，其前身是BOOTP协议。DHCP协议由RFC 2131定义，采用客户端/服务器通信模式，由客户端（DHCP Client）向服务器（DHCP Server）提出配置申请，DHCP Server为网络上的每个设备动态分配IP地址、子网掩码、默认网关地址，域名服务器（DNS）地址和其他相关配置参数，以便可以与其他IP网络通信。  
详见：[HUAWEI-什么是DHCP？](https://info.support.huawei.com/info-finder/encyclopedia/zh/DHCP.html "HUAWEI-什么是DHCP？")👍👍👍  
  
**2:)环境介绍：**  
使用VMware Workstation Pro 17 NAT模式配置  
|名称|IP|扮演角色|系统版本|  
|---|---|---|---|  
|DHCP-Master|192.168.2.137|DHCP服务器|Rocky-Boot-9.1|  
|DHCP-Client|DHCP获取|DHCP客户端|Rocky-Boot-9.1|  
|Win~`?#^*/!@&*|DHCP获取|DHCP客户端|Windows Server 2022 Standard|  
  
## 【1】安装DHCP  
命令：`yum -y install dhcp*`  
![67b88c1e88b80ef81d32eacdeac4d066.png](https://s1.imagehub.cc/images/2023/11/23/67b88c1e88b80ef81d32eacdeac4d066.png)  
  
## 【2】编写DHCP配置文件  
**配置文件路径：**`/etc/dhcp/dhcpd.conf`  
这时候的配置文件啥也没有，但它会为你指向一个DHCP配置文件模板路径  
现在我们去复制配置模板，在模板的基础上进行改写就行  
![7e3969c608bb4f47957bc9a3c2e2f9b1.png](https://s1.imagehub.cc/images/2023/11/23/7e3969c608bb4f47957bc9a3c2e2f9b1.png)  
**复制DHCP配置文件模板：**`cp -p /usr/share/doc/dhcp-server/dhcpd.conf.example /etc/dhcp/dhcpd.conf`  
输入"y"覆盖现有的DHCP配置文件  
![cda7455a08ebeacf12bc85325e9e6db7.png](https://s1.imagehub.cc/images/2023/11/23/cda7455a08ebeacf12bc85325e9e6db7.png)  
10.11行默认即可  
![0d9f299140ec7cdb55d770faf52e1851.png](https://s1.imagehub.cc/images/2023/11/23/0d9f299140ec7cdb55d770faf52e1851.png)  
取消注释14行  
![9ac65986fe128349ae40167ab9593eac.png](https://s1.imagehub.cc/images/2023/11/23/9ac65986fe128349ae40167ab9593eac.png)  
默认即可  
![f2ad437842e94f9bf25a45d4f6e21d41.png](https://s1.imagehub.cc/images/2023/11/23/f2ad437842e94f9bf25a45d4f6e21d41.png)  
声明要分配的网段IP，主机位为0  
子网掩码改为3个255  
![285a51a812fd2451af8ccce88575880f.png](https://s1.imagehub.cc/images/2023/11/23/285a51a812fd2451af8ccce88575880f.png)  
网段IP填写自己同网段，主机位填0  
子网掩码默认3个255即可  
地址范围按需划分(起始地址间有空格分隔)  
默认网关按需填写  
![1062e78faade8ea6cdb35f66bb804706.png](https://s1.imagehub.cc/images/2023/11/23/1062e78faade8ea6cdb35f66bb804706.png)  
36行后的内容都可以删掉了  
![cb293a7ec8d57fc3d08245961c9afdef.png](https://s1.imagehub.cc/images/2023/11/23/cb293a7ec8d57fc3d08245961c9afdef.png)  
  
## 【3】验收环节  
**1.重启DHCP服务：**  
`systemctl restart dhcpd`  
**2.将DHCP服务加入开机自启：**  
`systemctl enable dhcpd`  
**3.关闭防火墙：**  
`systemctl stop firewalld`  
**4.关闭防火墙开机自启：**  
`systemctl disable firewalld`  
**5.临时关闭SELinux(重启后失效)：**  
`setenforce 0`  
**6.查看DHCP运行状态：**  
`systemctl status dhcpd`  
![bb60bc3d428c83452b457497fb154312.png](https://s1.imagehub.cc/images/2023/11/23/bb60bc3d428c83452b457497fb154312.png)  
**7.取消VMware NAT DHCP服务：**  
如果不取消，客户端就会去获取VMware的DHCP，而不是去获取我们的DHCP服务  
![1b5093a0697a1d66ffaea89cb1875b41.png](https://s1.imagehub.cc/images/2023/11/23/1b5093a0697a1d66ffaea89cb1875b41.png)  
**8.客户端IP设置为自动获取：**  
![997b31c2cce6a35ea25a7951b9e02523.png](https://s1.imagehub.cc/images/2023/11/24/997b31c2cce6a35ea25a7951b9e02523.png)  
**DHCP-Client成功自动获取IP：**  
IP也是我们划分的DHCP范围内的IP地址  
![9971a29817eaaca7a6f059d73a4a0b41.png](https://s1.imagehub.cc/images/2023/11/23/9971a29817eaaca7a6f059d73a4a0b41.png)  
**9.网卡设置为自动获取：**  
![7f6afb5105dc6174bf4113dafe68689a.png](https://s1.imagehub.cc/images/2023/11/24/7f6afb5105dc6174bf4113dafe68689a.png)  
**Win~`?#^*/!@&*成功自动获取IP：**  
![0a92b2e468b237e7ecf1904c4aa56bdb.png](https://s1.imagehub.cc/images/2023/11/23/0a92b2e468b237e7ecf1904c4aa56bdb.png)  
  
**DHCP配置文件一键CV：**  
~~CV工程师狂喜~~  
```  
option domain-name "example.org";  
option domain-name-servers ns1.example.org, ns2.example.org;  
default-lease-time 600;  
max-lease-time 7200;  
ddns-update-style none;  
log-facility local7;  
subnet 192.168.2.0 netmask 255.255.255.0 {  
}  
subnet 192.168.2.0 netmask 255.255.255.0 {  
  range 192.168.2.230 192.168.2.240;  
  option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;  
}  
```  
  
资料参考：  
[CSDN-DHCP配置方式 dhcpd.conf配置文件](https://blog.csdn.net/hotshortgg/article/details/113903837 "CSDN-DHCP配置方式 dhcpd.conf配置文件")👍👍👍  
[CSDN-Linux安装配置DHCP](https://blog.csdn.net/renfeigui0/article/details/100130108 "CSDN-Linux安装配置DHCP")👍👍  
[CSDN-Linux环境下配置DHCP服务器](https://blog.csdn.net/mldl_/article/details/118282062 "CSDN-Linux环境下配置DHCP服务器")👍👍  
[博客园-linux中DHCP服务配置文件/etc/dhcpd.conf详细说明](https://www.cnblogs.com/wajika/p/6535175.html "博客园-linux中DHCP服务配置文件/etc/dhcpd.conf详细说明")👍👍👍  
  
# <font color=red>【10】Sabma服务器配置</font>👀  
**1): Samba简介：**  
Samba是基于SMB协议（Server Message Block 信息服务块）的开源软件。一种Linux、UNIX系统上可用于共享文件和打印机等资源的协议，这种协议基于Client/Server型协议  
Samba服务目录主要是用于Linux系统和Windows系统之间共享文件的最佳选择  
  
**2): 环境介绍**  
|名称|IP|扮演角色|系统版本|  
|---|---|---|---|  
|SMB-Server|192.168.10.181|SMB服务器|Rocky_Boot_9.1|  
|SMB-Client1|192.168.10.161|SMB客户端|Windows Server 2022 Standard|  
|SMB-Client1|192.168.10.183|SMB客户端|Ubuntu 22.04.3 Desktop|  
## 【1】安装Samaba  
命令：`dnf -y install samba`  
![2ff2ff045bb45f00d9fa7ba41bc51f54.png](https://s1.imagehub.cc/images/2023/11/30/2ff2ff045bb45f00d9fa7ba41bc51f54.png)  
  
## 【2】创建用户  
创建一个系统用户，为后续添加samba用户准备：`adduser username`  
创建完毕后为其创建用户密码：`passwd username`  
![d5fcf8cab86b79ed844a7506140f03ef.png](https://s1.imagehub.cc/images/2023/11/30/d5fcf8cab86b79ed844a7506140f03ef.png)  
  
## 【3】创建共享文件夹  
命令：`mkdir name`  
然后在文件夹内创建一个txt文件，再往里边随便写点内容  
`touch filename`  
![ab3fdb8d9bdc6524dec09eed21134ab9.png](https://s1.imagehub.cc/images/2023/11/30/ab3fdb8d9bdc6524dec09eed21134ab9.png)  
## 【4】SMB配置文件详解✔️  
### 【1】全局参数  
==================Global Settings ===================  
[global]  
1. `config file = /usr/local/samba/lib/smb.conf.%m`  
config file可以让你使用另一个配置文件来覆盖缺省的配置文件。如果文件不存在，则该项无效。这个参数很有用，可以使得samba配置更灵活，可以让一台samba服务器模拟多台不同配置的服务器。比如，你想让PC1（主机名）这台电脑在访问SambaServer时使用它自己的配置文件，那么先在/etc/samba/host/下为PC1配置一个名为smb.conf.pc1的文件，然后在smb.conf中加入：config file = /etc/samba/host/smb.conf.%m。这样当PC1请求连接Samba Server时，smb.conf.%m就被替换成smb.conf.pc1。这样，对于PC1来说，它所使用的Samba服务就是由smb.conf.pc1定义的，而其他机器访问Samba Server则还是应用smb.conf  
2. `workgroup = WORKGROUP`  
设定Samba Server 所要加入的工作组或者域  
3. `server string = Samba Server Version %v`  
设定Samba Server的注释，可以是任何字符串，也可以不填。宏%v表示显示Samba的版本号  
4. `netbios name = smbserver`  
设置Samba Server的NetBIOS名称。如果不填，则默认会使用该服务器的DNS名称的第一部分。netbios name和workgroup名字不要设置成一样了  
5. `interfaces = lo eth0 192.168.80.2/24 192.168.81.2/24`  
设置Samba Server监听哪些网卡，可以写网卡名，也可以写该网卡的IP地址  
6. `hosts allow = 127. 192.168.82. 192.168.80.130`  
表示允许连接到samba server 的客户端，多个参数以空格隔开。可以用一个IP表示，也可以用一个网段表示  
hosts allow和hosts deny刚好相反（2选1）  
例：  
hosts allow=192.168.80. EXCEPT192.168.80.130  
表示允许来自192.168.80.* 的主机连接，但排除192.168.80.130  
hosts allow=192.168.80.0/24  
表示允许来自192.168.80.0/24子网中的所有主机连接  
7. `hosts allow=M1，M2`  
表示容许来自M1和M2两台计算机连接  
8. `hosts allow=@xq`  
表示容许来自XQ网域的所有计算机连接  
9. `max connections = 0`  
max connections用来指定连接Samba Server的最大连接数目。如果超出连接数目，则新的连接请求将被拒绝。0表示不限制  
10.  `deadtime = 0`  
deadtime用来设置断掉一个没有打开任何文件的连接的时间。单位是分钟，0代表Samba Server不自动切断任何连接  
11.  `time server = yes/no`  
time server用来设置让nmdb成为windows客户端的时间服务器  
12.  `log file = /var/log/samba/log.%m`  
设置Samba Server日志文件的存储位置以及日志文件名称。在文件名后加个宏%m（主机名），表示对每台访问Samba Server的机器都单独记录一个日志文件。如果pc1、pc2访问过Samba Server，就会在/var/log/samba目录下留下log.pc1和log.pc2两个日志文件  
13.  `max log size =50`  
设置Samba Server日志文件的最大容量，单位为kB，0代表不限制。  
14.  `security = user`  
    设置用户访问Samba Server的验证方式，一共有四种验证方式：  
    1)：share：用户访问Samba Server不需要提供用户名和口令, 安全性能较低。  
    2)：user：Samba Server共享目录只能被授权的用户访问,由Samba Server负责检查账号和密码的正确性。账号和密码要在本Samba Server中建立。  
    3)：server：依靠其他Windows NT/2000或Samba Server来验证用户的账号和密码,是一种代理验证。此种安全模式下,系统管理员可以把所有的Windows用户和口令集中到一个NT系统上,使用Windows NT进行Samba认证, 远程服务器可以自动认证全部用户和口令,如果认证失败,Samba将使用用户级安全模式作为替代的方式。  
    4)：domain：域安全级别,使用主域控制器(PDC)来完成认证。  
15.  `passdb backend = tdbsam`  
    passdb backend就是用户后台的意思。目前有三种后台：smbpasswd、tdbsam和ldapsam。sam应该是security account manager（安全账户管理）的简写  
    1)：smbpasswd：该方式是使用smb自己的工具smbpasswd来给系统用户（真实用户或者虚拟用户）设置一个Samba密码，客户端就用这个密码来访问Samba的资源。smbpasswd文件默认在/etc/samba目录下，不过有时候要手工建立该文件。  
    2)：tdbsam：该方式则是使用一个数据库文件来建立用户数据库。数据库文件叫passdb.tdb，默认在/etc/samba目录下。passdb.tdb用户数据库可以使用smbpasswd –a来建立Samba用户，不过要建立的Samba用户必须先是系统用户。我们也可以使用pdbedit命令来建立Samba账户  
16.  `encrypt passwords = yes/no`  
是否将认证密码加密。因为现在windows操作系统都是使用加密密码，所以一般要开启此项。不过配置文件默认已开启  
17.  `smb passwd file = /etc/samba/smbpasswd`  
用来定义samba用户的密码文件。smbpasswd文件如果没有那就要手工新建  
18.  `username map = /etc/samba/smbusers`  
用来定义用户名映射，比如可以将root换成administrator、admin等。不过要事先在smbusers文件中定义好。比如：root = administrator admin，这样就可以用administrator或admin这两个用户来代替root登陆Samba Server，更贴近windows用户的习惯  
19.  `guest account = nobody`  
用来设置guest用户名  
20.  `socket options = TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192`  
用来设置服务器和客户端之间会话的Socket选项，可以优化传输速度  
21.  `domain master = yes/no`  
设置Samba服务器是否要成为网域主浏览器，网域主浏览器可以管理跨子网域的浏览服务  
22.  `local master = yes/no`  
local master用来指定Samba Server是否试图成为本地网域主浏览器。如果设为no，则永远不会成为本地网域主浏览器。但是即使设置为yes，也不等于该Samba Server就能成为主浏览器，还需要参加选举  
23.  `preferred master = yes/no`  
设置Samba Server一开机就强迫进行主浏览器选举，可以提高Samba Server成为本地网域主浏览器的机会。如果该参数指定为yes时，最好把domain master也指定为yes。使用该参数时要注意：如果在本Samba Server所在的子网有其他的机器（不论是windows NT还是其他Samba Server）也指定为首要主浏览器时，那么这些机器将会因为争夺主浏览器而在网络上大发广播，影响网络性能。如果同一个区域内有多台Samba Server，将上面三个参数设定在一台即可  
24.  `os level = 200`  
设置samba服务器的os level。该参数决定Samba Server是否有机会成为本地网域的主浏览器。os level从0到255，winNT的os level是32，win95/98的os level是1。Windows 2000的os level是64。如果设置为0，则意味着Samba Server将失去浏览选择。如果想让Samba Server成为PDC，那么将它的os level值设大些  
25.  `domain logons = yes/no`  
设置Samba Server是否要做为本地域控制器。主域控制器和备份域控制器都需要开启此项  
26.  `logon . = %u.bat`  
当使用者用windows客户端登陆，那么Samba将提供一个登陆档。如果设置成%u.bat，那么就要为每个用户提供一个登陆档。如果人比较多，那就比较麻烦。可以设置成一个具体的文件名，比如start.bat，那么用户登陆后都会去执行start.bat，而不用为每个用户设定一个登陆档了。这个文件要放置在[netlogon]的path设置的目录路径下  
27.  `wins support = yes/no`  
设置samba服务器是否提供wins服务  
28.  `wins server= wins服务器IP地址`  
设置Samba Server是否使用别的wins服务器提供wins服务  
29.  `wins proxy = yes/no`  
设置Samba Server是否开启wins代理服务  
30.  `dns proxy = yes/no`  
设置Samba Server是否开启dns代理服务  
31.  `load printers = yes/no`  
设置是否在启动Samba时就共享打印机  
32.  `printcap name = cups`  
设置共享打印机的配置文件  
33.  `printing = cups`  
设置Samba共享打印机的类型。现在支持的打印系统有：bsd, sysv, plp, lprng, aix, hpux, qnx  
  
### 【2】共享参数  
================== Share Definitions ==================  
[共享名]  
1. `comment = 任意字符串`  
comment是对该共享的描述，可以是任意字符串  
2. `path = 共享目录路径`  
path用来指定共享目录的路径。可以用%u、%m这样的宏来代替路径里的unix用户和客户机的Netbios名，用宏表示主要用于[homes]共享域。例如：如果我们不打算用home段做为客户的共享，而是在/home/share/下为每个Linux用户以他的用户名建个目录，作为他的共享目录，这样path就可以写成：path = /home/share/%u; 。用户在连接到这共享时具体的路径会被他的用户名代替，要注意这个用户名路径一定要存在，否则，客户机在访问时会找不到网络路径。同样，如果我们不是以用户来划分目录，而是以客户机来划分目录，为网络上每台可以访问samba的机器都各自建个以它的netbios名的路径，作为不同机器的共享资源，就可以这样写：path = /home/share/%m  
3. `browseable = yes/no`  
browseable用来指定该共享是否可以浏览  
4. `writable = yes/no`  
writable用来指定该共享路径是否可写  
5. `available = yes/no`  
available用来指定该共享资源是否可用  
6. `admin users = 该共享的管理者`  
admin users用来指定该共享的管理员（对该共享具有完全控制权限）。在samba 3.0中，如果用户验证方式设置成“security=share”时，此项无效  
例如：admin users =bobyuan，jane（多个用户中间用逗号隔开）  
7. `valid users = 允许访问该共享的用户`  
valid users用来指定允许访问该共享资源的用户  
例如：valid users =bobyuan，@bob，@tech（多个用户或者组中间用逗号隔开，如果要加入一个组就用“@+组名”表示  
8. `invalid users = 禁止访问该共享的用户`  
9. invalid users用来指定不允许访问该共享资源的用户  
例如：invalid users = root，@bob（多个用户或者组中间用逗号隔开  
10. `write list = 允许写入该共享的用户`  
write list用来指定可以在该共享下写入文件的用户  
例如：write list = bobyuan，@bob  
11. `public = yes/no`  
public用来指定该共享是否允许guest账户访问  
12. `guest ok = yes/no`  
意义同"public"  
  
### 【3】特殊共享  
```  
[homes]  
comment = Home Directories  
browseable = no  
writable = yes  
valid users = %S  
valid users = MYDOMAIN\%S  
  
[printers]  
comment = All Printers  
path = /var/spool/sam  
babrowseable = no  
guest ok = no  
writable = no  
printable = yes  
  
[netlogon]  
comment = Network Logon Service  
path = /var/lib/samba/netlogon  
guest ok = yes  
writable = no  
share modes = no  
  
[Profiles]  
path = /var/lib/samba/profiles  
browseable = no  
guest ok = yes  
```  
  
## 【5】编写Samba配置文件✍️  
**备份配置文件：**  
`cp -p /etc/samba/smb.conf smb.conf.bak`  
命令：`vi /etc/samba/smb.conf`  
然后在配置文件末尾添加以下内容：  
```  
[test1]  
       comment = '114514'  
       path=/smbshare  
       public=no  
       writable = yes  
       guest ok = yes  
```  
![01038d6826e2693c3a55b2363a0b8792.png](https://s1.imagehub.cc/images/2023/11/30/01038d6826e2693c3a55b2363a0b8792.png)  
  
## 【6】验收环节  
**1. 重启SMB：**  
`systemctl restart smb`  
**2. 关闭防火墙：**  
`systemctl stop firewalld`  
**3. 关闭SELinux：**  
`setenforce 0`  
  
Windows客户端测试连通性：  
![a6414d4fbffaca60ea95ecd0ec987937.png](https://s1.imagehub.cc/images/2023/11/30/a6414d4fbffaca60ea95ecd0ec987937.png)  
这时候去访问会显示"无法访问"  
![60ce4d2140259e711648e3b41f4513e4.png](https://s1.imagehub.cc/images/2023/11/30/60ce4d2140259e711648e3b41f4513e4.png)  
这是因为还没有向samba中添加本地用户  
然后再输入两次密码即可  
`smbpasswd -a username`  
![7289dc9bd598952192fad9c1e3ee5771.png](https://s1.imagehub.cc/images/2023/11/30/7289dc9bd598952192fad9c1e3ee5771.png)  
**SMB-Client1验证：**  
SMB-Client1验证成功  
![07ce311496db7c817a75b6456f017e75.png](https://s1.imagehub.cc/images/2023/11/30/07ce311496db7c817a75b6456f017e75.png)  
**SMB-Client2验证：**  
在Ubuntu"文件"-"其他位置"-"连接到服务器中输入"`smb://192.168.10.181`  
![e03689a49bdcc10b106fff94501ff7f5.png](https://s1.imagehub.cc/images/2023/11/30/e03689a49bdcc10b106fff94501ff7f5.png)  
选择"匿名"，然后点击"连接"  
![0d71ee93c5eaf0ad9263f769569b1550.png](https://s1.imagehub.cc/images/2023/11/30/0d71ee93c5eaf0ad9263f769569b1550.png)  
SMB-Client2验证成功  
![f92bc39076681c85119c473ee66eac4c.png](https://s1.imagehub.cc/images/2023/11/30/f92bc39076681c85119c473ee66eac4c.png)  
  
参考资料：  
[Linux教程和文章-如何在RHEL、Rocky Linux和AlmaLinux中设置Samba服务器](https://cn.linux-console.net/?p=2605 "Linux教程和文章-如何在RHEL、Rocky Linux和AlmaLinux中设置Samba服务器")⭐️⭐️  
[自如初-Rocky Linux 9.1安装Samba](https://ziruchu.com/art/541 "自如初-Rocky Linux 9.1安装Samba")👍👍👍  
[博客园-SAMBA配置文件详解](https://www.cnblogs.com/sswind/p/12060842.html "博客园-SAMBA配置文件详解")👍👍👍  
[阿里云开发者社区-Samba配置文件常用参数详解](https://developer.aliyun.com/article/471201#:~:text=Samba%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E5%B8%B8%E7%94%A8%E5%8F%82%E6%95%B0%E8%AF%A6%E8%A7%A3%201%20config%20file%20%3D%20%2Fusr%2Flocal%2Fsamba%2Flib%2Fsmb.conf.%25m%20%E8%AF%B4%E6%98%8E%EF%BC%9Aconfig%20file%E5%8F%AF%E4%BB%A5%E8%AE%A9%E4%BD%A0%E4%BD%BF%E7%94%A8%E5%8F%A6%E4%B8%80%E4%B8%AA%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E6%9D%A5%E8%A6%86%E7%9B%96%E7%BC%BA%E7%9C%81%E7%9A%84%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E3%80%82,Server%E6%97%A5%E5%BF%97%E6%96%87%E4%BB%B6%E7%9A%84%E5%AD%98%E5%82%A8%E4%BD%8D%E7%BD%AE%E4%BB%A5%E5%8F%8A%E6%97%A5%E5%BF%97%E6%96%87%E4%BB%B6%E5%90%8D%E7%A7%B0%E3%80%82%20...%205%20logon%20.%20%3D%20%25u.bat%20 "阿里云开发者社区-Samba配置文件常用参数详解")👍👍👍  
[博客园-如何在Linux中向Samba添加删除用户](https://www.cnblogs.com/a5idc/p/13533610.html "博客园-如何在Linux中向Samba添加删除用户")👍👍👍  
[CSDN-ubuntu16.04通过网络访问windows共享文件夹（samba）](https://blog.csdn.net/Yemiekai/article/details/113432451#:~:text=%E4%BB%8EUbuntu%20Desktop%E8%AE%BF%E9%97%AEWindows%E4%B8%8Bsamba%E5%85%B1%E4%BA%AB%E6%96%87%E4%BB%B6%E5%A4%B9%201%201.%20%E5%AE%89%E8%A3%85samba%20windows%E7%9A%84%E5%85%B1%E4%BA%AB%E6%96%87%E4%BB%B6%E5%A4%B9%E8%B2%8C%E4%BC%BC%E6%98%AF%E7%94%A8%E7%9A%84%20SMB%20%E5%8D%8F%E8%AE%AE%EF%BC%8C%E6%89%80%E4%BB%A5%E5%85%88%E7%BB%99ubuntu%E8%A3%85%E4%B8%8ASMB%EF%BC%9A,%E5%88%A0%E6%8E%89%E6%95%B4%E4%B8%AA%20%3Cbookmark%3E%20%E6%A0%87%E7%AD%BE%EF%BC%9A%20gedit%20~%2F.config%2Fnautilus%2Fservers%201%20%E7%84%B6%E5%90%8E%E5%88%A0%E6%8E%89%E4%BF%9D%E5%AD%98%E7%9A%84%E5%AF%86%E9%92%A5%EF%BC%9A%20 "CSDN-ubuntu16.04通过网络访问windows共享文件夹（samba）")⭐️⭐️  
  
# <font color=red>【11】Nginx HTTP服务配置</font>  
**Nginx简介：**  
Nginx(engine x)是一个轻量级高性能的HTTP和反向代理服务器，同时也是一个通用代理服务器 （TCP/UDP/IMAP/POP3/SMTP），最初由俄罗斯人Igor Sysoev编写  
Nginx是一款面向性能设计的HTTP服务器，相较于Apache、lighttpd具有占有内存少，稳定性高等优势  
  
**环境介绍：**  
|名称|IP地址|扮演角色|系统版本|  
|---|---|---|---|  
|Nginx-Server|192.168.10.183|Nginx服务器|Rocky_Boot_9.3|  
|Nginx-Client|192.168.10.162|Nginx客户端|Windows Server 2022 Standard|  
## 【1】安装Nginx  
命令：`dnf -y install nginx`  
  
## 【2】调整防火墙策略  
**在端口80上永久启用HTTP连接：**  
`firewall-cmd --permanent --add-service=http`  
**更新防火墙服务：**  
`firewall-cmd --reload`  
**或者直接关闭防火墙：**  
`systemctl stop firewalld`  
**临时关闭SELinux(重启失效)：**  
`setenforce 0`  
  
## 【3】编写Nginx配置文件  
Nginx配置文件位于`/etc/nginx/nginx.conf`  
备份Nginx配置文件：`cp -p /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak`  
  
**1-监听端口：**  
第39行是Nginx监听端口，我这里更改为8079端口  
![a615924a771b398e4cb7f9f972d8d9c8.png](https://s1.imagehub.cc/images/2023/12/07/a615924a771b398e4cb7f9f972d8d9c8.png)  
  
安装完Nginx后，启动Nginx服务，在浏览器地址栏内输入IP+端口如果能正常访问那就没问题，下面的更改访问路径及默认文档做不做都可以  
![22fe3cfe065938d82743b0814cb4e234.png](https://s1.imagehub.cc/images/2023/12/07/22fe3cfe065938d82743b0814cb4e234.png)  
  
**2-访问路径及站点默认文档：**  
把`root`后面原来的`/usr/share/nginx/html;`改成你站点主页的路径，记得加分号  
增加`index`行，并在后面填写站点默认文档文件名，也要加分号  
![4fa54e94b083827dc8afa18784f2c044.png](https://s1.imagehub.cc/images/2023/12/07/4fa54e94b083827dc8afa18784f2c044.png)  
  
## 【4】重启Nginx服务  
重启Nginx服务命令：`systemctl restart nginx`  
查看Nginx服务状态：`systemctl status nginx`  
![0b224219498e541987d8550cbdfc057a.png](https://s1.imagehub.cc/images/2023/12/07/0b224219498e541987d8550cbdfc057a.png)  
  
## 【5】编写站点默认文档  
在站点默认文档内随便写点内容以验证Nginx服务配置成功  
覆盖内容到114514.html中：`echo "114514" > /114514.html`  
![7a8015c35e3fbe47139a8e6640cdfb73.png](https://s1.imagehub.cc/images/2023/12/07/7a8015c35e3fbe47139a8e6640cdfb73.png)  
  
## 【6】验收环节⭐  
**测试客户端与Nginx服务器连通性：**  
![47c496144cfc5346c03a6a368208fac6.png](https://s1.imagehub.cc/images/2023/12/07/47c496144cfc5346c03a6a368208fac6.png)  
浏览器地址栏内输入`http://192.168.10.183:8079`  
![498167e3bc947ffcf443de14936e4121.png](https://s1.imagehub.cc/images/2023/12/07/498167e3bc947ffcf443de14936e4121.png)  
  
参考资料：  
[Linux教程和文章-如何在Rocky Linux 9上安装Nginx](https://cn.linux-console.net/?p=6592 "Linux教程和文章-如何在Rocky Linux 9上安装Nginx")👍👍👍  
[阿里云开发者社区-nginx配置改变默认访问路径](https://developer.aliyun.com/article/243316 "阿里云开发者社区-nginx配置改变默认访问路径")👍👍👍  
[博客园-Nginx配置文件详解](https://www.cnblogs.com/hunttown/p/5759959.html "博客园-Nginx配置文件详解")  
[博客园-Nginx配置文件详解](https://www.cnblogs.com/54chensongxia/p/12938929.html "博客园-Nginx配置文件详解")  
[博客园-nginx详细参数配置(史上最全)](https://www.cnblogs.com/hanease/p/15890509.html "博客园-nginx详细参数配置(史上最全)")  
  
# <font color=red>【12】Linux加入Windows域</font>  
**环境介绍：**  
|名称|IP|扮演角色|DNS指向|  
|---|---|---|---|  
|WinSer-1|192.168.10.100|AD主域控制器|192.168.10.100|  
|RocSer-1|192.168.10.183|AD域内主机|192.168.10.100|  
  
## 【1】配置AD主域控制器  
先把AD主域控制器配置好，并关闭全部防火墙  
![ccacf2c5f48550747e615fe43882471b.png](https://s1.imagehub.cc/images/2023/12/12/ccacf2c5f48550747e615fe43882471b.png)  
  
## 【2】修改主机名  
`vi /etc/hostname`  
![a5d47cbb93739d3339c5b2c23177fb07.png](https://s1.imagehub.cc/images/2023/12/12/a5d47cbb93739d3339c5b2c23177fb07.png)  
  
## 【3】安装realmd包  
命令：`yum -y install realmd`  
安装对应软件包：`yum -y install oddjob oddjob-mkhomedir sssd samba-common-tools`  
  
## 【4】修改本地DNS缓存  
命令：`vim /etc/resolv.conf`  
注释掉现有的DNS  
![7c22dc3a21db1a7e96005713caa7447a.png](https://s1.imagehub.cc/images/2023/12/12/7c22dc3a21db1a7e96005713caa7447a.png)  
  
## 【5】修改DNS指向  
命令：`vi /etc/NetworkManager/system-connections/ens33.nmconnection`  
DNS指向AD域控制器IP地址  
![1d544a11c3eee65afcde5924b8d58130.png](https://s1.imagehub.cc/images/2023/12/12/1d544a11c3eee65afcde5924b8d58130.png)  
  
## 【6】激活网卡配置  
```  
mcli connection load /etc/NetworkManager/system-connections/ens33.nmconnection  
mcli connection up /etc/NetworkManager/system-connections/ens33.nmconnection  
```  
  
## 【7】关闭防火墙及SELinux  
关闭防火墙：`systemctl stop firewalld`  
临时关闭SELinux：`setenforce 0`  
  
## 【8】加入AD域  
输入`realm join --user=域账号名 域名`  
然后输入Windows管理员密码，无报错即加域成功  
再次尝试加域会提示"已加入该域"  
![2d7f986417b6b382f4a15eeca0562c85.png](https://s1.imagehub.cc/images/2023/12/12/2d7f986417b6b382f4a15eeca0562c85.png)  
  
## 【9】验收环节  
在AD主域控制器内的AD用户和计算机-Computers可以看到刚才加进去的"ROCSER-1"主机  
![bebbf4cb54bf2e6ec35f1a792c7f204f.png](https://s1.imagehub.cc/images/2023/12/12/bebbf4cb54bf2e6ec35f1a792c7f204f.png)  
![269a3a1e95121f071000a905b858f61f.png](https://s1.imagehub.cc/images/2023/12/12/269a3a1e95121f071000a905b858f61f.png)  
![bf4e513e52cc9db8fb6c8e80b62139f3.png](https://s1.imagehub.cc/images/2023/12/12/bf4e513e52cc9db8fb6c8e80b62139f3.png)  
  
参考资料：  
[CSDN-Linux加入Windows域](https://blog.csdn.net/m0_57695646/article/details/122038213 "CSDN-Linux加入Windows域")👍👍👍  
  
# <font color=red>【13】Tomcat HTTP配置</font>  
  
**环境介绍：**  
|名称|IP|扮演角色|系统版本|  
|---|---|---|---|  
|Tomcat-Server|192.168.10.181|Tomcat服务器|Rocky_Linux_9.1|  
|Tomcat-Client|192.168.10.161|Tomcat客户端|Windows Server 2022 Standard|  
  
## 【1】下载Tomcat  
使用`wget`下载官网最新版Tomcat10.1.17安装包  
`wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.17/bin/apache-tomcat-10.1.17.tar.gz`  
  
## 【2】解压Tomcat tar.gz  
1. 在`/usr/local`内创建`tomcat`文件夹：  
`mkdir /usr/local/tomcat`  
2. 解压apache-tomcat-10.1.17.tar.gz到/usr/local/tomcat目录下  
`tar -zxvf apache-tomcat-10.1.17.tar.gz -C /usr/local/tomcat`  
  
## 【3】安装java环境  
Tomcat需要java环境支持  
安装java：`yum -y install java`  
![06c396520d6d878dde106f35a4d60088.png](https://s1.imagehub.cc/images/2023/12/13/06c396520d6d878dde106f35a4d60088.png)  
  
## 【4】启动Tomcat  
cd到bin文件夹内：`cd /usr/local/tomcat/apache-tomcat-10.1.17/bin`  
启动Tomcat脚本文件：`./startup.sh`或`sh startup.sh`  
![6a0bcfff9baaadcea5ebe493f0881df4.png](https://s1.imagehub.cc/images/2023/12/13/6a0bcfff9baaadcea5ebe493f0881df4.png)  
报错未找到文件"catalina.sh"?  
但是ls -l可以看到"catalina.sh"?  
![23c137df501c38d83da91a450f20a53c.png](https://s1.imagehub.cc/images/2023/12/13/23c137df501c38d83da91a450f20a53c.png)  
只是"catalina.sh"没有可执行权限而已  
`chmod +x catalina.sh`  
再次执行`./startup.sh`或`sh startup.sh`  
  
```  
[root@Tomcat-Server bin]# ./startup.sh  
Using CATALINA_BASE:   /usr/local/tomcat/apache-tomcat-10.1.17  
Using CATALINA_HOME:   /usr/local/tomcat/apache-tomcat-10.1.17  
Using CATALINA_TMPDIR: /usr/local/tomcat/apache-tomcat-10.1.17/temp  
Using JRE_HOME:        /usr  
Using CLASSPATH:       /usr/local/tomcat/apache-tomcat-10.1.17/bin/bootstrap.jar:/usr/local/tomcat/apache-tomcat-10.1.17/bin/tomcat-juli.jar  
Using CATALINA_OPTS:     
Tomcat started.  
```  
出现`Tomcat started`字段即为启动成功  
  
## 【5】验证Tomcat  
关闭防火墙：`systemctl stop firewalld`  
或放行8080端口：`firewall-cmd --zone=public --permanent --add-port=8080/tcp`  
更新防火墙策略：`firewall-cmd --reload`  
> 浏览器地址栏内输入`Tomcat服务器IP:8080`  
  
![5f41c5695898fd9fa79ec48757c3b650.png](https://s1.imagehub.cc/images/2023/12/13/5f41c5695898fd9fa79ec48757c3b650.png)  
  
## 【6】添加管理员账户密码  
账户文件位于`apache-tomcat-10.1.17/conf/tomcat-users.xml`文件内：`vi /usr/local/tomcat/apache-tomcat-10.1.17/conf/tomcat-users.xml`  
在倒数第2行内写入以下内容  
```  
<role rolename="manager-gui">  
<user username="username" password="password" roles="manager-gui"/>  
```  
![5536a7ae9fb3055352f1c21671f0f35f.png](https://s1.imagehub.cc/images/2023/12/13/5536a7ae9fb3055352f1c21671f0f35f.png)  
现在点击"Server Status"  
![50b37bfe52a3a8a7833421b41aa704a2.png](https://s1.imagehub.cc/images/2023/12/13/50b37bfe52a3a8a7833421b41aa704a2.png)  
会报错"401"  
![b06e8c8798af8c97abb2c02da10f33d1.png](https://s1.imagehub.cc/images/2023/12/13/b06e8c8798af8c97abb2c02da10f33d1.png)  
这是因为tomcat进行了ip限制，还需要将限制取消掉  
`vi /etc/local/tomcat/apache-tomcat-10.1.17/webapps/manager/META-INF/context.xml`  
![37198709dec6112168e22680b9941e04.png](https://s1.imagehub.cc/images/2023/12/13/37198709dec6112168e22680b9941e04.png)  
刷新界面，输入用户名密码即可登录  
忘记用户名或密码了?：`cat /usr/local/tomcat/apache-tomcat-10.1.17/conf/tomcat-users.xml`  
![36502fa91f72ddaa875d71df11763645.png](https://s1.imagehub.cc/images/2023/12/13/36502fa91f72ddaa875d71df11763645.png)  
![366394e14475561b239aaa2afc068191.png](https://s1.imagehub.cc/images/2023/12/13/366394e14475561b239aaa2afc068191.png)  
  
## 【7】更换监听端口  
`vi /usr/local/tomcat/apache-tomcat-10.1.17/conf/server.xml`  
把68行的`port=`内的数字改为你喜欢的端口  
![6f3af18f0e85935b77c124ef2e7fc97e.png](https://s1.imagehub.cc/images/2023/12/13/6f3af18f0e85935b77c124ef2e7fc97e.png)  
放行端口：`firewall-cmd --zone=public --permanent --add-port=端口/tcp`  
更新防火墙策略：`firewall-cmd --reload`  
  
我把tomcat解压到了`/usr/local/tomcat`目录，你如果解压到了其他的目录，请`cd`到那个目录进行配置  
> 忘了你的解压目录?  
  
从根目录开始查找名为`server.xml`的文件：`find / -name "server.xml"`  
![b9862473877b6251e8e3ca530d59ecac.png](https://s1.imagehub.cc/images/2023/12/13/b9862473877b6251e8e3ca530d59ecac.png)  
  
## 【8】更改默认目录  
`vi /usr/local/tomcat/apache-tomcat-10.1.17/conf/server.xml`  
在141行内的`appBase=`内修改为站点默认文档的路径  
![db54562aed60981bfa5c43878254746a.png](https://s1.imagehub.cc/images/2023/12/13/db54562aed60981bfa5c43878254746a.png)  
在www目录下创建ROOT文件夹：`mkdir -p /usr/local/tomcat/www/ROOT`  
输出`Tomcat Yes!`到`index.html`内：`echo "Tomcat Yes!" > index.html`  
  
## 【9】验收环节  
在浏览器地址栏内填写`Tomcat服务器IP+端口`  
如果你的端口改的是`80`的话就不用加端口了，直接输入IP即可  
![9ce005d220cd3a90acf7d64f13026d36.png](https://s1.imagehub.cc/images/2023/12/13/9ce005d220cd3a90acf7d64f13026d36.png)  
  
> 注意：  
对Tomcat配置文件进行更改后，要执行一遍conf目录下的`shutdown.sh`和`startup.sh`，即重启Tomcat服务  
需要cd到bin文件夹内执行：cd /usr/local/tomcat/apache-tomcat-10.1.17/bin  
```  
./shutdown.sh  
./startup.sh  
```  
  
参考资料：  
[CSDN-Linux下启动、配置、修改tomcat](https://blog.csdn.net/u011435933/article/details/80748531 "CSDN-Linux下启动、配置、修改tomcat")   
[CSDN-Tomcat访问Manager APP报403错误解决方案](https://blog.csdn.net/qq_36935391/article/details/81814505 "CSDN-Tomcat访问Manager APP报403错误解决方案")  
  
# <font color=red>【14】Keepalived+Nginx实现高可用Web负载均衡 </font>  
  
**Keepalived原理：**  
![3872e42c3153bfe568fb095443ec7b4d.png](https://s1.imagehub.cc/images/2023/12/26/3872e42c3153bfe568fb095443ec7b4d.png)  
![07f6d184d7c0c0481ab675b4d8a4d664.png](https://s1.imagehub.cc/images/2023/12/26/07f6d184d7c0c0481ab675b4d8a4d664.png)  
详见：  
[博客园-keepalived原理](https://www.cnblogs.com/aaronthon/p/9548633.html "博客园-keepalived原理")👍👍👍  
[知乎-Keepalived原理与实战](https://zhuanlan.zhihu.com/p/143295216 "知乎-Keepalived原理与实战")👍👍  
  
**环境介绍：**  
|名称|IP|扮演角色|系统版本|  
|--|---|---|---|  
|Keepalive-Master|192.168.10.191|Keepalive主服务器|Rocky_Linux_9.1|  
|Keepalive-Slave|192.168.10.192|Keepalive备服务器|Rocky_Linux_9.1|  
|/|192.168.10.190|Keepalive虚拟IP|/|  
|Keepalive-Client|192.168.10.161|Nginx客户端|Windows Server 2022 Standard|  
  
## 【1】下载Keepalived源码  
yum包管理器提供的虽然也是2.2.8版本的Keepalive包，但是有BUG，所以才会使用Keepalive源码编译  
Keepalive官网：[Keepalived for Linux](https://keepalived.org/index.html "Keepalived for Linux")  
来到Keepalive官网后，点击"Download"  
![63051241bb1d3fa3cb9e34dde301d536.png](https://s1.imagehub.cc/images/2023/12/16/63051241bb1d3fa3cb9e34dde301d536.png)  
右键最新的版本，复制下载链接至剪贴板  
![4ca1610cf02cd58e0616fe961b7896e4.png](https://s1.imagehub.cc/images/2023/12/16/4ca1610cf02cd58e0616fe961b7896e4.png)  
然后使用`wget`命令下载Keepalive-v2.2.8源码，等待下载完成  
`wget https://keepalived.org/software/keepalived-2.2.8.tar.gz`  
![31026f7fb944be9d11d41385323c9fa5.png](https://s1.imagehub.cc/images/2023/12/16/31026f7fb944be9d11d41385323c9fa5.png)  
  
## 【2】基础依赖包安装  
我只缺少前两款基础依赖包，安装前两款即可  
`yum -y install gcc openssl-devel`  
```  
yum -y install gcc  
yum -y install openssl-devel  
yum -y install libnl libnl-devel  
yum -y install libnfnetlink-devel  
yum -y install net-tools  
yum -y install vim  
```  
  
## 【3】解压Keepalived源码  
在/usr/local目录下创建keepalived文件夹：`mkdir /usr/local/keepalived`  
解压tar包至keepalived目录下：`tar -zxvf keepalived-2.2.8.tar.gz -C /usr/local/keepalived/`  
  
## 【4】编译安装Keepalived源码  
首先来到Keepalived安装目录内：  
`cd /usr/local/keepalived/keepalived-2.2.8/`  
生成makefile文件，并把Keepalived安装至/etc下：  
`./configure --prefix=/usr/local/keepalived --sysconf=/etc`  
安装执行：  
`make && make install`  
执行完这些命令后，屏幕上会乌央乌央的出现一大堆内容，请放心，这是正常现象  
  
## 【5】复制Keepalived配置文件  
如果你现在直接启动Keepalived的话，会报错配置文件丢失  
![0b5fa2843470746cdbde4037ac76b590.png](https://s1.imagehub.cc/images/2023/12/16/0b5fa2843470746cdbde4037ac76b590.png)  
解决办法也很简单，只需要把`/etc/keepalived`文件夹下的keepalived配置文件示例复制一份即可  
`cp -p /etc/keepalived/keepalived.conf.sample keepalived.conf`  
**Slave也别忘了复制一份**  
  
## 【6】编写Keepalived配置文件  
`vim /etc/keepalived/keepalived.conf`  
### 【1】Master Keepalived配置文件  
**全局定义模块：**  
除12行外全部注释，12行的`router_id`可以改为别的名称，比如Keepalived-Master类似的  
12行的`router_id`为全局唯一标识，不能重复  
![82e19fa0689dfe58c25eb63cb47b0a3e.png](https://s1.imagehub.cc/images/2023/12/16/82e19fa0689dfe58c25eb63cb47b0a3e.png)  
  
**Nginx脚本检测模块：**  
CV工程师狂喜：  
不要忘了复制最后一行的花括号  
  
```  
vrrp_script chk_nginx {  
         script "/etc/keepalived/nginx_check.sh"   
         interval 2   
         weight -20   
}  
```  
![fe87e6e8a24875d8e73dd6e5dd601344.png](https://s1.imagehub.cc/images/2023/12/16/fe87e6e8a24875d8e73dd6e5dd601344.png)  
  
**VRRP实例定义模块：**  
自己看图吧  
![0656374e03910782c5299afdf656e8ee.png](https://s1.imagehub.cc/images/2023/12/16/0656374e03910782c5299afdf656e8ee.png)  
后面的内容可以删掉了，按下"Esc"键，然后点击`dG`即可删除光标后所有内容  
![d29ddbfccbd1e7a9ee9a824e2e4cec90.png](https://s1.imagehub.cc/images/2023/12/16/d29ddbfccbd1e7a9ee9a824e2e4cec90.png)  
  
**重启Keepalived并加入开机自启：**  
`systemctl restart keepalived&&systemctl enable keepalived`  
  
**查看Keepalived状态：**  
`systemctl status keepalived`  
![fc832f78469cf138ed76c871a6912fcb.png](https://s1.imagehub.cc/images/2023/12/25/fc832f78469cf138ed76c871a6912fcb.png)  
  
### 【2】Slave Keepalived配置文件  
BACKUP与MASTER配置有3处不同，其他地方均是相同的  
第1处是router id与MASTER不同  
第2处将`MASTER`更改为`BACKUP`  
第3处将优先级修改为比`MASTER`优先级低50点  
![837dcd18cd2cd02e6a0a7b7365c776bd.png](https://s1.imagehub.cc/images/2023/12/25/837dcd18cd2cd02e6a0a7b7365c776bd.png)  
**重启Keepalived并加入开机自启：**  
`systemctl restart keepalived&&systemctl enable keepalived`  
  
**查看Keepalived状态：**  
![b8a75de9645a029d35840286fa1b5416.png](https://s1.imagehub.cc/images/2023/12/25/b8a75de9645a029d35840286fa1b5416.png)  
  
## 【7】编写Nginx检测脚本  
### 【1】Master  
脚本路径填写你在Keepalive配置文件20行中填写的路径  
`vi /etc/keepalived/nginx_check.sh`  
![c0d904d74ca0f3f5462dde4eab0286ae.png](https://s1.imagehub.cc/images/2023/12/25/c0d904d74ca0f3f5462dde4eab0286ae.png)  
```  
# vi /etc/keepalived/nginx_check.sh  
#!/bin/bash  
A=`ps -C nginx –no-header |wc -l`  
if [ $A -eq 0 ];then  
/usr/local/nginx/sbin/nginx  
sleep 2  
if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then  
	killall keepalived  
fi  
fi  
```  
然后给脚本文件赋予可执行权限  
`chmod +x /etc/keepalived/nginx_check.sh`  
**重启Keepalived：**  
`systemctl restart keepalived`  
  
### 【2】Slave  
![262853ed1973690ac2d752f94a3da8d2.png](https://s1.imagehub.cc/images/2023/12/25/262853ed1973690ac2d752f94a3da8d2.png)  
然后给脚本文件赋予可执行权限  
`chmod +x /etc/keepalived/nginx_check.sh`  
**重启Keepalived：**  
`systemctl restart keepalived`  
  
## 【8】Nginx配置  
### 【1】Master配置Nginx  
安装Nginx：`yum -y install nginx`  
编写Nginx配置文件：`vi /etc/nginx/nginx.conf`  
![dd51bd782a8de6589a63a3d0ce7766d0.png](https://s1.imagehub.cc/images/2023/12/25/dd51bd782a8de6589a63a3d0ce7766d0.png)  
在`server_name`后填写Keepalived虚拟IP  
如果需要改变Nginx主页的话那就修改42,43行  
  
输出This is Master!到/etc/nginx/index.html文件内  
`echo "This is Master!" > /etc/nginx/index.html`  
  
重启Nginx并加入开机自启：`systemctl restart nginx&&systemctl enable nginx`  
查看Nginx状态：`systemctl status nginx`  
![e057db9b1a5c67fdb53c0ee4a63cf9d3.png](https://s1.imagehub.cc/images/2023/12/25/e057db9b1a5c67fdb53c0ee4a63cf9d3.png)  
  
### 【2】Slave配置Nginx  
安装Nginx：`yum -y install nginx`  
编写Nginx配置文件：`vi /etc/nginx/nginx.conf`  
![51776e2e57bf81fee22b6a071838725c.png](https://s1.imagehub.cc/images/2023/12/25/51776e2e57bf81fee22b6a071838725c.png)  
  
输出This is Slave!到/etc/nginx/index.html文件内  
`echo "This is Slave!" > /etc/nginx/index.html`  
  
重启Nginx并加入开机自启：`systemctl restart nginx&&systemctl enable nginx`  
查看Nginx状态：`systemctl status nginx`  
![c7950c80edf03fa86ded4ac0aa15bb0d.png](https://s1.imagehub.cc/images/2023/12/25/c7950c80edf03fa86ded4ac0aa15bb0d.png)  
  
## 【9】验收环节  
客户端浏览器地址栏内输入Keepalived虚拟IP：`http://192.168.10.190`  
![2ba335abe0db7feb8db533856b275e31.png](https://s1.imagehub.cc/images/2023/12/25/2ba335abe0db7feb8db533856b275e31.png)  
然后挂起Master，模拟Master宕机  
或者停止Keepalived服务：`systemctl stop keepalived`  
![aadd60073ae13cde20326b3be59abe81.png](https://s1.imagehub.cc/images/2023/12/25/aadd60073ae13cde20326b3be59abe81.png)  
再次刷新网页后，Slave接替Nginx服务  
![fedf600080a5e62f640aafeb4fab7a02.png](https://s1.imagehub.cc/images/2023/12/25/fedf600080a5e62f640aafeb4fab7a02.png)  
还原Master  
或者重启Keepalived服务：`systemctl restart keepalived`  
![01ab02342b528fb8b454f2e47ffdcf69.png](https://s1.imagehub.cc/images/2023/12/25/01ab02342b528fb8b454f2e47ffdcf69.png)  
由于Master的优先级为200，比Slave优先级100高，所以由Master重新接替Nginx服务，本次实验成功  
![d097a20a58fd37ef00659ae15e9e8ade.png](https://s1.imagehub.cc/images/2023/12/25/d097a20a58fd37ef00659ae15e9e8ade.png)  
F12-网络：  
![8d6dd8aa65d7bdca53c911d07ddf60cb.png](https://s1.imagehub.cc/images/2023/12/25/8d6dd8aa65d7bdca53c911d07ddf60cb.png)  
  
参考资料：  
[CSDN-Keepalived之——Keepalived + Nginx 实现高可用 Web 负载均衡](https://blog.csdn.net/l1028386804/article/details/72801492 "CSDN-Keepalived之——Keepalived + Nginx 实现高可用 Web 负载均衡")👍👍👍  
[博客园-centos8 keepalived安装](https://www.cnblogs.com/chenwenchao123/p/15109290.html "博客园-centos8 keepalived安装")👍👍👍  
[知乎-nginx(六) 搭配keepalived高可用、四层负载均衡](https://zhuanlan.zhihu.com/p/455502306 "知乎-nginx(六) 搭配keepalived高可用、四层负载均衡")👍👍  
[CSDN-keepalived 源码编译安装部署](https://blog.csdn.net/qq_43584691/article/details/116483789 "CSDN-keepalived 源码编译安装部署")  
  