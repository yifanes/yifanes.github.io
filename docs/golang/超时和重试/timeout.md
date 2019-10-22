#在Go中用四种方法实现超时问题

超时是一种常见的并发模式。您希望等待一个长时间运行的任务，但不希望永远等待。有几种方法可以在Go中实现超时，有些方法比其他方法更容易管理。我将概述其中的三种方法(尽管我不建议使用第一个方法)，如果您想跳过，我更喜欢第三种方法。

## 方法一:快而不优雅
第一个方法是我认为大多数人会首先尝试的方法，因为它使用了许多语言中常见的概念，而且它在谷歌搜索“golang timeout”时排名很高，这是2010年的[一篇博客文章](https://blog.golang.org/go-concurrency-patterns-timing-out-and)中概述的。使用time . sleep:

```go
ch := make(chan bool, 1)
timeout := make(chan bool, 1)

// 1s后,往timeout的chan中发送bool值true
go func() {
  time.Sleep(1 * time.Second)
  timeout <- true
}()

// 要么1s拿到ch结果,要么当1s时拿到timeout chan结果(这时候超时)
select {
case <-ch:
  fmt.Println("Read from ch")
case <-timeout:
  fmt.Println("Timed out")
}
```



这个示例将等待，直到它从ch或超时通道接收到一些内容。因为我们从来没有发送给ch，它总是在1s之后超时。好又简单。然而，事后很难清理干净。如果我们不超时，并试图关闭通道，当超时最终被触发时，我们的代码将会出现panic。

```go
ch := make(chan bool, 1)
timeout := make(chan bool, 1)
defer close(ch)
defer close(timeout)

go func() {
  time.Sleep(1 * time.Second)
  timeout <- true
}()

go func() {
  ch <- true
}()

select {
case <-ch:
  fmt.Println("Read from ch")
case <-timeout:
  fmt.Println("Timed out")
}
```

![错误信息](https://storage.xueshop.cn/blog/2019-08-19-RYtrd7.png)

## 方法B: 就一行代码
有用的是，time package提供了After功能，它可以为我们创建超时通道:

```go
ch := make(chan bool, 1)
defer close(ch)

go func() {
  ch <- true
}()

select {
case <-ch:
  fmt.Println("Read from ch")
case <-time.After(1 * time.Second):
  fmt.Println("Timed out")
}
```



由于在select语句之后我们没有保留通道，所以垃圾收集器将在超时之后为我们清理所有东西。对于不需要经常处理超时的长时间运行的应用程序，这应该没有问题。但是在很多情况下，我们想要确保我们把所有的东西都清理干净。

##方法C:用时间定时器自己清理
如果你看一下godoc。之后，您可能已经被引导到此选项。引擎盖下是时间。使用定时器结构后，可以根据需要显式停止:

```go
ch := make(chan bool, 1)
defer close(ch)

go func() {
  ch <- true
}()

timer := time.NewTimer(1 * time.Second)
defer timer.Stop()

select {
case <-ch:
  fmt.Println("Read from ch")
case <-timer.C:
  fmt.Println("Timed out")
}
```

这需要比前一个示例多一点的代码，但是您可以放心，当函数返回时，它所使用的所有通道都已被清除。



##方法D:使用context :happy:

context提供了withTimeout的方法

```go
package main

import (
	"context"
	"fmt"
	"time"
)

func main() {
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(time.Second*3))
	defer cancel()
	dataChan := make(chan bool)

	go func(ctx context.Context, dataChan chan bool) {
		select {
		case <-ctx.Done():
			fmt.Println("done")
		case <-dataChan:
			fmt.Println("data parse ok!")
		}

	}(ctx, dataChan)

	go func() {
		time.Sleep(time.Second * 4)
		dataChan <- true
	}()

	time.Sleep(time.Second * 5)

}
```

##总结:

并发编程,路漫漫其修远兮!