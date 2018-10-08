K8S_VER?=v1.6.4
K8S_DIR:=$(CURDIR)/k8s

all: binary tgz image clean

.PHONY: help
help: ## show make targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

base:
	@docker build -t goodrainapps/k8s-builder -f Dockerfile.bin .

pull:
	@git clone --depth 1 https://github.com/goodrain/kubernetes.git $(K8S_DIR)

.PHONY: binary
binary: base pull ## make k8s binary
binary: k8s_pkg:=kubectl kubelet kube-apiserver kube-controller-manager kube-scheduler
binary:
	for bin in $(k8s_pkg);do\
		docker run -v $(K8S_DIR):/go/src/k8s.io/kubernetes -e COMPRESS=true -w /go/src/k8s.io/kubernetes -it --rm --privileged goodrainapps/k8s-builder $${bin}; \
	done

.PHONY: image
image: binary ## make k8s image
image: k8s_img:= kube-apiserver kube-controller-manager kube-scheduler
image:
	for img in $(k8s_img);do \
		docker build -t rainbond/$${img}:$(K8S_VER) -f Dockerfile.$${img} . ; \
	done

.PHONY: tgz
tgz: binary ## make k8s tgz
tgz:
	tar zcvf k8s.tgz $(K8S_DIR)/_output/local/bin/linux/amd64/

.PHONY: clean
clean: ## clean the build artifacts
	@rm -rf $(K8S_DIR)
