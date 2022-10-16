
# Http-echo

## Description
[Http echo] - A small go web server that serves the contents it was started with as an HTML page.


## Introduction

This chart deploys hello on a [Kubernetes] cluster using the [Helm 3] package manager and [Jenkins]

## Installing Minikube

To install Minikube if it's not available, run the script  **minikube_setup.sh** located in the root folder.

```console
$ bash minikube_setup.sh
```
The command checks, installs (if missing) and starts a minikube cluster named **wefox-challenge-cluster**
The [deploying](#Deploying) section lists the commands to deploy and upgrade the [Http echo](#Http-echo) helm chart.

> **Tip**: check minikube using `minikube status`

## Deploying the Jenkins helm chart

I deployed **Jenkins** to automate the deployment of **http-echo**
User: **admin**
password: **Wefoxchallenge01** 
```console
helm repo add jenkins https://charts.jenkins.io
helm repo update
kubectl create namespace devops-tools
kubectl config set-context --current --namespace=devops-tools
helm upgrade --install jenkins-admin --set controller.adminPassword=Wefoxchallenge01 jenkins/jenkins
kubectl --namespace devops-tools port-forward svc/myjenkins 8080:8080 &
kubectl apply -f charts/jenkins/rbac.yaml
```
>**Tip**: I added a service account with the needed permissions to allow Jenkins to deploy/update our Helm Chart

## Configure the GitHub repository

I generated a Personal access token (**PAT**) in the GitHub settings and added a webhook in the GitHub repository that we are going to use (**[wefox-challenge-automation-jenkins](https://github.com/fmlisco/wefox-challenge-automation-jenkins)**)

## Deploying 

when a new git tag is created in the git repo, Github notifies Jenkins that runs the '**wefox-challenge**' pipeline and atuomatically deploys the **http-echo** helm chart.
>**Tip**: The git tag **must** match the image name since Jenkins uses it.
>
> **Tip**: The service should be available from outside the cluster, via something like:
> curl http://hello.wefox.localhost:8081/

## Define the URL for http-echo
```console
sudo -- sh -c "echo 127.0.0.1    hello.wefox.localhost >> /etc/hosts"
```

## One line commands

### Minikube Dashboard
```console
minikube dashboard --url
```
>**Tip**: A great help to monitor the Minikube cluster

### Delete the minikube cluster
```console
minikube delete -p wefox-challenge-cluster
```


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [Helm 3]: <https://helm.sh/docs/intro/install/>
   [Jenkins]: <https://www.jenkins.io/>
   [Kubernetes]: <http://kubernetes.io>
   [Http echo]:<https://github.com/hashicorp/http-echo>

