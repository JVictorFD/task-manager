resource "null_resource" "bootstrap_cluster" {
  triggers = {
    cluster_name = var.cluster_name
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      if ! k3d cluster list 2>/dev/null | grep -q "${var.cluster_name}"; then
        k3d cluster create ${var.cluster_name} \
          --agents 1 \
          --servers 1 \
          --port "30080:80@loadbalancer" \
          --kubeconfig-switch-context \
          --wait
      fi
      mkdir -p ~/.kube
      k3d kubeconfig write ${var.cluster_name} --output ~/.kube/config >/dev/null 2>&1 || true
      kubectl config use-context k3d-${var.cluster_name} >/dev/null 2>&1 || true
      kubectl cluster-info >/dev/null
    EOT

    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "k3d cluster delete ${self.triggers.cluster_name} >/dev/null 2>&1 || true"
  }
}
