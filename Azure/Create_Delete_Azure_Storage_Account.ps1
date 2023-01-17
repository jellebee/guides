#This script can be used to create or delete an Azure storage account
#Set the option as a default (Create/Delete)
$createdelete = ""
#If no option is given this if loop will request the user what he/she would like to do
function createstorageaccount {

}
function deletestorageaccount {

}

if ($createdelete -ne 1 -or $createdelete -ne 2) {
    $createdelete = Read-Host -Prompt "Would you like to create or delete an Azure Storage Account? [Select 1 for create and 2 for delete]"
}
if ($createdelete -eq 1) {

}
elseif ($createdelete -eq 2) {
    Write-host "2 it is"
}
else {
    Write-host "Something went wrong"
}