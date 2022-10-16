#!/bin/bash
###############################################
#
###############################################

shopt -s expand_aliases

# VARS
# macosx -> checks if the OSTYPE is MacosX

# CONST
MINIKUBE_DEFPROF="wefox-challenge-cluster" # -> Minikube Default Profile


### Checking and installing minikube
if [[ "$OSTYPE" == "darwin"* ]]; then
	brew install hyperkit
	brew install minikube
	macosx="--driver=hyperkit"
elif [[ "$OSTYPE" == "linux"* ]]; then
	MINIKUBE="/usr/local/bin/minikube"
	if test -f "$MINIKUBE"; then
    	echo "$MINIKUBE already exists. No need to install it."
	else
		echo "I was not able to find ${MINIKUBE}. Downloading..."
		curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
		sudo install minikube-linux-amd64 /usr/local/bin/minikube
	fi
else
	echo "I can't proceed with ${OSTYPE}"
	exit 1
fi

### Minikube start
if [[ ! "$(minikube status | grep Running)" ]]; then
	minikube start "${macosx}" --container-runtime=docker -p ${MINIKUBE_DEFPROF} --memory 4096 --cpus 2
fi

### alias settings
if ! [ "$(grep "alias kubectl" ~/.bashrc)" ]; then 
	cat >> ~/.bashrc <<-EOL

	### Minikube settings
	alias kubectl="minikube kubectl --"
	alias k="minikube kubectl --"

	EOL
fi
alias kubectl="${MINIKUBE} kubectl --"

### Minikube set default cluster
minikube profile "${MINIKUBE_DEFPROF}"
eval $(minikube -p "${MINIKUBE_DEFPROF}" docker-env)
kubectl config set-cluster "${MINIKUBE_DEFPROF}"

### Minikube installed
minikube status
kubectl get all,secret,cm,ing,pvc
