# Docker

* Pull an image or a repository from a registry  
$ docker pull nginx

* 想列出已经下载下来的镜像  
$ docker images

* 会用 nginx 镜像启动一个容器，命名为 webserver ，并且映射了 80 端口, 可以直接访问：http://localhost  
$ docker run --name webserver -d -p 80:80 nginx


* 以交互式终端方式进入 webserver 容器，并执行了 bash 命令，也就是获得一个可操作的 Shell  
$ docker exec -it webserver bash


* 镜像构建,最终镜像的名称 -t nginx:v3,这个 . ，实际上是在指定上下文的目录  
$ docker build -t nginx:v3 .

* Return low-level information on Docker objects  
$ docker inspect

* Get an instance’s IP address  
$ docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $INSTANCE_ID

* Get an instance’s log path  
$ docker inspect --format='{{.LogPath}}' $INSTANCE_ID

* List all port bindings  
$ docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' $INSTANCE_ID

# docker之具名和匿名挂载

匿名挂载：卷挂载只写容器里面的路径，不写容器外的路径

[root@localhost pingxixi]# docker run -d  --name nginx01 -v  /etc/nginx  nginx
1
-v    容器内路径              #匿名挂载
-v    卷名：容器内路径         #具名挂载
-v    /宿主内路径：容器内路径   #指定路径挂载

docker volume ls则是可以查看所有的数据卷，可以看到是找不到具体是那个卷的，匿名起来了。

[root@localhost pingxixi]# docker volume ls
DRIVER              VOLUME NAME
local               444fdf7e612c0e0bc9706813adbe2dd335b5f07201b3beb871f149a0c70a8024
local               9191af3f0e4f7d72b7d952e41a2164b9bbe1f9ab0da0a4cad8d1cf462e78a9c0
local               ce4d698fb06e1df15d6fb8ec62e3ad234bf465f764dd526ccbc41dbad0f2b9e6
local               f12583ca32ab348d208bbac53c7c844f0b250675a105e158f584b995ebde73b1
local               portainer_data

具名挂载：就是挂载的卷陪一个自己的名字，可以方便的查找

/junit-nginx:/etc/nginx这种/junit-nginx是配绝对路径
junit-nginx:/etc/nginx这里junit-nginx则是卷名

重新启动一个nginx，并把卷名命为junit-nginx

[root@localhost pingxixi]# docker run -d --name  nginx03  -v  junit-nginx:/etc/nginx nginx
f8156490cb986b455a3554e136e6c08b566ff9783fb0dd8038d7c9b33e79a041

输入：docker volume ls查看所有卷名

[root@localhost pingxixi]# docker volume ls
DRIVER              VOLUME NAME
local               444fdf7e612c0e0bc9706813adbe2dd335b5f07201b3beb871f149a0c70a8024
local               9191af3f0e4f7d72b7d952e41a2164b9bbe1f9ab0da0a4cad8d1cf462e78a9c0
local               ce4d698fb06e1df15d6fb8ec62e3ad234bf465f764dd526ccbc41dbad0f2b9e6
local               f12583ca32ab348d208bbac53c7c844f0b250675a105e158f584b995ebde73b1
local               junit-nginx
local               portainer_data

在这里面就会看到自己的卷名 junit-nginx。

通过如下命令查看卷情况：docker volume inspect junit-nginx

[root@localhost pingxixi]# docker  volume inspect  junit-nginx
[
    {
        "CreatedAt": "2020-08-25T00:16:47+08:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/junit-nginx/_data",
        "Name": "junit-nginx",
        "Options": null,
        "Scope": "local"
    }
]

docker写卷的时候没有指定路径，都会默认存放在/var/lib/docker/volumes/junit-nginx/_data这个文件里面。
拓展：

-v 容器内路径：ro rw 改变读写的权限
ro readonly # 表示只读
rw readwrite #可读可写

 docker run -d -p  8080:80 --name nginx -v  jundas-nginx:/etc/nginx:ro nginx
 docker run -d -p  8080:80 --name nginx -v  jundas-nginx:/etc/nginx:rw nginx

看到ro说明这个路径只能是主机来操作，而容器里面是无法操作的