**环境介绍：**  
请确保你的Consele线全程保持连接  
使用银河麒麟桌面操作系统V10-SP1-2309内测版系统镜像进行实验  
![5773fdda293114cc1cdea31beb7e567d.png](https://s1.imagehub.cc/images/2024/01/02/5773fdda293114cc1cdea31beb7e567d.png)  
右键桌面打开终端，输入`sudo su`切换至root用户进行操作，否则下面的操作会报错权限不够  
![c050fbe410291242cdc27e9bc291fe93.png](https://s1.imagehub.cc/images/2024/01/02/c050fbe410291242cdc27e9bc291fe93.png)
输入`apt-get install minicom`使用apt包管理器安装minicom  
![41b430874afe5080667eba61348ac18b.png](https://s1.imagehub.cc/images/2024/01/02/41b430874afe5080667eba61348ac18b.png)  
输入`minicom -s`进入minicom配置界面  
![cb085d62b9788cae42394212a757b66b.png](https://s1.imagehub.cc/images/2024/01/02/cb085d62b9788cae42394212a757b66b.png)  
使用键盘下方向键选择到`Serial port setup`，回车确定  
![3689c61bbeb8c786169b41566393269d.png](https://s1.imagehub.cc/images/2024/01/02/3689c61bbeb8c786169b41566393269d.png)  
然后开启键盘大写锁定键，按下A,将`/dev/modem`修改为`/dev/ttyUSB0`  
修改完成后回车键返回  
![a303d454b519e1c239142289c83c6113.png](https://s1.imagehub.cc/images/2024/01/02/a303d454b519e1c239142289c83c6113.png)  
然后开启键盘大写锁定键，按下F，将`Hareware Flow Control`由`Yes`更改为`No`  
回车键确认  
![1658dd192b9e0aa6dc5095e86e867314.png](https://s1.imagehub.cc/images/2024/01/02/1658dd192b9e0aa6dc5095e86e867314.png)  
然后用方向键选择到`Save setup as dfl`，回车键确定保存配置更改  
![f1f1565d702b61954140ffa35e00718e.png](https://s1.imagehub.cc/images/2024/01/02/f1f1565d702b61954140ffa35e00718e.png)  
然后在虚拟机窗口界面的右下角，有一个USB样式的图标，点击它  
![01e0ca5eccb81d8cdaecf22e631ee94b.png](https://s1.imagehub.cc/images/2024/01/02/01e0ca5eccb81d8cdaecf22e631ee94b.png)  
点击"连接"  
这样会将这个USB设备连接到虚拟机，宿主机则会断开与此USB设备的连接状态  
![b4054f997238c44f17d5ce69daf136b9.png](https://s1.imagehub.cc/images/2024/01/02/b4054f997238c44f17d5ce69daf136b9.png)  
点击"是"即可  
![41227828c61f4643b3f8fd0630f189ab.png](https://s1.imagehub.cc/images/2024/01/02/41227828c61f4643b3f8fd0630f189ab.png)  
然后在终端内输入`minicom`，回车后就会出现你连接的设备  
![7986938b851aaa4fc54fd56c43b5f50f.png](https://s1.imagehub.cc/images/2024/01/02/7986938b851aaa4fc54fd56c43b5f50f.png)  
然后就可以开始你对设备的配置了  
![a4eb68b91832713f82766163ab5e46b6.png](https://s1.imagehub.cc/images/2024/01/02/a4eb68b91832713f82766163ab5e46b6.png)  
由于Minicom默认波特率是`115200`，在连接二层交换机时，会连接不上  
就会像这样，你把回车键敲烂它也出不来  
![93a8a1053a9a2df66ec03b9d8c067f07.png](https://s1.imagehub.cc/images/2024/01/02/93a8a1053a9a2df66ec03b9d8c067f07.png)  
这时候就要去更改Minicom的波特率  
建议先使用`sudo su`使用root用户配置  
使用`minicom -s`进入Minicom的配置界面  
选择到`Serial port setup`，回车确定  
![da1af7800e3b90923802aa4e865e1b61.png](https://s1.imagehub.cc/images/2024/01/02/da1af7800e3b90923802aa4e865e1b61.png)  
开启大写锁定，按下E键，去更改波特率  
![a16bc4eec52aef21a535f824e47c9dfd.png](https://s1.imagehub.cc/images/2024/01/02/a16bc4eec52aef21a535f824e47c9dfd.png)  
按下C键，使用9600波特率，确保大写锁定键是开启的，然后回车确认即可  
![c8f7d6752bcf0942d971826d06f311f3.png](https://s1.imagehub.cc/images/2024/01/02/c8f7d6752bcf0942d971826d06f311f3.png)  
可以看到这时候的波特率已经更改为9600，回车确定  
![0a75bed1865c0615168fe78e86c8a3c4.png](https://s1.imagehub.cc/images/2024/01/02/0a75bed1865c0615168fe78e86c8a3c4.png)  
然后用方向键选择到`Save setup as dfl`，回车键确定保存配置  
![007fc3df1705265cea4490605551888e.png](https://s1.imagehub.cc/images/2024/01/02/007fc3df1705265cea4490605551888e.png)  
选择到`Exit`，退出Minicom配置界面  
![bf317227f519432f4f224e13c089dbcf.png](https://s1.imagehub.cc/images/2024/01/02/bf317227f519432f4f224e13c089dbcf.png)  
这时候再次回车就能显示到二层交换机了  
想要更改回115200波特率也是同样的步骤  
![266748ab81d41a5089296ef1de2c036c.png](https://s1.imagehub.cc/images/2024/01/02/266748ab81d41a5089296ef1de2c036c.png)  

Minicom常用命令  
|命令|说明|/|
|---|---|---|
|Ctrl+A X|退出程序|/|
|Ctrl+A W|启用/禁用自动换行，默认禁用|/|
|Ctrl+A E|启用/禁用输入显示，默认禁用|/|
|Ctrl+A C|清屏|/|
