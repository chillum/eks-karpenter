This repo contains Terraform code to provision a EKS cluster with Karpenter into a pre-existing VPC.

The things that need to be customized, are in `vars.tf`. It's pretty straigtforward, you need to specify:
* AWS region
* VPC ID
* cluster's name
* fine-tune the node pools and classes

Also this code purposely does omit the means of storing the Terraform state in an S3 bucket, this should be done before this code goes to production.

While scheduling a pod/deployment please keep in mind that two node pools exist in cluster: with amd64 cpus and with arm64 cpus (Gravitron). My sincere recommendation is to specify in every runnable resource the architecture explicitly, as doing otherwise might lead to some things broken in a funny way. To do this, a proper [nodeSelector](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/) value should be provided to any container. Also please specify a `karpenter.sh/nodepool=default` selector to assure the load gets to Karpenter pools. It might be more pretty and descriptive with two one-arch nodepools, but purposedly went with one for overall simplification here.

TLDR: use `nodeSelector: {karpenter.sh/nodepool=default, kubernetes.io/arch: arm64}` for Gravitron containers and `nodeSelector: {karpenter.sh/nodepool=default, kubernetes.io/arch: amd64}` for Intel/AMD containers.

The included `test.yaml` file is a k8s manifest that will launch both Intel/AMD and Gravitron deployments to test, Karpenter is working. If they both schedule and run -- everything's working.
