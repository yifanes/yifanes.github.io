# 合并两个切片

```go
a := []string{"a", "b"}
b := []string{"c"}
append(a, b...)
```

如果b是nil的话不容许append

