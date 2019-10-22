 marshal/unmarshal序列化和反序列化

一个实现了接口UnmarshalJSON的示例

```go
package main

import (
	"encoding/json"
	"fmt"
)
type Picture string

type Profile struct {
	ID string `json:"id"`
	FirstName string `json:"first_name"`
	LastName string `json:"last_name"`
	Name string `json:"name"`
	Picture Picture `json:"picture,omitempty"`
}

func (p *Picture) UnmarshalJSON(b []byte) error  {
	var pictureData struct{
		Data struct{
			Url string `json:"url"`
		} `json:"data"`
	}
	if err := json.Unmarshal(b, &pictureData); err != nil {
		return err
	}
	*p = Picture(pictureData.Data.Url)
	return nil
}

func main() {
	var jsonStr string = `{
        "name": "golang",
		"first_name": "xueshop",
		"last_name": "cn",
		"picture": {
			"data": {
				"url": "https://golang.xueshop.cn"
			}
		},
		"id": "123456789"
	}`

	var profile Profile
	_ = json.Unmarshal([]byte(jsonStr), &profile)
	fmt.Println(profile)

}
```

结果:

```go
{123456789 xueshop cn golang https://golang.xueshop.cn}
```

