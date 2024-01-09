**环境介绍：**  
请确保你的Consele线全程保持连接  
使用`Ubuntu Desktop 22.04.3 LTS amd64`系统镜像进行实验  
![7e605c01a7f84ad6d872b92d9614c999.png](https://s1.imagehub.cc/images/2024/01/08/7e605c01a7f84ad6d872b92d9614c999.png)  
右键桌面打开终端，使用`sudo su`切换至root用户进行操作，避免权限不够而报错  
![37efa5186d0afda3090a398f9e9bfa79.png](https://s1.imagehub.cc/images/2024/01/08/37efa5186d0afda3090a398f9e9bfa79.png)  
更新apt源`apt update`  
使用`apt-get install minicom`安装Minicom包  
![b22df90cdf2d5620fb1e34e0b2fa7185.png](https://s1.imagehub.cc/images/2024/01/08/b22df90cdf2d5620fb1e34e0b2fa7185.png)  
使用`dmesg | grep ttyUSB0`查看串口设备  
![1201914002a3d27f98090023250fb23c.png](https://s1.imagehub.cc/images/2024/01/08/1201914002a3d27f98090023250fb23c.png)  
使用`minicom -s`进入Minicom配置界面  
![837874d56f85aea1b8ac9f38e690139c.png](https://s1.imagehub.cc/images/2024/01/08/837874d56f85aea1b8ac9f38e690139c.png)  
使用键盘方向键选择到"串口设置"(Serial port setup)  
![d41b41cf4fe60adbac31fff0d648fac0.png](https://s1.imagehub.cc/images/2024/01/08/d41b41cf4fe60adbac31fff0d648fac0.png)  
然后开启大写锁定，按下`A`修改串行设备  
更改为`/dev/ttyUSB0`，然后回车确定  
![d0a2edb7968ad798b2194a8ae3b7245c.png](https://s1.imagehub.cc/images/2024/01/08/d0a2edb7968ad798b2194a8ae3b7245c.png)  
我连接的是二层交换机，波特率为9600，但是Minicom默认波特率为115200，所以还需要修改波特率  
如果你使用的设备波特率为115200，则跳过修改波特率步骤  
按下`E`键去修改波特率  
![d0a2edb7968ad798b2194a8ae3b7245c.png](https://s1.imagehub.cc/images/2024/01/08/d0a2edb7968ad798b2194a8ae3b7245c.png)  
按下`C`键使用9600波特率，回车确定  
![ed149d963ec33cf29d4f933a56931bed.png](https://s1.imagehub.cc/images/2024/01/08/ed149d963ec33cf29d4f933a56931bed.png)  
可以看到波特率已经修改为9600了  
开启大写锁定，按下`F`键，将"硬件流控制"设置为"否"  
按2次回车键  
![5b1ae2f1ce40c574f325cc661c090c8f.png](https://s1.imagehub.cc/images/2024/01/09/5b1ae2f1ce40c574f325cc661c090c8f.png)  
然后方向键选择到"保存设置为dfl"(Save setup as dfl)  
![be9f47f3bfbca2a7f7c13020bd655597.png](https://s1.imagehub.cc/images/2024/01/08/be9f47f3bfbca2a7f7c13020bd655597.png)  
然后在Ubuntu虚拟机窗口右下角点击USB图标  
![b6df9d4ada0f5cf3fde68ba4e14321ac.png](https://s1.imagehub.cc/images/2024/01/08/b6df9d4ada0f5cf3fde68ba4e14321ac.png)  
点击"连接"  
这一步骤将会断开USB设备与宿主机的连接  
![0e758e96bf7ad969880616f19b832028.png](https://s1.imagehub.cc/images/2024/01/08/0e758e96bf7ad969880616f19b832028.png)  
点击"确定"  
![62f9662951bd12ceedaf806cc9ac0aa5.png](https://s1.imagehub.cc/images/2024/01/08/62f9662951bd12ceedaf806cc9ac0aa5.png)  
然后选择到"离开本画面"(Exit)  
![cc305c26ad4cd1a92cd804637aedf491.png](https://s1.imagehub.cc/images/2024/01/08/cc305c26ad4cd1a92cd804637aedf491.png)  
按1次回车键就可以连接至交换机了  
![1796935585cd14271510d42a6312128f.png](https://s1.imagehub.cc/images/2024/01/09/1796935585cd14271510d42a6312128f.png)  
  
Minicom常用命令  
|命令|说明|/|  
|---|---|---|  
|Ctrl+A X|退出程序|/|  
|Ctrl+A W|启用/禁用自动换行，默认禁用|/|  
|Ctrl+A E|启用/禁用输入显示，默认禁用|/|  
|Ctrl+A C|清屏|/|  
  