def rdsresource():
    rds_resource = boto3.client(
    'rds',
    aws_access_key_id=temp_credentials['AccessKeyId'],
    aws_secret_access_key=temp_credentials['SecretAccessKey'],
    aws_session_token=temp_credentials['SessionToken'],
    region_name="eu-west-1")
    return rds_resource


rds_resource_response = rds_resource.describe_db_instances()

   # for db_instance in rds_resource_response['DBInstances']:
   #     db_instance_name = db_instance['DBInstanceIdentifier']
   #     db_type = db_instance['DBInstanceClass']
   #     db_storage = db_instance['AllocatedStorage']
   #     db_engine =  db_instance['Engine']
   # print (Rolearnvalue,","db_instance_name,",",db_type,",",db_storage,",",db_engine)