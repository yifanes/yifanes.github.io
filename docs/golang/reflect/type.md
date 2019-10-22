# 根据反射然后比较类型的实践

## 群里的问题

![](https://storage.xueshop.cn/blog/2019-08-08-qTngB5.png)

 群里兄弟们给出的答案:

![](https://storage.xueshop.cn/blog/2019-08-08-VyLow6.png)

个人分析:

1.reflect.TypeOf(jsonp) 返回的是Type接口

2.v := reflect.TypeOf(jsonp) 表达式中,v是Type的具体实现,所以v也实现了Kind方法

3.reflect.String 是枚举const,所以做比对既是 等值判断