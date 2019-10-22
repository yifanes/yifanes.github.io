## date:2018-06-05 09:42

1.进入一个已经start的container

    #如果没有安装bash，需要apk add bash
    docker exec -it <container_id> /bin/bash

2.根据Dockerfile构建镜像 

    docker build -t <image_name:tag_id> .

3.运行构建好的镜像为容器

    #d为demon
    docker run -itd <image_id>

4.删除容器

    docker rm -f <container_id>

