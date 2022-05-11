resource "kubernetes_persistent_volume_claim" "ctfd_mysql_db_pv" {
  metadata {
    name      = "ctfd-mysql-db-pv"
    namespace = "ctfd"

    labels = {
      app = "ctfd-mysql-db-pv"

      ctfd = "mysql-pv"
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

resource "kubernetes_deployment" "ctfd_mysql_db" {
  metadata {
    name      = "ctfd-mysql-db"
    namespace = "ctfd"

    labels = {
      app = "ctfd-mysql-db"

      ctfd = "mysql"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ctfd-mysql-db"
      }
    }

    template {
      metadata {
        labels = {
          app = "ctfd-mysql-db"

          ctfd = "mysql"
        }
      }

      spec {
        volume {
          name = "ctfd-mysql-db-pv"

          persistent_volume_claim {
            claim_name = "ctfd-mysql-db-pv"
          }
        }

        container {
          name  = "ctfd-mysql-db"
          image = "mariadb:10.4.12"
          args  = ["mysqld", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci", "--wait_timeout=28800", "--log-warnings=0"]

          env {
            name  = "MYSQL_DATABASE"
            value = "ctfd"
          }

          env {
            name  = "MYSQL_PASSWORD"
            value = "ctfd"
          }

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "ctfd"
          }

          env {
            name  = "MYSQL_USER"
            value = "ctfd"
          }

          volume_mount {
            name       = "ctfd-mysql-db-pv"
            mount_path = "/var/lib/mysql"
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

resource "kubernetes_service" "ctfd_mysql_db" {
  metadata {
    name      = "ctfd-mysql-db"
    namespace = "ctfd"

    labels = {
      app = "ctfd-mysql-db"
    }
  }

  spec {
    port {
      name        = "mysql"
      protocol    = "TCP"
      port        = 3306
      target_port = "3306"
    }

    selector = {
      app = "ctfd-mysql-db"
    }

    type = "ClusterIP"
  }
}

