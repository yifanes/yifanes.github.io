# timer and ticker

理解:

time.NewTicker定时触发执行任务，当下一次执行到来而当前任务还没有执行结束时，会等待当前任务执行完毕后再执行下一次任务。查阅go官网的文档和经过代码验证。
time.NewTimer和Reset()函数实现定时触发，Reset()函数可能失败，经测试。

demo:

```go

package main

import (
	"fmt"
	"sync"
	"time"
)

func main() {
	var wg sync.WaitGroup
	wg.Add(2)

	ticker := time.NewTicker(2 * time.Second)

	go func(t *time.Ticker) {
		defer wg.Done()
		for {
			<-ticker.C
			fmt.Println(time.Now().Format("2006-01-02 15:04:05"))
		}
	}(ticker)


	timer := time.NewTimer(3 * time.Second)

	go func(t *time.Timer) {
		defer wg.Done()
		for {
			<-timer.C
			fmt.Println(time.Now().Format("2006-01-02"))
			t.Reset(2 * time.Second)
		}
	}(timer)

	wg.Wait()

}
```

结果:

```go
2019-08-23 14:42:04
2019-08-23
2019-08-23 14:42:06
2019-08-23 14:42:08
.....
.....
```

