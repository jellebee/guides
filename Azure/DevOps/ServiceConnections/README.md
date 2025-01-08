# Service Connections Overview

In this README, you will find a brief description/overview of the scripts in the ServiceConnections directory, including:

## Migrating service connections or Renaming service connections
- **Renaming Existing Connections to -old**
- **Converting Connections**:
  - From a Service principal (manual) federation to a Workload federation (manual) **without keeping the old connection**.
  - From a Service principal (manual) federation to a Workload federation (manual) **without touching the old connection**.
- **JSON Templates**:
  - Templates to facilitate these conversions.

### The WHY

The reason you might feel you would like this could include the following:

- **Ease of Management**: Because you do not wish to manually keep track of the secret/certificate expiry process.
- **Risk Mitigation**: Because you foresee risk in having to manually do this across all service connections.

### Limitations

- **Simultaneous Federation Limit**: You cannot use more than 20 simultaneous federations per service principal.
  - If you have more than 20 connections, consider setting it up in the traditional way using a manual rotating secret.
  
- **Automatic Workload Federation Shift**:
  - You could make a shift to automatic workload federation, however, permissions required within Azure would need to be set for each app registration automatically created.

## Adjusting all service connections
 - **Modify Connections**:
   - Adjust serviceconnections to be granted access to be consumed by all pipelines.

### The WHY

The reason you might feel you would like this could include the following:
- **Modify Connections**: Because you do not wish to grant every individual pipeline permission to use the service connection (especially when having multiple projects/origins using the serviceconnection)