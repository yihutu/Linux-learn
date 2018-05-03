# study
pyenv安装

1、安装阿里源
mv /etc/yum.repos.d/CentOS-Base.repo    /etc/yum.repos.d/CentOS-Base.repo_backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo  ##根据系统环境决定yum源

2、pyenv安装使用git
yum -y install git
python安装依赖
sudo yum -y install gcc make patch gdbm-devel openssl-devel sqlite-devel zlib-devel bzip2-devel readline-devel

3、创建用户
useradd Python
创建密码 
passwd Python 

4、使用Python用户登录，就是安装pyenv
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
在Python用户的~/.bash_profile中追加
cat .bash_profile  ##python用户的环境变量文件（使用Python做的，没用root做，和之后的操作有关系）
export PATH="$HOME/.pyenv/bin:$PATH"    
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
或选择这个，系统给出的提示
export PATH="/home/Python/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
或者
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
刷新source ~/.bash_profile

5、使用Pyenv
先查看本机Python
python --version ##查看当前版本
Python不能直接升级高版本可以先安装pyenv，pyenv能够管理多个Python的版本以及虚拟环境


6、pyenv命令：
pyenv 列出子命令
pyenv help install 
pyenv install --list/-l  ##列出所有能用的Python版本 
3.5.3和3.5.4都差不多用3.5.3的，3.5.5和3.5.6功能区别很大

7、安装使用缓存方式安装
pyenv install 3.5.3 -v ##可以看到安装详情，就这么安装吧
更快速安装，不好弄
cd ./pyenv
mkdir cache
把下载好的Python-3.5.3.tar.gz(有三种安装包都可以放入)包放入cache
然后pyenv install 3.5.3 -v安装

8、查看版本
pyenv version  ##当前版本（当前版本是系统版本 system）
pyenv versions  ##查看所有版本，现在还是2.6版本
ls .pyenv/versions -al  ##查看所有版本的真是目录
 
9、设置Python版本
a. pyenv global 3.5.3  ##设置Python环境为3.5.3（global：全局   local：本地）
Python version ##查看，已经是3.5.3了
###pyenv global这个相当于你用Python登录的所有用户，global使禁用的

b. pyenv global system ##切回系统
切记，这里用global是因为在非root用户Python用户下
如果是root用户安装，请不要用global，否则影响太大
使用pyenv local设置从当前工作目录开始向下递归都继承这个设置。

c.pyenv shell 3.5.3 只作用于当前会话，另一个会话还是原来的版本
缺点：会话断了，环境就没了

d.pyenv shell system

最好使用：
e.pyenv local 这个文件夹和当前环境捆在一起

f. 在xshell上开启新的连接，需要重新执行source .bash_profile

g.sudo mkdir /project
cd /project
pyenv local 3.5.3
验证：
在project文件下创建一个新的目录test
cd test
pyenv version 查看环境版本,子目录继承上一级目录权益
pyenv local 3.6.1 ##test做3.6.1

10、报错：
环境变量问题导致版本无法切换
[Python@bogon ~]$ pyenv versions
  system
* 3.5.3 (set by PYENV_VERSION environment variable)
  3.5.3/envs/test353
  3.6.1
  3.6.1/envs/test361
  test353
  test361
方法：用系统给出的提示写进[Python@bogon ~]$ vim .bash_profile这个文件中
export PATH="/home/Python/.pyenv/bin:$PATH"  ##因为我创建的用户是Python而不是python，所以路径有偏差
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

11、建立私有安装包环境：做版本包之间的隔离
先做一个3.6.1版本的安装
pyenv install -v 3.6.1  ##安装版本在哪里做都可以
可以认为自己定制的Python版本
#cd .pyenv
#cd versions ##创建好的某个版本会在这里
#cd cache ##会看到下载的包
#cd /project ##装完后cd进入
pyenv virtualenv 3.5.3 test353  ##从3.5.3起个别名在3.5.3下，自己会独立出一个小环境/虚拟环境
pyenv virtualenv 3.6.1 test361
pyenv versions ##查看多出来的版本
mkdir mumu ##随便创建一个目录
cd mumu/
pyenv local test353  ##建立一个虚拟环境,应用mumu这个虚拟环境
pyenv version ##查看修改的版本

12、删除虚拟环境：
如果要删除这个虚拟环境，只须直接删除它所在的目录即可：
rm -rf .pyenv/versions/env361


13、pip通用配置===yum（包管理器）
使用pip命令在env353的虚拟环境下安装ipython和redis模块
在mumu（已经应用test353虚拟环境）目录下
pip -v ##查看pip详情
pip -V ##查看指向
pip search xxx ##搜索包
(test353) [Python@bogon mumu]$ pip -V  
pip 9.0.1 from /home/Python/.pyenv/versions/3.5.3/envs/test353/lib/python3.5/site-packages (python 3.5)
(test361) [Python@bogon test]$ pip -V  ##也是虚拟环境
pip 9.0.1 from /home/Python/.pyenv/versions/3.6.1/envs/test361/lib/python3.6/site-packages (python 3.6)
site-packages以后安装的模块都在这里
/home/Python/.pyenv/versions/3.5.3/envs/test353/lib/python3.5/site-packages  ##模块路径

注意：没有envs目录的，安装的模块是在公共目录里取得的，比如
[Python@bogon project]$ pyenv version  ##不是虚拟环境
3.5.3 (set by /home/Python/project/.python-version)
[Python@bogon project]$ pip -V  ##证实了虚拟环境的模块隔离
pip 9.0.1 from /home/Python/.pyenv/versions/3.5.3/lib/python3.5/site-packages (python 3.5)


14、创建pip配置文件,加速下载，不去官网使用阿里镜像
(test353) [Python@bogon mumu]$ mkdir .pip
(test353) [Python@bogon mumu]$ ls -a
.  ..  .pip  .python-version
(test353) [Python@bogon mumu]$ cd .pip/
(test353) [Python@bogon .pip]$ touch pip.conf
(test353) [Python@bogon .pip]$ vim pip.conf 
[global]
index-url=https://mirrors.aliyun.com/pypi/simple/
trusted-host=mirrors.aliyun.com

15、安装redis和ipython以及jupyter
(test353) [Python@bogon mumu]$ pip install redis   ##服务只在当前虚拟环境，操作也在当前虚拟环境
(test353) [Python@bogon mumu]$ pip install ipython
(test353) [Python@bogon mumu]$ pip install jupyter  ##Jupyter Notebook（此前被称为 IPython notebook ipython的网页版）是一个交互式笔记本，
支持运行 40 多种编程语言。Jupyter Notebook 的本质是一个 Web 应用程序，
便于创建和共享文学化程序文档，支持实时代码，数学方程，可视化和 markdown。 用途包括：数据清理和转换，数值模拟，统计建模，机器学习等等。
jupyter notebook help  ##查看服务帮助
jupyter notebook --ip=0.0.0.0 --no-browser  ##开启服务进程，默认端口8888（0.0.0.0本地任意地址，--no-browser最小化安装，不起某个界面 --port 改端口）
验证：要关闭防火墙，之前做虚拟机，已经关了
访问：http://10.10.110.79:8888  ##我的虚拟机IP
输入token=91f7bea4b70684e3ba569c2bebb264351fbaa0e0a30a345e  ##我的服务进程生成
或者
修改密码
jupyter notebook password
再次启动jupyter
jupyter notebook
报错：
(test353) [Python@bogon mumu]$ jupyter-notebook 
[I 12:16:43.948 NotebookApp] Serving notebooks from local directory: /home/Python/mumu
[I 12:16:43.948 NotebookApp] 0 active kernels
[I 12:16:43.948 NotebookApp] The Jupyter Notebook is running at:
[I 12:16:43.948 NotebookApp] http://localhost:8888/
[I 12:16:43.949 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[W 12:16:43.950 NotebookApp] No web browser found: could not locate runnable browser.
解决：
jupyter-notebook --ip=0.0.0.0  
在 mumu/下创建 test.txt浏览器版会出现这个文件


16、打包test353环境
(test353) [Python@bogon mumu]$ pip freeze >wangzhan.txt
You are using pip version 9.0.1, however version 10.0.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
(test353) [Python@bogon mumu]$ ls
Untitled.ipynb  wangzhan.txt


17、安装test353开发环境到新的虚拟环境：
(test353) [Python@bogon mumu]$ mv wangzhan.txt /home/Python/project/test/
(test361) [Python@bogon test]$ pip install -r wangzhan.txt
(test361) [Python@bogon test]$ netstat -nlput
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
tcp        0      0 127.0.0.1:50119             0.0.0.0:*                   LISTEN      4300/python         
tcp        0      0 127.0.0.1:27432             0.0.0.0:*                   LISTEN      4300/python         
tcp        0      0 127.0.0.1:32747             0.0.0.0:*                   LISTEN      4300/python         
tcp        0      0 127.0.0.1:61293             0.0.0.0:*                   LISTEN      4300/python         
tcp        0      0 127.0.0.1:58926             0.0.0.0:*                   LISTEN      4300/python         
tcp        0      0 127.0.0.1:49939             0.0.0.0:*                   LISTEN      4300/python         
tcp        0      0 0.0.0.0:22                  0.0.0.0:*                   LISTEN      -                   
tcp        0      0 0.0.0.0:8888                0.0.0.0:*                   LISTEN      4252/python         
tcp        0      0 :::22                       :::*                        LISTEN      -                   
udp        0      0 0.0.0.0:68                  0.0.0.0:*                               -     



Windows安装python3.5.3 直接下一步，安装环境变量的√要打上，虚拟环境用pychrom做，主要注意PATH环境


