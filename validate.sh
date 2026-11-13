#!/usr/bin/env bash

PASS=0
FAIL=0

check() {
  local desc="$1"
  shift
  if bash -c "$*" > /dev/null 2>&1; then
    echo "[PASS] $desc"
    PASS=$((PASS+1))
  else
    echo "[FAIL] $desc"
    FAIL=$((FAIL+1))
  fi
}

echo "== Task 1: cluster and CNI"
check "3 nodes Ready" '[ "$(kubectl get nodes --no-headers | awk "\$2==\"Ready\"" | wc -l)" -eq 3 ]'
check "calico-node DaemonSet ready" 'kubectl -n kube-system rollout status ds/calico-node --timeout=10s'

echo "== Task 2: RBAC"
check "alice can create deployments in shop" 'kubectl --context alice@cka auth can-i create deployments -n shop'
check "alice cannot read secrets in shop" '! kubectl --context alice@cka auth can-i get secrets -n shop'
check "alice cannot list pods in default" '! kubectl --context alice@cka auth can-i list pods -n default'
check "node-viewer SA can list nodes" 'kubectl auth can-i list nodes --as=system:serviceaccount:ops:node-viewer'

echo "== Task 3: workloads and scheduling"
check "backend Deployment available" 'kubectl -n shop rollout status deploy/backend --timeout=10s'
check "frontend Deployment available" 'kubectl -n shop rollout status deploy/frontend --timeout=10s'
check "frontend image is nginx:1.27.1-alpine" '[ "$(kubectl -n shop get deploy frontend -o jsonpath="{.spec.template.spec.containers[0].image}")" = "nginx:1.27.1-alpine" ]'
check "ResourceQuota and LimitRange exist" 'kubectl -n shop get resourcequota shop-quota && kubectl -n shop get limitrange shop-defaults'
check "nightly-report Job complete on cka-worker2" 'kubectl -n shop wait --for=condition=complete job/nightly-report --timeout=5s && [ "$(kubectl -n shop get pod -l job-name=nightly-report -o jsonpath="{.items[0].spec.nodeName}")" = cka-worker2 ]'
check "HPA frontend exists with metrics" 'kubectl -n shop get hpa frontend -o jsonpath="{.status.currentMetrics[0].resource.current.averageUtilization}" | grep -q "[0-9]"'
check "metrics-server Helm release deployed" 'helm status metrics-server -n kube-system | grep -q "STATUS: deployed"'

echo "== Task 4: services and ingress"
check "frontend Service has endpoints" '[ -n "$(kubectl -n shop get endpoints frontend -o jsonpath="{.subsets[0].addresses[0].ip}")" ]'
check "Ingress serves /api/ with HTTP 200" '[ "$(curl -s -o /dev/null -w "%{http_code}" -H "Host: shop.local" http://localhost:18080/api/)" = 200 ]'

echo "== Task 5: network policies"
check "four original NetworkPolicies exist" 'kubectl -n shop get netpol default-deny-ingress allow-ingress-to-frontend allow-frontend-to-backend frontend-egress'
check "tester pod is blocked from backend" 'kubectl -n shop get pod tester && ! kubectl -n shop exec tester -- curl -s -m 3 http://backend:5678'
check "frontend can reach backend" 'kubectl -n shop exec deploy/frontend -- wget -qO- -T 3 http://backend:5678'

echo "== Task 6: storage"
check "orders-pvc Bound to orders-pv" '[ "$(kubectl -n shop get pvc orders-pvc -o jsonpath="{.spec.volumeName}")" = orders-pv ]'
check "orders.log exists on cka-worker" 'docker exec cka-worker test -s /mnt/disks/orders/orders.log'
check "ledger StatefulSet 2/2 ready" '[ "$(kubectl -n shop get sts ledger -o jsonpath="{.status.readyReplicas}")" = 2 ]'

echo "== Task 7: maintenance and etcd"
check "frontend PDB exists" 'kubectl -n shop get pdb frontend-pdb'
check "no node is cordoned" '! kubectl get nodes --no-headers | grep -q SchedulingDisabled'
check "etcd snapshot copied to host" 'test -s ~/k8s-lab/backups/snap-1.db'
check "etcd runs from restored data dir" 'docker exec cka-control-plane grep -q "path: /var/lib/etcd-from-backup" /etc/kubernetes/manifests/etcd.yaml'
check "restore-marker present, after-backup absent" 'kubectl -n shop get cm restore-marker && ! kubectl -n shop get cm after-backup'

echo "== Task 8: troubleshooting"
check "kubelet active and enabled on cka-worker" 'docker exec cka-worker systemctl is-enabled kubelet && docker exec cka-worker systemctl is-active kubelet'
check "kube-scheduler Ready" '[ "$(kubectl -n kube-system get pod kube-scheduler-cka-control-plane -o jsonpath="{.status.containerStatuses[0].ready}")" = true ]'
check "backend Service selector fixed" '[ -n "$(kubectl -n shop get endpoints backend -o jsonpath="{.subsets[0].addresses[0].ip}")" ]'
check "invoice running on cka-worker2" 'kubectl -n shop rollout status deploy/invoice --timeout=10s && [ "$(kubectl -n shop get pod -l app=invoice -o jsonpath="{.items[0].spec.nodeName}")" = cka-worker2 ]'

echo
echo "Result: $PASS passed, $FAIL failed"
