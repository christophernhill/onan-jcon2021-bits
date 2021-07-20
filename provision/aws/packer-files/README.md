# 
# Packer files to create a NVidia GPU + Spack OpenMPI + Julia image
#

environment variables used at head of packer.json must be set and environment variables e.g.

```
       "variables": {
	   "vpc": "{{env `BUILD_VPC_ID`}}",
	   "subnet": "{{env `BUILD_SUBNET_ID`}}",
	   "aws_region": "{{env `AWS_REGION`}}",
	   "ami_name": "my-rocm-singularity-test-ami-{{isotime}}",
	   "access_key": "{{env `AWS_ACCESS_KEY`}}",
	   "secret_key": "{{env `AWS_SECRET_KEY`}}",
	   "ssh_keypair": "{{env `SSH_KEYPAIR`}}",
	   "ssh_private_key_file": "{{env `SSH_PRIVATE_KEY_FILE`}}"
        },
```


Once set this script can be executed using command
```
packer build packer.json
```


This will create an AMI in the account of AWS_ACCESS_KEY that can then be use to create a VM instance with an
NVidia GPU, for example, a p3.2xlarge instance.
