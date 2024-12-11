This repo contains Terraform code to provision a EKS cluster with Karpenter into a pre-existing VPC. Please note that it's currently totally untested.

The things that need to be customized, are in `vars.tf`. It's pretty straigtforward, you need to specify:
* AWS region
* VPC ID (changing this is required; provided default obviosly won't work)
* cluster's name
* fine-tune the node pools

Also this code purposely does omit the means of storing the Terraform state in an S3 bucket, that's the next step after actually testing and fixing it, but before deploying resources that would be used.

While scheduling a pod/deployment please keep in mind that two node pools exist in cluster: with amd64 cpus and with arm64 cpus (Gravitron). My sincere recommendation is to specify in every runnable resource the architecture explicitly, as doing otherwise might lead to some things broken in a funny way. To do this, a proper [nodeSelector](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/) value should be provided to any container.

TLDR: use `nodeSelector: {kubernetes.io/arch: arm64}` for Gravitron containers and `nodeSelector: {kubernetes.io/arch: amd64}` for Intel/AMD containers.
