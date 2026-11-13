#!/usr/bin/env bash
set -euo pipefail
docker exec cka-worker systemctl disable --now kubelet > /dev/null 2>&1
docker exec cka-control-plane sed -i 's/^\(\s*\)- kube-scheduler$/\1- kube-schedulerx/' /etc/kubernetes/manifests/kube-scheduler.yaml
kubectl -n shop patch service backend -p '{"spec":{"selector":{"app":"backend-v2"}}}' > /dev/null
kubectl apply -f - > /dev/null <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: invoice
  namespace: shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: invoice
  template:
    metadata:
      labels:
        app: invoice
    spec:
      nodeSelector:
        disktype: ssd
      containers:
      - name: invoice
        image: nginx:1.27-alpine
YAML
echo "maintenance complete"
