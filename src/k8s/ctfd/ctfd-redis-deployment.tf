resource "kubernetes_persistent_volume_claim" "ctfd_redis_cache_pv" {
  metadata {
    name      = "ctfd-redis-cache-pv"
    namespace = "ctfd"

    labels = {
      app = "ctfd-redis-cache-pv"

      ctfd = "redis-pv"
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

resource "kubernetes_deployment" "ctfd_redis_cache" {
  metadata {
    name      = "ctfd-redis-cache"
    namespace = "ctfd"

    labels = {
      app = "ctfd-redis-cache"

      ctfd = "redis"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ctfd-redis-cache"
      }
    }

    template {
      metadata {
        labels = {
          app = "ctfd-redis-cache"

          ctfd = "redis"
        }
      }

      spec {
        volume {
          name = "ctfd-redis-cache-pv"

          persistent_volume_claim {
            claim_name = "ctfd-redis-cache-pv"
          }
        }

        container {
          name  = "ctfd-redis-cache"
          image = "redis:4"

          volume_mount {
            name       = "ctfd-redis-cache-pv"
            mount_path = "/data"
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

resource "kubernetes_service" "ctfd_redis_cache" {
  metadata {
    name      = "ctfd-redis-cache"
    namespace = "ctfd"

    labels = {
      app = "ctfd-redis-cache"
    }
  }

  spec {
    port {
      name        = "redis"
      protocol    = "TCP"
      port        = 6379
      target_port = "6379"
    }

    selector = {
      app = "ctfd-redis-cache"
    }

    type = "ClusterIP"
  }
}

