# 使用channel实现timeout机制

我们可以利用 select上面加上timeout时间,如果到某这个timeout时间,就进入select的case,进而起到timeout的理论知识



```go
package main

import (
	"fmt"
	"time"
)

func main() {
	ch := make(chan string)

	go func() {
		time.Sleep(time.Microsecond * 500)
		ch <- "ok"
	}()

	select {
	case res := <-ch:
		fmt.Println(res)
	case <-time.After(time.Second * 1):
		fmt.Println("time out")
	}

}

```

