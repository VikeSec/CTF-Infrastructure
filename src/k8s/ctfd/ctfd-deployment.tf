resource "kubernetes_namespace" "ctfd" {
  metadata {
    name = "ctfd"
  }
}

resource "kubernetes_persistent_volume_claim" "ctf_pv_logs" {
  metadata {
    name      = "ctf-pv-logs"
    namespace = "ctfd"

    labels = {
      app = "ctf-pv-logs"

      ctfd = "ctf-pv"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "100Mi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "ctfd_pv_uploads" {
  metadata {
    name      = "ctfd-pv-uploads"
    namespace = "ctfd"

    labels = {
      app = "ctfd-pv-uploads"

      ctfd = "ctf-pv"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "500Mi"
      }
    }
  }
}

resource "kubernetes_deployment" "ctfd" {
  metadata {
    name      = "ctfd"
    namespace = "ctfd"

    labels = {
      app = "ctfd"

      ctfd = "ctfd"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ctfd"
      }
    }

    template {
      metadata {
        labels = {
          app = "ctfd"

          ctfd = "ctfd"
        }
      }

      spec {
        volume {
          name = "ctf-pv-logs"

          persistent_volume_claim {
            claim_name = "ctf-pv-logs"
          }
        }

        volume {
          name = "ctfd-pv-uploads"

          persistent_volume_claim {
            claim_name = "ctfd-pv-uploads"
          }
        }

        container {
          name  = "ctfd"
          image = "ctfd/ctfd"

          env {
            name  = "ACCESS_LOG"
            value = "-"
          }

          env {
            name  = "DATABASE_URL"
            value = "mysql+pymysql://ctfd:ctfd@ctfd-mysql-db/ctfd"
          }

          env {
            name  = "ERROR_LOG"
            value = "-"
          }

          env {
            name  = "LOG_FOLDER"
            value = "/var/log/CTFd"
          }

          env {
            name  = "REDIS_URL"
            value = "redis://ctfd-redis-cache:6379"
          }

          env {
            name  = "REVERSE_PROXY"
            value = "true"
          }

          env {
            name  = "UPLOAD_FOLDER"
            value = "/var/uploads"
          }

          env {
            name  = "WORKERS"
            value = "1"
          }

          volume_mount {
            name       = "ctf-pv-logs"
            mount_path = "/var/log/CTFd"
          }

          volume_mount {
            name       = "ctfd-pv-uploads"
            mount_path = "/var/uploads"
          }
        }

        restart_policy = "Always"
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_service" "ctfd" {
  metadata {
    name      = "ctfd"
    namespace = "ctfd"

    labels = {
      app = "ctfd"
    }
  }

  spec {
    port {
      name        = "ctfd"
      protocol    = "TCP"
      port        = 8000
      target_port = 8000
    }

    selector = {
      app = "ctfd"
    }

    type = "ClusterIP"
  }
}

