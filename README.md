# k8s-builder

## usage

- clone rainbond kubenetes code

```bash
git clone https://github.com/goodrain/kubernetes.git
```

- make kubenetes

```bash
docker run -v $PWD:/go/src/k8s.io/kubernetes \
-w /go/src/k8s.io/kubernetes \
-it --rm --privileged goodrainapps/8s-builder
make kube-apiserver
```
