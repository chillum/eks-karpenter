locals {
  region       = "eu-central-1"
  vpc_id       = "vpc-02b26ec9554a5fbb4"
  cluster_name = "demo-cluster"

  node_groups = {
    default = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["c5.large"]

      min_size     = 1
      desired_size = 2
      max_size     = 3
    }
  }

  ec2nodeclass = <<-YAML
    apiVersion: karpenter.k8s.aws/v1
    kind: EC2NodeClass
    metadata:
      name: default
    spec:
      role: ${module.karpenter.node_iam_role_name}
      amiFamily: AL2023
      amiSelectorTerms:
        - id: ami-004686234852ad556
        - id: ami-000c3a352e968dbb3
      subnetSelectorTerms:
      %{for i in data.aws_subnets.eks.ids}
        - id: ${i}
      %{endfor}
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${local.cluster_name}
      tags:
        karpenter.sh/discovery: ${local.cluster_name}
  YAML

  nodepool = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: default
    spec:
      template:
        spec:
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: default
          requirements:
            - key: kubernetes.io/arch
              operator: In
              values: ["amd64", "arm64"]
            - key: "karpenter.k8s.aws/instance-cpu"
              operator: In
              values: ["2", "4", "8"]
            - key: karpenter.sh/capacity-type
              operator: In
              values: ["spot"]
            - key: karpenter.k8s.aws/instance-category
              operator: In
              values: ["c", "m", "r"]
            - key: "karpenter.k8s.aws/instance-generation"
              operator: Gt
              values: ["5"]
  YAML
}
