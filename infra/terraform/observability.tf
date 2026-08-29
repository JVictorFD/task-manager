resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
  }
}

resource "helm_release" "monitoring" {
  name       = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "76.1.0"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = true

  depends_on = [
    null_resource.k3d_cluster,
    kubernetes_namespace.monitoring
  ]

  timeout = 600

  values = [<<-EOT
grafana:
  adminUser: admin
  adminPassword: prom-operator
  service:
    type: ClusterIP
  additionalDataSources:
    - name: Loki
      type: loki
      access: proxy
      url: http://loki:3100
      isDefault: false
prometheus:
  prometheusSpec:
    serviceMonitorSelectorNilUsesHelmValues: false
    serviceMonitorSelector: {}
    podMonitorSelectorNilUsesHelmValues: false
    podMonitorSelector: {}
EOT
  ]
}

resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = "2.10.2"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = true

  depends_on = [
    helm_release.monitoring
  ]

  timeout = 600

  values = [<<-EOT
loki:
  isDefault: false
  auth_enabled: false
  persistence:
    enabled: true
    size: 5Gi
promtail:
  enabled: true
EOT
  ]
}
