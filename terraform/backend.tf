terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "infrastructure/terraform.tfstate"
    endpoint                    = "http://minio.infrastructure:9000"
    force_path_style           = true
    skip_credentials_validation = true
    skip_metadata_api_check    = true
    skip_region_validation     = true
    region                     = "main"
  }
}

# State backup configuration
resource "null_resource" "state_backup" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws s3 cp terraform.tfstate s3://terraform-state/backups/terraform-$(date +%Y%m%d-%H%M%S).tfstate \
        --endpoint-url http://minio.infrastructure:9000
    EOT
  }
}
