# Import the required modules (You might need to install them)
from azure.identity import ClientSecretCredential
from azure.mgmt.rdbms.postgresql import PostgreSQLManagementClient
from azure.mgmt.rdbms.postgresql.models import ServerPropertiesForDefaultCreate, Sku

# Set your Azure credentials and subscription ID
tenant_id = "your_tenant_id"
client_id = "your_client_id"
client_secret = "your_client_secret"
subscription_id = "your_subscription_id"

# Set the name and location of the new PostgreSQL server and the admin login and password
server_name = "your_server_name"
location = "your_location"
admin_username = "your_admin_username"
admin_password = "your_admin_password"

# Set the SKU of the new PostgreSQL server
sku = Sku(name="GP_Gen5_2", tier="GeneralPurpose", family="Gen5", capacity=2)

# Create the client credential object
credentials = ClientSecretCredential(tenant_id, client_id, client_secret)

# Create the PostgreSQL management client object
postgres_client = PostgreSQLManagementClient(credentials, subscription_id)

# Create the new PostgreSQL server
server = postgres_client.servers.create(resource_group_name="your_resource_group_name", server_name=server_name,
                                        parameters=ServerPropertiesForDefaultCreate(administrator_login=admin_username,
                                                                                    administrator_login_password=admin_password,
                                                                                    sku=sku, location=location))

# Print the details of the new PostgreSQL server
print("New PostgreSQL server created with the following details:")
print(f"Server name: {server.name}")
print(f"Server location: {server.location}")
print(f"Server admin login: {server.administrator_login}")