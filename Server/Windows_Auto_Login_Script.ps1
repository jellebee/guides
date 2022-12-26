$Username = "username"
$Pass = "password"
$Domain = "domainname"
$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
$Autologinvalue = (Get-ItemProperty -Path $RegistryPath -Name AutoAdminLogon).AutoAdminLogon
$defaultuservalue = (Get-ItemProperty -Path $RegistryPath -Name DefaultUsername).DefaultUsername
$defaultpasswordvalue = (Get-ItemProperty -Path $RegistryPath -Name DefaultPassword).DefaultPassword
$defaultdomainvalue = (Get-ItemProperty -Path $RegistryPath -Name DefaultDomainName).DefaultDomainName
function setautologon{
Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value "1" -Type String 
Set-ItemProperty $RegistryPath 'DefaultUsername' -Value "$Username" -type String
Set-Itemproperty $RegistryPath 'DefaultDomainName' -Value "$domain" -type String
if(!$defaultpasswordvalue){
New-ItemProperty $RegistryPath 'DefaultPassword' -Value "$Pass" -type String
}
Else{
Set-ItemProperty $RegistryPath 'DefaultPassword' -Value "$Pass" -type String
}
}

If ($Autologinvalue = '0' -or $defaultuservalue -ne $Username -or $defaultpasswordvalue -ne $Pass -or $defaultdomainvalue -ne $Domain){
setautologon
}
else{
exit
}