# Dashboard de Observabilidade — Grafana

## 📊 Descrição

Dashboard criado para visualizar métricas e logs da aplicação task-manager rodando no cluster k3d.

## 📈 Painéis Inclusos

1. **CPU do task-manager**: Gráfico de linha com uso de CPU em tempo real
   - Fonte: Prometheus
   - Métrica: `sum(rate(container_cpu_usage_seconds_total{pod=~"task-manager.*"}[5m])) by (pod)`

2. **Logs do task-manager**: Tabela de logs estruturados
   - Fonte: Loki
   - Query: `{pod="task-manager-58484bcbb9-b7xms"}`

## 🔄 Datasources Configurados

- **Prometheus**: http://prometheus:9090 (métricas)
- **Loki**: http://loki:3100 (logs)

## 📝 Configuração

O dashboard foi importado via API do Grafana:
```bash
curl -X POST http://localhost:3001/api/dashboards/db \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d @infra/grafana-dashboard-post.json
```

## 🎯 Status

✅ Dashboard pronto para monitoramento da stack de observabilidade

Data de criação: 2026-08-29
