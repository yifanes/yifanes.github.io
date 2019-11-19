# 判断slice中是否有某元素

```go
func contains(s []int, e int) bool {
  //注意这里是 _, a 而不是a, 如果是a的话php是val,go是key
    for _, a := range s {
        if a == e {
            return true
        }
    }
    return false
}
```

