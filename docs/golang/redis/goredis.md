# go redis 关于类型的转换的一写注意点



## redis 针对update或者set之类的,通常返回 影响数



127.0.0.1:6379> SETNX nxkey val
(integer) 0

这类情况,redis.SetNX(nxkey, 1, 0).Result()

更具result返回的结果类型来判断(goredis已经做好了类型转换)



例如: 

127.0.0.1:6379> CONFIG GET timeout
1) "timeout"
2) "0"

redis.ConfigGet("time").Result() 返回[]interface{}, 这个时候我们转换为:[]string

