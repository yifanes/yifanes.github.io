# 利用...转化append

```go
append([]string{1, 2, 3}, string{3, 4, 5}...)
```

如果没有... , 则第二个参数是数组,不合适