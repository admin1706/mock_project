provider "helm" {
  kubernetes {
    config_path = local_file.kube_config.filename
  }
}
resource "helm_release" "phpadmin" {
    depends_on = [ azurerm_kubernetes_cluster.aks]
  name       = "phpadmin"
  chart      = "charts-phppgadmin/"
  version    = "lastest"
  values = [
    "${file("./charts-phppgadmin/values.yaml")}"
  ]
  set {
    name  = "cluster.enabled"
    value = "true"
  }
  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "service.annotations.prometheus\\.io/port"
    value = "9127"
    type  = "string"
  }
}
/* resource "helm_release" "back-end" {
    depends_on = [ azurerm_kubernetes_cluster.aks]
  name       = "backend"
  chart      = "be-chart/"
  version    = "lastest"
  values = [
    "${file("/home/quan/assignment-3/terra-acr-aks-helm/be-chart/values.yaml")}"
  ]
  set {
    name  = "cluster.enabled"
    value = "true"
  }
  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "service.annotations.prometheus\\.io/port"
    value = "9127"
    type  = "string"
  }
}
resource "helm_release" "front-end" {
    depends_on = [ azurerm_kubernetes_cluster.aks]
  name       = "frontend"
  chart      = "fe-chart/"
  version    = "lastest"
  values = [
    "${file("/home/quan/assignment-3/terra-acr-aks-helm/fe-chart/values.yaml")}"
  ]
  set {
    name  = "cluster.enabled"
    value = "true"
  }
  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "service.annotations.prometheus\\.io/port"
    value = "9127"
    type  = "string"
  }
} */