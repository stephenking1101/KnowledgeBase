# Kubernetes

Kubernete是google公司开源的大规模容器集群管理系统，它为容器化应用提供了资源调试、部署、服务发现、扩展机制等功能。Kubernete的核心概念包括：
        
*Node:  
Node是Kubernete中的一个工作机器，可以是物理机或虚拟机。依据角色不同分类主控节点（Master）与从属节点（Minion)。其中Master提供调试与控制功能，负责整个集群的管理工作，而Minion则是集群的工作节点。

*Pod:  
Pod是Kubernetes的基本操作单元，是最小的可创建、调试和管理的部署单元。把相关的一个或多个容器构成一个Pod，通常Pod里的容器运行相同的应用。Pod包含的容器运行在同一个Minion(Host)上，作业一个统一管理单元，共享相同的volumes和network namespace/IP和Port空间。        
        
*Service:  
Services也是Kubernetes的基本操作单元，是真实应用服务的抽象，每一个服务后面都有很多对应的容器来支持。Kubernete用于定义一系列Pod逻辑关系与访问规则，服务的目标是为了隔绝前端与后端的耦合性。通过服务Proxy的port和服务selector决定服务请求传递给后端提供服务的容器，对外表现为一个单一访问接口，外部不需要了解后端如何运行。

*Replication Controller:  
Replication Controller是Kubernete的副本控制器，确保任何时候Kubernetes集群中有指定数量的pod副本(replicas)在运行， 如果少于指定数量的pod副本(replicas)，Replication Controller会启动新的Container，反之会杀死多余的以保证数量不变。Replication Controller使用预先定义的pod模板创建pods。对于利用pod 模板创建的pods，Replication Controller根据label selector来关联。

*Label:  
Label是一组附加在各类对象上的键值对，是Kubernete中最重要的节点分组方法，用于区分Pod、Service、Replication Controller。每个Pod、Service、 Replication Controller可以有多个label，但是每个label的key只能对应一个value。Labels是Service和Replication Controller运行的基础，Kubernete通过Label来选择正确的容器，将访问Service的请求转发给后端提供服务的多个容器。同样，Replication Controller也使用labels来管理通过pod 模板创建的一组容器。

* kubectl cheatsheet  
https://kubernetes.io/docs/reference/kubectl/cheatsheet/

## Minikube Example 1

```shell
$ minikube start
Starting local Kubernetes v1.7.5 cluster...
Starting VM...
SSH-ing files into VM...
Setting up certs...
Starting cluster components...
Connecting to cluster...
Setting up kubeconfig...
Kubectl is now configured to use the cluster.

$ kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
deployment "hello-minikube" created
$ kubectl expose deployment hello-minikube --type=NodePort
service "hello-minikube" exposed

# We have now launched an echoserver pod but we have to wait until the pod is up before curling/accessing it
# via the exposed service.
# To check whether the pod is up and running we can use the following:
$ kubectl get pod
NAME                              READY     STATUS              RESTARTS   AGE
hello-minikube-3383150820-vctvh   1/1       ContainerCreating   0          3s
# We can see that the pod is still being created from the ContainerCreating status
$ kubectl get pod
NAME                              READY     STATUS    RESTARTS   AGE
hello-minikube-3383150820-vctvh   1/1       Running   0          13s
# We can see that the pod is now Running and we will now be able to curl it:
$ curl $(minikube service hello-minikube --url)
CLIENT VALUES:
client_address=192.168.99.1
command=GET
real path=/
...
$ kubectl delete deployment hello-minikube
deployment "hello-minikube" deleted
$ minikube stop
Stopping local Kubernetes cluster...
Machine stopped.
```

## Example 2

```shell
$ kubectl get pods
NAME                         READY     STATUS    RESTARTS   AGE
nginx-app-4028413181-cnt1i   1/1       Running   0          6m

$ kubectl exec nginx-app-4028413181-cnt1i ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.5  31736  5108 ?        Ss   00:19   0:00 nginx: master process nginx -g daemon off;
nginx        5  0.0  0.2  32124  2844 ?        S    00:19   0:00 nginx: worker process
root        18  0.0  0.2  17500  2112 ?        Rs   00:25   0:00 ps aux

$ kubectl describe pod nginx-app-4028413181-cnt1i
Name:          nginx-app-4028413181-cnt1i
Namespace:         default
Node:          boot2docker/192.168.64.12
Start Time:        Tue, 06 Sep 2016 08:18:41 +0800
Labels:        pod-template-hash=4028413181
               run=nginx-app
Status:        Running
IP:            172.17.0.3
Controllers:       ReplicaSet/nginx-app-4028413181
Containers:
  nginx-app:
    Container ID:              docker://4ef989b57d0a7638ad9c5bbc22e16d5ea5b459281c77074fc982eba50973107f
    Image:                 nginx
    Image ID:              docker://sha256:4efb2fcdb1ab05fb03c9435234343c1cc65289eeb016be86193e88d3a5d84f6b
    Port:                  80/TCP
    State:                 Running
      Started:             Tue, 06 Sep 2016 08:19:30 +0800
    Ready:                 True
    Restart Count:             0
    Environment Variables:         <none>
Conditions:
  Type         Status
  Initialized      True
  Ready            True
  PodScheduled     True
Volumes:
  default-token-9o8ks:
    Type:          Secret (a volume populated by a Secret)
    SecretName:    default-token-9o8ks
QoS Tier:          BestEffort
Events:
  FirstSeen        LastSeen           Count      From               SubobjectPath              Type           Reason         Message
  ---------        --------           -----      ----               -------------              --------           ------         -------
  8m           8m             1          {default-scheduler }                       Normal         Scheduled          Successfully assigned nginx-app-4028413181-cnt1i to boot2docker
  8m           8m             1          {kubelet boot2docker}      spec.containers{nginx-app}         Normal         Pulling        pulling image "nginx"
  7m           7m             1          {kubelet boot2docker}      spec.containers{nginx-app}         Normal         Pulled         Successfully pulled image "nginx"
  7m           7m             1          {kubelet boot2docker}      spec.containers{nginx-app}         Normal         Created        Created container with docker id 4ef989b57d0a
  7m           7m             1          {kubelet boot2docker}      spec.containers{nginx-app}         Normal         Started        Started container with docker id 4ef989b57d0a

$ curl http://172.17.0.3
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>
<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>
<p><em>Thank you for using nginx.</em></p>
</body>
</html>

$ kubectl logs nginx-app-4028413181-cnt1i
127.0.0.1 - - [06/Sep/2016:00:27:13 +0000] "GET / HTTP/1.0 " 200 612 "-" "-" "-"
```

–Delete (stop)

kubectl delete -f /ci2/config/deploy/k8s-config/config/

–Create (start)

kubectl create -f /ci2/config/deploy/k8s-config/config/

kubectl get namespaces

kubectl config set-context minikube --namespace=ft

kubectl get deployments

kubectl get pods

kubectl get services

kubectl describe pod rba-user-activity-deployment-1709186581-srkl8

docker ps
docker exec -it xxx bash
docker cp /root/war.war 67606405f2f2:/var/lib/jetty/deployments/war.war
docker restart 67606405f2f2