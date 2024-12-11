variable "region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_id" {
  type    = string
  default = "vpc-12345"
}

variable "cluster_name" {
  type    = string
  default = "demo-cluster"
}

variable "node_groups" {
  type = map(any)
  default = {
    intel = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["g3.large", "g4.xlarge"]
      capacity_type  = "SPOT"

      min_size     = 1
      desired_size = 1
      max_size     = 10
    }
    gravitron = {
      ami_type       = "AL2023_ARM_64_STANDARD"
      instance_types = ["g3.large", "g4.xlarge"]
      capacity_type  = "SPOT"

      min_size     = 1
      desired_size = 1
      max_size     = 10
    }
  }
}
