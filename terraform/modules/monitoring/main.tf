resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    file("${path.module}/prometheus-values.yaml")
  ]

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_password
  }
}

resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = "monitoring"

  values = [
    file("${path.module}/loki-values.yaml")
  ]
}

resource "kubernetes_storage_class" "local_path" {
  metadata {
    name = var.storage_class
  }
  storage_provisioner = "rancher.io/local-path"
  reclaim_policy     = "Retain"
}
