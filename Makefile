K8S_VER?=v1.6.4
RBD_VER?=3.5
K8S_DIR:=$(CURDIR)/k8s
RBD_DIR:=$(CURDIR)/rainbond

.PHONY: help
help: ## show make targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: k8s-bin k8s-image rbd-bin rbd-image clean

base:
	@docker build -t goodrainapps/k8s-builder -f Dockerfile.bin .

pull-k8s:
	@git clone https://github.com/goodrain/kubernetes.git $(K8S_DIR)

.PHONY: k8s-bin 
k8s-bin: base pull-k8s 
k8s-bin: k8s_pkg:=kubectl kubelet kube-apiserver kube-controller-manager kube-scheduler
k8s-bin: ## make k8s binary
	for bin in $(k8s_pkg);do\
		docker run -v $(K8S_DIR):/go/src/k8s.io/kubernetes -e COMPRESS=true -w /go/src/k8s.io/kubernetes -it --rm --privileged goodrainapps/k8s-builder $${bin};\
	done

.PHONY: k8s-image
k8s-image: k8s-bin 
k8s-image: k8s_img:= kube-apiserver kube-controller-manager kube-scheduler
k8s-image: ## make k8s image
	for img in $(k8s_img);do \
		docker build -t rainbond/$${img}:$(K8S_VER) -f Dockerfile.$${img} . ;\
	done

pull-rainbond:
	@git clone -b V$(RBD_VER) https://github.com/goodrain/rainbond.git $(RBD_DIR)

.PHONY: rbd-bin
rbd-bin: pull-rainbond
rbd-bin: rbd_bins:= grctl node mq worker builder entrance webcli api eventlog
rbd-bin: ## make rainbond binary
	for rbd_bin in $(rbd_bins);do \
		docker run --rm -v $(RBD_DIR):/go/src/github.com/goodrain/rainbond -w /go/src/github.com/goodrain/rainbond -it golang:1.8.3 go build -ldflags '-w -s'  -o ./hack/contrib/docker/$${rbd_bin}/rainbond-$${rbd_bin} ./cmd/$${rbd_bin};\
	done

.PHONY: rbd-image
rbd-image: rbd-bin
rbd-image: rbd_images:= mq worker chaos entrance webcli api eventlog
rbd-image: ## make rainbond image
	for rbd_img in $(rbd_images);do \
		docker run --rm -v $(RBD_DIR):/go/src/github.com/goodrain/rainbond -w /go/src/github.com/goodrain/rainbond -it golang:1.8.3 go build -ldflags '-w -s'  -o ./hack/contrib/docker/$${rbd_bin}/rainbond-$${rbd_bin} ./cmd/$${rbd_bin};\
	done

.PHONY: clean
clean: ## clean the build artifacts
	@rm -rf $(K8S_DIR)