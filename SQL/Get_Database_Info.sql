/*
	Basic query to get all databases except master, tempdb, model and msdb
*/
Select @@SERVERNAME AS 'ServerName'
, name
, database_id
, create_date
, state_desc
from Sys.Databases WHERE name NOT IN ('master','tempdb','model','msdb')