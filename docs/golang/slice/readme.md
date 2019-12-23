# readme

make([]string, 2, 10) 表示在内存中已经有2个长度的数组,值为nil

所以在append的时候 不要 make([]string, 2) 然后再append,而是需要在第三个参数指定cap,第二个参数指定0

