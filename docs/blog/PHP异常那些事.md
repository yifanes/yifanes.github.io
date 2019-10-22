## date: 2019-06-06 16:38

在这篇文章中,我将从头梳理PHP开发中 `Exception` 这个关键字的周边知识,争取梳理清楚如下的几个问题
1.什么是异常
2.异常从哪里来
3.异常应该到哪里去
4.异常之分门别类
5.异常和错误的区别和联系
6.异常之于业务场景

### 什么是异常
在我们开始所有解释之前,我么首先举个栗子.
假设你要按照给定`id`来查找humans表的用户邮箱,这个功能可以写成这样:

```php
function getHumanEmailById($id)
{
    return \Humans::whereId($id)->email;
}
```

但是这绝对不是一个健壮的代码,一旦用户传递一个不存在的id(数据库不存在),或者传递是压根就不是int型的正整数,程序就会进入: `PHP Notice` 状态,导致整个程序进入非预期流程,这里的非预期流程可能是个php层的警告,也可能是个`fatal error`(假设方法的实现还有更加致命的逻辑假设),导致程序异常终止,所以这时候需要这个方法告诉调用方`你的参数有误`这种信息,这个时候通常我们的做法有两种.
1.
```
if (##如果id非法) {return '';}
```
2.
```
if (##如果id非法) {throw new \InvalidArgumentException("参数非法");}
```

而第二种做法就是我们讨论的Exception,好了,到这里我们只是讨论清楚了抛出异常的必要性,但是就如上面两个例子看到的,调用方调用完毕这个方法怎么按照你给的信号(throw 出来的exception)做出合理的处理呢?

### 异常从哪里来?
Q:上面说清楚了异常的必要性以及可能性,那么异常从哪里来呢? 
A:异常来自开发者对整体代码逻辑的非预期结果给出的提示.
所以简单来说,异常是PHP代码层抛出的.
### 异常应该到哪里去
上面已经定义了`function getHumanEmailById`,同时对参数的非法性做了异常的抛出,但是我们不知道异常到哪里去了,我们尝试调用它`getHumanEmailById(1)`,这里假设id是1的human信息在数据库中已经被删除,看看php执行器返回结果:
> Fatal error: Uncaught InvalidArgumentException: 参数非法

这里发现,我们抛出的异常居然变成了`Fatal error`,所以异常抛出后交给了PHP解释器,解释器没有找到 catch 这个异常的逻辑代码,所以直接fatal error,说明这一点,我们继续修改代码
```
    try{
        getHumanEmailById(1);
    }catch (\Exception $e)
    {
        echo $e->getMessage();
    }
```

执行结果正常输出: 参数非法
到此,我们解释清楚了异常应该到哪里去的问题

###异常之分门别类
也许你留意到上面的代码没有`catch InvalidArgumentException`,是因为`Exception`是`InvalidArgumentException`的父类,因为异常的类型很多,我们有一些需求确实需要根据不同的异常做不同的事情,例如下面的伪代码:
```
try {
    $variable = 'string';
} catch (MyException $e) {
    ##todo1
} catch (YourException $e) {
    ##todo2
} catch (OurException $e) {
    ##todo3
} catch (Exception $e) {
    echo "异常信息:" . $e->getMessage();
}
```
如果你想了解更多的异常分类,可以查看[php手册](https://www.php.net/manual/zh/spl.exceptions.php),也可以通过执行 [这个脚本](https://gist.github.com/mlocati/249f07b074a0de339d4d1ca980848e6a) 来打印异常分类.

###异常和错误的区别和联系
这个主题,我想只有PHP官方php5时代的开发才能解释清楚这一点,通俗的来说,错误可能是不可修复的,当然现在的php7版本已经将error和exception统一了,他们都集成自throwable这个interface.具体的关系如图:
![继承关系](https://storage.xueshop.cn/ZQZSOED@R7S00S12WG@8B.png)

php7一下的话,我们可以尝试将`error`转为`exception`,具体实现代码:
```
protected function registerErrorHandler()
{
	set_error_handler(array($this, 'handleError'));
}

public function handleError($level, $message, $file, $line, $context)
{
	if (error_reporting() & $level)
	{
		throw new ErrorException($message, $level, 0, $file, $line);
	}
}
```
更多是实现方案参照 laravel的[exception\Handler](https://github.com/laravel/framework/blob/53fb3c1f0db3fdbc06155ea405f12fcc4379020c/src/Illuminate/Exception/Handler.php#L95)

###异常之于业务场景
#### 特定一类throwable统一输出json
最后,我们回归到上面最初的代码,如果human的id是非法的,就抛出了异常,假设这个id恰好是业务前端传递的,我们就需要告诉用户这个id是非法的,明确告诉他非法请求.
实现的逻辑代码大致为:
```
        try{
            getHumanEmailById(1);
        }catch (\InvalidArgumentException $e)
        {
            echo json_encode([
                'code' => 444, 
                'msg' => "参数id错误: " . $e->getMessage(), 
                'data' => []
            ]);
        }
```
如果这中参数对应的msg想统一起来,且前端提交的参数非常多,都需要这样判断呢? 这里我们可以抽象出有一个类,继承自InvalidArgumentException的类ApiInvalidArgumentException,然后统一在上层捕获这个异常,然后统一输出json格式
这里的最佳实践可以在laravel中看到影子,大致思路如下:
1.继承\Illuminate\Foundation\Exceptions\Handler::render($request, Exception $e)
2.ApiInvalidArgumentException类定义toJson方法
3.拿到$e,特判ApiInvalidArgumentException,return出tojson

如此对业务代码无侵入,看起来干净且明了

#### 将没有catch的异常介入第三方统计
线上在所难免的会有一些异常是未捕获的,这时php会将信息直接fatal error,并输出堆栈信息,所以我们可以将这些信息介入第三方,实时发消息给开发者,解决和发现线上问题.
推荐大家使用sentry作为php异常处理和发现的工具,很强大,目前我们团队线上就在大量使用.

###总结
因为我们的业务需要判断和处理太多太多不符合预期的结果了,有时候一个鲁棒性强的代码可能是核心业务代码的2-3倍,这个时候如果我们能够很好的利用`exception`,既能让代码健壮,又能让健壮性判断可读性高,例如我们可以二次封装if判断,转变为assert断言,然后在断言中抛出异常.现在很多第三方类库,都很好的定义了自己的异常,为的就是健壮和可读性,希望通过这篇文章,大家能够收获一些新的心得体会,也希望你能斧正文章的错误,下篇博客见!