Write-Host "Welcome to the SQLDB Extract script."

#Setting export path
$path = "C:\Exports\"
#If the path is not set request the user for setting the path
if ($path.length -lt 2){
	$path = Read-Host -Prompt "What would you like the export path to be?"
}
#checking the directory exists and creating one where necessary
If(!(test-path $path)){
    New-Item -ItemType Directory -Force -Path $path
	Write-Host "A new export directory has been created at: $($path)"
}

#setting date
$date = get-date -Format yyyyMMdd-HHmmss


#Setting file name
$filename = "SQLDB_$date.csv"
if ($filename.length -lt 5){
	$filename = Read-Host -Prompt "What would you like the (export) filename to be?"
}
$file = $path + $filename
Write-Host "The export filename has been set to $($filename)"
Write-Host "The full export path has been set to $($file)"

#Setting logpath
$logpath = "C:\TBIS\Logs\"
#If the logpath is not set request the user for setting the logpath
if ($logpath.length -lt 5){
	$logpath = Read-Host -Prompt "What would you like the logpath to be?"
}
#checking the log directory exists and creating one where necessary
If(!(test-path $logpath)){
	New-Item -ItemType Directory -Force -Path $logpath
	Write-Host "A new logging directory has been created at: $($logpath)"
}
Write-Host "The logfilepath has been set to $($logpath)"

#Setting log filename
$logfilename = "$($env:ComputerName)_SQLDB_$date.log"
if ($logfile.length -lt 2){
	$logfilename = Read-Host -Prompt "What would you like the logfilename to be?"
}
$logfile = $logpath + $logfilename
Write-Host "The logfile has been set to $($logfile)"

$server = ""
if ($server.length -lt 2){
	$server = Read-Host -Prompt "From which server would you like to extract the SQLDB logs?"
}
Write-Host "The SQLServer name has been set to $($server)"

Start-Transcript -Path $logfile -Append -NoClobber

#Opens an SQL connection to the mentioned DB
$sqlcn = New-Object System.Data.SqlClient.SqlConnection
try{
$sqlcn.ConnectionString = "Server=$server;Integrated Security=true;Initial Catalog=master"
$sqlcn.Open()
$connect = $true
}
catch{
Write-host "An error has occurred in connecting to server $($server) `n $($Error[0])"
$connect = $false
$Error[0] = $null
}
if ($connect -eq $true){
#Creates the query to check the databases
$sqlcmd = $sqlcn.CreateCommand()
#Query to get the servername, dbname, databaseID, Createdate, State(Online/Offline) where DB not equal to master, tempdb, model and msdb
$query = "Select @@SERVERNAME AS 'ServerName', name, database_id, create_date, state_desc from Sys.Databases WHERE name NOT IN ('master','tempdb','model','msdb')"
$sqlcmd.CommandText = $query

#Connects the SQLcmd to a query and loads the data
$adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
$data = New-Object System.Data.DataSet
$adp.Fill($data) | Out-Default
$data.Tables
#Checks all databases
$tableofdb = $data.Tables
$dboutput += foreach ($db in $tableofdb){
$db

}
}
else{
    Write-Host "There is no need to check the databases as the computer running the script $($env:computername) has no connection with server $server"
}
$dboutput | Export-Csv -Path $file -Force -NoTypeInformation -Delimiter '|'
Stop-Transcript
$dboutput = $null