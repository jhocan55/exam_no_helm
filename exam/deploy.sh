#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Set the namespace
NAMESPACE="standard"
echo -e "\nSetting namespace to '$NAMESPACE'..."
kubectl config set-context --current --namespace=$NAMESPACE

### 1. APPLY CONFIGMAP AND SECRET FOR POSTGRES ###
echo -e "\n[1/8] Creating ConfigMap and Secret for PostgreSQL..."
kubectl apply -f postgres-configmap.yaml
kubectl apply -f postgres-secret.yaml

### 2. DEPLOY POSTGRESQL STATEFULSET AND SERVICE ###
echo -e "\n[2/8] Deploying PostgreSQL StatefulSet and Service..."
kubectl apply -f postgres-statefulset.yaml
kubectl apply -f postgres-service.yaml

### 3. DEPLOY FASTAPI APP (3 replicas) AND SERVICE ###
echo -e "\n[3/8] Deploying FastAPI Deployment and Service..."
kubectl apply -f fastapi-secret.yaml
kubectl apply -f fastapi-deployment.yaml
kubectl apply -f fastapi-service.yaml

### 4. OPTIONAL: DEPLOY FASTAPI NODEPORT SERVICE FOR NGROK ###
echo -e "\n[4/8] (Optional) Deploying FastAPI NodePort Service for Ngrok..."
kubectl apply -f fastapi-service-ngrok.yaml

### 5. SETUP HORIZONTAL POD AUTOSCALER FOR FASTAPI ###
echo -e "\n[5/8] Creating Horizontal Pod Autoscaler for FastAPI..."
kubectl apply -f fastapi-hpa.yaml

### 6. DEPLOY INGRESS RESOURCE FOR FASTAPI ###
echo -e "\n[6/8] Creating Ingress for FastAPI with TLS (Cert-Manager & Let's Encrypt)..."
kubectl apply -f fastapi-ingress.yaml

### 7. VERIFY DEPLOYED RESOURCES ###
echo -e "\n[7/8] Deployed resources in '$NAMESPACE' namespace:"
kubectl get all
kubectl get ingress
# kubectl get certificates
kubectl get hpa

### 8. DNS CONFIGURATION REMINDER ###
echo -e "\n[8/8] DNS Configuration Reminder:"
echo "Ensure your domain (on CloudNS) points to the IP address of your Ingress Controller."
echo "Check your Ingress external IP with:"
echo "kubectl get ingress fastapi-ingress"
echo "\nAll done. Your FastAPI application is ready and secured with HTTPS!"