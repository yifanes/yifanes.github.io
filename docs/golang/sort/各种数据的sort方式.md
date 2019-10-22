# 各种数据的sort方式

```go
package main

import (
   "fmt"
   "sort"
)

type Animal struct {
   Nickname string
   Age      int
}
type ByAge []Animal

func (b ByAge) Len() int {
   return len(b)
}

func (b ByAge) Less(i, j int) bool {
   return b[i].Age < b[j].Age
}

func (b ByAge) Swap(i, j int) {
   b[i], b[j] = b[j], b[i]
}

func main() {
   //string slice sort
   a := []string{"c", "_", "ac"}
   sort.Strings(a)
   fmt.Println(a)
   //int slice sort
   b := []int{5, 2, 1, 7}
   sort.Ints(b)
   fmt.Println(b)
   //float64 slice sort
   c := []float64{3.14, 2, 5.0}
   sort.Float64s(c)
   fmt.Println(c)

   //struct
   Person := [] struct {
      Name string
      Age  int
   }{
      {
         Name: "Abot",
         Age:  34,
      },
      {
         Name: "Cbot",
         Age:  12,
      },
   }
   sort.SliceStable(Person, func(i, j int) bool {
      return Person[i].Age < Person[j].Age
   })

   fmt.Println(Person)

   //面向接口编程的做法
   animal := []Animal{
      {
         Age:      3,
         Nickname: "dog",
      },
      {
         Age:      1,
         Nickname: "dog",
      },
   }
   sort.Sort(ByAge(animal))
   fmt.Println(animal)

   //map
   //map排序最扯淡
   m := map[string]int{"abc": 1, "oks": 3, "edd": 4}
   keys := make([]string, 0, len(m))
   for k := range m {
      keys = append(keys, k)
   }
   sort.Strings(keys)
   for _, k := range keys {
      fmt.Println(k, m[k])
   }
}
```

