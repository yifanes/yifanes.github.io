# 使用golang和cobra构建健壮的命令行工具

## 开始之前

如果你长期工作于linux的命令行下,你会发现稍微复杂的工具,命令行复杂的要死,这个时候如果你选择记住这下命令是不明智的,这个时候如果有个好的`usage`则是极好的事情,例如我可以-h或者--help来查看支持的命令,以及命令的层级结构.

所以作为开发者的我们写一些给别人用,或者哪怕给自己用的工具时,我们就需要构建一个好的usage,这是工具使用侧,我们还需要有不同命令分层分文件的描述功能的实现,来构建工具代码侧.

上面即是我们的需求,好在开源软件为我们提供了优秀的cli工具包 `cobra`,下面我们就该工具包为大家阐述它的思想以及使用心得.

## 安装cobra

假定`golang`的环境你已经搭建完毕.并具有go代码的基础.

```shell
go get github.com/spf13/cobra/cobra
```

Cobra附带了自己的命令行程序 cobra,尽管我们可能不需要它来作为初始构建项目的办法,但是我强烈推荐使用该工具作为基础代码和结构的构建.

通常情况下,cobra程序在 `~/go/bin/cobra`

> 这里的`~/go` 是你的gopath目录

执行 cobra后如下:
![](https://storage.xueshop.cn/blog/2019-10-31-yZaFOY.png)

### 一个cobra开发工具的不成名规则
所有的Cobra项目遵循相同的开发周期。首先使用cobra工具初始化项目，然后创建命令和子命令，最后对生成的Go源文件进行所需的更改，以支持所需的功能。

## 拉出来实战

在本节中，您将了解如何使用三个名为insert、delete和list的命令来开发简单命令行实用程序的框架。
### 初始的结构
为了创建我们的第一个命令行实用工具，它将被称为`three`，我们需要执行以下命令:

```shell
cobra init three --pkg-name cobrathree
cd three
cobra add insert
cobra add delete
cobra add list
```
然后我们使用`tree`命令查看下目录结构:
```shell
➜  three tree -L 2
.
├── LICENSE
├── cmd
│   ├── delete.go
│   ├── insert.go
│   ├── list.go
│   └── root.go
└── main.go

1 directory, 6 files
➜  three
```

###小插曲
本来到这里我们就可以 `go build main.go` 来测试程序了,但是我的代码环境是go1.13,所以需要在当前目录下生成go.mod来支撑 go mod的方式,而且本身我的代码也在gopath之外(为了方便测试),关于这一块的支持你可以搜索gomod来学习.所以我需要执行:
```shell
#这里的cobrathree需要和上面的--pkg-name一致
go mod init cobrathree
```

### 构建+测试
> go run main.go insert

```insert called```

> go run main.go delete

```delete called```

> go run main.go list

```list called```

go run main.go doesNotExist
```
Error: unknown command "doesNotExist" for "three"
Run 'three --help' for usage.
unknown command "doesNotExist" for "three"
exit status 1
```

### 看看实现功能的代码(这里以delete为例)

```go
/*
Copyright © 2019 NAME HERE <EMAIL ADDRESS>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

// deleteCmd represents the delete command
var deleteCmd = &cobra.Command{
	Use:   "delete",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("delete called")
	},
}

func init() {
	rootCmd.AddCommand(deleteCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// deleteCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// deleteCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
```

### 我们来尝试修改代码

```go
package cmd

import (
        "fmt"
        "github.com/spf13/cobra"
)

var deleteCmd = &cobra.Command{
        Use:   "delete",
        Short: "这是删除的简短介绍",
        Long:  `这是删除的长介绍.`,
        Run: func(cmd *cobra.Command, args []string) {
                fmt.Println("我是执行删除操作的!")
        },
}

func init() {
        rootCmd.AddCommand(deleteCmd)
}
```

然后执行 `go run main.go delete` 如你所见,预期返回!

###带有第一级和第二级命令的实用程序

在本节中，您将学习如何将子命令添加到现有命令中——子命令是仅与特定命令相关联的命令。在本例中，我们将实现上一节中创建的实用程序的delete和list命令的all子命令。insert命令不需要这样的功能。

```shell
cobra add delete_all -p 'deleteCmd'
```

在这种情况下，应该使用delete命令的内部表示形式，即deleteCmd。all是delete的子命令这一事实是在./cmd/all的init()函数中定义的。如下:

```go
// ./cmd/all.go
func init() {
        deleteCmd.AddCommand(allCmd)
}
```

同时我们添加list的子命令all

```shell
three cobra add list_all -p 'listCmd'
```

####这里有个坑:

我们创建的子命令成了  `list_all`,我们修改代码为`all`即可

因为我们一旦创建 `all`自命令,那么list和delete的文件就冲突了

好了,到此执行下`go run main.go delete all`

```shell
go run main.go delete all
deleteAll called
```

### 带有flag命令的实用程序
这一次，我们将创建一个命令行实用程序，其中包含一个全局标志和一个仅连接到特定命令的标志。

全局flags
一个标志可以是“持久的”，这意味着这个标志将对它分配给的命令以及该命令下的每个命令可用。对于全局标志，将标志指定为根上的持久标志。

> rootCmd.PersistentFlags().BoolVarP(&Verbose, "verbose", "v", false, "verbose output")
Local Flags

还可以在本地分配一个标志，它只适用于特定的命令。

> localCmd.Flags().StringVarP(&Source, "source", "s", "", "Source directory to read from")

### 总结

其实cobra拥有更加强大的功能.例如别名,参数的检验等,但这不是最常用的,所以有需求我么可以查文档.