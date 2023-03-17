resource "kubernetes_ingress_v1" "traefik_dashboard" {
  metadata {
    name      = "traefik-ingress"
    namespace = "ctfd"

    annotations = {
      "kubernetes.io/ingress.class" = "traefik"
    }
  }

  spec {
    default_backend {
      service {
        name = kubernetes_deployment.ctfd.metadata[0].name
        port {
          number = kubernetes_service.ctfd.spec[0].port[0].port
        }
      }
    }

    rule {
      http {
        path {
          path = "/"
          backend {
            service {
              name = kubernetes_service.ctfd.metadata[0].name
              port {
                number = kubernetes_service.ctfd.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }
}
