resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app_namespace
  }
}

resource "kubernetes_deployment" "postgres" {
  depends_on = [kubernetes_namespace.app]

  metadata {
    name      = "task-manager-db"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "task-manager-db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "task-manager-db"
      }
    }

    template {
      metadata {
        labels = {
          app = "task-manager-db"
        }
      }

      spec {
        container {
          image = "postgres:15-alpine"
          name  = "postgres"

          env {
            name  = "POSTGRES_DB"
            value = "task_manager"
          }

          env {
            name  = "POSTGRES_USER"
            value = "admin"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = var.db_password
          }

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "postgres-storage"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  depends_on = [kubernetes_deployment.postgres]

  metadata {
    name      = "task-manager-db"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = {
      app = "task-manager-db"
    }

    port {
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "task_manager" {
  depends_on = [
    kubernetes_namespace.app,
    kubernetes_deployment.postgres,
    null_resource.task_manager_image
  ]

  metadata {
    name      = "task-manager"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "task-manager"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "task-manager"
      }
    }

    template {
      metadata {
        labels = {
          app = "task-manager"
        }
      }

      spec {
        container {
          image = var.app_image
          name  = "task-manager"

          image_pull_policy = "IfNotPresent"

          env {
            name  = "DATABASE_HOST"
            value = "task-manager-db"
          }

          env {
            name  = "DATABASE_PORT"
            value = "5432"
          }

          env {
            name  = "DATABASE_NAME"
            value = "task_manager"
          }

          env {
            name  = "DATABASE_USER"
            value = "admin"
          }

          env {
            name  = "DATABASE_PASSWORD"
            value = var.db_password
          }

          port {
            container_port = 3000
          }

          liveness_probe {
            http_get {
              path = "/api/health"
              port = 3000
            }
            initial_delay_seconds = 15
            period_seconds        = 15
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/api/health"
              port = 3000
            }
            initial_delay_seconds = 20
            period_seconds        = 10
            timeout_seconds       = 5
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "task_manager" {
  depends_on = [kubernetes_deployment.task_manager]

  metadata {
    name      = "task-manager"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = {
      app = "task-manager"
    }

    port {
      port        = 3000
      target_port = 3000
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}
