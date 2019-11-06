# runtime获取调用函数的被调用栈信息

```go
pc, fileName, line, ok := runtime.Caller(0)
if !ok {
   fmt.Println("error")
}
pcName := runtime.FuncForPC(pc).Name()

fmt.Printf("%s %s %d", pcName, fileName, line)
```

