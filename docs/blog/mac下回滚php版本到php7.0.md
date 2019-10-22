## date:2019-04-30 16:32

## 为啥要回滚

之前mac上一直是php最新版本,过年前为了测试php7.3新特性,升级到7.3, 可是公司的项目构建在php7.0上,每次composer update都会改写composer.lock对php版本的限制.
为此决定回滚php版本到php7.0,但是这个过程比我想象的难

## 如果不回滚版本,有办法解决composer update的问题吗?


可以解决,但是为了工作环境下项目不多虑版本问题,所以觉得revert

> 方案: /usr/local/php7/bin/php composer.phar require laravel/laravel

这样composer就不会拿PATH中的php去做lock文件

## 为啥回滚比想象的难

因为官方brew源已经移除了php7.0,现在可以升级的版本是:7.1,7.2,7.3

[PHP 7.0 removed from Homebrew](https://www.reddit.com/r/PHP/comments/a4vggg/php_70_removed_from_homebrew)


## 如何解决

自制源或者使用第三方源,恰好github上有人已经制作了这个源,所以拿来使用

[github-地址](https://github.com/eXolnet/homebrew-deprecated)

> brew tap exolnet/homebrew-deprecated

> brew install php@7.0

但是作者并没有很好的构建bottles, 所以导致安装后没有 fpm的conf文件,导致 `brew services start php@7.0` 失败,随后查看github的[issues](https://github.com/eXolnet/homebrew-deprecated/issues/3),确实有人提过这个bug
最后通过作者提醒,使用源代码构建源解决问题

## 解决办法

```
# -s 参数告诉brew通过源码编译
brew install php@7.0 -s 
```