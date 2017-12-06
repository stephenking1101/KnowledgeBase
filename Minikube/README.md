# Kubernetes

* kubectl cheatsheet  
https://kubernetes.io/docs/reference/kubectl/cheatsheet/

## Example 1

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