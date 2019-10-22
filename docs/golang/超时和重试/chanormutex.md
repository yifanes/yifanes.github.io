#并发使用chan还是mutex

```	go
package main

import (
	"fmt"
	"sync"
	"time"
)

type pool struct {
	ids     []int
	maxSize int
	mu      sync.Mutex
}

func NewPool() (*pool, error) {
	p := new(pool)
	return p, nil
}

func (this *pool) Get() int {
	this.mu.Lock()
	defer this.mu.Unlock()
	if len(this.ids) == 0 {
		this.maxSize++
		return this.maxSize
	}

	i := this.ids[0]
	this.ids = this.ids[1:]
	return i
}

func (this *pool) Put(i int) bool {
	this.mu.Lock()
	defer this.mu.Unlock()
	this.ids = append(this.ids, i)
	return true
}

func main() {
	p, _ := NewPool()
	for i := 0; i < 4; i++ {
		go func() {
			for {
				i := p.Get()
				fmt.Println(i)
				p.Put(i)
				time.Sleep(time.Second)
			}
		}()
	}

	time.Sleep(1000 * time.Second)
}
```

