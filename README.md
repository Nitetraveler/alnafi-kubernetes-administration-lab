# Alnafi Kubernetes Administration Lab

Hands-on Kubernetes administration lab using kind, Kubernetes v1.30.4,
Calico, Helm, and a three-node cluster.

## Environment
- Kubernetes: v1.30.4
- kind: v0.24.0
- Nodes: cka-control-plane, cka-worker, cka-worker2
- CNI: Calico v3.28.2
- Helm: v3.15.4
- Ingress HTTP endpoint: 127.0.0.1:18080

## Completed lab tasks
1. Cluster setup and CNI
2. Authentication, certificates, and RBAC
3. Workloads, scheduling, quotas, metrics-server, and HPA
4. Services, DNS, and Ingress
5. NetworkPolicies
6. Persistent storage and StatefulSets
7. Node maintenance and etcd backup/restore
8. Kubernetes troubleshooting

## Challenge extension
- Restricted CI service account and RBAC
- Kustomize base and production overlay
- PriorityClass and production replicas
- Catalog Deployment, Service, NetworkPolicy, and Ingress

## Repository layout
- `manifests/` — Kubernetes manifests
- `kustomize/` — Kustomize base and production overlay
- `docs/` — progress and verification records
- `validate.sh` — live cluster validation
- `break-cluster.sh` — intentional troubleshooting fault injection

## Validation
Run `./validate.sh` from the project directory.
The cluster must be running and required local tools available.

## Security
Credentials, private keys, client certificates, kubeconfigs, etcd snapshots,
and downloaded binaries are excluded from this repository.

`manifests/shop.example.yaml` uses a placeholder Secret value. Replace it
locally before applying it.

`break-cluster.sh` deliberately introduces faults. Use it only in this
disposable lab environment.
