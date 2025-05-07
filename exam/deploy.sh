#!/bin/bash

# Exit on error
set -e

### 1. APPLY CONFIGMAP AND SECRET FOR POSTGRES ###
echo "\n[1/6] Creating ConfigMap and Secret for PostgreSQL..."
kubectl apply -f postgres-configmap.yaml
kubectl apply -f postgres-secret.yaml

### 2. DEPLOY POSTGRESQL STATEFULSET ###
echo "\n[2/6] Deploying PostgreSQL StatefulSet and Service..."
kubectl apply -f postgres-statefulset.yaml
kubectl apply -f postgres-service.yaml

### 3. DEPLOY FASTAPI APP (3 replicas) ###
echo "\n[3/6] Deploying FastAPI Deployment and Service..."
kubectl apply -f fastapi-deployment.yaml
kubectl apply -f fastapi-service.yaml

### 4. DEPLOY INGRESS CONTROLLER (if needed) ###
echo "\n[4/6] Creating Ingress for FastAPI..."
kubectl apply -f fastapi-ingress.yaml

### 5. DISPLAY RESOURCES ###
echo "\n[5/6] Deployed Resources in 'default' namespace:"
kubectl get all

### 6. SUGGEST DNS STEP ###
echo "\n[6/6] Reminder:"
echo "Make sure your domain (ClouDNS) points to your Ingress Controller IP."
echo "Check Ingress IP with: kubectl get ingress"
echo "Done."
