## date:2019-09-12 17:07

> 作为开发,我们总是需要关心调用一个服务,执行一个性能较差的代码,这个时候我们需要用一些简单的方法将`timing` `logger`,然后作为参考,有时候业务很重要的逻辑,我们都需要线上加入这个日志来采集我们需要的timing来衡量代码是否正常.这篇博客简单的介绍下在golang中捎带技巧的方法.
## 简单的计算方法

```go
func main() {
    start := time.Now()
    //执行比较耗时的计算
    time.Sleep(time.Second * 2)
    elapsed := time.Since(start)
    log.Printf("MAIN函数耗时:", elapsed)
}
```

按照我们的续期 日志 正常输出:

> 2019/09/12 16:56:23 MAIN函数耗时: 2.001828676s

当然，这也适用于函数调用，但是很快就会变得混乱。如果我们想把这个技巧应用到代码中的许多部分，会怎么样?然后你可以使用时间跟踪技巧。

## 利用defer抽象出时间统计的func 👍👍👏👏
```go
func TimeTrack(start time.Time, logName string) {
	elapsed := time.Since(start)
	log.Printf("%s 耗时 %s", logName, elapsed)
}

func main() {
	defer TimeTrack(time.Now(), "main")
	time.Sleep(time.Second * 2)
}
```

output:

> 2019/09/12 17:00:50 main 耗时 2.001762384s

上面的方法只是一个简单的定制,你完全可以传递更多有用的信息到`TimeTrack`,将耗时这个日志统计化.

## 总结:
原本计算耗时的需要将耗时的代码部署在计算的开始和结束,这样当代码量大,或者需要很多处统一,就闲的不够优雅,或者看着很乱,利用defer的特性就可以完全解决问题.这个思路就和我们`open`一个资源做一堆操作,最后`close`一样.

另外这里特别有一处细节需要考虑,defer里面传递的time.Now()到底是执行defer语句才执行,还是申明defer就执行呢?🤔🤔