#!/bin/bash
export VERSION=1.0.18
export FPM_IMAGE="mattsws/example-fpm:$VERSION"
export NGINX_IMAGE="mattsws/example-nginx:$VERSION"

SCRIPT_DIR=$(dirname "$0")

docker buildx build --platform linux/amd64 -t example-fpm:$VERSION -f docker/fpm/dockerfile --load .
docker tag example-fpm:$VERSION $FPM_IMAGE
docker push $FPM_IMAGE

docker buildx build --platform linux/amd64 -t example-nginx:$VERSION -f docker/nginx/dockerfile --load .
docker tag example-nginx:$VERSION $NGINX_IMAGE
docker push $NGINX_IMAGE

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/do/deploy.yaml
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml
kubectl apply -f ingress_nginx_svc.yaml
kubectl apply -f cert-issuer.yaml
kubectl apply -f config.yaml
kubectl apply -f secret.yaml

template=`cat "deployment.yaml" | sed "s|XXXNGINX_IMAGEXXX|$NGINX_IMAGE|g"`
template=`echo "$template" | sed "s|XXXFPM_IMAGEXXX|$FPM_IMAGE|g"`
echo "$template" | kubectl apply -f -

kubectl rollout restart deployment example-site