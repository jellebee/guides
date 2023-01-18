In this read me I will shortly describe some of the more common script in the root of this directory:
Get-Childitem - Used to obtain a list of all files and directories in the current directory including all subitems
RoboCopy - Used for copying between network drives or shares
Windows_Auto_Logon_Script - Used for configuring the auto login option within Windows
Fileshares_Export - Exports a list of SMB shares on the current machine (server). Including ACL's from all child items.
NSLookup - Used for performing NSLookups with user input
NSLookup_Form - Similar to NSLookup but with a visual interface (GUI)
Get_SQL_DBs - Powershell script to get the SQL DBs from the specified server. You could run this under a task schedular with a specific user (if the user you use to access powershell has no access to the DB, tested with dbo rights, but you could consider restricting this.)
Get_Windows_Software - Obtains a list of all software on the device using the WMI service. (WMI service has to be running)
