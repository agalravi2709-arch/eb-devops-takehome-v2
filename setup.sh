
#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="demo"
NAMESPACE="demo"
RELEASE_NAME="demo"
IMAGE_NAME="eb-demo:1.0.0"

echo "Checking required tools..."
for tool in docker kind kubectl helm; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "ERROR: $tool is not installed."
    exit 1
  fi
done

echo "Checking Docker..."
docker info >/dev/null

echo "Creating or reusing kind cluster..."
if ! kind get clusters | grep -qx "$CLUSTER_NAME"; then
  kind create cluster --name "$CLUSTER_NAME"
fi

kubectl config use-context "kind-${CLUSTER_NAME}"

echo "Installing ingress-nginx..."
if ! kubectl get namespace ingress-nginx >/dev/null 2>&1; then
  kubectl apply -f \
    https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.14.3/deploy/static/provider/kind/deploy.yaml
fi

echo "Waiting for ingress controller..."
kubectl rollout status deployment/ingress-nginx-controller \
  -n ingress-nginx --timeout=180s

echo "Building Docker image..."
docker build -t "$IMAGE_NAME" ./service

echo "Loading image into kind..."
kind load docker-image "$IMAGE_NAME" --name "$CLUSTER_NAME"

echo "Creating application namespace..."
kubectl create namespace "$NAMESPACE" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Installing Helm chart..."
helm upgrade --install "$RELEASE_NAME" ./chart \
  --namespace "$NAMESPACE" \
  --set image.repository=eb-demo \
  --set image.tag=1.0.0 \
  --wait --timeout 180s

echo "Deployment completed successfully!"
kubectl get pods -n "$NAMESPACE"
kubectl get svc,ingress -n "$NAMESPACE"
