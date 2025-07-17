terraform {
  backend "http" {
    address = "http://minio.infrastructure.svc.cluster.local:9000/terraform-state/terraform.tfstate"
    lock_address = "http://minio.infrastructure.svc.cluster.local:9000/terraform-state/terraform.tfstate.lock"
    unlock_address = "http://minio.infrastructure.svc.cluster.local:9000/terraform-state/terraform.tfstate.lock"
    username = "${storage_minio_access_key}"
    password = "${storage_minio_secret_key}"
  }
}

# State backup configuration
resource "null_resource" "state_backup" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      mc alias set minio http://minio.infrastructure.svc.cluster.local:9000 ${storage_minio_access_key} ${storage_minio_secret_key}
      mc cp terraform.tfstate minio/terraform-state/backups/terraform-$(date +%Y%m%d-%H%M%S).tfstate
    EOT
  }
}
