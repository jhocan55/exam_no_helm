#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

### 1. APPLY CONFIGMAP AND SECRET FOR POSTGRES ###
echo -e "\n[1/8] Creating ConfigMap and Secret for PostgreSQL..."
kubectl apply -f postgres-configmap.yaml -n standard
kubectl apply -f postgres-secret.yaml -n standard

### 2. APPLY SECRET FOR FASTAPI ###
echo -e "\n[2/8] Creating Secret for FastAPI..."
kubectl delete secret fastapi-secret -n standard --ignore-not-found
kubectl create -f fastapi-secret.yaml --save-config -n standard

### 3. DEPLOY POSTGRESQL STATEFULSET AND SERVICE ###
echo -e "\n[3/8] Deploying PostgreSQL StatefulSet and Service..."
kubectl apply -f postgres-statefulset.yaml -n standard
kubectl apply -f postgres-service.yaml -n standard

### 4. DEPLOY FASTAPI APP (3 replicas) AND SERVICE ###
echo -e "\n[4/8] Deploying FastAPI Deployment and Service..."
kubectl apply -f fastapi-deployment.yaml -n standard
kubectl apply -f fastapi-service.yaml -n standard

### 5. SETUP HORIZONTAL POD AUTOSCALER FOR FASTAPI ###
echo -e "\n[5/8] Creating Horizontal Pod Autoscaler for FastAPI..."
kubectl apply -f fastapi-hpa.yaml -n standard

### 6. DEPLOY INGRESS RESOURCE FOR FASTAPI ###
echo -e "\n[6/8] Creating Ingress for FastAPI with TLS (Cert-Manager & Let's Encrypt)..."
kubectl apply -f fastapi-ingress.yaml -n standard

### 7. VERIFY DEPLOYED RESOURCES ###
echo -e "\n[7/8] Deployed resources in 'standard' namespace:"
kubectl get all -n standard
kubectl get ingress -n standard
kubectl get hpa -n standard

### 8. DNS CONFIGURATION REMINDER ###
echo -e "\n[8/8] DNS Configuration Reminder:"
echo "Ensure your domain (on CloudNS) points to the IP address of your Ingress Controller."
echo "Check your Ingress external IP with:"
echo "kubectl get ingress fastapi-ingress -n standard"
echo "\nAll done. Your FastAPI application is ready and secured with HTTPS!"