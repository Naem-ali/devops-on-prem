resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  namespace  = "metallb-system"
  create_namespace = true

  values = [
    templatefile("${path.module}/values.yaml", {
      ip_pool_range = var.ip_pool_range
    })
  ]
}

resource "kubernetes_manifest" "metallb_pool" {
  depends_on = [helm_release.metallb]

  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind       = "IPAddressPool"
    metadata = {
      name      = "default-pool"
      namespace = "metallb-system"
    }
    spec = {
      addresses = [var.ip_pool_range]
    }
  }
}
