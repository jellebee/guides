# EC2 Jumphost overview #

## Option ##
- EC2 ASG instance which allows to be used as a jumphost.

## Recommended ##
-  Use of a default AWS image for creating a jumphost, it saves a lot of headaches using the image builder to build your own images based on (in this example) Rocky 8
- Also if no custom information or authorization is required it is always recommended to use a Containers EKS/ECS over an EC2 ASG over a static EC2 instance

### Software/package dependencies ###
Most of the requirements are clearly described in-code.
Including:
For the use of PIP on the Rocky linux instance we will need python to be installed prior to PIP.
For the installation of CodeDeploy we need to install ruby first
For the use of the ssm agent we need to use pip to install the AWSCLI first 