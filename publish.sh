#!/bin/bash

cd /Users/zhangxianyou/study/golang/golang-book
echo "开始生成site内容"
mkdocs build
echo "进入临时目录"
cd /tmp
echo "克隆yifanes.github.io仓库"
git clone git@github.com:yifanes/yifanes.github.io.git
cd yifanes.github.io
git config --local user.name yifanes
git config --local user.email yifanes@qq.com
echo "拷贝文件"
cp -r /Users/zhangxianyou/study/golang/golang-book/site/* /tmp/yifanes.github.io/
git stage -A
git commit -m "publish"
echo "push to github"
git push
cd /Users/zhangxianyou/study/golang/golang-book
echo "删除垃圾文件"
rm -rf site
rm -rf /tmp/yifanes.github.io






