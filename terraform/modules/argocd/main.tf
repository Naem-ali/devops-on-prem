resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  values = [
    templatefile("${path.module}/values.yaml", {
      domain         = var.domain
      admin_password = var.admin_password
    })
  ]
}

resource "kubernetes_manifest" "argocd_ingress" {
  depends_on = [helm_release.argocd]

  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "argocd"
      namespace = "argocd"
    }
    spec = {
      entryPoints = ["websecure"]
      routes = [{
        match = "Host(`${var.domain}`)"
        kind  = "Rule"
        services = [{
          name = "argocd-server"
          port = 80
        }]
      }]
    }
  }
}
