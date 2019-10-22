# go代理设置

在Go 1.13中，我们可以通过`GOPROXY`来控制代理，以及通过`GOPRIVATE`控制私有库不走代理。

## 设置`GOPROXY`代理：

```json
go env -w GOPROXY=https://goproxy.cn,direct
```

## 设置`GOPRIVATE`来跳过私有库，比如常用的`Gitlab`或`Gitee`，中间使用逗号分隔：

```js
go env -w GOPRIVATE=*.gitlab.com,*.gitee.com
```

## 设置sumdb:

```js
go env -w GOSUMDB=off // 关闭
go env -w GOSUMDB="sum.golang.google.cn" //开放给zh-CN的
```

