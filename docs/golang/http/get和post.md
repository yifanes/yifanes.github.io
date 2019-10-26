# http client实现GET和POST请求

## GET(带encode参数,带头,带cookie)

```go
//http get
func NewRequest() (*http.Response, error)  {
  //这里注意第三个参数,实现了io.Reader
	request, err := http.NewRequest(http.MethodGet, "baidu.com", strings.NewReader("test"))
	if err != nil {
		return nil, fmt.Errorf("new request error!")
	}
  //这里是拼接参数,并且encode
	query := request.URL.Query()
	query.Add("aaa", "bbb")
	request.URL.RawQuery = query.Encode()
  //这里是添加头
	request.Header.Add("aaa", "bbbb")
  //这里添加cookie
  request.AddCookie(&http.Cookie{Name:"seesionId", Value:"seesion val"})
  //实例化client客户端
	client := http.Client{}
  //发起request请求
	return client.Do(request)
}
```

# post(Content-Type: application/json;)

**方式设置头信息,设置get参数,设置cookie和GET请求一致,这里不多叙述**

```go
func newPost() (*http.Response, error) {
	stuStruct := struct {
		Name string
		Id int
	}{Name:"tet", Id: 1}
	stuJson, _ := json.Marshal(stuStruct)
	request, err := http.NewRequest(http.MethodPost, "baidu.com", strings.NewReader(string(stuJson)))
	if err != nil {
		return nil, fmt.Errorf("new request error!")
	}
	return http.Client{}.Do(request)
}
```

## post(Content-Type: application/x-www-form-urlencoded)

```go
func newPostForm() (*http.Response, error) {
	formMap := url.Values{"a": {"b"}}
	request, _ := http.NewRequest(http.MethodPost, "baidu.com", strings.NewReader(formMap.Encode()))
	return http.Client{}.Do(request)
}
```

## 针对response处理

```go
func main() {
	response, _ := NewGet()
	_ = response.Body.Close()
	body, _ := ioutil.ReadAll(response.Body)
	fmt.Println(body)
}
```



另外针对get和post,golang的http库封装了几个便捷的方法

> http.Get

> http.Post