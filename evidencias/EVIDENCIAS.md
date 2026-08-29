# Evidências de Observabilidade

## 📋 Checklist de Provas

### ✅ Etapa 11 — Port-forward do Grafana
**Comando:**
```bash
kubectl port-forward svc/monitoring-grafana 3001:80 -n monitoring
```

**Print esperado**: `11-port-forward-grafana-3001.png`
- Terminal mostrando: `Forwarding from 127.0.0.1:3001 -> 80`
- URL: http://localhost:3001

---

### ✅ Etapa 12 — Dashboard Importado no Grafana
**Print esperado**: `12-grafana-dashboard-final.png`
- Tela do Grafana mostrando:
  - Dashboard "Task Manager - Observability"
  - Painel 1: "CPU do task-manager" (timeseries)
  - Painel 2: "Logs do task-manager" (logs)
- Data/hora visível na tela

---

### ✅ Etapa 13 — Datasources Confirmados
**Print esperado**: `13-grafana-datasources.png`
- Tela em: ⚙️ → Connections → Data sources
- Mostrando:
  - ✅ Prometheus (status verde)
  - ✅ Loki (status verde)
- Ambos com acesso proxy ativo

---

### ✅ Etapa 14 — Métricas do Cluster
**Comando:**
```bash
kubectl get nodes && echo "---" && kubectl get pods -A --no-headers | wc -l && echo "recursos ativos"
```

**Print esperado**: `14-cluster-resources.png`
- Nós do cluster (Ready)
- Total de pods rodando
- Namespaces (default, kube-system, monitoring, task-manager)

---

### ✅ Etapa 15 — Terraform Destroy
**Comando:**
```bash
cd /workspaces/task-manager/infra/terraform && terraform destroy -auto-approve
```

**Print esperado**: `15-terraform-destroy-output.png`
- Output: `Destroy complete! Resources: X destroyed`
- Confirmação de limpeza da infraestrutura

---

## 📁 Estrutura de Evidências

```
evidencias/
├── 11-port-forward-grafana-3001.png
├── 12-grafana-dashboard-final.png
├── 13-grafana-datasources.png
├── 14-cluster-resources.png
└── 15-terraform-destroy-output.png
```

## 📅 Data de Execução

2026-08-29 - Stack de observabilidade completa e validada
