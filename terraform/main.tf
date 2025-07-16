terraform {
  required_version = ">= 1.0.0"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

module "k3s_cluster" {
  source = "./modules/k3s"

  node_count = 3
  vm_config = {
    cpu    = 4
    memory = 8192
    disk   = 100
  }
  network_config = {
    subnet = "192.168.1.0/24"
    domain = "local"
  }
}

module "metallb" {
  source = "./modules/metallb"
  
  ip_pool_range = "192.168.1.200-192.168.1.250"
  depends_on    = [module.k3s_cluster]
}

module "argocd" {
  source = "./modules/argocd"
  
  domain           = "argocd.local"
  admin_password   = var.argocd_password
  depends_on       = [module.metallb]
}

module "monitoring" {
  source = "./modules/monitoring"
  
  storage_class    = "local-path"
  grafana_password = var.grafana_password
  depends_on       = [module.metallb]
}
