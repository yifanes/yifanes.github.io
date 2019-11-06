# 让搜狗输入法在mac下用的更加得心应手

## 问题描述:

### 中英文切换诡异问题
由于个人长久使用搜狗输入法,熟悉了一些配置,同时也用账号同步了历史以来的词汇,所以对于我来说,搜狗输入法真香,但是在mac ox环境下, `^ + 空格` 用的总是那么不舒心,偶尔的自动切换到系统默认的输入法,偶尔的切换不过来中文,使得中文->英文,英文->中文,这两个操作有些烦躁.

### 官方不能本土化的定制
例如:
搜狗有符号设置: 可以在知乎页面中使用「」代替引号
再例如:
在中文输入法下,使用英文标点,且可以设置App清单
再例如:
定制化的皮肤

### 无法禁用Mac ox自带的默认输入法
可能这也是遇到问题的最根本原因,所以这篇文章主要说明的问题就是:如何`解决掉`自带的输入法.

## 解决方法:

### 思路:
其实思路很简单,mac ox上没法禁用自带的输入法,而这个输入法是由一个plist文件配置,但是这个配置文件是系统配置文件,所以需要关闭SIP(系统完整性保护),然后再修改plist配置文件

### 步骤:

1. 关闭SIP

   ```shell
   (1)重启OSX系统，然后按住Command+R
   
   (2)出现界面之后，选择Utilities menu中Terminal
   
   (3)在Terminal中输入csrutil disable 关闭SIP(csrutil enable打开SIP)
   
   (4)重启reboot OSX
   ```

2. 下载plist edit:

   这个只要输入关键字,百度有很多渠道下载,不再赘述

3. 修改com.apple.HIToolbox.plist

   ```shell
   (1)open ~/Library/Preferences/
   (2)找到`com.apple.HIToolbox.plist`文件,右键用plistEdit打开
   ```

4. 修改input属性(如下图):

   ![](https://storage.xueshop.cn/blog/2019-11-06-KadIB6.png)
   
   删除掉非sogou相关的序列,搞定!

