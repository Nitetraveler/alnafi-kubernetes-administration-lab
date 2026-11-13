# Verification Record

Latest observed validation: **30 passed, 0 failed**.

| Area | Verification | Observed result |
|---|---|---|
| Cluster | Three kind nodes | All Ready |
| CNI | Calico DaemonSet | Ready |
| Alice RBAC | Create Deployment in shop | Allowed |
| Alice RBAC | Read shop Secrets | Denied |
| Alice RBAC | List pods in default | Denied |
| Node viewer | List nodes / delete nodes | Allowed / denied |
| Workloads | Backend / frontend | 2/2 / 3/3 |
| Quota | shop-quota and shop-defaults | Present |
| Scheduling | nightly-report | Completed on cka-worker2 |
| Metrics | metrics-server | Available |
| HPA | frontend | CPU metric observed; 3 replicas |
| Ingress | shop.local/api/ | HTTP 200 |
| NetworkPolicy | tester to backend | Blocked |
| NetworkPolicy | frontend to backend | Allowed |
| Storage | orders-pvc | Bound to orders-pv |
| Storage | ledger StatefulSet | 2 replicas ready |
| Maintenance | PDB and node state | PDB present; nodes schedulable |
| etcd | Restore verification | Restore marker present |
| Troubleshooting | kubelet, scheduler, Service, invoice | Repaired and verified |
| Challenge | catalog Deployment | 3/3 available |
| Challenge | catalog.local | HTTP 200 |

Run `./validate.sh` again before submission to verify the current live state.
Credentials, private keys, kubeconfigs, and raw etcd snapshots are retained
locally and excluded from Git.
