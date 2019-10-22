## date:2019-07-17 20:21

你知道什么是类工厂吗?为什么它有用?是否考虑过在Golang中实现一个类工厂，即使Go在本质上不是完全面向对象的?除了令人印象深刻的并发功能之外，您是否对Go中的一些出色特性感到好奇?如果你对这些问题中的任何一个感兴趣，那么继续读下去也许是值得的。本文介绍了在Go中实现工厂设计模式。

### 什么是工厂模式?
目前在网上已经有很多关于工厂模式的定义了,其实工厂模式的概念非常简单.在oop的环境中,工厂或者类工厂是一种最小化的添加未来代码的设计方式,但是为什么我们需要将未来的代码添加到现有的应用程序中呢?因为这是软件行业的本质, ***需求永远在变***

类工厂通过使用接口和继承来实现面向对象世界中新旧代码之间的解耦。守则将分为三部分:


1. 核心代码或主代码
2. 一个类的工厂
3. 实现相同接口或抽象类的具体类也使用相同的公共函数签名

核心代码主要与类工厂通信，它向类工厂请求类型。然后类工厂实例化表示该类型的类，并将该类的父接口返回给核心代码。然后核心代码从接口调用函数。这些函数由实现接口的所有类共享，这意味着无论何时核心代码要求不同的类型，相同的函数仍然可以工作。下面是一个面向对象的类工厂的完整示例。

![](https://storage.xueshop.cn/blog/2019-07-17-Class-Factory-Diagram.png)

例如，设想一个负责打开家用电器的软件。让我们假设-最初-你被要求支持的器具只是炉子和冰箱。但是一年之后，你也被要求增加对微波的支持。如果您从一开始就没有很好地设计它，那么您将需要更改许多现有代码。但是，如果使用类工厂设计模式，应用程序的核心代码只需要考虑两件事:1-请求特定类型的设备。2-打开电器。其余的由工厂负责。代码流程应该是这样的:

```
Core Application code:  myAppliance = ApplianceClassFactory.Get(“Oven”)

Class Factory:    return new OvenClass

Core Application code: myAppliance.TurnOn()
```

###那么我们来看看,在golang中如何写一个工厂

首先，我需要弄清楚，Go并不是一种完全面向对象的编程语言。这意味着当我在Go中说类工厂时，我并不是指类的工厂，我只是出于习惯使用这个术语。在Go中，它将更像是一个结构体工厂，很快就会说到这一点:

其次，在用Go编写类工厂之前，需要熟悉该语言的两个重要的知识点，即结构和接口。

#### 什么是结构体

Go结构体与对象是等价的，只是它们要简单得多。结构体可以同时承载变量和函数。结构体内部的变量在结构定义语句中指定，而属于结构的函数在函数签名中标识父结构。

让我们用一个例子来补充它，假设我们需要一个包含三个变量的结构体:一个整数、一个字符串和一个布尔值:

```
type exampleStruct struct{
    num int
    s string
    flag bool
}
```

现在让我们假设有一个printExampleStruct()函数，它属于我们新创建的struct:

```
func (s exampleStruct) printExampleStruct(){
    //print the contents of the struct
   fmt.Printf("example struct: num = %v, s = %v,  flag = %v", s.num, s.s, s.flag)
}
```

要调用和使用结构体，只需先初始化该结构体类型的变量，然后使用它。代码如下:

```
myStruct := exampleStruct{ 
num: 5,
s: "I am a string variable",
flag: true,
}
	
myStruct.printExampleStruct()
```

当我们把所有这些加起来并打包后，我们的struct示例程序将如下所示:

```
package main

import "fmt"

type exampleStruct struct{
    num int
    s string
    flag bool
}

func (s exampleStruct) printExampleStruct(){
    fmt.Printf("example struct: num = %v, s = %v,  flag = %v", s.num, s.s, s.flag)
}

func main() {
    myStruct := exampleStruct{ 
	num: 5,
	s: "I am a string variable",
	flag: true,
	}
	
	myStruct.printExampleStruct()
}
```

####接下来介绍接口

Go接口在概念上与主流语言(如Java或c#)中的接口相似。实际上，它们是定义一组函数\方法的类型。由于结构就像对象一样，它们通常实现接口。Go的不同之处在于没有特殊的关键字和/或大括号来表示结构“Y”继承了接口“X”。它的工作原理是，如果您的结构包含一个函数，该函数在定义的接口中具有与函数相同的签名，那么您的结构将实现该接口。是的,就是这样!

接口可以简单地通过以下语法定义:

```
type myInterface interface {
    myFunction() float64
}

```

如前所述，任何实现相同签名功能的struct都被认为是接口的子结构，结构如下:

```
type myStruct struct{
    f float64
}

func (s myStruct)myFunction() float64{
	return 455.984
}
```

好了说完interface和struct,我们来说说怎么用go实现工厂

### go实现工厂

让我们想象一下，我们被要求设计一个程序，它可以与多种类型的设备对话。该程序将启动一个设备或返回特定设备的操作说明。例如，该计划支持的当前设备类型是冰箱和炉子。但是，在将来，我们可能会对其他设备类型有额外的需求。

为了设计一个好的软件来达到这个目的，我们需要编写我们的程序，当客户要求添加更多的设备时，我们不需要修改任何主代码。这时我们意识到类工厂对于我们的项目来说是一个好主意。

让我们从核心\main应用程序代码开始，下面是它需要为我们做的:

1. 询问用户他们喜欢的设备类型
2. 使用类工厂检索该类型的设备
3. 打开电器
4. 显示设备功能的描述

因此，总的来说，我们需要在核心应用程序代码中实现四个简单的任务。即使第二天又添加了500多个设备类型，这些代码将来也不需要进行任何编辑。现在是时候试试golang了:

首先，我们需要导入核心代码中使用的包。Go中的包类似于Java中的包或c#中的名称空间，c#是代码的大容器，比类构造高一两步。第一个包表示项目的类工厂，在我的示例中是“ClassFactoryTutorial/ appliance”，第二个包是“fmt”，它处理各种命令行任务。“fmt”类似于Java中的“System”或c#中的“Console”。

其次，我们编写主函数来实现前面描述的四个任务。下面是代码的样子:

```
package main

import (
    "ClassFactoryTutorial/Appliances"
	"fmt"
)

func main(){
	//Request the user to enter the appliance type
	fmt.Println("Enter preferred appliance type")

	//use fmt.scan to retrieve the user's input
	var myType int
	fmt.Scan(&myType)

	//Use the class factory to create an appliance of the requested type
	myAppliance, err := Appliances.CreateAppliance(myType)

	//if no errors start the appliance then print it's purpose
	if err==nil{
		myAppliance.Start()
		fmt.Println(myAppliance.GetPurpose())
	} else {
		//if error encountered, print the error
		fmt.Println(err)
	}

}
```

上面代码片段中使用的“appliance”关键字是我们的类工厂，它只不过是一个包含构建类工厂所需函数的包。

接下来，让我们在Golang创建我们的电器类工厂

首先，我们需要定义一个包含任何设备类型所需功能的接口。

其次，我们需要编写一个函数，返回与从核心代码传递到类工厂的设备类型对应的结构类型(同样，类似于Go中的对象)。

####package Appliances

```
//import errors to log errors when they occur
import "errors"

//The main interface used to describe appliances
type Appliance interface{
    Start()
	GetPurpose() string
}

//Our appliance types
const (
	STOVE = iota
	FRIDGE
)

//Function to create the appliances
func CreateAppliance(t int)(Appliance, error) {
	//Use a switch case to switch between types, if a type exist then error is nil (null)
	switch t{
	case STOVE:
		return new(Stove),nil
	case FRIDGE:
		return new(Fridge),nil
	default:
		//if type is invalid, return an error
		return nil, errors.New("Invalid Appliance Type")
	}
}

```

CreateAppliance()函数不需要属于任何特定的结构或接口，它只属于“appliance”包。如果您想与Java或c#进行比较，它有点类似于静态方法。

代码中的设备类型是enum常量，当将“iota”分配给列表中的第一项时，其余项的增量为0。这意味着类型“火炉”将等于0，类型“冰箱”将等于1。

这样，我们班工厂的主体就完成了。下一步是编写代码来表示我们支持的设备类型，炉子的炉子结构和冰箱的冰箱结构。在技术术语中，我们需要编写结构(再一次，像类)来实现“设备”接口中定义的函数。

让我们从设备类型开始，我们需要写一段代码:

定义一个电器类型结构体，“炉子”表示炉子类型，“冰箱”表示冰箱类型
实现“Start()”和“GetPurpose()”函数。同样，这些是在类工厂“Appliance”接口中定义的函数。通过实现它们，设备类型结构将成为“设备”接口的实现，因此任何处理“设备”接口的代码都将在设备类型结构上工作
功能已完全定义，让我们跳转到“火炉”结构的代码:

```
package Appliances

// define a stove struct, the struct contain a string representing the type name
type Stove struct{
    typeName string
}

//The stove struct implements the start() function
func (sv *Stove)Start(){
	sv.typeName = " Stove "
}

//The stove struct implements the GetPurpose() function
func (sv *Stove)GetPurpose() string{
	return "I am a " + sv.typeName + " I cook food!!"
}
```

很直接。

继续看“Fridge”结构，实现将非常类似:

```
package Appliances

// define a fridge struct, the struct contain a string representing the type name
type Fridge struct{
    typeName string
}

//The fridge struct implements the start() function
func (fr *Fridge)Start(){
	 fr.typeName = " Fridge "
}

//The fridge struct implements the start() function
func (fr *Fridge)GetPurpose() string{
	return "I am a " + fr.typeName + " I cool stuff down!!"
}

```


这样，程序就完成了。下一步是使用它:

> ➜  factory ./main 
> Enter preferred appliance type
> 0
> I am a  Stove  I cook food!!
> ➜  factory ./main
> Enter preferred appliance type
> 1
> I am a  Fridge  I cool stuff down!!


现在，假设一个星期后，客户回来要求您的软件支持微波炉类型的设备，我们会怎么做?因为我们是围绕类工厂设计应用程序的，所以支持新内容所需的附加功能将相当简单和直接。如果我们要增加对微波的支持，我们需要:

核心代码(主要功能):不需要更改
类工厂代码:添加类型“微波”
添加一个表示微波设备类型的新结构
下面是类工厂代码的新添加:

```
//Our appliance types
const (
    STOVE = iota
	FRIDGE
	//Now we support microwaves
	MICROWAVE
)

func CreateAppliance(t int)(Appliance, error) {
	switch t{
	case STOVE:
		return new(Stove),nil
	case FRIDGE:
		return new(Fridge),nil
		//new case added for microwaves
	case MICROWAVE:
		return new(Microwave),nil
	default:
		return nil, errors.New("Invalid Appliance Type")
	}

```

这是新的结构体:

```
package Appliances

type Microwave struct{
    typeName string
}

func (mr *Microwave)Start(){
	mr.typeName = " Microwave "
}

func (mr *Microwave)GetPurpose() string{
	return "I am a " + mr.typeName + " I heat stuff up!!"
}
```


讲完这些，我们就到本教程的结尾了。正如您所看到的，从一开始就遵循一个好的设计可以为您在将来省去很多麻烦，并使编码更加高效。像Go这样强大而有趣的语言使它更加简单。