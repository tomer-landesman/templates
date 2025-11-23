module "my-cluster" {
  source = "github.com/env0/k8s-modules//aws?ref=v1.0.0"

  region       = var.region
  cluster_name = var.cluster_name
}