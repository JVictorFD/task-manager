variable "cluster_name" {
  description = "Nome do cluster k3d"
  type        = string
  default     = "task-manager-cluster"
}

variable "app_namespace" {
  description = "Namespace da aplicação"
  type        = string
  default     = "task-manager"
}

variable "monitoring_namespace" {
  description = "Namespace da stack de monitoramento"
  type        = string
  default     = "monitoring"
}

variable "app_image" {
  description = "Imagem Docker do task-manager usada no deployment"
  type        = string
  default     = "task-manager:latest"
}

variable "db_password" {
  description = "Senha do PostgreSQL"
  type        = string
  default     = "admin"
}
