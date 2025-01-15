# Zabbix Proxy Overview #
This project/template is used for deploying a Zabbix Proxy in your respective environment.
This could either be via pipeline or via the portal (e.g. going to cloudformation and manually uploading the template)
The code will just evolve around usecase amazonRDS. If preferred defaults for Aurora and local hosting (e.g. ECS; same cluster or EKS) can be added

## Zabbix Proxy using Amazon MySQL RDS (code in repo) ##
### Benefits ###
Allows for finetuning what you need/matches with what you like.
- If you have a predictable load and will not require all the autoscaling capabilities I would urge you to consider RDS. With its versatile usecase it makes up for a balance between flexibility and cost.
### Limitations ###
If there are limitations they will be specified here.
- Is somewhat difficult in terms of autoscaling, but still allows some flexibility here. Use this in case you have a steady load.

## Zabbix Proxy using Amazon MySQL container with EFS mount (code not present) ##
### Benefits ###
- If you rather host it in either your own cluster (to cut down costs) or already have an eks/ecs fargate cluster running you could consider hosting this yourself in a cluster.
### Limitations ###
- If you have custom dns setup through route 53 (e.g. to forward queries to onprem dns servers) the EFS mount for ECS Fargate will NOT work. There is no way to work around this at the time of writing

## Zabbix Proxy using Amazon Aurora serverless v2 (code not present) ##
### Benefits ###
- Using Amazon Aurora serverless will allow for scaling based on performance requirements set between "hard" limits. Usecase flexibility/autoschaling.
### Limitations ###
- Due to the nature and pricing model of Aurora serverless it is often cheaper to go with RDS or a containarized SQL solution if the load is predictable.
