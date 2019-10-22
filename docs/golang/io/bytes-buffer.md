# bytes.buffer

##说明

`bytes.buffer`是一个缓冲byte类型的缓冲器,存放着的都是byte

`Buffer`是`byte`包中的一个type Buffer struct{...}

是一个变长的buffer,具有read和Write方法,Buffer的零之是一个空的buffer,但是可以使用

Buffer就像一个集装箱,可以存东西,取东西

1. 创建一个Buffer(其实底层就是一个字节切片)
2. 向其中写入数据
3. 向其中读取数据

## 创建Buffer缓冲器的几种方法

```go
//这种方式直接申明变量,就可以使用
var b bytes.Buffer
//使用new
b1 := new(bytes.Buffer)
//通过字符切片初始化Buffer
b2 := bytes.NewBuffer([]byte("I love Golang"))
//通过字符初始化Buffer
b2 := bytes.NewBufferString("xueshop.cn")
```

示例

```go
func IntToBytes(n int) []byte {
	x := int32(n)
	byteBuffer := bytes.NewBuffer([]byte{})
	binary.Write(byteBuffer, binary.BigEndian, x)
	return byteBuffer.Bytes()
}
```

##向Buffer中写数据

1. Write (把字节切片写入的`buffer`中去)

```go
	newBytes := []byte("xueshop")

	buf := bytes.NewBuffer([]byte("Love Golang"))

	buf.Write(newBytes)
	fmt.Println(buf.String())

//结果:
Love Golangxueshop
```

2. WriteString
3. WriteByte
4. WriteRune



## 向buffer中读取数据



1. Read

   > 给read一个容器p, 读完后,p就满了,缓冲器相应的减小了, 返回的n为成功读的数量

   ```go
   buf := bytes.NewBuffer([]byte("Love Golang"))
   l := make([]byte, 8)
   n, err := buf.Read(l)
   fmt.Println(n, err)
   
   fmt.Println(buf.String())
   ```

2. ReadByte

   > 返回缓冲器的第一个byte,缓冲器头部的第一个byte被拿掉

3. ReadRune

   > ReadRune和ReadByte很像 
   > 返回缓冲器头部的第一个rune，缓冲器头部第一个rune被拿掉

4. ReadBytes

   > ReadBytes需要一个byte作为分隔符，读的时候从缓冲器里找第一个出现的分隔符（delim），找到后，把从缓冲器头部开始到分隔符之间的所有byte进行返回，作为byte类型的slice，返回后，缓冲器也会空掉一部分

5. ReadString

   > ReadString需要一个byte作为分隔符，读的时候从缓冲器里找第一个出现的分隔符（delim），找到后，把从缓冲器头部开始到分隔符之间的所有byte进行返回，作为字符串，返回后，缓冲器也会空掉一部分 
   > 和ReadBytes类似

6. ReadFrom

   > 从一个实现io.Reader接口的r，把r里的内容读到缓冲器里，n返回读的数量

   ```go
   func ReadFrom(){
       //test.txt 内容是 "未来"
       file, _ := os.Open("learngo/bytes/text.txt")
       buf := bytes.NewBufferString("Learning swift.")
       buf.ReadFrom(file)              //将text.txt内容追加到缓冲器的尾部
       fmt.Println(buf.String())
   
   ```

   

7. Reset

   > 清空buffer数据

8. String

   > 未读出的buffer数据转为string返回