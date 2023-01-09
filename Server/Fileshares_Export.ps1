#checking the directory exists and creating one where necessary
$path = "C:\Exports\"
If(!(test-path $path)){
    New-Item -ItemType Directory -Force -Path $path
}
$date = get-date -Format yyyyMMdd-HHmmss

#Setting file name
$file = "$path\$($env:ComputerName)_Shares_$date.csv"

$smbshare = Get-SMBShare | Where-object {$_.Description -notlike "Remote Admin" -and $_.Description -notlike "Default Share" -and $_.Description -notlike "Remote IPC"}
foreach($share in $smbshare){
#setting share path
$spath = $share.path

#Getting All directories in a specified share
$directories = Get-childitem -path $spath -Directory -recurse

#Getting all permissions in a specified share
$output += foreach($directory in $directories){
	$Acl = Get-Acl -Path $directory.FullName
	foreach ($Access in $acl.Access) {
       if ($access.IsInherited -ne $true -and $Access.IdentityReference.value -notlike "BUILTIN\*" -and $Access.IdentityReference -notlike "domain\Domain Admins" -and $Access.IdentityReference -notlike "CREATOR OWNER" -and $access.IdentityReference -notlike "NT AUTHORITY\SYSTEM") {
        New-Object -TypeName PSObject -Property @{
        Servername = $env:ComputerName
        Foldername = $directory.fullname
        Owner = $acl.Owner
        ADGroup = $access.IdentityReference
		Permissions = $Access.FileSystemRights
        } | Select-Object Servername, Foldername, Owner, ADGroup, Permissions
    }	
}

}
}
#Exporting the results to CSV
$output | Export-csv -Path $file -Delimiter '|' -NoClobber -NoTypeInformation -Force

#Setting the output variable to 0 (empty)
$output = $null