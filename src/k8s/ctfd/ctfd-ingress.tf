resource "kubernetes_ingress_v1" "ctfd_ingress" {
  metadata {
    name      = "traefik-ingress"
    namespace = "ctfd"

    annotations = {
      "kubernetes.io/ingress.class"                      = "traefik"
      "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
      # "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
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
      # host = "ctf.vikesec.ca"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
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
