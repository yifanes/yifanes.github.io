## date:2019-08-08 11:19

[Go](https://golang.org/)的[JSON](http://www.json.org/) 标准库 [library support](https://golang.org/pkg/encoding/json/) 是支持配置文件的一中方式. 应用程序可以定义一个包含所有可配置元素的配置结构类型，并将JSON从一个文件加载到这个结构的实例中，例如:

```go
type Config struct {
	ServerUrl   string
	APIKey	    string
	MaxSessions int
}

func readConfig(filename string) (*Config, error) {
	// 实例化一个默认的配置结构体
	conf := &Config{Url: "http://localhost:8080/", MaxSessions: 10}

	b, err := ioutil.ReadFile("./conf.json")
	if err != nil {
		return nil, err
	}
	if err = json.Unmarshal(b, conf); err != nil {
		return nil, err
	}
	return conf, nil
}
```
这种方式相对于没有类型的数据结构(例如js或者python的数据结构)已经是一种提升,例如我们可以使用`json.Unmarshal`来实现简单的参数验证,如果配置文件是:

```json
{ "MaxSessions": "20 seconds" }
```

`json.Unmarshal`将会return出一个错误提示:  `"20 seconds"` is not a valid integer, 然后我们就可以将这种判断放在启动`load文件`而不是出现在运行环境中了.

#### 定制


<!--more-->


当然Go JSON 类库还提供了那些我们不能通过简单的配置即可序列号的方式,我们可以通过 `json.Unmarshaler`来定制这些我们的需求:

```go
type Unmarshaler interface {
	UnmarshalJSON([]byte) error
}
```
如果我们的配置结构体中的某个字段的类型实现了`json.Unmarshaler`接口,那么当我们将文件载入struct中时,就会将`UnmarshalJSON`方法调用,以便来赋值(或者叫做填充)这个字段,这中方式有很多拥堵,来使得我们的配置更愉悦.

#### 从其他地方加载值

上面这种配置方式也许是一种简单可行的方式,可是我们试想,这个`APIKeyFile`将会配置在json文件中,假象这个配置文件又需要普通开发配置这个文件的其他字段,那么这个key其实就是泄露了的,我们能不能既让配置文件集中在这个文件中,又能单独配置`apikey`的值,例如将key写入线上服务器的一个高权限的文件中,只有管理员才能看到,这时我们可以使用下面的方式:

```go
type Config struct {
  ...
  APIKeyFile	string
}
```

假设我们的配置文件是ServerA,ServerB给颁发的,那么我们的结构体就会是下面这样:
```go
type FileString string

type Config struct {
	...
	AliAPIKeyFile FileString
	WechatAPIKeyFile FileString
	...
}
```
然后我们定制一个解析器

```go
type FileString string

func (f *FileString) UnmarshalJSON(b []byte) error {
	var s string
	err := json.Unmarshal(b, &s)
	if err != nil {
		return err
	}
	f, err := ioutil.ReadFile(s)
	if err != nil {
		return err
	}
	val := strings.TrimSpace(string(f))
	*f = FileString(val)
	return nil
}

type Config struct {
	// ...
	APIKey FileString
	// ...
}
```

现在  `Config` `APIKey` 字段已经从配置文件中读取到了.

#### 校验和解析

现在APIKey已经可以正常工作了,接下来`ServerUrl`需要验证下url的有效性,我们可以定制一个解析器:

```go
type Url string

	func (u *Url) UnmarshalJSON(b []byte) error {
		var s string
		err := json.Unmarshal(b, &s)
		if err != nil {
			return err
		}
		*u = Url(s)
		_, err = url.Parse(s)
		return err
	}

	type Config struct {
		ServerUrl  Url
		// ...
	}

```

这样,如果用户提供了错误或者无效的url,它将被认为是一个错误,`ServerURL`这个字段也就保证了URL字符串的有效性.

另外上面的程序我们使用 `url.Parse`只是为了验证url,但是我们如果验证成功,他返回的就是一个合法的URL,所以我们可以优化我们的这段程序.

```go
	type Url struct { *url.URL }

	func (u *Url) UnmarshalJSON(b []byte) error {
		var s string
		err := json.Unmarshal(b, &s)
		if err != nil {
			return err
		}
		u.URL, err = url.Parse(s)
		return err
	}
```

#### 总结

在Go 库中,"encoding/json"的接口`Unmarshaler`是一个强大的抽象。它允许拦截复杂JSON对象的解析，并验证或将基础值转换为应用程序所需的形式。

尽管本文是以json为中心的，但标准XML库和领先的第三方YAML库中出现了类似的`Unmarshaler`接口，因此上述技术适用于XML和YAML配置。