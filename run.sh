
#!/bin/bash

set -e

IMAGE_NAME="python-api"
IMAGE_TAG="1.0.1"
CLUSTER_NAME="gitops-cluster"
NAMESPACE="python-api"

echo "=== Starting Kubernetes deployment ==="

echo "=== Starting k3d cluster ==="
k3d cluster start "$CLUSTER_NAME"

echo "=== Building Docker image ==="
docker build --no-cache -t "$IMAGE_NAME:$IMAGE_TAG" .

echo "=== Testing Docker image ==="
docker run --rm "$IMAGE_NAME:$IMAGE_TAG" python -c "import main; print('Application import OK')"

echo "=== Importing image into k3d ==="
k3d image import "$IMAGE_NAME:$IMAGE_TAG" -c "$CLUSTER_NAME"

echo "=== Applying namespace ==="
kubectl apply -f k8s/namespace.yaml

echo "=== Applying deployment ==="
kubectl apply -f k8s/deployment.yaml

echo "=== Applying service ==="
kubectl apply -f k8s/service.yaml

echo "=== Applying ingress ==="
kubectl apply -f k8s/ingress.yaml

echo "=== Updating deployment image ==="
kubectl set image deployment/"$IMAGE_NAME" \
  "$IMAGE_NAME=$IMAGE_NAME:$IMAGE_TAG" \
  -n "$NAMESPACE"

echo "=== Waiting for deployment ==="
kubectl rollout status deployment/"$IMAGE_NAME" -n "$NAMESPACE" --timeout=120s

echo "=== Deployment status ==="
kubectl get deployment -n "$NAMESPACE"

echo "=== Pods ==="
kubectl get pods -n "$NAMESPACE" -o wide

echo "=== Service ==="
kubectl get svc -n "$NAMESPACE"

echo "=== Ingress ==="
kubectl get ingress -n "$NAMESPACE"

echo "=== Deployment completed ==="
echo "API: http://python-api.localhost"
echo "Swagger: http://python-api.localhost/docs"