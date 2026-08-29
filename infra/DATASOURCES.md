# Datasources do Grafana

## 📊 Datasources Configurados

### 1. Prometheus
- **URL**: http://prometheus:9090
- **Status**: ✅ Ativo
- **Tipo**: Prometheus
- **Configuração**: Incluído no `kube-prometheus-stack` via Helm

### 2. Loki
- **URL**: http://loki:3100
- **Status**: ✅ Ativo
- **Tipo**: Loki
- **Configuração**: Instalado via `loki-stack` Helm chart

## 🔧 Instalação

Os datasources foram provisionados automaticamente via Terraform e Helm:

```hcl
# No helm_release.monitoring:
additionalDataSources:
  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    isDefault: false
```

## ✅ Verificação

Para confirmar os datasources no Grafana:
1. Login: admin / prom-operator
2. Menu ⚙️ → Connections → Data sources
3. Verificar: Prometheus (verde) e Loki (verde)

## 📅 Data de Confirmação

2026-08-29 - Stack de observabilidade validada
