K8S_VER?=v1.10.13
K8S_DIR:=$(CURDIR)/k8s

all: image clean

.PHONY: help
help: ## show make targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

download_pkg:
	@wget https://dl.k8s.io/$(K8S_VER)/kubernetes-server-linux-amd64.tar.gz -P /tmp
	@tar xf /tmp/kubernetes-server-linux-amd64.tar.gz -C /tmp/
	@mkdir -p $(K8S_DIR)/_output/local/bin/linux/amd64/
	@cp -a /tmp/kubernetes/server/bin/kube-* $(K8S_DIR)/_output/local/bin/linux/amd64/

.PHONY: image
image: download_pkg ## make k8s image
image: k8s_img:= kube-apiserver kube-controller-manager kube-scheduler 
image:
	for img in $(k8s_img);do \
		docker build -t rainbond/$${img}:$(K8S_VER) -f Dockerfile.$${img} . ; \
	done

.PHONY: clean
clean: ## clean the build artifacts
	@rm -rf $(K8S_DIR)
	@rm -rf /tmp/kubernetes*
