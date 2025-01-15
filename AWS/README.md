# AWS Repository Overview #

## This includes the following: ##
- AWS Prerequisites
- AWS Lambda's mostly built using CloudFormation and Python (/lambda)
- Useful AWS CLI commands/scripts
- Projects (templates) mostly built using CloudFormation and Python (/projects)

### Prerequisites ###
- AWS CLI must be installed
    - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- Python interpeter must be installed for Python development
    - https://www.python.org/downloads/
    - Also when launching new projects consider to load them into a virtual environment. You do this via the script called setupEnv.ps1 alternatively you could adjust it from .venv to .projectname.venv to ensure that if you use multiple projects it will use the correct (new) venv each time.
- (Optional) Install & use a certain IDE for development
    - VSCode (https://code.visualstudio.com/download)
    - PyCharm (https://www.jetbrains.com/pycharm) (NOT FREE)
- (Optional) Consider the use of [localstack](https://www.localstack.cloud/) to test without actually touching the AWS environment


### Disclaimer ###
Most of the items in this repo has been made by me, however, some of them have solely been rewritten/modified to adjust and serve the general public as usecase.