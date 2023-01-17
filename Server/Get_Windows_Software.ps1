#checking the directory exists and creating one where necessary
Write-Host "Welcome to the WindowsSoftware extract script. We will try to get all Win_32 Products through WMI.`nPlease make sure that the Windows WMI service (Windows Management Instrumentation) is running."

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

$date = get-date -Format yyyyMMdd-HHmmss

#Setting file name
$filename = "$($env:ComputerName)_windowssoftware_$date.csv"
$file = "$($path)\$($filename)"
if ($filename.length -lt 5){
	$filename = Read-Host -Prompt "What would you like the (export) filename to be?"
}
Write-Host "The export filename has been set to $($filename)"

$Export = Read-Host -prompt "Would you like to export? [y/n]"

#Setting excluded vendors (in this case Microsoft, Adobe and Intel projectss
$vendor = {$_.Vendor -notlike "*Microsoft*" -and $_.Vendor -notlike "*Intel*" -and $_.Vendor -notlike "*Adobe*"}

#getting installed software info
$installedsoftware =  get-wmiobject Win32_Product | Select-Object Name, Vendor, Version

#Filtering out selected vendors
$installedsoftware = $installedsoftware | Where-Object $vendor

#Exporting the info
$output = foreach ($software in $installedsoftware){
 New-Object -TypeName PSObject -Property @{
        Servername = $env:ComputerName
        Name = $software.name
        Vendor = $software.Vendor
        Version = $software.Version
        } | Select-Object Servername, Name, Vendor, Version
}
if($Export -eq 'y' -or $Export -eq 'yes')
	$output | Export-csv -Path $file -Delimiter '|' -NoClobber -NoTypeInformation -Force
else{
	Write-Host "There will not be an export as you did not say 'y' or 'yes'"
	$output | Out-GridView
}