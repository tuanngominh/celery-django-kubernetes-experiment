### Prepare for gcr server build
GOOGLE_CLOUD_PROJECT=tuanngo-me
SA_NAME=gcr-celery-k8s-experiment
TAG=v0.0.7
gcloud iam service-accounts create $SA_NAME \
    --description "Experiment Celery and K8s on gcp" \
    --display-name "$SA_NAME" \
    --project=$GOOGLE_CLOUD_PROJECT
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
  --member serviceAccount:$SA_NAME@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --role roles/viewer
gcloud iam service-accounts keys create ./$SA_NAME.json \
  --iam-account $SA_NAME@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
# ref: https://blog.container-solutions.com/using-google-container-registry-with-kubernetes
kubectl create secret docker-registry gcr-json-key \
  --docker-server=gcr.io \
  --docker-username=_json_key \
  --docker-password="$(cat ./$SA_NAME.json)" \
  --docker-email=tuannm79@gmail.com
kubectl patch serviceaccount default \
  -p '{"imagePullSecrets": [{"name": "gcr-json-key"}]}'

docker build . -t gcr.io/$GOOGLE_CLOUD_PROJECT/celery-kubernetes-experiment:$TAG
docker push gcr.io/$GOOGLE_CLOUD_PROJECT/celery-kubernetes-experiment:$TAG


### Setup k8s with deployments and services
kubectl create -f k8s/db-deployment.yaml
kubectl create -f k8s/db-service.yaml
kubectl create -f k8s/rabbitmq-deployment.yaml
kubectl create -f k8s/rabbitmq-service.yaml
kubectl create -f k8s/redis-deployment.yaml
kubectl create -f k8s/redis-service.yaml
kubectl create -f k8s/server-deployment.yaml
kubectl create -f k8s/server-service.yaml
kubectl create -f k8s/worker-deployment.yaml

### Setup app
kubectl get pods
kubectl exec -ti server-5dd945dbf5-dpkj4 bash
python ./manage.py migrate
python ./manage.py createsuperuser


### Try app in a web browser
minikube service server

##### Debug
kubectl expose deployment/server --type="NodePort" --port 15672
docker run -it -t gcr.io/$GOOGLE_CLOUD_PROJECT/celery-kubernetes-experiment:$TAG bash
docker run -it -t gcr.io/$GOOGLE_CLOUD_PROJECT/celery-kubernetes-experiment:$TAG python ./manage.py runserver 0.0.0.0:8000
kubectl delete deployment/server
kubectl create -f k8s/server-deployment.yaml
kubectl delete deployment/worker
kubectl create -f k8s/worker-deployment.yaml

kubectl expose deployment/server --type="NodePort" --port 8000
#kubectl expose deployment server --type="NodePort" --port 15672
#minikube service server

export NODE_PORT=$(kubectl get services/server -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT # Create an environment variable called NODE_PORT that has the value of the Node port assigned
curl $(minikube ip):$NODE_PORT

kubectl delete service/server
