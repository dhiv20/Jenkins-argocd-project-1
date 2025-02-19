## django-todo
A simple todo app built with django

![todo App](https://raw.githubusercontent.com/shreys7/django-todo/develop/staticfiles/todoApp.png)

## CICD Architecture [GitHub -> Jenkins -> docker -> k8s Manifests -> Argo CD -> k8s cluster]

![Screenshot 2023-02-01 at 2 48 06 PM](https://user-images.githubusercontent.com/43399466/216001659-74024e94-2c3c-4f1a-8e2e-3ef69b3a88ad.png)



## Requirements of the Project:

- First we need to have some sample application with source code etc. 
EG: "To-Do-List App" at Github URL = https://github.com/dhiv20/Jenkins-argocd-project-1.git

- We need to have Jenkins, Argo cd, docker, k8s cluster installed in the master server. (nproc if required)

- We need 2 repositories on Github. 
	- One is for to-do-app files, Jenkinsfile, dockerfile ==> https://github.com/dhiv20/Jenkins-argocd-project-1.git
	- Another is for files like deployment.yaml , service.yaml ==> https://github.com/dhiv20/Jenkins-argocd-project-1-deployments.git

- Other necessary things like:
	- jenkins plugins like docker-pipeline, docker
	- setup github/docker credentials on jenkins
	- setup webhook trigger
	- create pipeline job on jenkins
	- creating application on Argo cd which refers the repository of deployment files 



## Working of the Project: 

- Firstly we will clone the Django-todo App into our workspace.
- Then we will test & verify the functioning of the application on our local workspace.
- Make sure Jenkins, Argo cd, docker, k8s cluster are active in the master server. (nproc if required)
- Then create Jenkins Credentials for docker and github. The credential id from these credentials will be used in the pipeline scripts.
- We will now create the Jenkinsfile, Dockerfile , deployment.yaml , service.yaml.
- With jenknsfile we have facilitated multiple stages with following functions:

	CI Part:
	- When we make changes to the html file in template folder of the "to-do app" and commit those changes. Then with github webhook trigger, 		jenkinsfile will get triggered, thus executing various stages of the pipeline. Stage one will checkout to the GitHub repository. Stage two 		will build the dockerfile, thus creating an image having application files and its dependencies. Then this new image is pushed to the dockerhub. 

	- In next stage we will check out to the second repository which will store the deployment manifests (deployment.yaml & service.yaml). The 		next stage will use scripts to automatically update the deployment manifests (image name & tags), whenever a new image is build and pushed to the 	dockerhub.

	CD Part:
	- We will create an argo cd app at argo cd portal. Argo cd app will check for any changes made to the deployment file in the second github repo 	of deployment manifests, and argo cd will deploy k8s cluster with the to-do app from the new image versions that we get from continuous integration.
	- Open the address on browser we get using command: minikube service <service-name> --url
	- We can see the to-do app running.
