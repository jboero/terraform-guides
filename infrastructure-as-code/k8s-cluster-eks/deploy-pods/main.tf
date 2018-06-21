provider "kubernetes" {
    host = "${data.terraform_remote_state.k8s_cluster.endpoint}"
    cluster_ca_certificate = "${base64decode(data.terraform_remote_state.k8s_cluster.ca-cert)}"
}

data "terraform_remote_state" "k8s_cluster" {
    backend = "atlas"
    config {
        name = "JohnBoero/hashihang-pods"
    }
}

resource "kubernetes_config_map" "aws_auth_worker_node_join" {
  metadata {
    name      = "${var.config_map_name}"
    namespace = "kube-system"
  }

  data {
    mapRoles  = <<EOF
- rolearn: ${var.iam-role-arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
EOF
  }
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "${var.namespace_name}"

    labels {
      name = "example-label"
    }

    annotations {
      name = "example-annotation"
    }
  }
}

resource "kubernetes_pod" "nginx" {
  metadata {
    name      = "${var.nginx_pod_name}"
    namespace = "${var.namespace_name}"

    labels {
      app = "nginx"
    }
  }

  spec {
    container {
      name  = "${var.nginx_pod_name}"
      image = "${var.nginx_pod_image}"
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "${var.nginx_pod_name}"
    namespace = "${var.namespace_name}"
  }

  spec {
    selector {
      app = "${kubernetes_pod.nginx.metadata.0.labels.app}"
    }

    port {
      port = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
