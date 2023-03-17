# https://github.com/DownUnderCTF/kube-ctf/blob/develop/chart/templates/networkpolicy.yaml
resource "kubernetes_namespace" "challenges" {
  metadata {
    name = "challenges"

    labels = {
      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "latest"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/warn-version"    = "latest"
    }
  }
}
