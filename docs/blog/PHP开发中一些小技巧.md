## Date:2018-06-04 15:25

1. 我们用php-cli写一些业务常用逻辑，然后需要打印一些有用信息到终端时,通常的 `echo` `var_dump`往往在显示数据较多多时滚动显示,这样不方便肉眼盯数据,此时可以用如下逻辑实现 `wget` 下载文件滚动条的实现:
    <?php
    for($n = 1; $n < 100; $n++) {
        echo chr(3); // 输出文本结束控制字符，这样可以清除之前输出的文本内容
        echo chr(8); // 将前一个控制字符删掉，避免在控制台留下控制字符的标记
        echo "inserting row $n\r";
        sleep(1); // 延时一秒是为了看清楚文字变化
    }

2. model中有很多常量,建议开发者以 `group` 的方式设置:
   例如 : `STATUS_ON` , `STATUS_OFF`,

3. windows下面添加服务
   首先需要定义一个可执行的bat文件，大致如下

   ```
   @echo off  
   start  "C:\Windows\System32\cmd.exe"   
   cd C:\xxxx\bbbb
   ## 这里是执行的具体内容
   exit
   ```
    添加服务

  `sc create frp binPath=  C:\Users\Administrator\Desktop\frp.bat start= auto`

  然后到`ctrl+shift+esc` 找到服务，启动

4. 当你对一个数组元素`unset`之后,你一定要小心,这个时候php由于中间缺了一个不连续的key,在`json_encode`的时候就会有key参与到json中,需要用array_values 重新构建索引

5.放弃`ps -ef | grep nginx`这种丑陋的做法吧,请使用`pgrep`
6.通过终端写入多行数据到一个文件

```shell
cat <<EOF > hello.php
<?php
echo "xueshop.cn";
EOF
```