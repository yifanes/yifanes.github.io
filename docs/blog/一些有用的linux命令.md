## Date:2018-03-28 10:57

这里整理一些有意思的linux命令，方便忘记命令查看

 1. 查找某个目录最大的文件
 2. 删除某个目录下的6个月之前修改的文件
 3. 统计文件夹内部文件总大小
 4. 查看端口占用情况，以及被谁占用
 5. 同步目录到另一台服务器指定目录
 6. 替换指定几行的字符串
 7. 替换当前目录下匹配文件的字符串为另一个字符
 8. 查看LINUX发行版的名称及其版本号的命令
 9. 根据nginx日志统计最大qps
 10. ssh登陆使用指定密钥登陆
 11.查看linux占用的端口号
 12.指定文件列宽(给你一长串不换号文本转换后方便查看)

1.查找某个目录最大的文件

思路：先find+f(文件)，然后对每个文件stat(-c=format),然后sort(n自然r逆序)

    find -type f -exec stat -c "%s %n" {} \; | sort -nr | head -1

2.删除某个目录下的6个月之前修改的文件

    find ./ -name "*.log" -mtime +180 -exec rm -rf {} \;

3.统计文件夹内部文件总大小(s=summary h=human)

    du -sh

4.查看端口占用情况，以及被谁占用
    /usr/sbin/lsof -i:80

5.同步目录到另一台服务器指定目录

    rsync -r /opt root@10.10.10.11:/opt

6.替换指定几行的字符串

    :2,10s/aaa/bbb/g #从第2行到第10行替换aaa到bbb
7.替换当前目录下匹配文件的字符串为另一个字符(经常用来修改配置文件)

    sed -i "s/10.11.12.115/10.16.10.12/g" /opt/projects/deploy/config/base.php

8.查看LINUX发行版的名称及其版本号的命令

    cat /etc/issue

9.根据nginx日志统计最大qps

    awk -F"," '{print $1}' nginx.log | sort | uniq -c | sort -n -r | head -n 1

10.ssh登陆使用指定密钥登陆

    ssh -i <identity_file> root@123.134.23.43

11.查看linux占用的端口号

    netstat -an | grep "LISTEN"

12.指定文件列宽(给你一长串不换号文本转换后方便查看)

    cat fileData | fold -w 64
    fold -w 64 fileData