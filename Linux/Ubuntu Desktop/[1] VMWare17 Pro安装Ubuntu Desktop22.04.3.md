链接跳转：  
[Ubuntu Linux官网](https://ubuntu.com/ "Ubuntu Linux官网")  
[Ubuntu-阿里开源镜像站](https://developer.aliyun.com/mirror/ubuntu "Ubuntu-阿里开源镜像站")  
  
**环境介绍：**  
使用`VMware Workstation 17Pro`和`Ubuntu Desktop 22.04.3`进行实验  
首先新建虚拟机，选择"自定义"  
![93fe74106b22d520ba5eaa2271ae52b5.png](https://s1.imagehub.cc/images/2024/01/07/93fe74106b22d520ba5eaa2271ae52b5.png)  
下一步  
![9cf5fbfd2f576ade4eb3c5b90a2054fb.png](https://s1.imagehub.cc/images/2024/01/07/9cf5fbfd2f576ade4eb3c5b90a2054fb.png)  
选择"稍后安装操作系统"  
![82536ef2c6d607efc259cef6d57c182b.png](https://s1.imagehub.cc/images/2024/01/07/82536ef2c6d607efc259cef6d57c182b.png)  
选择"Linux"，版本"Ubuntu 64位"  
![c9b34a1ea2b096c1787ba97474aced99.png](https://s1.imagehub.cc/images/2024/01/07/c9b34a1ea2b096c1787ba97474aced99.png)  
填写虚拟机名称以及选择虚拟机位置  
![951b7033986fbe9f63288219328f1bde.png](https://s1.imagehub.cc/images/2024/01/07/951b7033986fbe9f63288219328f1bde.png)  
处理器数量选择`1`，内核数量根据自己CPU的核心数量填写，一般来说4个足够应对大部分场景了  
我的CPU是Inter i5-10400，是6核12线程的一款CPU，为Ubuntu分配4个核心足够跑动  
![b48f57633045ccd0a79f8bf89827eee0.png](https://s1.imagehub.cc/images/2024/01/07/b48f57633045ccd0a79f8bf89827eee0.png)  
为Ubuntu分配4GB内存足够了，宿主机内存建议大于等于8G  
![a29e4873c057194e1f9ebf82b833e28a.png](https://s1.imagehub.cc/images/2024/01/07/a29e4873c057194e1f9ebf82b833e28a.png)  
网络模式我这里使用的是NAT模式  
![d972294ac99369989a213223dd377719.png](https://s1.imagehub.cc/images/2024/01/07/d972294ac99369989a213223dd377719.png)  
默认即可，下一步  
![2096b2a2d9490c9372a360ab7df5faaa.png](https://s1.imagehub.cc/images/2024/01/07/2096b2a2d9490c9372a360ab7df5faaa.png)  
虚拟磁盘类型默认SCSI就行  
![74ebb0a0aaac697911842ab06a9e748b.png](https://s1.imagehub.cc/images/2024/01/07/74ebb0a0aaac697911842ab06a9e748b.png)  
选择"创建新虚拟磁盘"  
![a6ea735ae45769c78c885d09996cfb1c.png](https://s1.imagehub.cc/images/2024/01/07/a6ea735ae45769c78c885d09996cfb1c.png)  
Ubuntu最大磁盘大小分配30G及以上足够  
![b50fcad5d598eef706ddac6486d54dfa.png](https://s1.imagehub.cc/images/2024/01/07/b50fcad5d598eef706ddac6486d54dfa.png)  
![510e4b7a655f76eb292570ab37f24d57.png](https://s1.imagehub.cc/images/2024/01/07/510e4b7a655f76eb292570ab37f24d57.png)  
点击"自定义硬件"  
![45a88dda914e2d449b3abc9659be2c38.png](https://s1.imagehub.cc/images/2024/01/07/45a88dda914e2d449b3abc9659be2c38.png)  
在"CD/DVD"中点击"浏览"，选择到Ubuntu镜像  
![03358d4766ab4cc5cdbbbf5564bacb02.png](https://s1.imagehub.cc/images/2024/01/07/03358d4766ab4cc5cdbbbf5564bacb02.png)  
可以把声卡和打印机移除，没什么用  
然后关闭"自定义硬件"，完成新建虚拟机  
![819fd1d68f15aa00207909d7b1421a50.png](https://s1.imagehub.cc/images/2024/01/07/819fd1d68f15aa00207909d7b1421a50.png)  
然后开启Ubuntu  
![697d5d7b93964ac7a0e7c903ab1b46e8.png](https://s1.imagehub.cc/images/2024/01/07/697d5d7b93964ac7a0e7c903ab1b46e8.png)  
选择到`Try or Install Ubuntu`并回车确定  
![586329d846fa4b5097c3378b5ebb55e5.png](https://s1.imagehub.cc/images/2024/01/07/586329d846fa4b5097c3378b5ebb55e5.png)  
在左边语言栏内选择到"中文(简体)"，然后点击"安装Ubuntu"  
![9d515fd0e1fc6b13a3004d237cf2fa0d.png](https://s1.imagehub.cc/images/2024/01/07/9d515fd0e1fc6b13a3004d237cf2fa0d.png)  
键盘布局选择"Chinese"  
![9b1e2ac94bbabf60974942de7b6418a3.png](https://s1.imagehub.cc/images/2024/01/07/9b1e2ac94bbabf60974942de7b6418a3.png)  
选择"正常安装"以及勾选"安装Ubuntu时下载更新"  
![2c02c6afdeab53d3e2d341d4af171e50.png](https://s1.imagehub.cc/images/2024/01/07/2c02c6afdeab53d3e2d341d4af171e50.png)  
选择"清除整个磁盘并安装Ubuntu"，然后点击"现在安装"  
![01f29a52ed7fc080e6236ff506fbe9e1.png](https://s1.imagehub.cc/images/2024/01/07/01f29a52ed7fc080e6236ff506fbe9e1.png)  
点击"继续"  
![b618e2697d6004f9e98ad373baa68e7a.png](https://s1.imagehub.cc/images/2024/01/07/b618e2697d6004f9e98ad373baa68e7a.png)  
选择地区时区  
![457bafbc65dede6dfcb6bfea54ea59a8.png](https://s1.imagehub.cc/images/2024/01/07/457bafbc65dede6dfcb6bfea54ea59a8.png)  
填写"姓名"以及一个符合Ubuntu密码规则的密码，点击"继续"  
![566f4387dfe0e3a6112c0999f5f5b884.png](https://s1.imagehub.cc/images/2024/01/07/566f4387dfe0e3a6112c0999f5f5b884.png)  
等待Ubuntu安装，安装过程会持续20-40分钟，安装速度取决于你硬盘的读写性能了  
![35b6d11991f65045bcf4c4b58fd8d95c.png](https://s1.imagehub.cc/images/2024/01/07/35b6d11991f65045bcf4c4b58fd8d95c.png)  
安装完毕后点击"现在重启"  
![39a1213abce95de05bf9cce3d6b8cb16.png](https://s1.imagehub.cc/images/2024/01/07/39a1213abce95de05bf9cce3d6b8cb16.png)  
按下回车键  
![09583ebed819efcb6b2ef4d1cc3f367d.png](https://s1.imagehub.cc/images/2024/01/07/09583ebed819efcb6b2ef4d1cc3f367d.png)  
点击用户名，输入你的密码后登录  
![542074bc94a4e8d8613af45c075da1bd.png](https://s1.imagehub.cc/images/2024/01/07/542074bc94a4e8d8613af45c075da1bd.png)  
点击右上角的"跳过"  
![1692ee21a1fd46fb20278385db1bfe4e.png](https://s1.imagehub.cc/images/2024/01/07/1692ee21a1fd46fb20278385db1bfe4e.png)  
点击"前进"  
![a83661404c6f2a5a7c1dd349ffaf978b.png](https://s1.imagehub.cc/images/2024/01/07/a83661404c6f2a5a7c1dd349ffaf978b.png)  
点击"前进"  
![c06998b7bdfc24699d35090f0f1ca981.png](https://s1.imagehub.cc/images/2024/01/07/c06998b7bdfc24699d35090f0f1ca981.png)  
点击右上角的"完成"  
![efd90d0f9fee00eb75b357f7532077ae.png](https://s1.imagehub.cc/images/2024/01/07/efd90d0f9fee00eb75b357f7532077ae.png)  
至此，Ubuntu Desktop安装完毕  
可以开始你的操作了  
建议拍摄一个快照版本，这样如果你Ubuntu系统做毁了还可以回到这个快照版本  
~~比如rm -rf /*~~  
![7215db59cedf6041b9160db8cae583a3.png](https://s1.imagehub.cc/images/2024/01/07/7215db59cedf6041b9160db8cae583a3.png)  
  