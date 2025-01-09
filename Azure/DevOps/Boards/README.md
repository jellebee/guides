# DevOps Items Automation Overview

This documentation provides an overview of the script designed to automate the closure of resolved or done DevOps items. It involves setting up configurations and running PowerShell functions to streamline this process.

## Task Completion automation
### Usecase:
In many organizations Azure DevOps has been used for years alongside boards, but SCRUM and Agile are relatively new terms hence not every organization is as strict as could be when it comes to handling the backlog.

Due to many different views and priorities tasks don't alsways end up on the board. The ones NOT linked to an active or new backlog item should likely be removed or done especially if the backlog item is already removed or done.

For the sake of not having to manually perform grooming all the time this piece of code was written.

### Why Automate?
Automation of task closures offers:
- **Reduced Manual Overhead**:
  - Eliminates the need to manually track and update tasks across projects.
- **Minimized Risk**:
  - Ensures consistency in task status updates and adheres to defined project workflows.

### Additional features
A dry run option was build into the solution which allows for the pipeline to show the to-be-performed actions instead of always executing.