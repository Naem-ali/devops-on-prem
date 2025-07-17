terraform {
  required_version = ">= 1.0.0"
  backend "http" {
    address = "http://minio.infrastructure.svc.cluster.local:9000/terraform-state/terraform.tfstate"
  }
}

module "cluster" {
  source = "./modules/cluster"
  
  cluster_name = var.cluster_name
  node_count = var.cluster_node_count
  node_size = var.cluster_node_size
}

module "networking" {
  source = "./modules/networking"
  
  vpc_cidr = var.network_cidr
  subnets = var.network_subnets
  domain = var.network_domain
}

module "applications" {
  source = "./modules/applications"
  
  monitoring_enabled = var.app_monitoring_enabled
  monitoring_storage = var.app_monitoring_storage_size
  monitoring_retention = var.app_monitoring_retention_days
  
  argocd_enabled = var.app_argocd_enabled
  argocd_domain = var.app_argocd_domain
  
  security_enabled = var.app_security_enabled
  security_policies = var.app_security_policies
}

module "storage" {
  source = "./modules/storage"
  
  minio_enabled = var.storage_minio_enabled
  minio_size = var.storage_minio_size
  minio_replicas = var.storage_minio_replicas
}
