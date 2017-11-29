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

