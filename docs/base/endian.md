# 理解字节序

![](https://storage.xueshop.cn/blog/2019-08-22-ZGlK7v.jpg)



> 大端字节序：高位字节在前，低位字节在后，这是人类读写数值的方法。
> 小端字节序：低位字节在前，高位字节在后，即以0x1122形式储存。



golang版本的判断大端字节序的方法

```go
func isBidEndian() bool  {
	x := 0x1234
	b := byte(x)
	if b == 0x12 {
		return true
	}
	return false
}
```

