## Date:2016年06月08日

这里整理一些非常常用的git命令，方便忘记命令查看

1.克隆指定的分支
2.创建一个无提交记录的分支
3.合并多个commit
4.忽略暂存文件
5.共享commit在不同分支
6.跟踪远程分支并在本地创建
7.给分支做备注
8.根据commit获取分支
9.prune清理无效的远程追踪分支

1.克隆指定的分支

说明：例如php版本从4-7有非常多的分支，我只想检索5.3这个版本的时候可以这么用

```
git init
git remote add -t BRANCH_NAME_HERE -f origin REMOTE_REPO_URL_PATH_HERE
git checkout BRANCH_NAME_HERE
```
2. 创建一个无提交记录的分支

说明：开发中我在我自己创建的分支上查看log只想看到我提交的记录
```
git checkout --orphan BRANCH_NAME_HEAR
```
3.合并多个commit

说明：开发中commit了多次，最后发现一些细节可以归纳为1次commit记录，此时可以用rebase -i, 后面带HEAD~2代表合并2条
```
rebase -i HEAD~2
```
![](https://storage.xueshop.cn/blog/2019-10-09-1079656396.gif)

4.忽略暂存文件

说明：开发中由于刚开始没有考虑到一些文件是否要加暂存，所以经过了add或者stage，同时push过，

但是现在想接下来的修改不再加入版本库
```
git update-index --assume-unchanged HEAR_IS_FILE
```
当然这条命令也有相反的命令(取消忽略指令)
```
git update-index --no-assume-unchanged HEAR_IS_FILE
```
5.共享commit在不同分支

说明：假如在brancha 分支提交了一个commit，而这个commit是一个重要的热性代码，这时候可以将这个提交的修改打补丁到其他分支

git cherry-pick COMMIT-ID
6.跟踪远程分支并在本地创建

说明：其他开发者在某个结点从master上checkout出一个分支并开发一段时间需要你介入该分支，此时你需要在本地创建一个和远程完全一致的分支
```
git checkout -b BRANCH_NAME --track origin/BRANCH_NAME
```
7.给分支做备注

说明：例如我们的某些分支因为测试或者开发周期较长，但是分支名往往不能非常准确的说明分支的作用，这时，我们需要给分支做备注
```
git branch --edit-description
git config branch..description
```
这是本地存储的。根据定义，它不能被推送，因为它存储在 .git / config 。

如果您删除分支，说明也会一并删除。
如果您设置 git config --global branchdesc true

8.根据commit获取分支
```
    git branch --contains <commit_id>
```
9.跟新代码后只想看到冲突的文件
```
gsb | grep "^U"
```
10.更新代码后只想看冲突的diff
```
gd --diff-filter=U
```

11.强制更新本地代码为原创的代码
```
git reset --hard origin/master
git clean -fdx
```

12.prune清理无效的远程追踪分支

```
git remote prune origin --dry-run #先查看
git remote prune origin #清理
```