## date:2018-06-12 14:09

## 1.base64_encode可以替代rawurlencode吗？为什么？
不能，因为base64生成的结果包含`字母数字+/=`，而rawurlencode需要转义+=/

## 2. echo json_encode([]) 和 echo json_encode(['a'=>'b'])的区别是什么?

如果json_encode 传递空数组,返回的是json数组,否则返回的是json对象,但是这个在前端解析的时候是致命的,尤其在ios的解析库中,可能由于开发者不注意留意这个而造成app的崩溃,所以推荐使用 `JSON_FORCE_OBJECT` 参数来encode数组 

