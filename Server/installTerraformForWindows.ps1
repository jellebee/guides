#Creates the install directory
mkdir C:\terraform
cd C:\terraform

#Download the .zip file (currently version 1.10.4)
$version = Read-Host -prompt "What is the version of the terraform you would like to use? (default 1.10.4))"
if(-not $version){
    $version = "1.10.4"
}
Invoke-WebRequest -Uri https://releases.hashicorp.com/terraform/$($version)/terraform_$($version)_windows_amd64.zip -outfile terraform_$($version)_windows_amd64.zip

#Extract the zip file and remove it.
Expand-Archive -Path .\terraform_$($version)_windows_amd64.zip -DestinationPath .\
rm .\terraform_$($version)_windows_amd64.zip -Force

#Set terraform as PATH variable
setx PATH "$env:path;C:\terraform" -m

#Update powershell with the new environment variable
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

#Confirm terraform is installed
terraform version