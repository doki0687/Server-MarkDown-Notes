# 【1】更新apt源  
命令：`sudo apt update`  
![bdb497771a898c6ef973125543598948.png](https://s1.imagehub.cc/images/2024/01/08/bdb497771a898c6ef973125543598948.png)  
# 【2】添加中文语言支持  
在右上角打开设置  
![d7a179d440b8d8b3fc69f09a7b5cc2bd.png](https://s1.imagehub.cc/images/2024/01/08/d7a179d440b8d8b3fc69f09a7b5cc2bd.png)  
打开"区域与语言"，然后点击"管理已安装的语言"  
![e3311cc7028af272b2905e535caa1c5a.png](https://s1.imagehub.cc/images/2024/01/08/e3311cc7028af272b2905e535caa1c5a.png)  
点击"添加或删除语言"  
![e1478764aabe6a7067d5ecf61024a976.png](https://s1.imagehub.cc/images/2024/01/08/e1478764aabe6a7067d5ecf61024a976.png)  
勾选"中文(简体)"，点击应用  
![72f85760317003c36b12edf04d272412.png](https://s1.imagehub.cc/images/2024/01/08/72f85760317003c36b12edf04d272412.png)  
# 【3】安装Fcitx输入法系统  
在桌面右键，点击"在终端中打开"  
![3b4ad990ff11cf253c2460237ca59493.png](https://s1.imagehub.cc/images/2024/01/08/3b4ad990ff11cf253c2460237ca59493.png)  
输入`sudo apt-get install fcitx`，然后输入密码  
![48951561e2be3f41ff0fd86b5ea314c3.png](https://s1.imagehub.cc/images/2024/01/08/48951561e2be3f41ff0fd86b5ea314c3.png)  
输入`y`确认安装Fcitx  
![4a59613cfec90ae1e8e38773823e4600.png](https://s1.imagehub.cc/images/2024/01/08/4a59613cfec90ae1e8e38773823e4600.png)  
等待它跑完即可  
![e17063df0ac7d1f813670863ae1f7e73.png](https://s1.imagehub.cc/images/2024/01/08/e17063df0ac7d1f813670863ae1f7e73.png)  
重新打开"语言支持"窗口，然后选择Fcitx 4键盘输入法系统  
![73c2ef21222474826a3499a0d5c5b9d1.png](https://s1.imagehub.cc/images/2024/01/08/73c2ef21222474826a3499a0d5c5b9d1.png)  
然后将Fcitx添加到开机自启  
![d2c52bde4160c86582bcaa597ac81276.png](https://s1.imagehub.cc/images/2024/01/08/d2c52bde4160c86582bcaa597ac81276.png)  
# 【4】卸载ibus输入法框架  
终端内输入`sudo apt purge ibus`卸载ibus框架  
![f9ffd1e4bb4cedb245fba35a0ee1a8bb.png](https://s1.imagehub.cc/images/2024/01/08/f9ffd1e4bb4cedb245fba35a0ee1a8bb.png)  
ibus框架卸载完成  
![5d82e893bd91027e91e8e8f139297830.png](https://s1.imagehub.cc/images/2024/01/08/5d82e893bd91027e91e8e8f139297830.png)  
# 【5】下载搜狗输入法包  
首先打开[搜狗输入法官网](https://shurufa.sogou.com/ "搜狗输入法")  
点击下载Linux个人版  
![852598e071814f7895b03ee50e066d89.png](https://s1.imagehub.cc/images/2024/01/08/852598e071814f7895b03ee50e066d89.png)  
等待下载完成  
![e3b13478ec581051301776633035d864.png](https://s1.imagehub.cc/images/2024/01/08/e3b13478ec581051301776633035d864.png)  
# 【6】安装搜狗输入法  
点击文件夹图标，在文件夹中显示  
![0548168c53250a52c64258f7e171ea49.png](https://s1.imagehub.cc/images/2024/01/08/0548168c53250a52c64258f7e171ea49.png)  
右键在终端中打开  
![118d91cfc5a51721d146a1d1eb8ef496.png](https://s1.imagehub.cc/images/2024/01/08/118d91cfc5a51721d146a1d1eb8ef496.png)  
输入命令`sudo dpkg -i 包名`  
![6a4f1132a6d6299b9fa9be018bcbbe73.png](https://s1.imagehub.cc/images/2024/01/08/6a4f1132a6d6299b9fa9be018bcbbe73.png)  
![ae17f7dbf3a44998839aa30dab9855ad.png](https://s1.imagehub.cc/images/2024/01/08/ae17f7dbf3a44998839aa30dab9855ad.png)  
安装输入法依赖：  
`sudo apt install libqt5qml5 libqt5quick5 libqt5quickwidgets5 qml-module-qtquick2`  
`sudo apt install libgsettings-qt1`  
![bb059b984fb45e1936a9e9031b19a514.png](https://s1.imagehub.cc/images/2024/01/08/bb059b984fb45e1936a9e9031b19a514.png)  
  
# 【7】重启Ubuntu  
![d8ec09b993b9874dd2eb481666692850.png](https://s1.imagehub.cc/images/2024/01/08/d8ec09b993b9874dd2eb481666692850.png)  
重启完成后，就可以在右上角看到"搜狗输入法"字样了  
![bba93bbb90b0b48917a656a180c85906.png](https://s1.imagehub.cc/images/2024/01/08/bba93bbb90b0b48917a656a180c85906.png)  
至此，搜狗拼音输入法安装完毕  
![0713d5966ef8654c2462dfa210cc7780.png](https://s1.imagehub.cc/images/2024/01/08/0713d5966ef8654c2462dfa210cc7780.png)  
  