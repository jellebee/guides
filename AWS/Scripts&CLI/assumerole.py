import boto3
import botocore

#create function for STS connect
def stsconnect (aws_access_key_id, aws_secret_access_key, aws_account_id, aws_user):
    sts_client = boto3.client(service_name="sts", aws_access_key_id, aws_secret_access_key)
    response = sts_client.assume_role(
    RoleArn=Rolearnvalue,
    RoleSessionName="rolearnvalue",
    SerialNumber=f'arn:aws:iam::{aws_account_id}:mfa/{aws_user}',
    TokenCode=token_code
    )
    temp_credentials = response['Credentials']
    return temp_credentials

#create function for AWS RDS Resource in Ireland. Just for the sake of testing
def rdsresource():
    rds_resource = boto3.client(
    'rds',
    aws_access_key_id=temp_credentials['AccessKeyId'],
    aws_secret_access_key=temp_credentials['SecretAccessKey'],
    aws_session_token=temp_credentials['SessionToken'],
    region_name="eu-west-1")
    return rds_resource

role_arn_file_path = "C:/Users/myuser/downloads/role_arns.txt" #Place your role arns file here
with open(role_arn_file_path, "r") as role_arn_file:
list_of_role_arns = role_arn_file.read().split('\n')

for Rolearnvalue in list_of_role_arns:
    #GetMFATokenCode
    token_code = input("Give me a token key: ")
    print(token_code)
    #if token_code > 0:
    #Getting the actual temporary credentials here
    temp_credentials = stsconnect()
    print(f"You assumed role {Rolearnvalue} and got temporary credentials.")
    rds_resource = rdsresource()
    print(f"You succesfully connected to the RDS resource using the temporary credentials.")/

    
    rds_resource_response = rds_resource.describe_db_instances()

   # for db_instance in rds_resource_response['DBInstances']:
   #     db_instance_name = db_instance['DBInstanceIdentifier']
   #     db_type = db_instance['DBInstanceClass']
   #     db_storage = db_instance['AllocatedStorage']
   #     db_engine =  db_instance['Engine']
   # print (Rolearnvalue,","db_instance_name,",",db_type,",",db_storage,",",db_engine)