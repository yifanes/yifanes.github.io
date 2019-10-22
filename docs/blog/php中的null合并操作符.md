## date:2019-05-29 11:53

您可能已经知道PHP中的一些比较运算符。比如三元`?:`，空合并`??`以及宇宙飞船的操作符 <=>。但你真的知道它们是如何工作的吗？了解这些运算符会使您更多地使用它们，从而产生更清晰的代码。

## 三元运算符
三元运算符是为了简化 `if {} else {}` 结构, 例如我们如下的代码:
```
if ($condition) {
    $result = 'foo' 
} else {
    $result = 'bar'
}
```
你可以这样写:
```
$result = $condition ? "foo" : "bar";
```

如果上面代码中的`$condition`的值是`true`, 左边的值就赋值给`$result`,如果值是`false`, 右边的值将会用于`$condition`.

一个有趣的事实: 三元运算符的名称实际上是指"作用于三个操作数的运算符".运算符是可以通过给出的一或多个值（用编程行话来说，表达式）来产生另一个值（因而整个结构成为一个表达式）的东西。

运算符可按照其能接受几个值来分组。一元运算符只能接受一个值，例如 !（逻辑取反运算符）或 ++（递增运算符）。 二元运算符可接受两个值，例如熟悉的算术运算符 +（加）和 -（减），大多数 PHP 运算符都是这种。最后是唯一的三元运算符 ? :，可接受三个值；通常就简单称之为“三元运算符”（尽管称之为条件运算符可能更合适）。

关于这些知识,官方手册是系统的学习这些知识的渠道, [这是地址](https://www.php.net/manual/zh/language.operators.php)

回头我们继续三目运算符: 你知道哪些表达式是`true`, 哪些表达式是`false`吗?你可以从这里得到答案 [这是地址](https://www.php.net/manual/zh/types.comparisons.php)

当条件的计算结果为真时，三元运算符将使用其左边操作数。这可以是字符串、整数、布尔值等。右侧操作数将用于所谓的“错误值”。例如0或“0”、空数组或字符串、空值、未定义或未分配的变量，当然还有false本身。所有这些值都将使三元运算符使用其右手操作数。

## 更加简短的三目运算表达式

从`php5.3`,你可以省略左侧的操作数,例如:
```
$result = $initial ?: 'default';
```

在这种情况下，`$result`的值将是`$initial`的值，除非`$initial`的计算结果为`false`，在这种情况下，将使用字符串`default`。

当然你可以将这种场景的代码按照正常的三目运算表达式:
```
$result = $condition ? $condition : 'default';
```

但是这里特定意义上来说,简化的三目运算表达式,变成了二元运算符.

## 链式三目运算符

如下的代码,看起来很符合逻辑,但是他在`PHP`中不能按照常理输出内容.

```
$firstCondition = $elseCondition = true;
$result = $firstCondition
    ? 'truth'
    : $elseCondition
        ? 'elseTrue'
        : 'elseFalse';
```

原因是PHP中的三元运算符是左相关的，因此以一种非常奇怪的方式进行解析:上面的示例总是首先判断`$elsecondition`部分，因此即使`$firstCondition`为true，也不会看到它的输出.

所以上面的代码输出: `elseTrue`

关于这一点你可以, [点击进入stackoverflow学习](https://stackoverflow.com/questions/20559150/ternary-operator-left-associativity/38231137#38231137)

值得注意的是,在php7.4版本中,官方已经`deprecated`了不带括号的三目运算,[这里是更详实的资料](https://stitcher.io/blog/new-in-php-74#left-associative-ternary-operator-deprecation-rfc)

##空合并运算符

你以前看过[类型比较表](https://www.php.net/manual/zh/types.comparisons.php)吗？从php 7.0开始，可以使用空合并运算符。它类似于三元运算符，但其行为类似于左侧操作数上的ISSET，而不仅仅是使用其布尔值。这使得该运算符对于数组和**未设置变量**时指定默认值特别有用。

```
$undefined ?? 'fallback'; // 'fallback'

$unassigned;
$unassigned ?? 'fallback'; // 'fallback'

$assigned = 'foo';
$assigned ?? 'fallback'; // 'foo'

'' ?? 'fallback'; // ''
'foo' ?? 'fallback'; // 'foo'
'0' ?? 'fallback'; // '0'
0 ?? 'fallback'; // 0
false ?? 'fallback'; // false
```

### 空合并操作符在数组上的使用
此运算符与数组结合使用时特别有用，因为它的行为类似于`isset`。这意味着您可以快速检查键的存在，甚至是嵌套键，而无需编写详细的表达式。

```
$input = [
    'key' => 'key',
    'nested' => [
        'key' => true
    ]
];

$input['key'] ?? 'fallback'; // 'key'
$input['nested']['key'] ?? 'fallback'; // true
$input['undefined'] ?? 'fallback'; // 'fallback'
$input['nested']['undefined'] ?? 'fallback'; // 'fallback'

null ?? 'fallback'; // 'fallback'
```

这里举个栗子,上面第一行的表达式`$input['key'] ?? 'fallback';` 我们比较传统(low)一些的做法是:
```
$output = isset($input['key']) ? $input['key'] : 'fallback';
```

**请注意**，在检查数组键是否存在时，不可能使用简化三元运算符。它将触发错误或返回布尔值，而不是实际的左操作数的值。
举个栗子:
```
//特别注意,这里返回的是true而不是key键对应的值
$output = isset($input['key']) ?: 'fallback' 
//这里如果没有key值,将会触发一个 `undefined index` 错误
$output = $input['key'] ?: 'fallback';
```

### 链式操作空合并操作符

与三元运算符一样，也可以链接空合并运算符。它的语法比三元的要简单得多。

```
$input = [
    'key' => 'key',
];

$input['undefined'] ?? $input['key'] ?? 'fallback'; // 'key'
```

### 空合并分配运算符

在php 7,4中，我们可以期待一种更简短的语法，称为“空合并赋值操作符”。
```
// 这个操作符在7.4中才生效

function (array $parameters = []) {
    $parameters['property'] ??= 'default';
}
```
在此示例中，$parameters['property']将被设置为“default”，除非它在传递给函数的数组中设置。这相当于使用当前的空合并运算符执行以下操作：

```
function (array $parameters = []) {
    $parameters['property'] = $parameters['property'] ?? 'default';
}
```

## 太空操作符

太空船操作符，虽然有一个很特别的名字，但可能非常有用。它是用于比较的运算符。它将始终返回三个值之一：0、-1或1。

当两个值完全相等时,返回`0`, 左边的大返回`1`, 右边的大返回`-1`.
举个栗子:
```
1 <=> 2; // 返回 -1
```
它还不止这么简单的比较数字,还有其他的,比如:

```
// 比较字符串
'a' <=> 'z'; // -1

// 数组
[2, 1] <=> [2, 1]; // 0

// 多维数组
[[1, 2], [2, 2]] <=> [[1, 2], [1, 2]]; // 1

// 甚至大小写 
'Z' <=> 'z'; // -1
```

奇怪的是，在比较字母大小写时，小写字母被认为是最高的。不过，有一个简单的解释:字符串比较是通过每个字符比较字符来完成的。一旦一个字符不同，就会比较它们的ASCII值。因为在ASCII表中，小写字母排在大写字母之后，所以它们的值更高。

### 比较对象

其实我感觉对象比较就有些过分了,毕竟对象作为复杂的数据结构,比较的基础是什么?但是这里可以提到一点,下面的做法有时又很有用,如下:

```
$datea=DateTime::createFromFormat('y-m-d', '2000-02-01');
$dateb=DateTime::createFromFormat('y-m-d', '2000-01-01');
$datea<=>$dateb；//返回1
```
当然，比较日期只是一个例子，但仍然是一个非常有用的例子。

### 排序函数

这个运算符的一个重要用途是对数组进行排序。在PHP中对数组进行排序有很多种方法，其中一些方法允许使用用户定义的排序函数。此函数必须比较两个元素，并根据它们的位置返回1、0或-1。
```
$array = [5, 1, 6, 3];

usort($array, function ($a, $b) {
    return $a <=> $b;
});

// $array = [1, 3, 5, 6];
```
逆序排列:

```
usort($array, function ($a, $b) {
    return -($a <=> $b);
});
```

好了,至此,php的这些新特性介绍完毕,相信它对你的代码的优雅型有一些提高,谢谢阅读!