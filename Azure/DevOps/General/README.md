# General ADO Overview
In this file you will find a general overview of scripts, additions and designs which are related to devops but cannot simply be scoped at a certain subresource type

## Examples include:
- a **pumlConverter** which converts .puml(plantUML) charts into PNG's within the same repo. (This is prepared for AzureDevOps, but can be converted to work with other tooling)
- an **updateDevOpsAgents** pipeline file which allows for **Periodic** updates on all private agents across your specified project. With a bit of tweaking it can run on an ORG level too.