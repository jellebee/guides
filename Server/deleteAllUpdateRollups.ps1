$windowspackages = Get-WindowsPackage -Online
foreach ($item in $windowspackages){
if ($item.packagename -like 'Package_for_RollupFix'){
try{
Remove-WindowsPackage -Online -PackageName $item.packagename
write-host Succesful removal of package $($item.packagename)
}
catch{
$windowspackageerror = Get-WindowsPackage -Online -PackageName $item.PackageName  Select-Object description -ExpandProperty description
write-host Failed to remove package $($item.packagename)
write-host Description of the errored package $windowspackageerror
}
}
}