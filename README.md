# Configuration
- [x] Celery with chord for running parallel task.
    - [x] Redis result backend to avoid infinite loop when there is error in chord tasks
    - [x] Rabbitmq broker 
- [x] Django to create workflow for celery and saving result.
- [x] Docker compose to setup servers
- [ ] Kubernetes on GCP for scale
    - [ ] Kubernetes locally with [minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/)

# Monitoring
Run flower
```shell script
poetry shell
# flower --A mysite --broker=redis://localhost:6379/0
# rabbitmq admin
flower --A mysite --broker-api=http://guest:guest@localhost:15672/api/
```

Rabbitmq management. u/p: guest/guest
```
http://localhost:15672/#/
```

Minikube
```shell script
# will open a web browser
minikube dashboard
```
