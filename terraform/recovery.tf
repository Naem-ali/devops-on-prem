# Recovery configuration for infrastructure

# Recovery state lock
resource "kubernetes_secret" "recovery_lock" {
  metadata {
    name      = "tf-recovery-lock"
    namespace = "kube-system"
  }

  data = {
    timestamp = timestamp()
    operator  = var.operator
  }
}

# Recovery notification
resource "null_resource" "recovery_notification" {
  triggers = {
    recovery_started = kubernetes_secret.recovery_lock.metadata[0].creation_timestamp
  }

  provisioner "local-exec" {
    command = <<-EOT
      curl -X POST ${var.slack_webhook_url} \
        -H 'Content-Type: application/json' \
        -d '{"text":"Infrastructure recovery started by ${var.operator}"}'
    EOT
  }
}

# Recovery validation
resource "null_resource" "validate_recovery" {
  depends_on = [
    module.k3s_cluster,
    module.vault,
    module.monitoring,
    module.registry,
    module.argocd
  ]

  provisioner "local-exec" {
    command = <<-EOT
      ./scripts/validate-infrastructure.sh
      ./scripts/verify-core-services.sh
      ./scripts/check-applications.sh
    EOT
  }
}
