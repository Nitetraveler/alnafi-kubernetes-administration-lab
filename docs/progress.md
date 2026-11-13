# Lab Progress

## Environment
Three-node kind cluster: cka-control-plane, cka-worker, cka-worker2.
Kubernetes v1.30.4, Calico v3.28.2, Helm v3.15.4.

## Completed tasks

1. **Cluster and CNI:** Three nodes Ready; Calico DaemonSet verified.
2. **Authentication and RBAC:** Alice certificate and kubeconfig configured;
   shop-devs permissions tested; node-viewer service account and node-reader
   ClusterRole tested.
3. **Workloads and scheduling:** Backend and frontend Deployments available;
   ResourceQuota and LimitRange restored; nightly-report completed on
   cka-worker2; metrics-server and frontend HPA verified.
4. **Services and Ingress:** Service discovery verified; shop.local `/api/`
   returns HTTP 200.
5. **NetworkPolicies:** Default-deny and required allow policies applied;
   tester-to-backend blocked; frontend-to-backend allowed.
6. **Persistent storage:** orders-pvc bound to orders-pv; order log persisted
   through pod recreation; two-replica ledger StatefulSet uses persistent
   claims.
7. **Maintenance and etcd:** Frontend PDB created; worker drained and
   uncordoned; etcd snapshot and restore completed; restored cluster state
   verified.
8. **Troubleshooting:** Worker kubelet, scheduler, backend Service selector,
   and invoice workload faults repaired.

## Challenge extension
Restricted CI service account and RBAC configured; Kustomize production
overlay applied; catalog Deployment reached 3/3 available; catalog.local
Ingress returned HTTP 200.

## Final validation
Latest live validation: 30 checks passed, 0 failed.
Challenge-specific checks are not yet included in the validation count.
